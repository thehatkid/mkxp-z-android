/*
** main.cpp
**
** This file is part of mkxp.
**
** Copyright (C) 2013 Jonas Kulla <Nyocurio@gmail.com>
**
** mkxp is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 2 of the License, or
** (at your option) any later version.
**
** mkxp is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with mkxp.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef MKXPZ_BUILD_XCODE
#include "icon.png.xxd"
#endif

#include <SDL.h>
#include <SDL_image.h>
#include <SDL_sound.h>
#include <SDL_ttf.h>
#include <alc.h>

#include <assert.h>
#include <string.h>
#include <string>
#include <unistd.h>
#include <regex>

#include "binding.h"
#include "sharedstate.h"
#include "eventthread.h"
#include "util/debugwriter.h"
#include "util/exception.h"
#include "display/gl/gl-debug.h"
#include "display/gl/gl-fun.h"
#include "filesystem/filesystem.h"
#include "system/system.h"

#if defined(__WIN32__)
#include "resource.h"
#include <Winsock2.h>
#include "util/win-consoleutils.h"

/* Try to work around buggy GL drivers that tend to be in Optimus laptops
 * by forcing MKXP to use the dedicated card instead of the integrated one. */
#include <windows.h>
extern "C" {
	__declspec(dllexport) DWORD NvOptimusEnablement = 0x00000001;
	__declspec(dllexport) int AmdPowerXpressRequestHighPerformance = 1;
}
#endif

#ifdef __ANDROID__
#include <jni.h>
#include <sys/system_properties.h>
#endif

#ifdef MKXPZ_STEAM
#include "steamshim_child.h"
#endif

#ifdef MKXPZ_BUILD_XCODE
#include <Availability.h>
#include "TouchBar.h"
#if __MAC_OS_X_VERSION_MAX_ALLOWED < __MAC_10_15
#define MKXPZ_INIT_GL_LATER
#endif
#endif

#ifndef MKXPZ_INIT_GL_LATER
#define GLINIT_SHOWERROR(s) showInitError(s)
#else
#define GLINIT_SHOWERROR(s) rgssThreadError(threadData, s)
#endif

static void rgssThreadError(RGSSThreadData *rtData, const std::string &msg);
static void showInitError(const std::string &msg);

static inline const char *glGetStringInt(GLenum name)
{
	return (const char *)gl.GetString(name);
}

static void printGLInfo()
{
	const std::string renderer(glGetStringInt(GL_RENDERER));
	const std::string version(glGetStringInt(GL_VERSION));

	std::regex rgx("ANGLE \\((.+), ANGLE Metal Renderer: (.+), Version (.+)\\)");

	std::smatch matches;
	if (std::regex_search(renderer, matches, rgx)) {
		Debug() << "Backend           :" << "Metal";
		Debug() << "Metal Device      :" << matches[2] << "(" + matches[1].str() + ")";
		Debug() << "Renderer Version  :" << matches[3].str();

		std::smatch vmatches;
		if (std::regex_search(version, vmatches, std::regex("\\(ANGLE (.+) git hash: .+\\)")))
			Debug() << "ANGLE Version     :" << vmatches[1].str();

		return;
	}

	Debug() << "Backend      :" << "OpenGL";
	Debug() << "GL Vendor    :" << glGetStringInt(GL_VENDOR);
	Debug() << "GL Renderer  :" << renderer;
	Debug() << "GL Version   :" << version;
	Debug() << "GLSL Version :" << glGetStringInt(GL_SHADING_LANGUAGE_VERSION);
}

static SDL_GLContext initGL(SDL_Window *win, Config &conf, RGSSThreadData *threadData);

int rgssThreadFun(void *userdata)
{
	RGSSThreadData *threadData = static_cast<RGSSThreadData *>(userdata);

	// Initialize OpenGL
#ifdef MKXPZ_INIT_GL_LATER
	threadData->glContext = initGL(threadData->window, threadData->config, threadData);

	if (!threadData->glContext)
		return 0;
#else
	SDL_GL_MakeCurrent(threadData->window, threadData->glContext);
#endif

	// Setup OpenAL context
	ALCcontext *alcCtx = alcCreateContext(threadData->alcDev, 0);

	if (!alcCtx) {
		rgssThreadError(threadData, "Error creating OpenAL context");
		return 0;
	}

	alcMakeContextCurrent(alcCtx);

	try {
		SharedState::initInstance(threadData);
	} catch (const Exception &exc) {
		rgssThreadError(threadData, exc.msg);
		alcDestroyContext(alcCtx);
		return 0;
	}

	// Start script execution
	scriptBinding->execute();

	// Terminate execution
	threadData->rqTermAck.set();
	threadData->ethread->requestTerminate();

	SharedState::finiInstance();

	alcDestroyContext(alcCtx);

	return 0;
}

