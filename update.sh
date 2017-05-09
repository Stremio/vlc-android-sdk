#!/bin/bash

VER=${1:-"2.0.6"}

TMPDEST="./temp"
JNIDIR="./src/main/jniLibs"
SRCDIR="./src/main/java"

mkdir -p "$TMPDEST"
rm -rf "$JNIDIR"/*
rm -rf "$SRCDIR"/*

for ARCH in "ARMv7" "ARMv8" "x86" "x86_64" "MIPS";
do
    APK_URL="ftp://ftp.videolan.org/pub/videolan/vlc-android/$VER/VLC-Android-$VER-$ARCH.apk"
    DESTFILE="$TMPDEST/$(basename $APK_URL)"
    curl -s "$APK_URL" -o "$DESTFILE"
    unzip "$DESTFILE" -d "$TMPDEST"
    mv "$TMPDEST"/lib/* "$JNIDIR"
    rm -rf "$TMPDEST"/*
done

SOURCE_CODE_URL="ftp://ftp.videolan.org/pub/videolan/vlc-android/$VER/VLC-Android-$VER.tar.gz"
DESTFILE="$TMPDEST/$(basename $SOURCE_CODE_URL)"
curl -s "$SOURCE_CODE_URL" -o "$DESTFILE"
tar -xvf "$DESTFILE" --directory "$TMPDEST"
mv "$TMPDEST"/libvlc/src/* "$SRCDIR"

rm -rf "$TMPDEST"
