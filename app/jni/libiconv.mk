LOCAL_PATH := $(call my-dir)/libiconv
LOCAL_BUILD_PATH := $(call my-dir)/build-$(TARGET_ARCH_ABI)

include $(CLEAR_VARS)

LOCAL_MODULE := libiconv

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_BUILD_PATH)/include

LOCAL_SRC_FILES := $(LOCAL_BUILD_PATH)/lib/libiconv.a

include $(PREBUILT_STATIC_LIBRARY)
