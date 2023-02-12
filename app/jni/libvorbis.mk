LOCAL_PATH := $(call my-dir)/libvorbis
LOCAL_PRECONFIG_PATH := $(call my-dir)/preconfigured/universal

include $(CLEAR_VARS)

LOCAL_MODULE := libvorbis

LOCAL_CFLAGS := \
	-ffast-math \
	-fsigned-char \
	-DBYTE_ORDER=LITTLE_ENDIAN \
	-D_ARM_ASSEM_

LOCAL_C_INCLUDES := \
	$(LOCAL_PRECONFIG_PATH)/libogg \
	$(LOCAL_PRECONFIG_PATH)/libvorbis \
	$(LOCAL_PATH)/include \
	$(LOCAL_PATH)/lib

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include

LOCAL_SRC_FILES := \
	$(LOCAL_PATH)/lib/mdct.c \
	$(LOCAL_PATH)/lib/smallft.c \
	$(LOCAL_PATH)/lib/block.c \
	$(LOCAL_PATH)/lib/envelope.c \
	$(LOCAL_PATH)/lib/window.c \
	$(LOCAL_PATH)/lib/lsp.c \
	$(LOCAL_PATH)/lib/lpc.c \
	$(LOCAL_PATH)/lib/analysis.c \
	$(LOCAL_PATH)/lib/synthesis.c \
	$(LOCAL_PATH)/lib/psy.c \
	$(LOCAL_PATH)/lib/info.c \
	$(LOCAL_PATH)/lib/floor1.c \
	$(LOCAL_PATH)/lib/floor0.c \
	$(LOCAL_PATH)/lib/res0.c \
	$(LOCAL_PATH)/lib/mapping0.c \
	$(LOCAL_PATH)/lib/registry.c \
	$(LOCAL_PATH)/lib/codebook.c \
	$(LOCAL_PATH)/lib/sharedbook.c \
	$(LOCAL_PATH)/lib/lookup.c \
	$(LOCAL_PATH)/lib/bitrate.c \
	$(LOCAL_PATH)/lib/vorbisfile.c \
	$(LOCAL_PATH)/lib/vorbisenc.c

include $(BUILD_STATIC_LIBRARY)
