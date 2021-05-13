# Based on https://code.videolan.org/videolan/docker-images/-/blob/c64798bc010982bdf557dee79e90993cb2158324/vlc-debian-android/Dockerfile

FROM debian:buster-20200224

ENV USERNAME="stremioci"
ENV OPEN_JDK=/home/"$USERNAME"/open-jdk
ENV ANDROID_SDK=/home/"$USERNAME"/android-sdk
ENV ANDROID_NDK=/home/"$USERNAME"/android-ndk
ENV PATH="$OPEN_JDK"/bin:"$ANDROID_NDK"/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH

RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends -y \
    ca-certificates autoconf m4 automake ant autopoint bison \
    flex build-essential libtool libtool-bin patch pkg-config ragel subversion \
    git rpm2cpio yasm ragel g++ protobuf-compiler gettext meson ninja-build \
    libgsm1-dev wget expect unzip zip python python3 locales libltdl-dev curl cmake automake nasm && \
    apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    addgroup --quiet "$USERNAME" && \
    adduser --quiet --disabled-password -gecos "" --ingroup "$USERNAME" "$USERNAME" && \
    echo "$USERNAME:$USERNAME" | chpasswd

USER "$USERNAME"
RUN mkdir -p "$OPEN_JDK" && cd "$OPEN_JDK" && \
    echo "Download openjdk" && wget -q https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u232-b09/OpenJDK8U-jdk_x64_linux_8u232b09.tar.gz && \
    JDK_SHA256=c261f5e2776f4430249fcf6276649969a40f28262d1f224390aa764ae84464df && \
    echo $JDK_SHA256 OpenJDK8U-jdk_x64_linux_8u232b09.tar.gz | sha256sum -c && \
    echo "Extract openjdk" && tar -xzf OpenJDK8U-jdk_x64_linux_8u232b09.tar.gz --strip=1 && \
    rm -f OpenJDK8U-jdk_x64_linux_8u232b09.tar.gz && \
    mkdir -p "$ANDROID_SDK" && cd "$ANDROID_SDK" && \
    mkdir licenses && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "licenses/android-sdk-license" && \
    echo "d56f5187479451eabf01fb78af6dfcb131a6481e" >> "licenses/android-sdk-license" && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" >> "licenses/android-sdk-license" && \
    echo "Download android sdk" && wget -q https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    SDK_TOOLS_SHA256=444e22ce8ca0f67353bda4b85175ed3731cae3ffa695ca18119cbacef1c1bea0 && \
    echo "$SDK_TOOLS_SHA256" sdk-tools-linux-3859397.zip | sha256sum -c && \
    echo "Extract android sdk" && unzip -q sdk-tools-linux-3859397.zip && \
    rm -f sdk-tools-linux-3859397.zip && \
    tools/bin/sdkmanager "build-tools;26.0.1" "platform-tools" "platforms;android-26" && \
    mkdir -p "$ANDROID_NDK" && cd "$ANDROID_NDK" && \
    ANDROID_NDK_VERSION=r21 && \
    echo "Download android ndk" && wget -q https://dl.google.com/android/repository/android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip && \
    ANDROID_NDK_SHA256=b65ea2d5c5b68fb603626adcbcea6e4d12c68eb8a73e373bbb9d23c252fc647b && \
    echo "$ANDROID_NDK_SHA256" android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip | sha256sum -c && \
    echo "Extract android ndk" && unzip -q android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip && \
    rm -f android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip && \
    mv android-ndk-$ANDROID_NDK_VERSION/** . && \
    rm -rf android-ndk-$ANDROID_NDK_VERSION && \
    git config --global user.name "$USERNAME" && \
    git config --global user.email "$USERNAME@stremio.com"

COPY compile-jni /home/"$USERNAME"/
ENTRYPOINT ["/home/stremioci/compile-jni"]
