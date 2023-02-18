package com.hatkid.mkxpz;

import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.os.Bundle;
import android.util.Log;
import java.util.Locale;

import org.libsdl.app.SDLActivity;
import com.hatkid.mkxpz.gamepad.Gamepad;
import com.hatkid.mkxpz.gamepad.GamepadConfig;

public class MainActivity extends SDLActivity
{
    // This activity inherits from SDLActivity activity.
    // Put your Java-side stuff here.

    private static final String TAG = "mkxp-z[Activity]";
    protected static boolean DEBUG = false;

    // In-screen gamepad
    public Gamepad gpad = new Gamepad();

    @Override
    protected void onStart()
    {
        try {
            ActivityInfo actInfo = getPackageManager().getActivityInfo(this.getComponentName(), PackageManager.GET_META_DATA);
            DEBUG = actInfo.metaData.getBoolean("mkxp_debug");
        } catch (PackageManager.NameNotFoundException e) {
            Log.w(TAG, "Failed to set debug flag: " + e);
            e.printStackTrace();
        }

        super.onStart();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        GamepadConfig gpadConfig = new GamepadConfig();
        gpad.init(gpadConfig);
        gpad.setOnKeyDownListener(SDLActivity::onNativeKeyDown);
        gpad.setOnKeyUpListener(SDLActivity::onNativeKeyUp);

        if (mLayout != null) {
            gpad.attachTo(this, mLayout);
        }
    }

    @Override
    protected void onDestroy()
    {
        super.onDestroy();

        // HACK: Exiting the JVM (process) since Ruby does not likes when we
        // trying to re-initialize Ruby VM in mkxp-z (JNI native library)
        // that leads to segmentation fault, even we have cleanup the Ruby VM.
        System.exit(0);
    }

    @Override
    public boolean dispatchKeyEvent(KeyEvent evt)
    {
        if (gpad != null)
            if (gpad.processGamepadEvent(evt))
                return true;

        return super.dispatchKeyEvent(evt);
    }

    @Override
    public boolean onGenericMotionEvent(MotionEvent evt)
    {
        if (gpad != null)
            if (gpad.processDPadEvent(evt))
                return true;

        return super.onGenericMotionEvent(evt);
    }

    /**
     * This method is for arguments for launching native mkxp-z.
     * @return arguments for the mkxp-z
     */
    @Override
    protected String[] getArguments()
    {
        String[] args;

        if (DEBUG) {
            // Arguments in Debug mode
            args = new String[] { "debug" };
        } else {
            // Arguments in normal mode
            args = new String[] {};
        }

        return args;
    }

    /**
     * This method is used in native mkxp-z. (see systemImpl.cpp)
     * This method returns current device locale tag. (e.g. "en_US")
     * @return string of locale tag
     */
    @SuppressWarnings("unused")
    private static String getSystemLanguage()
    {
        Locale locale = Locale.getDefault();

        return locale.toString();
    }
}