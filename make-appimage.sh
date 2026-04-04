#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=2026.01
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/RigsOfRods/rigs-of-rods/refs/heads/master/doc/images/rorlogo.png
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun ./AppDir/bin/RunRoR ./AppDir/bin/RoR /usr/lib/Plugin*.so* /usr/lib/Render*.so* /usr/lib/libMyGUI*.so* /usr/lib/libOgre*.so* /usr/lib/Codec*.so* /usr/lib/fips.so /usr/lib/legacy.so
#quick-sharun ./AppDir/bin/RunRoR ./AppDir/bin/RoR
ln -sf ./AppDir/shared/lib ./AppDir/bin/lib
#echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
