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
patchelf --set-rpath '$ORIGIN' ./lib/*.so*
rm -f ./*.zip ./RunRoR

# TODO find a way to set version automatically, will leavea this as reference in case dev doesn't sync with GH releases
#echo '2026.01' > ~/version
VERSION="$(git ls-remote --tags --sort="v:refname" https://github.com/RigsOfRods/rigs-of-rods | grep -o '20[0-9]\{2\}\.[0-9]\{2\}' | tail -n1)"
echo "$VERSION" > ~/version
