#!/bin/bash

TMPDEST="./temp"
VLC_ANDROID_TAG="3.0.6"
VLC_TESTED_HASH="d7b653c"
SOURCE_URL="http://download.videolan.org/pub/videolan/vlc-android/$VLC_ANDROID_TAG/VLC-Android-sources-$VLC_ANDROID_TAG.tar.gz"
ARCHITECTURES="armeabi-v7a x86"

export ANDROID_SDK=/home/slim/Android/Sdk
export ANDROID_NDK=/home/slim/Android/ndk14
export PATH=$PATH:$ANDROID_SDK/platform-tools:$ANDROID_SDK/tools

mkdir -p "$TMPDEST"
DESTFILE="$TMPDEST/$(basename $SOURCE_URL)"
curl -s "$SOURCE_URL" -o "$DESTFILE"
tar -xvf "$DESTFILE" --directory "$TMPDEST"
cd "$TMPDEST"
sed -i -E -e "s/^(TESTED_HASH=[A-Za-z0-9]*)$/TESTED_HASH=$VLC_TESTED_HASH/g" compile.sh
for ARCH in $ARCHITECTURES;
do
    sh compile.sh -a $ARCH -l --release --no-ml
    #TODO unzip aar and move jnissssssss
done
