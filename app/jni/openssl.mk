LOCAL_PATH := $(call my-dir)/openssl
LOCAL_BUILD_PATH := $(call my-dir)/build-$(TARGET_ARCH_ABI)

# -------------------- libcrypto for OpenSSL --------------------
include $(CLEAR_VARS)

LOCAL_MODULE := libcrypto

LOCAL_SRC_FILES := $(LOCAL_BUILD_PATH)/lib/libcrypto.a

include $(PREBUILT_STATIC_LIBRARY)

# -------------------- OpenSSL static library --------------------
include $(CLEAR_VARS)

LOCAL_MODULE := openssl

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_BUILD_PATH)/include/openssl

LOCAL_SRC_FILES := $(LOCAL_BUILD_PATH)/lib/libssl.a

LOCAL_STATIC_LIBRARIES := libcrypto

include $(PREBUILT_STATIC_LIBRARY)
