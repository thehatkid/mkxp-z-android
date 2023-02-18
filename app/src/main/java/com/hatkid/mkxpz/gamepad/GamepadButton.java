package com.hatkid.mkxpz.gamepad;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.ImageView;

import com.hatkid.mkxpz.R;

public class GamepadButton extends ImageView
{
    private Drawable mBackgroundDrawable;
    private Drawable mForegroundDrawable;
    private String mText;
    private int mTextSize = 36;
    private final int mTextColor = Color.rgb(255, 255, 255);
    private final Paint mPaint = new Paint(Paint.ANTI_ALIAS_FLAG);

    private int mKey = 0;

    private OnKeyDownListener mOnKeyDownListener = key -> {};
    private OnKeyUpListener mOnKeyUpListener = key -> {};

    public interface OnKeyDownListener
    {
        void onKeyDown(int key);
    }

    public interface OnKeyUpListener
    {
        void onKeyUp(int key);
    }

    public GamepadButton(Context context)
    {
        super(context);
    }

    public GamepadButton(Context context, AttributeSet attrs)
    {
        super(context, attrs);
        initGamepadButton(attrs, null);
    }

    public GamepadButton(Context context, AttributeSet attrs, int defStyleAttr)
    {
        super(context, attrs, defStyleAttr);
        initGamepadButton(attrs, defStyleAttr);
    }

    public GamepadButton(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes)
    {
        super(context, attrs, defStyleAttr, defStyleRes);
        initGamepadButton(attrs, defStyleAttr);
    }

    public void initGamepadButton(AttributeSet attrs, Integer defStyleAttr)
    {
        if (attrs != null) {
            TypedArray a;

            if (defStyleAttr != null)
                a = getContext().obtainStyledAttributes(attrs, R.styleable.GamepadButton, defStyleAttr, R.style.GamepadButton);
            else
                a = getContext().obtainStyledAttributes(attrs, R.styleable.GamepadButton);

            this.mBackgroundDrawable = a.getDrawable(R.styleable.GamepadButton_bgDrawable);
            this.mForegroundDrawable = a.getDrawable(R.styleable.GamepadButton_fgDrawable);
            this.mText = a.getString(R.styleable.GamepadButton_text);

            a.recycle();
        }
    }

    @Override
    public void setBackground(Drawable drawable)
    {
        this.mBackgroundDrawable = drawable;
        initBitmap();
    }

    @Override
    public void setBackgroundResource(int drawableResource)
    {
        Drawable backgroundDrawable = getContext().getResources().getDrawable(drawableResource);
        setBackground(backgroundDrawable);
    }

    @Override
    public void setForeground(Drawable drawable)
    {
        this.mForegroundDrawable = drawable;
        this.mText = null;
        initBitmap();
    }

    public void setForegroundResource(int drawableResource)
    {
        Drawable foregroundDrawable = getContext().getResources().getDrawable(drawableResource);
        setForeground(foregroundDrawable);
    }

    public void setForegroundText(String text)
    {
        this.mForegroundDrawable = null;
        this.mText = text;
        initBitmap();
    }

    public void initBitmap()
    {
        if (this.getWidth() < 1 || this.getHeight() < 1)
            return;

        Bitmap bitmap = Bitmap.createBitmap(this.getWidth(), this.getHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bitmap);

        if (mBackgroundDrawable != null) {
            mBackgroundDrawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
            mBackgroundDrawable.draw(canvas);
        }

        int w = (int) Math.round(canvas.getWidth() * 0.9);
        int h = (int) Math.round(canvas.getHeight() * 0.9);
        int pw = (canvas.getWidth() - w) / 2;
        int ph = (canvas.getHeight() - h) / 2;

        if (mForegroundDrawable != null) {
            mForegroundDrawable.setBounds(pw, ph, w + pw, h + ph);
            mForegroundDrawable.draw(canvas);
        }

        if (mText != null) {
            initPaint();
            int x = (int) canvas.getWidth() / 2;
            int y = (int) canvas.getHeight() / 2;
            canvas.drawText(mText, 0, mText.length(), x, y - mPaint.ascent() / 2f, mPaint);
        }

        this.setImageBitmap(bitmap);
    }

    private void initPaint()
    {
        mPaint.setColor(mTextColor);
        mPaint.setTypeface(Typeface.create("sans-serif", Typeface.BOLD));
        mPaint.setTextAlign(Paint.Align.CENTER);
        mPaint.setTextSize(getTextSize());
    }

    private int getTextSize()
    {
        mPaint.setTextSize(mTextSize);

        int mIntrinsicWidth = (int) Math.round(mPaint.measureText(mText, 0, mText.length()) + .5);
        int mIntrinsicHeight = mPaint.getFontMetricsInt(null);

        while (mIntrinsicHeight > this.getHeight() * 0.85 || mIntrinsicWidth > this.getWidth() * 0.85)
        {
            mTextSize -= 2;
            mPaint.setTextSize(mTextSize);
            mIntrinsicWidth = (int) Math.round(mPaint.measureText(mText, 0, mText.length()) + .5);
            mIntrinsicHeight = mPaint.getFontMetricsInt(null);
        }

        return mTextSize;
    }

    public void setOnKeyDownListener(OnKeyDownListener onKeyDownListener)
    {
        mOnKeyDownListener = onKeyDownListener;
    }

    public void setOnKeyUpListener(OnKeyUpListener onKeyUpListener)
    {
        mOnKeyUpListener = onKeyUpListener;
    }

    public void setKey(int key)
    {
        mKey = key;
        initBitmap();
    }

    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom)
    {
        super.onLayout(changed, left, top, right, bottom);
        initBitmap();
    }

    @Override
    protected void onSizeChanged(int width, int height, int oldWidth, int oldHeight)
    {
        super.onSizeChanged(width, height, oldWidth, oldHeight);
        initBitmap();
    }

    @SuppressLint("ClickableViewAccessibility")
    @Override
    public boolean onTouchEvent(MotionEvent evt)
    {
        switch (evt.getAction())
        {
            case MotionEvent.ACTION_DOWN:
            case MotionEvent.ACTION_POINTER_DOWN:
                this.setAlpha(0.5f);
                mOnKeyDownListener.onKeyDown(mKey);
                break;

            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_POINTER_UP:
            case MotionEvent.ACTION_CANCEL:
                this.setAlpha(1.0f);
                mOnKeyUpListener.onKeyUp(mKey);
                break;
        }

        return true;
    }
}