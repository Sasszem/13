FROM helpermethod/docker-luarocks

USER root
WORKDIR /

# install tha tools
RUN apk add openjdk8 wget bash
RUN apk add gcc musl-dev unzip libzip-dev
RUN luarocks install love-release
RUN luarocks install luafilesystem

RUN wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
RUN wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.6.0.jar -O apktool.jar
RUN chmod +x apktool
RUN mv ./apktool* /usr/local/bin/


# install GLIBC cuz' zipalign is a POS

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk
RUN apk add glibc-2.34-r0.apk

# install zipalign cuz' we need that
RUN apk add --no-cache curl libgcc musl
# libc6-compat
RUN curl -sL https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip -o /sdktools.zip
RUN mkdir -p /sdk/licenses
WORKDIR /sdk
RUN unzip -q /sdktools.zip
RUN echo 24333f8a63b6825ea9c5514f83c2829b004d1fee > /sdk/licenses/android-sdk-license
RUN /sdk/tools/bin/sdkmanager "build-tools;26.0.1"


RUN cp /lib/libz.so.1 /sdk/build-tools/26.0.1/lib64/
RUN cp /usr/lib/libgcc_s.so.1 /sdk/build-tools/26.0.1/lib64/
RUN cp /lib/libc.musl-x86_64.so.1 /sdk/build-tools/26.0.1/lib64/
RUN ln -s /sdk/build-tools/26.0.1/zipalign /usr/bin/zipalign

WORKDIR /project/
#CMD sh
CMD lua build.lua
#USER lua
#WORKDIR lua
