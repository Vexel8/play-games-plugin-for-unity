FROM java:jdk
ENV DEBIAN_FRONTEND noninteractive
# Dependencies
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -yq file libstdc++6:i386 zlib1g:i386 libncurses5:i386 lib32z1 make ant maven mono-complete monodevelop nunit nunit-console --no-install-recommends

ENV GRADLE_URL http://services.gradle.org/distributions/gradle-2.2.1-all.zip
RUN curl -L ${GRADLE_URL} -o /tmp/gradle-2.2.1-all.zip && unzip /tmp/gradle-2.2.1-all.zip -d /usr/local && rm /tmp/gradle-2.2.1-all.zip
ENV GRADLE_HOME /usr/local/gradle-2.2.1
# Download and untar SDK
ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN curl -L ${ANDROID_SDK_URL} | tar xz -C /usr/local
ENV ANDROID_SDK_HOME /usr/local/android-sdk-linux
ENV ANDROID_HOME /usr/local/android-sdk-linux
RUN chmod g+rwxs $ANDROID_HOME
# Install Android SDK components
ENV ANDROID_SDK_COMPONENTS platform-tools,build-tools;25.0.2,build-tools-23.0.2,android-23,android-22,source-21,extra-android-support,extra-android-m2repository,extra-google-m2repository
RUN echo y | ${ANDROID_SDK_HOME}/tools/android update sdk --no-ui --all --filter "${ANDROID_SDK_COMPONENTS}"
RUN mkdir -p "${ANDROID_HOME}/licenses"
RUN chmod -R 777 $ANDROID_HOME
RUN echo 2be0707768cdfbd4d05ab4bcbae066129ba66f5d > "${ANDROID_HOME}/licenses/Android SDK License"
RUN echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > "${ANDROID_HOME}/licenses/android-sdk-license"
RUN echo d56f5187479451eabf01fb78af6dfcb131a6481e >> "${ANDROID_HOME}/licenses/android-sdk-license"

# Install Android NDK
ENV NDK_URL http://dl.google.com/android/ndk/android-ndk-r10d-linux-x86_64.bin
RUN curl ${NDK_URL} -o /tmp/android-ndk-r10d-linux-x86_64.bin && chmod +x /tmp/android-ndk-r10d-linux-x86_64.bin && \
    cd /usr/local && /tmp/android-ndk-r10d-linux-x86_64.bin && rm /tmp/android-ndk-r10d-linux-x86_64.bin
ENV NDK_HOME /usr/local/android-ndk-r10d
ENV ANDROID_NDK_HOME /usr/local/android-ndk-r10d
ENV ANDROID_NDK_ROOT=${ANDROID_NDK_HOME}
# Path
ENV PATH $PATH:${ANDROID_SDK_HOME}/tools:${ANDROID_SDK_HOME}/platform-tools:${GRADLE_HOME}/bin:${NDK_HOME}
RUN useradd devrel-build -u 250520 -m
