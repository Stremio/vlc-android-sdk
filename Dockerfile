FROM debian:stretch-20190506

ARG VLC_ANDROID_TAG

ENV VLC_ANDROID_TAG=$VLC_ANDROID_TAG
ENV ANDROID_NDK="/android-ndk"
ENV ANDROID_SDK="/android-sdk"

RUN addgroup --quiet "stremioci" && \
    adduser --quiet --ingroup "stremioci" "stremioci" && \
    echo "stremioci:stremioci" | chpasswd && \
    apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y \
    openjdk-8-jdk-headless ca-certificates autoconf m4 automake ant autopoint bison \
    flex build-essential libtool libtool-bin patch pkg-config ragel subversion \
    git rpm2cpio libwebkitgtk-1.0-0 yasm ragel g++ protobuf-compiler gettext \
    libgsm1-dev wget expect unzip python python3 locales libltdl-dev && \
    echo "deb http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list && \
    apt-get update && apt-get -y -t stretch-backports install cmake && \
    rm -f /etc/apt/sources.list.d/stretch-backports.list && \
    echo "deb http://deb.debian.org/debian testing main" > /etc/apt/sources.list.d/testing.list && \
    apt-get update && apt-get -y -t testing --no-install-suggests --no-install-recommends install automake && \
    rm -f /etc/apt/sources.list.d/testing.list && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    cd / && mkdir "android-ndk" && cd "android-ndk" && \
    wget -q https://dl.google.com/android/repository/android-ndk-r18b-linux-x86_64.zip && \
    ANDROID_NDK_SHA256=4f61cbe4bbf6406aa5ef2ae871def78010eed6271af72de83f8bd0b07a9fd3fd && \
    echo $ANDROID_NDK_SHA256 android-ndk-r18b-linux-x86_64.zip | sha256sum -c && \
    unzip android-ndk-r18b-linux-x86_64.zip && \
    rm -f android-ndk-r18b-linux-x86_64.zip && \
    mv android-ndk-r18b/** . && \
    rm -rf android-ndk-r18b && \
    cd / && mkdir "android-sdk" && cd "android-sdk" && \
    mkdir "licenses" && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "licenses/android-sdk-license" && \
    echo "d56f5187479451eabf01fb78af6dfcb131a6481e" >> "licenses/android-sdk-license" && \
    wget -q https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    SDK_TOOLS_SHA256=444e22ce8ca0f67353bda4b85175ed3731cae3ffa695ca18119cbacef1c1bea0 && \
    echo $SDK_TOOLS_SHA256 sdk-tools-linux-3859397.zip | sha256sum -c && \
    unzip sdk-tools-linux-3859397.zip && \
    rm -f sdk-tools-linux-3859397.zip && \
    tools/bin/sdkmanager "build-tools;26.0.1" "platform-tools" "platforms;android-26" && \
    chown -R "stremioci" "/android-ndk" && \
    chown -R "stremioci" "/android-sdk"

USER stremioci

RUN git config --global user.name stremioci && \
    git config --global user.email stremioci@stremio.com
