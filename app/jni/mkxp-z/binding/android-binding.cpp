#include "binding-util.h"

#include <SDL.h>
#include <jni.h>

RB_METHOD(androidDeviceInfo)
{
	RB_UNUSED_PARAM;

	VALUE hash = rb_hash_new();
	JNIEnv *env = (JNIEnv *)SDL_AndroidGetJNIEnv();
	jclass cls = env->FindClass("android/os/Build");

	// Build.BRAND field
	jfieldID fIDBrand = env->GetStaticFieldID(cls, "BRAND", "Ljava/lang/String;");
	jstring strJBrand = (jstring)env->GetStaticObjectField(cls, fIDBrand);
	const char *strCBrand = env->GetStringUTFChars(strJBrand, 0);

	// Build.MANUFACTURER field
	jfieldID fIDManufacturer = env->GetStaticFieldID(cls, "MANUFACTURER", "Ljava/lang/String;");
	jstring strJManufacturer = (jstring)env->GetStaticObjectField(cls, fIDManufacturer);
	const char *strCManufacturer = env->GetStringUTFChars(strJManufacturer, 0);

	// Build.MODEL field
	jfieldID fIDModel = env->GetStaticFieldID(cls, "MODEL", "Ljava/lang/String;");
	jstring strJModel = (jstring)env->GetStaticObjectField(cls, fIDModel);
	const char *strCModel = env->GetStringUTFChars(strJModel, 0);

	// Build.PRODUCT field
	jfieldID fIDProduct = env->GetStaticFieldID(cls, "PRODUCT", "Ljava/lang/String;");
	jstring strJProduct = (jstring)env->GetStaticObjectField(cls, fIDProduct);
	const char *strCProduct = env->GetStringUTFChars(strJProduct, 0);

	rb_hash_aset(hash, ID2SYM(rb_intern("brand")), rb_str_new_cstr(strCBrand));
	rb_hash_aset(hash, ID2SYM(rb_intern("manufacturer")), rb_str_new_cstr(strCManufacturer));
	rb_hash_aset(hash, ID2SYM(rb_intern("model")), rb_str_new_cstr(strCModel));
	rb_hash_aset(hash, ID2SYM(rb_intern("product")), rb_str_new_cstr(strCProduct));

	env->ReleaseStringUTFChars(strJBrand, strCBrand);
	env->ReleaseStringUTFChars(strJManufacturer, strCManufacturer);
	env->ReleaseStringUTFChars(strJModel, strCModel);
	env->ReleaseStringUTFChars(strJProduct, strCProduct);
	env->DeleteLocalRef(strJBrand);
	env->DeleteLocalRef(strJManufacturer);
	env->DeleteLocalRef(strJModel);
	env->DeleteLocalRef(strJProduct);
	env->DeleteLocalRef(cls);

	return hash;
}

RB_METHOD(androidIsTablet)
{
	RB_UNUSED_PARAM;

	return rb_bool_new(SDL_IsTablet() == SDL_TRUE);
}

RB_METHOD(androidIsTV)
{
	RB_UNUSED_PARAM;

	return rb_bool_new(SDL_IsAndroidTV() == SDL_TRUE);
}

RB_METHOD(androidIsChromebook)
{
	RB_UNUSED_PARAM;

	return rb_bool_new(SDL_IsChromebook() == SDL_TRUE);
}

RB_METHOD(androidIsDeXMode)
{
	RB_UNUSED_PARAM;

	return rb_bool_new(SDL_IsDeXMode() == SDL_TRUE);
}

RB_METHOD(androidHasVibrator)
{
	RB_UNUSED_PARAM;

	JNIEnv *env = (JNIEnv *)SDL_AndroidGetJNIEnv();
	jobject activity = (jobject)SDL_AndroidGetActivity();
	jclass cls = env->GetObjectClass(activity);

	jmethodID mID = env->GetStaticMethodID(cls, "hasVibrator", "()Z");
	SDL_assert(mID != 0);
	jboolean hasVibrator = (jboolean)env->CallStaticBooleanMethod(cls, mID);

	env->DeleteLocalRef(cls);
	env->DeleteLocalRef(activity);

	return rb_bool_new(hasVibrator);
}

RB_METHOD(androidVibrate)
{
	RB_UNUSED_PARAM;

	int duration;
	rb_get_args(argc, argv, "i", &duration RB_ARG_END);

	JNIEnv *env = (JNIEnv *)SDL_AndroidGetJNIEnv();
	jobject activity = (jobject)SDL_AndroidGetActivity();
	jclass cls = env->GetObjectClass(activity);

	jmethodID mID = env->GetStaticMethodID(cls, "vibrate", "(I)V");
	SDL_assert(mID != 0);
	env->CallStaticVoidMethod(cls, mID, (jint)duration);

	env->DeleteLocalRef(cls);
	env->DeleteLocalRef(activity);

	return Qnil;
}

RB_METHOD(androidVibrateStop)
{
	RB_UNUSED_PARAM;

	JNIEnv *env = (JNIEnv *)SDL_AndroidGetJNIEnv();
	jobject activity = (jobject)SDL_AndroidGetActivity();
	jclass cls = env->GetObjectClass(activity);

	jmethodID mID = env->GetStaticMethodID(cls, "vibrateStop", "()V");
	SDL_assert(mID != 0);
	env->CallStaticVoidMethod(cls, mID);

	env->DeleteLocalRef(cls);
	env->DeleteLocalRef(activity);

	return Qnil;
}

RB_METHOD(androidInMultiWindow)
{
	RB_UNUSED_PARAM;

	JNIEnv *env = (JNIEnv *)SDL_AndroidGetJNIEnv();
	jobject activity = (jobject)SDL_AndroidGetActivity();
	jclass cls = env->GetObjectClass(activity);

	jmethodID mID = env->GetStaticMethodID(cls, "inMultiWindow", "(Landroid/app/Activity;)Z");
	SDL_assert(mID != 0);
	jboolean winMode = (jboolean)env->CallStaticBooleanMethod(cls, mID, activity);

	env->DeleteLocalRef(cls);
	env->DeleteLocalRef(activity);

	return rb_bool_new(winMode);
}

void androidBindingInit()
{
	VALUE module = rb_define_module("Android");

	// Android version/device info
	rb_const_set(module, rb_intern("SDK_VERSION"), INT2NUM(SDL_GetAndroidSDKVersion()));
	_rb_define_module_function(module, "device", androidDeviceInfo);
	_rb_define_module_function(module, "is_tablet?", androidIsTablet);
	_rb_define_module_function(module, "is_tv?", androidIsTV);
	_rb_define_module_function(module, "is_chromebook?", androidIsChromebook);
	_rb_define_module_function(module, "is_dex_mode?", androidIsDeXMode);

	// Vibration
	_rb_define_module_function(module, "has_vibrator?", androidHasVibrator);
	_rb_define_module_function(module, "vibrate", androidVibrate);
	_rb_define_module_function(module, "vibrate_stop", androidVibrateStop);

	// Multi-window (Android 7.0+)
	_rb_define_module_function(module, "in_multiwindow?", androidInMultiWindow);
}