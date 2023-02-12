LOCAL_PATH := $(call my-dir)/ruby
LOCAL_BUILD_PATH := $(call my-dir)/build-$(TARGET_ARCH_ABI)

include $(CLEAR_VARS)

LOCAL_MODULE := ruby

LOCAL_C_INCLUDES := $(LOCAL_BUILD_PATH)/include/ruby-3.1.0

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_BUILD_PATH)/include/ruby-3.1.0

ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
	LOCAL_C_INCLUDES += $(LOCAL_BUILD_PATH)/include/ruby-3.1.0/armv7a-linux-androideabi-android
	LOCAL_EXPORT_C_INCLUDES += $(LOCAL_BUILD_PATH)/include/ruby-3.1.0/armv7a-linux-androideabi-android
else ifeq ($(TARGET_ARCH_ABI), arm64-v8a)
	LOCAL_C_INCLUDES += $(LOCAL_BUILD_PATH)/include/ruby-3.1.0/aarch64-linux-android-android
	LOCAL_EXPORT_C_INCLUDES += $(LOCAL_BUILD_PATH)/include/ruby-3.1.0/aarch64-linux-android-android
else ifeq ($(TARGET_ARCH_ABI), x86)
	LOCAL_C_INCLUDES += $(LOCAL_BUILD_PATH)/include/ruby-3.1.0/i686-linux-android-android
	LOCAL_EXPORT_C_INCLUDES += $(LOCAL_BUILD_PATH)/include/ruby-3.1.0/i686-linux-android-android
else ifeq ($(TARGET_ARCH_ABI), x86_64)
	LOCAL_C_INCLUDES += $(LOCAL_BUILD_PATH)/include/ruby-3.1.0/x86_64-linux-android-android
	LOCAL_EXPORT_C_INCLUDES += $(LOCAL_BUILD_PATH)/include/ruby-3.1.0/x86_64-linux-android-android
endif

LOCAL_SRC_FILES := $(LOCAL_BUILD_PATH)/lib/libruby.so

include $(PREBUILT_SHARED_LIBRARY)
