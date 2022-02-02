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
    echo "Download openjdk" && wget -q https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases/download/jdk-11.0.12%2B7/OpenJDK11U-jdk_x64_linux_11.0.12_7.tar.gz && \
    JDK_SHA256=06c04b1eccd61dec3849e88f7606d17192c9a713a433ba26f82fe5fe9587d6bb && \
    echo $JDK_SHA256 OpenJDK11U-jdk_x64_linux_11.0.12_7.tar.gz | sha256sum -c && \
    echo "Extract openjdk" && tar -xzf OpenJDK11U-jdk_x64_linux_11.0.12_7.tar.gz --strip=1 && \
    rm -f OpenJDK11U-jdk_x64_linux_11.0.12_7.tar.gz && \
    mkdir -p "$ANDROID_SDK" && cd "$ANDROID_SDK" && \
    mkdir licenses && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "licenses/android-sdk-license" && \
    echo "d56f5187479451eabf01fb78af6dfcb131a6481e" >> "licenses/android-sdk-license" && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" >> "licenses/android-sdk-license" && \
    echo "Download android sdk" && wget -q https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip && \
    SDK_TOOLS_SHA256=124f2d5115eee365df6cf3228ffbca6fc3911d16f8025bebd5b1c6e2fcfa7faf && \
    echo "$SDK_TOOLS_SHA256" commandlinetools-linux-7583922_latest.zip | sha256sum -c && \
    echo "Extract android sdk" && unzip -q commandlinetools-linux-7583922_latest.zip && \
    rm -f commandlinetools-linux-7583922_latest.zip && \
    cmdline-tools/bin/sdkmanager --verbose --sdk_root="$ANDROID_SDK" "build-tools;26.0.1" "platform-tools" "platforms;android-26" && \
    mkdir -p "$ANDROID_NDK" && cd "$ANDROID_NDK" && \
    ANDROID_NDK_VERSION=r21 && \
    echo "Download android ndk" && wget -q https://dl.google.com/android/repository/android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip && \
    ANDROID_NDK_SHA256=b65ea2d5c5b68fb603626adcbcea6e4d12c68eb8a73e373bbb9d23c252fc647b && \
    echo "$ANDROID_NDK_SHA256" android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip | sha256sum -c && \
    echo "Extract android ndk" && unzip -q android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip && \
    rm -f android-ndk-$ANDROID_NDK_VERSION-linux-x86_64.zip && \
    mv android-ndk-$ANDROID_NDK_VERSION/** . && \
    rm -rf android-ndk-$ANDROID_NDK_VERSION && \
    git config --global http.sslVerify false && \
    git config --global user.name "$USERNAME" && \
    git config --global user.email "$USERNAME@stremio.com"

COPY compile-jni /home/"$USERNAME"/
ENTRYPOINT ["/home/stremioci/compile-jni"]
