# mkxp-z for Android

This is port of [mkxp-z](https://github.com/mkxp-z/mkxp-z) to Android.

Currently, it's *almost* works properly (likely, *experemental*),
but enough to have running RPG Maker XP, VX and VX Ace games.

## Running mkxp-z on Android

0. ~~Build mkxp-z application in Android Studio or with Gradle in command line~~
   (TODO: make tutorial or public release)
1. Install APK on your Android device
2. Create `mkxp-z` folder on internal storage (e.g. `/storage/emulated/0/mkxp-z`)
3. You can put custom mkxp-z config ([mkxp.json](app/jni/mkxp-z/mkxp.json)) in `mkxp-z` folder
   (e.g. preload scripts or change game directory to load game from external storage)
4. Copy game files into folder `mkxp-z`
   (or to other game folder that defined in your `mkxp.json`)
5. Run mkxp-z and have fun, I think?

## Known issues

- You can't write saves/files in external storage (such as SD Card) due Android security policy
  (i.e. external storage is read-only and unable to create and modify files on it)
- Unable to read `/storage/emulated/0/mkxp-z` directory content on Android 11+ due Scoped Storage
  (Possible fix: Give a permission to mkxp-z application "Allow management of all files",
  but **not works** in Android 13+)

## To Do...

- mkxp-z Android compilation tutorial on GitHub Wiki page
- Fix compile Ruby extensions in Windows MSYS2 environment
- Try to fit on Scoped Storage restrictions
  - with selecting RPG Maker game folder with folder picker in Android (`ACTION_OPEN_DOCUMENT_TREE`)
  - with changing default game path to Android `Documents` folder (?)
- Loading RPG Maker game from [Android OBB](https://developer.android.com/google/play/expansion-files) files
- *...and much more, I think?*
