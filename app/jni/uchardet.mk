LOCAL_PATH := $(call my-dir)/uchardet

include $(CLEAR_VARS)

LOCAL_MODULE := uchardet

LOCAL_C_INCLUDES := $(LOCAL_PATH)/src

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/src

LOCAL_SRC_FILES := \
	$(LOCAL_PATH)/src/CharDistribution.cpp \
	$(LOCAL_PATH)/src/JpCntx.cpp \
	$(LOCAL_PATH)/src/LangModels/LangArabicModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangBulgarianModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangCroatianModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangCzechModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangEsperantoModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangEstonianModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangFinnishModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangFrenchModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangDanishModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangGermanModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangGreekModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangHungarianModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangHebrewModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangIrishModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangItalianModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangLithuanianModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangLatvianModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangMalteseModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangPolishModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangPortugueseModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangRomanianModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangRussianModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangSlovakModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangSloveneModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangSwedishModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangSpanishModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangThaiModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangTurkishModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangVietnameseModel.cpp \
	$(LOCAL_PATH)/src/LangModels/LangNorwegianModel.cpp \
	$(LOCAL_PATH)/src/nsHebrewProber.cpp \
	$(LOCAL_PATH)/src/nsCharSetProber.cpp \
	$(LOCAL_PATH)/src/nsBig5Prober.cpp \
	$(LOCAL_PATH)/src/nsEUCJPProber.cpp \
	$(LOCAL_PATH)/src/nsEUCKRProber.cpp \
	$(LOCAL_PATH)/src/nsEUCTWProber.cpp \
	$(LOCAL_PATH)/src/nsEscCharsetProber.cpp \
	$(LOCAL_PATH)/src/nsEscSM.cpp \
	$(LOCAL_PATH)/src/nsGB2312Prober.cpp \
	$(LOCAL_PATH)/src/nsMBCSGroupProber.cpp \
	$(LOCAL_PATH)/src/nsMBCSSM.cpp \
	$(LOCAL_PATH)/src/nsSBCSGroupProber.cpp \
	$(LOCAL_PATH)/src/nsSBCharSetProber.cpp \
	$(LOCAL_PATH)/src/nsSJISProber.cpp \
	$(LOCAL_PATH)/src/nsUTF8Prober.cpp \
	$(LOCAL_PATH)/src/nsLatin1Prober.cpp \
	$(LOCAL_PATH)/src/nsUniversalDetector.cpp \
	$(LOCAL_PATH)/src/uchardet.cpp

include $(BUILD_STATIC_LIBRARY)
