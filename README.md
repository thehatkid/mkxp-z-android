# mkxp-z for Android

This is port of [mkxp-z](https://github.com/mkxp-z/mkxp-z) to Android.

Currently, it's *almost* works properly (likely, *experemental*),
but enough to have running RPG Maker XP, VX and VX Ace games.

## Running mkxp-z on Android

0. ~~Build mkxp-z application~~ (TODO: make tutorial or public release)
1. Install APK on your Android device
2. Create `mkxp-z` folder on internal storage (e.g. `/storage/emulated/0/mkxp-z`)
3. You can put custom mkxp-z config ([mkxp.json](app/jni/mkxp-z/mkxp.json)) in `mkxp-z` folder
   (e.g. preload scripts or change game directory to load game from external storage)
4. Copy game files into folder `mkxp-z`
   (or to other game folder that defined in your `mkxp.json`)
5. Run mkxp-z, grant access to storage, and have fun, I think?

## Known issues

- You can't write saves/files in external storage (such as SD Card) on lower than Android 10
  (On Android 11+ granting All Files Access means You can write on external storages)

## To Do...

- mkxp-z Android compilation tutorial on GitHub Wiki page
- Fix compile Ruby extensions in Windows MSYS2 environment
- *...and much more, I think?*
