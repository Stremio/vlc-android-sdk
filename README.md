# VLC-ANDROID-SDK

[![Build Status](https://travis-ci.com/Stremio/vlc-android-sdk.svg?branch=master)](https://travis-ci.com/Stremio/vlc-android-sdk)

### libvlc for android based on VLC-Android 3.3.4

# Setup

## Gradle

### Add the JitPack repository to your root build.gradle

```gradle
allprojects {
    repositories {
        ...
        maven { url 'https://jitpack.io' }
    }
}
```

### Add the vlc-android-sdk dependency

```gradle
dependencies {
    implementation 'com.github.stremio:vlc-android-sdk:6.0.1'
}
```

## Manual

[Download](https://jitpack.io/com/github/stremio/vlc-android-sdk/6.0.1/vlc-android-sdk-6.0.1.aar) aar and link it manually
