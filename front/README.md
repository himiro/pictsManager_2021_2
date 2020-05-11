You can use docker or install flutter on your computer

# DOCKER (don't work)
## PRE-REQUIS
  - docker

## Docker Usage
*To understand all the flags run the command `docker run --help` or `docker build -h`*
  - docker pull IMAGE_NAME:TAG
  - docker build -t IMAGE_NAME:TAG FOLDER_DEST
  - docker run --rm -it -e [SOURCE_FOLDER]:/tmp/[DEST_FOLDER] IMAGE_NAME:TAG COMMAND

## Flutter troubles ?
  - Run `flutter doctor -v`


# LOCAL INSTALLATION

## PRE-REQUIS
   - git
   - curl
   - AndroidStudio
   - IntelliJ
   - dart

## Installation
   - git clone https://github.com/flutter/flutter.git -b stable
   - add export PATH="$PATH:`pwd`/flutter/bin" to .bashrc
   - flutter doctor (check your config)
   - flutter devices (check your devices connections)

## Creation flutter application
   - flutter create app
   - flutter run