LOCAL_PATH := $(call my-dir)/libtheora
LOCAL_PRECONFIG_PATH := $(call my-dir)/preconfigured/universal

include $(CLEAR_VARS)

LOCAL_MODULE := libtheora

LOCAL_CFLAGS := \
	-ffast-math \
	-fsigned-char \
	-DBYTE_ORDER=LITTLE_ENDIAN \
	-D_ARM_ASSEM_ \
	-Wno-parentheses \
	-Wno-shift-op-parentheses \
	-Wno-shift-negative-value

LOCAL_C_INCLUDES := \
	$(LOCAL_PRECONFIG_PATH)/libogg \
	$(LOCAL_PRECONFIG_PATH)/libtheora \
	$(LOCAL_PATH)/include \
	$(LOCAL_PATH)/lib

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include

LOCAL_SRC_FILES := \
	$(LOCAL_PATH)/lib/analyze.c \
	$(LOCAL_PATH)/lib/apiwrapper.c \
	$(LOCAL_PATH)/lib/bitpack.c \
	$(LOCAL_PATH)/lib/cpu.c \
	$(LOCAL_PATH)/lib/decapiwrapper.c \
	$(LOCAL_PATH)/lib/decinfo.c \
	$(LOCAL_PATH)/lib/decode.c \
	$(LOCAL_PATH)/lib/dequant.c \
	$(LOCAL_PATH)/lib/encapiwrapper.c \
	$(LOCAL_PATH)/lib/encfrag.c \
	$(LOCAL_PATH)/lib/encinfo.c \
	$(LOCAL_PATH)/lib/enquant.c \
	$(LOCAL_PATH)/lib/fdct.c \
	$(LOCAL_PATH)/lib/fragment.c \
	$(LOCAL_PATH)/lib/huffdec.c \
	$(LOCAL_PATH)/lib/huffenc.c \
	$(LOCAL_PATH)/lib/idct.c \
	$(LOCAL_PATH)/lib/info.c \
	$(LOCAL_PATH)/lib/internal.c \
	$(LOCAL_PATH)/lib/mathops.c \
	$(LOCAL_PATH)/lib/mcenc.c \
	$(LOCAL_PATH)/lib/quant.c \
	$(LOCAL_PATH)/lib/rate.c \
	$(LOCAL_PATH)/lib/state.c \
	$(LOCAL_PATH)/lib/tokenize.c

ifeq ($(TARGET_ARCH_ABI), x86)
	LOCAL_C_INCLUDES += $(LOCAL_PATH)/lib/x86
	LOCAL_SRC_FILES += \
		$(LOCAL_PATH)/lib/x86/mmxencfrag.c \
		$(LOCAL_PATH)/lib/x86/mmxfdct.c \
		$(LOCAL_PATH)/lib/x86/mmxfrag.c \
		$(LOCAL_PATH)/lib/x86/mmxidct.c \
		$(LOCAL_PATH)/lib/x86/mmxstate.c \
		$(LOCAL_PATH)/lib/x86/x86enc.c \
		$(LOCAL_PATH)/lib/x86/x86state.c
else ifeq ($(TARGET_ARCH_ABI), x86_64)
	LOCAL_C_INCLUDES += $(LOCAL_PATH)/lib/x86
	LOCAL_SRC_FILES += \
		$(LOCAL_PATH)/lib/x86/mmxencfrag.c \
		$(LOCAL_PATH)/lib/x86/mmxfdct.c \
		$(LOCAL_PATH)/lib/x86/mmxfrag.c \
		$(LOCAL_PATH)/lib/x86/mmxidct.c \
		$(LOCAL_PATH)/lib/x86/mmxstate.c \
		$(LOCAL_PATH)/lib/x86/x86enc.c \
		$(LOCAL_PATH)/lib/x86/x86state.c \
		$(LOCAL_PATH)/lib/x86/sse2fdct.c
endif

include $(BUILD_STATIC_LIBRARY)
