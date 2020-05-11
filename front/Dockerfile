FROM cirrusci/flutter:latest

WORKDIR /tmp

RUN flutter create picts_manager_bootstrap && ls -la

WORKDIR /tmp/picts_manager_bootstrap

RUN sudo apt-get update -y && sudo apt-get install -y android-sdk

RUN sudo apt-get remove --purge -y openjdk-*-jdk && sudo apt-get install -y openjdk-8-jdk

#change java-11 to java-8
RUN java -version && sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java 1112 && java -version

RUN flutter precache

RUN cd $ANDROID_HOME/tools/bin && sudo ./*sdkmanager "system-images;android-27;google_apis_playstore;x86" && sudo ./sdkmanager --licenses

RUN flutter emulators
