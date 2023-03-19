LOCAL_PATH := $(call my-dir)/mkxp-z
LOCAL_BUILD_PATH := $(call my-dir)/build-$(TARGET_ARCH_ABI)

include $(CLEAR_VARS)

LOCAL_MODULE := mkxp-z

LOCAL_CPPFLAGS := \
	-DGLES2_HEADER \
	-DMKXPZ_BUILD_ANDROID \
	-DMKXPZ_VERSION="\"2.4\"" \
	-DMKXPZ_INIT_GL_LATER \
	-DMKXPZ_ALCDEVICE="ALCdevice" \
	-DMKXPZ_SSL \
	-DMKXPZ_MINIFFI \
	-Wno-undefined-var-template \
	-Wno-uninitialized

LOCAL_C_INCLUDES := \
	$(LOCAL_BUILD_PATH)/include \
	$(LOCAL_PATH)/xxd/assets \
	$(LOCAL_PATH)/xxd/shader \
	$(LOCAL_PATH)/src \
	$(LOCAL_PATH)/src/audio \
	$(LOCAL_PATH)/src/theoraplay \
	$(LOCAL_PATH)/src/crypto \
	$(LOCAL_PATH)/src/display \
	$(LOCAL_PATH)/src/display/gl \
	$(LOCAL_PATH)/src/display/libnsgif \
	$(LOCAL_PATH)/src/etc \
	$(LOCAL_PATH)/src/filesystem \
	$(LOCAL_PATH)/src/input \
	$(LOCAL_PATH)/src/net \
	$(LOCAL_PATH)/src/system \
	$(LOCAL_PATH)/src/util

LOCAL_SRC_FILES := \
	$(LOCAL_PATH)/src/main.cpp \
	$(LOCAL_PATH)/src/config.cpp \
	$(LOCAL_PATH)/src/eventthread.cpp \
	$(LOCAL_PATH)/src/sharedstate.cpp \
	$(LOCAL_PATH)/src/settingsmenu.cpp \
	$(LOCAL_PATH)/src/etc/etc.cpp \
	$(LOCAL_PATH)/src/etc/table.cpp \
	$(LOCAL_PATH)/src/audio/audio.cpp \
	$(LOCAL_PATH)/src/audio/audiostream.cpp \
	$(LOCAL_PATH)/src/audio/fluid-fun.cpp \
	$(LOCAL_PATH)/src/audio/soundemitter.cpp \
	$(LOCAL_PATH)/src/audio/alstream.cpp \
	$(LOCAL_PATH)/src/audio/sdlsoundsource.cpp \
	$(LOCAL_PATH)/src/audio/vorbissource.cpp \
	$(LOCAL_PATH)/src/audio/midisource.cpp \
	$(LOCAL_PATH)/src/theoraplay/theoraplay.c \
	$(LOCAL_PATH)/src/display/graphics.cpp \
	$(LOCAL_PATH)/src/display/viewport.cpp \
	$(LOCAL_PATH)/src/display/bitmap.cpp \
	$(LOCAL_PATH)/src/display/sprite.cpp \
	$(LOCAL_PATH)/src/display/plane.cpp \
	$(LOCAL_PATH)/src/display/font.cpp \
	$(LOCAL_PATH)/src/display/tilemap.cpp \
	$(LOCAL_PATH)/src/display/tilemapvx.cpp \
	$(LOCAL_PATH)/src/display/autotiles.cpp \
	$(LOCAL_PATH)/src/display/autotilesvx.cpp \
	$(LOCAL_PATH)/src/display/window.cpp \
	$(LOCAL_PATH)/src/display/windowvx.cpp \
	$(LOCAL_PATH)/src/display/gl/gl-fun.cpp \
	$(LOCAL_PATH)/src/display/gl/gl-meta.cpp \
	$(LOCAL_PATH)/src/display/gl/gl-debug.cpp \
	$(LOCAL_PATH)/src/display/gl/glstate.cpp \
	$(LOCAL_PATH)/src/display/gl/scene.cpp \
	$(LOCAL_PATH)/src/display/gl/shader.cpp \
	$(LOCAL_PATH)/src/display/gl/texpool.cpp \
	$(LOCAL_PATH)/src/display/gl/tileatlas.cpp \
	$(LOCAL_PATH)/src/display/gl/tileatlasvx.cpp \
	$(LOCAL_PATH)/src/display/gl/tilequad.cpp \
	$(LOCAL_PATH)/src/display/gl/vertex.cpp \
	$(LOCAL_PATH)/src/display/libnsgif/libnsgif.c \
	$(LOCAL_PATH)/src/display/libnsgif/lzw.c \
	$(LOCAL_PATH)/src/input/input.cpp \
	$(LOCAL_PATH)/src/input/keybindings.cpp \
	$(LOCAL_PATH)/src/filesystem/filesystem.cpp \
	$(LOCAL_PATH)/src/filesystem/filesystemImpl.cpp \
	$(LOCAL_PATH)/src/system/systemImpl.cpp \
	$(LOCAL_PATH)/src/util/iniconfig.cpp \
	$(LOCAL_PATH)/src/net/net.cpp \
	$(LOCAL_PATH)/src/net/LUrlParser.cpp \
	$(LOCAL_PATH)/src/crypto/rgssad.cpp \
	$(LOCAL_PATH)/binding/binding-mri.cpp \
	$(LOCAL_PATH)/binding/binding-util.cpp \
	$(LOCAL_PATH)/binding/etc-binding.cpp \
	$(LOCAL_PATH)/binding/table-binding.cpp \
	$(LOCAL_PATH)/binding/filesystem-binding.cpp \
	$(LOCAL_PATH)/binding/input-binding.cpp \
	$(LOCAL_PATH)/binding/audio-binding.cpp \
	$(LOCAL_PATH)/binding/graphics-binding.cpp \
	$(LOCAL_PATH)/binding/bitmap-binding.cpp \
	$(LOCAL_PATH)/binding/plane-binding.cpp \
	$(LOCAL_PATH)/binding/sprite-binding.cpp \
	$(LOCAL_PATH)/binding/font-binding.cpp \
	$(LOCAL_PATH)/binding/tilemap-binding.cpp \
	$(LOCAL_PATH)/binding/tilemapvx-binding.cpp \
	$(LOCAL_PATH)/binding/viewport-binding.cpp \
	$(LOCAL_PATH)/binding/window-binding.cpp \
	$(LOCAL_PATH)/binding/windowvx-binding.cpp \
	$(LOCAL_PATH)/binding/android-binding.cpp \
	$(LOCAL_PATH)/binding/cusl-binding.cpp \
	$(LOCAL_PATH)/binding/http-binding.cpp \
	$(LOCAL_PATH)/binding/miniffi.cpp \
	$(LOCAL_PATH)/binding/miniffi-binding.cpp \
	$(LOCAL_PATH)/binding/module_rpg.cpp

LOCAL_SHARED_LIBRARIES := SDL2 SDL2_ttf SDL2_image SDL2_sound openal ruby

LOCAL_STATIC_LIBRARIES := libogg libvorbis libtheora physfs pixman uchardet libiconv openssl

LOCAL_LDLIBS := -lz -llog -ldl -lm -lOpenSLES

include $(BUILD_SHARED_LIBRARY)
