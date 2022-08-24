# Android gradleBuild 
# name:houbijian
# email:hou.bijian@huake-tek.com

# ubuntu:18.04 x64
FROM ubuntu:18.04

ENV LANG C.UTF-8

#---------Install Ubuntu tools
RUN apt-get update
RUN apt-get install -y  net-tools
RUN apt-get install -y  iputils-ping
RUN apt-get install -y  curl unzip git
RUN apt-get install  wget
RUN apt-get update

RUN mkdir -p /usr/src/androidtools/

#---------Install and configure JDK 1.8
#COPY ./jdk-8u341-linux-x64.tar.gz /usr/src/androidtools/jdk-8u341-linux-x64.tar.gz
RUN cd /usr/src/androidtools && \
    wget https://repo.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz && \
    tar zxvf jdk-8u202-linux-x64.tar.gz
RUN cd /usr/src/androidtools && \
    ls
#RUN echo "\n export JAVA_HOME=/usr/src/androidtools/jdk1.8.0_341 \n export JRE_HOME=${JAVA_HOME}/jre \n export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib \n export PATH=${JAVA_HOME}/bin:$PATH" >> /etc/profile && \
#        source /etc/profile
# Add PATH
ENV JAVA_HOME /usr/src/androidtools/jdk1.8.0_202
ENV JRE_HOME ${JAVA_HOME}/jre
ENV CLASSPATH .:${JAVA_HOME}/lib:${JRE_HOME}/lib
ENV PATH ${JAVA_HOME}/bin:$PATH

#RUN add-apt-repository -y ppa:webupd8team/java
#RUN add-apt-repository -y ppa:ts.sch.gr/ppa
#RUN apt-get update
#RUN apt-get -y install oracle-java8-installer
RUN java -version

#---------Install and configure Gradle 4.6
#COPY ./gradle-4.6-all.zip /usr/src/androidtools/gradle-4.6-all.zip
RUN cd /usr/src/androidtools && \
    wget https://downloads.gradle-dn.com/distributions/gradle-4.6-all.zip && \
    unzip gradle-4.6-all.zip
RUN cd /usr/src/androidtools && \
    ls
#RUN echo "\n GRADLE_HOME=/usr/src/androidtools/gradle-4.6 \n PATH=$GRADLE_HOME/bin:$PATH" >> /etc/profile && \
#        source /etc/profile
# Add PATH
ENV GRADLE_HOME /usr/src/androidtools/gradle-4.6
ENV PATH $GRADLE_HOME/bin:$PATH
RUN gradle -v

#---------Install and configure SDK
#COPY ./android-sdk_r24.4.1-linux.tgz /usr/src/androidtools/android-sdk_r24.4.1-linux.tgz
RUN cd /usr/src/androidtools && \
    wget https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
    tar zxvf android-sdk_r24.4.1-linux.tgz
RUN cd /usr/src/androidtools && \
    ls
#RUN echo "\n ANDROID_SDK_HOME=/usr/src/androidtools/android-sdk-linux \n PATH=$PATH:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools" >> /etc/profile && \
#        source /etc/profile
# Add PATH
ENV ANDROID_HOME /usr/src/androidtools/android-sdk-linux
ENV ANDROID_SDK_HOME /usr/src/androidtools/android-sdk-linux
ENV PATH $PATH:$ANDROID_SDK_HOME/tools:$ANDROID_SDK_HOME/platform-tools

#---------Install and configure SDK Tools
#1.API 28/API 26/API 25 or Android 9.0/Android 8.0/Android 7.1.1
#2.Android SDK Build-Tools 28.0.2
#3.Platform-Tools

RUN echo y | android update sdk --no-ui --all --filter build-tools-28.0.2,android-28,android-26,android-25,extra-android-m2repository
RUN echo y | android update sdk --no-ui --all --filter Platform-Tools

#----------Delete not files required 
RUN cd /usr/src/androidtools && \
	rm jdk-8u202-linux-x64.tar.gz gradle-4.6-all.zip android-sdk_r24.4.1-linux.tgz
	
#RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.2,build-tools-28.0.3
#RUN echo y | android update sdk --no-ui --all --filter android-21,android-23,android-24,android-29,android-30,android-31,android-22

RUN mkdir -p /usr/src/androidpro/
COPY . /usr/src/androidpro/

#---------RUN Build
RUN cd /usr/src/androidpro/ && \
    gradle assemble