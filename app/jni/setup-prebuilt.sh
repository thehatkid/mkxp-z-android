#!/bin/bash

# This script downloads/git clones project dependencies that will be prebuilt.

GIT_ARGS="-q -c advice.detachedHead=false --single-branch --depth 1"

if [[ ! -d "libiconv" ]]; then
  echo "Downloading libiconv..."
  wget -q https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz
  tar -xzf libiconv-1.17.tar.gz
  mv libiconv-1.17 libiconv
  rm -f libiconv-1.17.tar.gz
fi

if [[ ! -d "fluidsynth" ]]; then
  echo "Downloading FluidSynth"
  git clone $GIT_ARGS https://github.com/VolcanoMobile/fluidsynth-android.git fluidsynth
fi

# OpenSSL 3.2.1
if [[ ! -d "openssl" ]]; then
  echo "Downloading OpenSSL..."
  git clone $GIT_ARGS -b openssl-3.2.1 https://github.com/openssl/openssl openssl
fi

# OpenAL Soft 1.23.1
if [[ ! -d "openal" ]]; then
  echo "Downloading OpenAL Soft..."
   git clone $GIT_ARGS -b 1.23.1 https://github.com/kcat/openal-soft openal
fi

# Ruby 3.1.0 (patched for mkxp-z)
if [[ ! -d "ruby" ]]; then
  echo "Downloading Ruby..."
  git clone $GIT_ARGS -b mkxp-z-3.1 https://github.com/mkxp-z/ruby ruby
fi