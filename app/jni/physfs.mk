LOCAL_PATH := $(call my-dir)/physfs

include $(CLEAR_VARS)

LOCAL_MODULE := physfs

LOCAL_CFLAGS := \
	-DPHYSFS_SUPPORTS_ZIP=1 \
	-DPHYSFS_ARCHIVE_7Z=1 \
	-DPHYSFS_SUPPORTS_GRP=0 \
	-DPHYSFS_SUPPORTS_WAD=1 \
	-DPHYSFS_SUPPORTS_HOG=0 \
	-DPHYSFS_SUPPORTS_MVL=0 \
	-DPHYSFS_SUPPORTS_QPAK=1 \
	-DPHYSFS_SUPPORTS_SLB=0 \
	-DPHYSFS_SUPPORTS_ISO9660=1 \
	-DPHYSFS_SUPPORTS_VDF=1

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/src

LOCAL_SRC_FILES := \
	$(LOCAL_PATH)/src/physfs.c \
	$(LOCAL_PATH)/src/physfs_byteorder.c \
	$(LOCAL_PATH)/src/physfs_unicode.c \
	$(LOCAL_PATH)/src/physfs_archiver_7z.c \
	$(LOCAL_PATH)/src/physfs_archiver_dir.c \
	$(LOCAL_PATH)/src/physfs_archiver_grp.c \
	$(LOCAL_PATH)/src/physfs_archiver_hog.c \
	$(LOCAL_PATH)/src/physfs_archiver_iso9660.c \
	$(LOCAL_PATH)/src/physfs_archiver_mvl.c \
	$(LOCAL_PATH)/src/physfs_archiver_qpak.c \
	$(LOCAL_PATH)/src/physfs_archiver_slb.c \
	$(LOCAL_PATH)/src/physfs_archiver_unpacked.c \
	$(LOCAL_PATH)/src/physfs_archiver_vdf.c \
	$(LOCAL_PATH)/src/physfs_archiver_wad.c \
	$(LOCAL_PATH)/src/physfs_archiver_zip.c \
	$(LOCAL_PATH)/src/physfs_platform_posix.c \
	$(LOCAL_PATH)/src/physfs_platform_unix.c \
	$(LOCAL_PATH)/src/physfs_platform_android.c

include $(BUILD_STATIC_LIBRARY)
