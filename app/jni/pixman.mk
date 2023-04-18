LOCAL_PATH := $(call my-dir)/pixman
LOCAL_BUILD_PATH := $(call my-dir)/build-$(TARGET_ARCH_ABI)

include $(CLEAR_VARS)

LOCAL_MODULE := pixman

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_BUILD_PATH)/include/pixman-1

LOCAL_SRC_FILES := $(LOCAL_BUILD_PATH)/lib/libpixman-1.a

include $(PREBUILT_STATIC_LIBRARY)
