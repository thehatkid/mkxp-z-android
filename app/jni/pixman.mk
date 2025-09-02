LOCAL_PATH := $(call my-dir)/pixman
LOCAL_PRECONFIG_PATH := $(call my-dir)/preconfigured/$(TARGET_ARCH_ABI)

include $(CLEAR_VARS)

LOCAL_MODULE := pixman

LOCAL_CFLAGS := \
	-DHAVE_CONFIG_H \
	-DPIXMAN_NO_TLS \
	-D_USE_MATH_DEFINES \
	-Wno-unknown-attributes \
	-Wno-expansion-to-defined

LOCAL_C_INCLUDES := \
	$(LOCAL_PRECONFIG_PATH)/pixman \
	$(LOCAL_PRECONFIG_PATH)/pixman/pixman \
	$(LOCAL_PATH)/pixman

LOCAL_EXPORT_C_INCLUDES := \
	$(LOCAL_PRECONFIG_PATH)/pixman/pixman \
	$(LOCAL_PATH)/pixman

LOCAL_SRC_FILES := \
	$(LOCAL_PATH)/pixman/pixman.c \
	$(LOCAL_PATH)/pixman/pixman-access.c \
	$(LOCAL_PATH)/pixman/pixman-access-accessors.c \
	$(LOCAL_PATH)/pixman/pixman-bits-image.c \
	$(LOCAL_PATH)/pixman/pixman-combine32.c \
	$(LOCAL_PATH)/pixman/pixman-combine-float.c \
	$(LOCAL_PATH)/pixman/pixman-conical-gradient.c \
	$(LOCAL_PATH)/pixman/pixman-filter.c \
	$(LOCAL_PATH)/pixman/pixman-x86.c \
	$(LOCAL_PATH)/pixman/pixman-mips.c \
	$(LOCAL_PATH)/pixman/pixman-arm.c \
	$(LOCAL_PATH)/pixman/pixman-ppc.c \
	$(LOCAL_PATH)/pixman/pixman-edge.c \
	$(LOCAL_PATH)/pixman/pixman-edge-accessors.c \
	$(LOCAL_PATH)/pixman/pixman-fast-path.c \
	$(LOCAL_PATH)/pixman/pixman-glyph.c \
	$(LOCAL_PATH)/pixman/pixman-general.c \
	$(LOCAL_PATH)/pixman/pixman-gradient-walker.c \
	$(LOCAL_PATH)/pixman/pixman-image.c \
	$(LOCAL_PATH)/pixman/pixman-implementation.c \
	$(LOCAL_PATH)/pixman/pixman-linear-gradient.c \
	$(LOCAL_PATH)/pixman/pixman-matrix.c \
	$(LOCAL_PATH)/pixman/pixman-mmx.c \
	$(LOCAL_PATH)/pixman/pixman-noop.c \
	$(LOCAL_PATH)/pixman/pixman-radial-gradient.c \
	$(LOCAL_PATH)/pixman/pixman-region16.c \
	$(LOCAL_PATH)/pixman/pixman-region32.c \
	$(LOCAL_PATH)/pixman/pixman-solid-fill.c \
	$(LOCAL_PATH)/pixman/pixman-timer.c \
	$(LOCAL_PATH)/pixman/pixman-trap.c \
	$(LOCAL_PATH)/pixman/pixman-utils.c

ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
	LOCAL_CFLAGS += -DUSE_ARM_NEON -DUSE_ARM_SIMD
	LOCAL_SRC_FILES += \
		$(LOCAL_PATH)/pixman/pixman-arm-simd.c \
		$(LOCAL_PATH)/pixman/pixman-arm-simd-asm.S \
		$(LOCAL_PATH)/pixman/pixman-arm-simd-asm-scaled.S \
		$(LOCAL_PATH)/pixman/pixman-arm-neon.c \
		$(LOCAL_PATH)/pixman/pixman-arm-neon-asm.S \
		$(LOCAL_PATH)/pixman/pixman-arm-neon-asm-bilinear.S
else ifeq ($(TARGET_ARCH_ABI), arm64-v8a)
	LOCAL_CFLAGS += -DUSE_ARM_NEON -DUSE_ARM_A64_NEON
	LOCAL_SRC_FILES += \
		$(LOCAL_PATH)/pixman/pixman-arm-neon.c \
		$(LOCAL_PATH)/pixman/pixman-arma64-neon-asm.S \
		$(LOCAL_PATH)/pixman/pixman-arma64-neon-asm-bilinear.S
else ifeq ($(TARGET_ARCH_ABI), x86)
	LOCAL_CFLAGS += -DUSE_X86_MMX -DUSE_SSE2 -DUSE_SSSE3
	LOCAL_SRC_FILES += \
		$(LOCAL_PATH)/pixman/pixman-sse2.c \
		$(LOCAL_PATH)/pixman/pixman-ssse3.c
else ifeq ($(TARGET_ARCH_ABI), x86_64)
	LOCAL_CFLAGS += -DUSE_X86_MMX -DUSE_SSE2 -DUSE_SSSE3
	LOCAL_SRC_FILES += \
		$(LOCAL_PATH)/pixman/pixman-sse2.c \
		$(LOCAL_PATH)/pixman/pixman-ssse3.c
endif

LOCAL_STATIC_LIBRARIES := cpufeatures

include $(BUILD_STATIC_LIBRARY)

$(call import-module,android/cpufeatures)
