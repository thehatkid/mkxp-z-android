LOCAL_PATH := $(call my-dir)/libogg
LOCAL_PRECONFIG_PATH := $(call my-dir)/preconfigured/universal

include $(CLEAR_VARS)

LOCAL_MODULE := libogg

LOCAL_CFLAGS := \
	-ffast-math \
	-fsigned-char \
	-DBYTE_ORDER=LITTLE_ENDIAN \
	-D_ARM_ASSEM_

LOCAL_C_INCLUDES := \
	$(LOCAL_PRECONFIG_PATH)/libogg \
	$(LOCAL_PATH)/include

LOCAL_EXPORT_C_INCLUDES := \
	$(LOCAL_PRECONFIG_PATH)/libogg \
	$(LOCAL_PATH)/include

LOCAL_SRC_FILES := \
	$(LOCAL_PATH)/src/bitwise.c \
	$(LOCAL_PATH)/src/framing.c

include $(BUILD_STATIC_LIBRARY)
