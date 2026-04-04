#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libxaw \
    openal \
    patchelf

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package itchio-downloader

# If the application needs to be manually built that has to be done down here
echo "Getting app..."
echo "---------------------------------------------------------------"
mkdir -p ./AppDir/bin
cd ./AppDir/bin
itchio-downloader --url "https://rigs-of-rods.itch.io/rigs-of-rods" --platform linux --downloadDirectory .
bsdtar -xvf ./game-2066563.zip
patchelf --set-rpath '$ORIGIN/lib' ./RoR
rm -f ./*.zip ./*.RunRoR