static void printRgssVersion(int ver)
{
	const char *const makers[] = {"", "XP", "VX", "VX Ace"};

	char buf[128];
	snprintf(buf, sizeof(buf), "RGSS version %d (RPG Maker %s)", ver, makers[ver]);

	Debug() << buf;
}

static void rgssThreadError(RGSSThreadData *rtData, const std::string &msg)
{
	rtData->rgssErrorMsg = msg;
	rtData->ethread->requestTerminate();
	rtData->rqTermAck.set();
}

static void showInitError(const std::string &msg)
{
	Debug() << msg;
	SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, "mkxp-z", msg.c_str(), 0);
}

static void setupWindowIcon(const Config &conf, SDL_Window *win)
{
	SDL_RWops *iconSrc;

	if (conf.iconPath.empty())
#ifndef MKXPZ_BUILD_XCODE
		iconSrc = SDL_RWFromConstMem(assets_icon_png, assets_icon_png_len);
#else
		iconSrc = SDL_RWFromFile(mkxp_fs::getPathForAsset("icon", "png").c_str(), "rb");
#endif
	else
		iconSrc = SDL_RWFromFile(conf.iconPath.c_str(), "rb");

	SDL_Surface *iconImg = IMG_Load_RW(iconSrc, SDL_TRUE);

	if (iconImg) {
		SDL_SetWindowIcon(win, iconImg);
		SDL_FreeSurface(iconImg);
	}
}

int main(int argc, char *argv[])
{
	// Set SDL hints
	SDL_SetHint(SDL_HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS, "0");
	SDL_SetHint(SDL_HINT_ACCELEROMETER_AS_JOYSTICK, "0");

#ifdef MKXPZ_BUILD_ANDROID
	// Lock orientations to landscape
	SDL_SetHint(SDL_HINT_ORIENTATIONS, "LandscapeLeft LandscapeRight");
#endif

#ifdef GLES2_HEADER
	// Use OpenGL ES
	SDL_SetHint(SDL_HINT_OPENGL_ES_DRIVER, "1");
#endif

	// Initialize SDL first
	if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_GAMECONTROLLER) < 0)
	{
		showInitError(std::string("Error initializing SDL: ") + SDL_GetError());
		return 0;
	}

	if (!EventThread::allocUserEvents()) {
		showInitError("Error allocating SDL user events");
		return 0;
	}

	// Setup working directory
	/*
#ifndef WORKDIR_CURRENT
	char dataDir[512]{};
#if defined(__linux__)
	char *tmp{};
	tmp = getenv("SRCDIR");
	if (tmp) {
		strncpy(dataDir, tmp, sizeof(dataDir));
	}
#endif
	if (!dataDir[0]) {
		strncpy(dataDir, mkxp_fs::getDefaultGameRoot().c_str(), sizeof(dataDir));
	}
	mkxp_fs::setCurrentDirectory(dataDir);
#endif
	*/
#ifdef MKXPZ_BUILD_ANDROID
	char sdkVersionChar[PROP_VALUE_MAX];
	__system_property_get("ro.build.version.sdk", sdkVersionChar);
	int sdkVersion = atoi(sdkVersionChar);

	// Get GAME_PATH string field from JNI (MainActivity.java)
	JNIEnv *env = (JNIEnv *)SDL_AndroidGetJNIEnv();
	jobject activity = (jobject)SDL_AndroidGetActivity();
	jclass cls = env->GetObjectClass(activity);
	jfieldID fIDGamePath = env->GetStaticFieldID(cls, "GAME_PATH", "Ljava/lang/String;");
	jstring strJGamePath = (jstring)env->GetStaticObjectField(cls, fIDGamePath);
	const char *dataDir = env->GetStringUTFChars(strJGamePath, 0);

	// Request storage permission (before Android 11)
	if (sdkVersion < 30) {
		if (!SDL_AndroidRequestPermission("android.permission.WRITE_EXTERNAL_STORAGE")) {
			showInitError("Failed to get external storage. Please check the app permissions.");
			SDL_Quit();
			return 0;
		}
	}

	// Set and ensure current directory
	if (!mkxp_fs::directoryExists(dataDir)) {
		char buf[200];
		snprintf(buf, sizeof(buf), "Failed to set current directory to %s", dataDir);
		showInitError(std::string(buf));
		SDL_Quit();
		return 0;
	}
	mkxp_fs::setCurrentDirectory(dataDir);

	env->ReleaseStringUTFChars(strJGamePath, dataDir);
	env->DeleteLocalRef(strJGamePath);
	env->DeleteLocalRef(cls);
#endif

	// Load configuration
	Config conf;
	conf.read(argc, argv);

