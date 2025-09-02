LOCAL_PATH := $(call my-dir)/fluidsynth
LOCAL_BUILD_PATH := $(call my-dir)/build-$(TARGET_ARCH_ABI)

include $(CLEAR_VARS)

LOCAL_MODULE := fluidsynth

LOCAL_C_INCLUDES := $(LOCAL_BUILD_PATH)/include

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_BUILD_PATH)/include

LOCAL_SRC_FILES := $(LOCAL_BUILD_PATH)/lib/$(TARGET_ARCH_ABI)/libfluidsynth.so

include $(PREBUILT_SHARED_LIBRARY)
