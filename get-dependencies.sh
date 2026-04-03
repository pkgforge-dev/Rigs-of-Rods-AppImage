#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libxaw \
    openal

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
make-aur-package itchio-downloader

# If the application needs to be manually built that has to be done down here
echo "Getting app..."
echo "---------------------------------------------------------------"
itchio-downloader --url "https://rigs-of-rods.itch.io/rigs-of-rods" --platform linux --downloadDirectory .
mkdir -p ./AppDir/bin
bsdtar -xvf game-2066563.zip
rm -f *.zip
#sed -i "s#PluginFolder=lib#PluginFolder=\"\$APPDIR\"/shared/lib#" plugins.cfg
#mv -v RoR plugins.cfg resources languages content ./AppDir/bin
mv -v RoR resources languages content lib ./AppDir/bin
#mv -v lib/* /usr/lib
