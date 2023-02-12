# This Makefile is just for exporting headers from SDL2_sound
# and then include SDL2_sound Android.mk itself.

LOCAL_PATH := $(call my-dir)

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/SDL2_sound

include $(LOCAL_PATH)/SDL2_sound/Android.mk