#if defined(__WIN32__)
	// Create a debug console in debug mode
	if (conf.winConsole) {
		if (setupWindowsConsole()) {
			reopenWindowsStreams();
		} else {
			char buf[200];
			snprintf(buf, sizeof(buf), "Error allocating console: %lu", GetLastError());
			showInitError(std::string(buf));
		}
	}
#endif

#ifdef MKXPZ_STEAM
	if (!STEAMSHIM_init()) {
		showInitError("Failed to initialize Steamworks. The application cannot continue launching.");
		SDL_Quit();
		return 0;
	}
#endif

	// Set window title
	if (conf.windowTitle.empty())
		conf.windowTitle = conf.game.title;

	// Validate and print RGSS version
	assert(conf.rgssVersion >= 1 && conf.rgssVersion <= 3);
	printRgssVersion(conf.rgssVersion);

	// Initialize SDL_image
	int imgFlags = IMG_INIT_PNG | IMG_INIT_JPG;
	if (IMG_Init(imgFlags) != imgFlags) {
		showInitError(std::string("Error initializing SDL_image: ") + SDL_GetError());
		SDL_Quit();
#ifdef MKXPZ_STEAM
		STEAMSHIM_deinit();
#endif
		return 0;
	}

	// Initialize SDL_ttf
	if (TTF_Init() < 0) {
		showInitError(std::string("Error initializing SDL_ttf: ") + SDL_GetError());
		IMG_Quit();
		SDL_Quit();
#ifdef MKXPZ_STEAM
		STEAMSHIM_deinit();
#endif
		return 0;
	}

	// Initialize SDL_sound
	if (Sound_Init() == 0) {
		showInitError(std::string("Error initializing SDL_sound: ") + Sound_GetError());
		TTF_Quit();
		IMG_Quit();
		SDL_Quit();
#ifdef MKXPZ_STEAM
		STEAMSHIM_deinit();
#endif
		return 0;
	}

	// Win32: Initialize Winsock2
#if defined(__WIN32__)
	WSAData wsadata = {0};
	if (WSAStartup(0x101, &wsadata) || wsadata.wVersion != 0x101) {
		char buf[200];
		snprintf(buf, sizeof(buf), "Error initializing winsock: %08X", WSAGetLastError());
		showInitError(std::string(buf)); // Not an error worth ending the program over
	}
#endif

	// Create SDL window
	SDL_Window *win;
	Uint32 winFlags = SDL_WINDOW_OPENGL | SDL_WINDOW_INPUT_FOCUS | SDL_WINDOW_ALLOW_HIGHDPI;

	if (conf.winResizable)
		winFlags |= SDL_WINDOW_RESIZABLE;

	if (conf.fullscreen)
		winFlags |= SDL_WINDOW_FULLSCREEN_DESKTOP;

#ifdef GLES2_HEADER
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES);
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2);
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0);

	// LoadLibrary properly initializes EGL, it won't work otherwise.
	// Doesn't completely do it though, needs a small patch to SDL
#ifdef MKXPZ_BUILD_XCODE
	SDL_setenv("ANGLE_DEFAULT_PLATFORM", (conf.preferMetalRenderer) ? "metal" : "opengl", true);
	SDL_GL_LoadLibrary("@rpath/libEGL.dylib");
#endif // MKXPZ_BUILD_XCODE
#endif // GLES2_HEADER

	win = SDL_CreateWindow(
		conf.windowTitle.c_str(),
		SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
		conf.defScreenW, conf.defScreenH,
		winFlags
	);

	if (!win) {
		showInitError(std::string("Error creating window: ") + SDL_GetError());

#ifdef MKXPZ_STEAM
		STEAMSHIM_deinit();
#endif

		return 0;
	}

#ifdef MKXPZ_BUILD_XCODE
#define DEBUG_FSELECT_MSG "Select the folder from which to load game files. This is the folder containing the game's INI."
#define DEBUG_FSELECT_PROMPT "Load Game"
	if (conf.manualFolderSelect) {
		std::string dataDirStr = mkxp_fs::selectPath(win, DEBUG_FSELECT_MSG, DEBUG_FSELECT_PROMPT);

		if (!dataDirStr.empty()) {
			conf.gameFolder = dataDirStr;
			mkxp_fs::setCurrentDirectory(dataDirStr.c_str());
			Debug() << "Current directory set to" << dataDirStr;
			conf.read(argc, argv);
			conf.readGameINI();
		}
	}
#endif

	/* OSX and Windows have their own native ways of
	 * dealing with icons; don't interfere with them */
#ifdef __LINUX__
	setupWindowIcon(conf, win);
#else
	(void)setupWindowIcon;
