package com.hatkid.mkxpz.utils;

public class DirectionUtils
{
    public enum Direction
    {
        UP,
        UP_RIGHT,
        RIGHT,
        DOWN_RIGHT,
        DOWN,
        DOWN_LEFT,
        LEFT,
        UP_LEFT,
        UNKNOWN
    }

    public static Direction getDir(float x, float y, boolean isDiagonal)
    {
        return getAngle(0, x, 0, y, isDiagonal);
    }

    public static Direction getDir(double angle, boolean isDiagonal)
    {
        if (isDiagonal)
            return get8dir(angle);
        else
            return get4dir(angle);
    }

    private static Direction get4dir(double angle)
    {
        if ((angle > 45) && (angle < 136))
            return Direction.UP;
        else if ((angle > 135) && (angle < 226))
            return Direction.RIGHT;
        else if ((angle > 225) && (angle < 316))
            return Direction.DOWN;
        else if (((angle >= 0) && (angle < 46)) || ((angle > 315) && (angle <361)))
            return Direction.LEFT;
        else
            return Direction.UNKNOWN;
    }

    private static Direction get8dir(double angle)
    {
        if ((angle >= 67.5) && (angle < 113.5))
            return Direction.UP;
        else if ((angle >= 113.5) && (angle < 158.5))
            return Direction.UP_RIGHT;
        else if ((angle >= 158.5) && (angle < 203.5))
            return Direction.RIGHT;
        else if ((angle >= 203.5) && (angle < 248.5))
            return Direction.DOWN_RIGHT;
        else if ((angle >= 248.5) && (angle < 293.5))
            return Direction.DOWN;
        else if ((angle >= 293.5) && (angle < 338.5))
            return Direction.DOWN_LEFT;
        else if (((angle >= 0) && (angle < 23.5)) || ((angle >= 338.5) && (angle <361)))
            return Direction.LEFT;
        else if ((angle >= 23.5) && (angle < 67.5))
            return Direction.UP_LEFT;
        else
            return Direction.UNKNOWN;
    }

    public static Direction getAngle(float initX, float posX, float initY, float posY, boolean isDiagonal)
    {
        double angle = 0;

        try {
            angle = Math.toDegrees(Math.atan2((initY - posY), (initX - posX)));
        } catch (Exception ignored) { }

        if (angle < 0)
            angle += 360;

        return DirectionUtils.getDir(angle, isDiagonal);
    }
}