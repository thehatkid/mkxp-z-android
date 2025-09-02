#!/bin/bash

# This script downloads/git clones project dependencies
# such as libogg, SDL2, Ruby, etc.


# Xiph libogg
if [[ ! -d "libogg" ]]; then
  echo "Downloading libogg..."
  git submodule add https://github.com/xiph/ogg libogg && cd libogg && git checkout v1.3.5 && cd ..
fi

# Xiph libvorbis
if [[ ! -d "libvorbis" ]]; then
  echo "Downloading libvorbis..."
  git submodule add https://github.com/xiph/vorbis libvorbis && cd libvorbis && git checkout v1.3.7 && cd ..
fi

# Xiph libtheora
if [[ ! -d "libtheora" ]]; then
  echo "Downloading libtheora..."
  git submodule add https://github.com/xiph/theora.git libtheora && cd libtheora && git checkout v1.1.1 && cd ..
fi

# GNU libiconv
if [[ ! -d "libiconv" ]]; then
  echo "Downloading libiconv..."
  git submodule add https://git.savannah.gnu.org/git/libiconv.git libiconv && cd libiconv && git checkout v1.17 && cd ..
fi

# Freedesktop uchardet
if [[ ! -d "uchardet" ]]; then
  echo "Downloading uchardet..."
  git submodule add https://gitlab.freedesktop.org/uchardet/uchardet.git uchardet && cd uchardet && git checkout v0.0.8 && cd ..
fi

# Freedesktop Pixman
if [[ ! -d "pixman" ]]; then
  echo "Downloading Pixman..."
  git submodule add https://gitlab.freedesktop.org/pixman/pixman.git pixman && cd pixman && git checkout pixman-0.43.2 && cd ..
fi

# PhysicsFS
if [[ ! -d "physfs" ]]; then
  echo "Downloading PhysicsFS..."
  git submodule add https://github.com/icculus/physfs physfs && cd physfs && git checkout release-3.2.0 && cd ..
fi

# SDL2
if [[ ! -d "SDL2" ]]; then
  echo "Downloading SDL2..."
  git submodule add https://github.com/libsdl-org/SDL SDL2 && cd SDL2 && git checkout release-2.30.0 && cd ..
fi

# SDL2_image
if [[ ! -d "SDL2_image" ]]; then
  echo "Downloading SDL2_image..."
  git submodule add https://github.com/libsdl-org/SDL_image SDL2_image && cd SDL2_image && git checkout release-2.8.2 && cd ..
fi

# SDL2_ttf
if [[ ! -d "SDL2_ttf" ]]; then
  echo "Downloading SDL2_ttf..."
  git submodule add https://github.com/libsdl-org/SDL_ttf SDL2_ttf && cd SDL2_ttf && git checkout release-2.22.0 && cd ..
fi

# SDL2_sound
if [[ ! -d "SDL2_sound" ]]; then
  echo "Downloading SDL2_sound..."
  git submodule add https://github.com/icculus/SDL_sound SDL2_sound && cd SDL2_sound && git checkout v2.0.2 && cd ..
fi

echo "Done!"
