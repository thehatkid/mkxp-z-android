package com.hatkid.mkxpz.utils;

import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.hatkid.mkxpz.gamepad.GamepadButton;

public class ViewUtils
{
    public static void changeOpacity(ViewGroup viewGroup, int opacity)
    {
        for (int i = 0; viewGroup.getChildCount() > i; i++)
        {
            View view = viewGroup.getChildAt(i);

            if (view instanceof Button) {
                view.getBackground().setAlpha(Math.round(opacity * 2.25f));
                view.setAlpha((opacity / 100f) * 2);
            } else if (view instanceof GamepadButton) {
                ((GamepadButton) view).setImageAlpha(Math.round(Math.min(opacity, 100) * 2.55f));
            } else if (view instanceof ViewGroup) {
                changeOpacity((ViewGroup) view, opacity);
            }
        }
    }

    public static void resize(View view, float scale)
    {
        ViewGroup.LayoutParams lParams = view.getLayoutParams();

        if (lParams.width > 0)
            lParams.width = Math.round(lParams.width * (scale / 100f));

        if (lParams.height > 0)
            lParams.height = Math.round(lParams.height * (scale / 100f));

        view.setLayoutParams(lParams);

        int tPadding = Math.round(view.getPaddingTop() * (scale / 100f));
        int bPadding = Math.round(view.getPaddingBottom() * (scale / 100f));
        int lPadding = Math.round(view.getPaddingLeft() * (scale / 100f));
        int rPadding = Math.round(view.getPaddingRight() * (scale / 100f));
        view.setPadding(lPadding, tPadding, rPadding, bPadding);

        if (view instanceof ViewGroup) {
            for (int i = 0; ((ViewGroup) view).getChildCount() > i; i++)
            {
                View v = ((ViewGroup) view).getChildAt(i);

                if (v != null)
                    resize(v, scale);
            }
        }
    }
}