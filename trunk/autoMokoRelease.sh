#!/bin/bash
BUILD_ROOT=""                                                                   #Path from / to the directory where you have checked out the repo.
PROJECT="android-on-freerunner"                                                 #Google code project
USER=""                                                                         #Google code user name without @gmail.com
PASSWORD=""                                                                     #Google code password not you gmail password can be found here:
                                                                                #http://code.google.com/hosting/settings
ANDROID_VERSION="Cupcake"                                                       #version for lables
LABELS="Type-Archive, BuildVersion-Weekly"                                      #Labels
SUMMARY="Weekly realease of andoid-on-freerunner."                              #Summary "Buildt on: YYYY-MM-DD" will be added to this.
FILENAME="android-on-freerunner-cupcake-week"                                   #Filename "-YYYY-WW" will be added to the end, after this
                                                                                #.zip or .tar.gz will be added

LABELS=$LABELS", AndroidVersion-$ANDROID_VERSION"
SUMMARY=$SUMMARY" Buildt on: "$(date +%Y-%m-%d)
FILENAME=$FILENAME"-"$(date +%Y-%V)
cd $BUILD_ROOT
repo sync
make TARGET_PRODUCT=freerunner
rm -rf weeklyBuild
mkdir weeklyBuild
cp -R baseDir/* weeklyBuild/
cp out/target/product/freerunner/*.img weeklyBuild/
md5sum weeklyBuild/boot/uImage-GTA02.bin weeklyBuild/ramdisk.img weeklyBuild/uImage weeklyBuild/userdata.img weeklyBuild/kernel.img weeklyBuild/qi.img  weeklyBuild/system.img weeklyBuild/uImage.bin > weeklyBuild/md5sums
cd weeklyBuild
zip -r ../$FILENAME .                                                           #Bugged out zip command!!!!!!!!
cd ..
tar -czvf $FILENAME.tar.gz weeklyBuild/*

./googlecode_upload.py -s "$SUMMARY" -p $PROJECT -u $USER -w $PASSWORD -l "$LABELS, OpSys-Windows" $FILENAME.zip
./googlecode_upload.py -s "$SUMMARY" -p $PROJECT -u $USER -w $PASSWORD -l "$LABELS, OpSys-Linux" $FILENAME.tar.gz
