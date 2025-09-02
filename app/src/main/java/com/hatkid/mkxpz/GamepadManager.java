package com.hatkid.mkxpz;

import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.ViewGroup;

import com.hatkid.mkxpz.gamepad.Gamepad;
import com.hatkid.mkxpz.gamepad.GamepadConfig;

import org.libsdl.app.SDLActivity;

public class GamepadManager {

    private final Gamepad mGamepad = new Gamepad();
    private boolean mGamepadInvisible = false;
    // mActivity is not strictly needed if SDLActivity methods like isAndroidTV are public static
    // or if these booleans are passed in constructor.
    // However, attachTo requires an Activity, and SDLActivity itself is passed.
    // isAndroidTV() and isChromebook() are protected instance methods of SDLActivity.
    // mLayout is a protected instance field of SDLActivity.

    public GamepadManager(SDLActivity activity, ViewGroup layout) {
        // Setup in-screen gamepad
        // Assuming isAndroidTV() and isChromebook() are accessible via the activity instance.
        // These are protected methods in SDLActivity, so they are accessible if GamepadManager
        // is in the same package or if 'activity' is an instance of a class that can access them.
        // For simplicity, we assume 'activity' provides these.
        mGamepadInvisible = (activity.isAndroidTV() || activity.isChromebook());
        GamepadConfig gpadConfig = new GamepadConfig();
        mGamepad.init(gpadConfig, mGamepadInvisible);

        // SDLActivity.onNativeKeyDown and SDLActivity.onNativeKeyUp are public static methods in SDLActivity.
        mGamepad.setOnKeyDownListener(SDLActivity::onNativeKeyDown);
        mGamepad.setOnKeyUpListener(SDLActivity::onNativeKeyUp);

        if (layout != null) {
            // The attachTo method in Gamepad might need specific context.
            // Assuming 'activity' is the correct context to pass.
            mGamepad.attachTo(activity, layout);
        }
    }

    /**
     * Handles key events for the gamepad.
     * Manages gamepad visibility based on non-system key presses.
     * Processes the event through the gamepad.
     * @param evt The KeyEvent.
     * @return True if the event was consumed by the gamepad, false otherwise.
     */
    public boolean handleDispatchKeyEvent(KeyEvent evt) {
        if (evt.getKeyCode() != KeyEvent.KEYCODE_BACK &&
            evt.getKeyCode() != KeyEvent.KEYCODE_VOLUME_UP &&
            evt.getKeyCode() != KeyEvent.KEYCODE_VOLUME_DOWN &&
            evt.getKeyCode() != KeyEvent.KEYCODE_VOLUME_MUTE &&
            evt.getKeyCode() != KeyEvent.KEYCODE_HEADSETHOOK) {
            if (!mGamepadInvisible) {
                mGamepad.hideView();
                mGamepadInvisible = true;
            }
        }
        return mGamepad.processGamepadEvent(evt);
    }

    /**
     * Handles touch events to manage gamepad visibility.
     * Shows the gamepad view on touch if it's currently invisible.
     */
    public void handleDispatchTouchEvent() {
        if (mGamepadInvisible) {
            mGamepad.showView();
            mGamepadInvisible = false;
        }
    }

    /**
     * Processes generic motion events (like D-pad) through the gamepad.
     * @param evt The MotionEvent.
     * @return True if the event was consumed by the D-pad processing, false otherwise.
     */
    public boolean onGenericMotionEvent(MotionEvent evt) {
        return mGamepad.processDPadEvent(evt);
    }

    /**
     * Processes key down events through the gamepad.
     * @param event The KeyEvent.
     * @return True if the event was consumed by the gamepad, false otherwise.
     */
    public boolean onKeyDown(KeyEvent event) {
        return mGamepad.processGamepadEvent(event);
    }

    /**
     * Processes key up events through the gamepad.
     * @param event The KeyEvent.
     * @return True if the event was consumed by the gamepad, false otherwise.
     */
    public boolean onKeyUp(KeyEvent event) {
        return mGamepad.processGamepadEvent(event);
    }
}
