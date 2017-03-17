FROM openjdk:8-jdk
MAINTAINER Pin <pinfake@hotmail.com>
ENV ANDROID_HOME="/opt/android-sdk-linux"
ENV ANDROID_SDK_HOME="${ANDROID_HOME}"
ENV PATH="${PATH}:${ANDROID_SDK_HOME}/tools:${ANDROID_SDK_HOME}/platform-tools"
ENV TERM=xterm
RUN dpkg --add-architecture i386 && \
    curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get install -y nodejs libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 build-essential \
    python-dev autoconf dtach vim tmux libc6:i386 libstdc++6:i386 zlib1g:i386 libgl1-mesa-dri && \
    apt-get clean
RUN npm install -g react-native-cli
RUN cd /tmp && git clone https://github.com/facebook/watchman.git && cd watchman && \
    git checkout v4.1.0 && ./autogen.sh && ./configure && make && make install && rm -rf /tmp/watchman
RUN mkdir /root/.gradle && touch /root/.gradle/gradle.properties && echo "org.gradle.daemon=true" >> /root/.gradle/gradle.properties
RUN cd /tmp && \
    curl -O https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
    cd /opt && tar xzf /tmp/*.tgz && rm /tmp/*.tgz
RUN echo "y" | android update sdk --no-ui --force -a --filter extra-android-m2repository,extra-android-support,extra-google-m2repository,platform-tools,android-23,build-tools-23.0.1
RUN echo "export PATH=${PATH}" > /root/.profile
COPY entrypoint.sh /
RUN ln -sv /usr/lib/x86_64-linux-gnu/mesa/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so
#RUN apt-get install -y lib32z1 lib32ncurses5
ENTRYPOINT ["/entrypoint.sh"]