#endif

	// Open ALC audio device
	ALCdevice *alcDev = alcOpenDevice(0);

	if (!alcDev) {
		showInitError("Error opening OpenAL device");
		SDL_DestroyWindow(win);
		TTF_Quit();
		IMG_Quit();
		SDL_Quit();
#ifdef MKXPZ_STEAM
		STEAMSHIM_deinit();
#endif
		return 0;
	}

	SDL_DisplayMode mode;
	SDL_GetDisplayMode(0, 0, &mode);

	// Can't sync to display refresh rate if its value is unknown
	if (!mode.refresh_rate)
		conf.syncToRefreshrate = false;

	EventThread eventThread;

#ifndef MKXPZ_INIT_GL_LATER
	SDL_GLContext glCtx = initGL(win, conf, 0);
#else
	SDL_GLContext glCtx = NULL;
#endif

	RGSSThreadData rtData(&eventThread, argv[0], win, alcDev, mode.refresh_rate, mkxp_sys::getScalingFactor(), conf, glCtx);

	int winW, winH, drwW, drwH;
	SDL_GetWindowSize(win, &winW, &winH);
	rtData.windowSizeMsg.post(Vec2i(winW, winH));

	SDL_GL_GetDrawableSize(win, &drwW, &drwH);
	rtData.drawableSizeMsg.post(Vec2i(drwW, drwH));

	// Load and post key bindings
	rtData.bindingUpdateMsg.post(loadBindings(conf));

#ifdef MKXPZ_BUILD_XCODE
	// macOS: Create Touch Bar
	initTouchBar(win, conf);
#endif

	// Start RGSS thread
	SDL_Thread *rgssThread = SDL_CreateThread(rgssThreadFun, "rgss", &rtData);

	// Start events processing
	eventThread.process(rtData);

	// Request RGSS thread to stop
	rtData.rqTerm.set();

	// Wait for RGSS thread response
	for (int i = 0; i < 1000; ++i) {
		// We can stop waiting when the request was ack'd
		if (rtData.rqTermAck) {
			Debug() << "RGSS thread ack'd request after" << i * 10 << "ms";
			break;
		}

		// Give RGSS thread some time to respond
		SDL_Delay(10);
	}

	/* If RGSS thread ack'd request, wait for it to shutdown,
	 * otherwise abandon hope and just end the process as is. */
	if (rtData.rqTermAck)
		SDL_WaitThread(rgssThread, 0);
	else
		SDL_ShowSimpleMessageBox(
			SDL_MESSAGEBOX_ERROR, conf.game.title.c_str(),
			std::string("The RGSS script seems to be stuck. " + conf.game.title + " will now force quit.").c_str(),
			win
		);

	if (!rtData.rgssErrorMsg.empty()) {
		Debug() << rtData.rgssErrorMsg;
		SDL_ShowSimpleMessageBox(
			SDL_MESSAGEBOX_ERROR, conf.game.title.c_str(),
			rtData.rgssErrorMsg.c_str(),
			win
		);
	}

	// Delete GL context
	if (rtData.glContext)
		SDL_GL_DeleteContext(rtData.glContext);

	// Clean up any remainin events
	eventThread.cleanup();

	Debug() << "Shutting down.";

	alcCloseDevice(alcDev);

	SDL_DestroyWindow(win);

#if defined(__WIN32__)
	if (wsadata.wVersion)
		WSACleanup();
#endif
#ifdef MKXPZ_STEAM
	STEAMSHIM_deinit();
#endif
	Sound_Quit();
	TTF_Quit();
	IMG_Quit();
	SDL_Quit();

	return 0;
}

static SDL_GLContext initGL(SDL_Window *win, Config &conf, RGSSThreadData *threadData)
{
	SDL_GLContext glCtx{};

	// Setup GL context. Must be done in main thread since macOS 10.15
	SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

	if (conf.debugMode)
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_FLAGS, SDL_GL_CONTEXT_DEBUG_FLAG);

	glCtx = SDL_GL_CreateContext(win);

	if (!glCtx) {
		GLINIT_SHOWERROR(std::string("Error creating context: ") + SDL_GetError());
		return 0;
	}

	try {
		initGLFunctions();
	} catch (const Exception &exc) {
		GLINIT_SHOWERROR(exc.msg);
		SDL_GL_DeleteContext(glCtx);
		return 0;
	}

	// This breaks scaling for Retina screens.
	// Using Metal should be rendering this irrelevant anyway, hopefully.
#ifndef MKXPZ_BUILD_XCODE
	if (!conf.enableBlitting)
		gl.BlitFramebuffer = 0;
#endif

	gl.ClearColor(0, 0, 0, 1);
	gl.Clear(GL_COLOR_BUFFER_BIT);
	SDL_GL_SwapWindow(win);

	printGLInfo();

	bool vsync = conf.vsync || conf.syncToRefreshrate;
	SDL_GL_SetSwapInterval(vsync ? 1 : 0);

	//GLDebugLogger dLogger;

	return glCtx;
}
