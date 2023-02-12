#!/bin/sh

# This script makes hexdump of files (XXD) from assets, fonts and shaders
# to include assets in mkxp-z and then built into binary (library).

# Check if directories are not exists
if [ ! -d "xxd" ]; then
  # Create directories: xxd, xxd/assets and xxd/shader
  mkdir -p xxd
  if [ ! -d "xxd/assets" ]; then mkdir -p xxd/assets; fi
  if [ ! -d "xxd/shader" ]; then mkdir -p xxd/shader; fi
fi

# Clean up XXD files
rm -f xxd/assets/*.xxd
rm -f xxd/shader/*.xxd

# Make hexdumps of files
for i in $(ls assets); do
  printf "Generating assets/%s.xxd\n" $i
  xxd -i "assets/$i" "xxd/assets/$i.xxd"
done

for i in $(ls shader); do
  printf "Generating shader/%s.xxd\n" $i
  xxd -i "shader/$i" "xxd/shader/$i.xxd"
done
