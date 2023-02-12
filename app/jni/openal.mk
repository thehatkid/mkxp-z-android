LOCAL_PATH := $(call my-dir)/openal
LOCAL_BUILD_PATH := $(call my-dir)/build-$(TARGET_ARCH_ABI)

include $(CLEAR_VARS)

LOCAL_MODULE := openal

LOCAL_C_INCLUDES := $(LOCAL_BUILD_PATH)/include/AL

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_BUILD_PATH)/include/AL

LOCAL_SRC_FILES := $(LOCAL_BUILD_PATH)/lib/libopenal.so

include $(PREBUILT_SHARED_LIBRARY)
