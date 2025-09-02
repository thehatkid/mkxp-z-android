APP_ABI := arm64-v8a x86_64
APP_PLATFORM := android-28
APP_OPTIM := debug
APP_STL := c++_shared
APP_CPPFLAGS := -std=c++14 -frtti -fexceptions

ifeq ($(NDK_DEBUG),1)
	APP_STRIP_MODE := none
endif