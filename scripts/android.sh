#!/bin/bash

timestamp=$(TZ='Africa/Cairo' date +"%Y-%m-%d_%T")

cd $HOME/main

# setup
cd Android
flutter pub get

cd android

if [ -f "$HOME/secrets/android/local.properties" ]; then
    cp $HOME/secrets/android/local.properties ./
elif [ ! -f "local.properties" ]; then
    echo "local.properties not found"
    exit -1
fi

# build
touch $HOME/flags/android-build.lck
gradle wrapper | tee -a "$HOME/logs/android/build_$timestamp" && ./gradlew clean | tee -a "$HOME/logs/android/build_$timestamp" && ./gradlew assembleDebug | tee -a "$HOME/logs/android/build_$timestamp" && rm $HOME/flags/android-build.lck

[ -f "$HOME/flags/android-build.lck" ] &&
    echo -e "Subject: Android Build Failed\nAndroid build failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    exit -1

# test
touch $HOME/flags/android-test.lck
# no tests yet so just echo
echo "android test successfull" | tee -a "$HOME/logs/android/test_$timestamp" && rm $HOME/flags/android-test.lck

[ -f "$HOME/flags/android-test.lck" ] &&
    echo -e "Subject: Android Tests Failed\nAndroid tests failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    exit -1

# deploy
[ ! -d "/var/www/files" ] && mkdir /var/www/files
rm -rf /var/www/files/*

cp ../build/app/outputs/flutter-apk/app-debug.apk /var/www/files/release.apk
echo "Deployed at [$(TZ='Africa/Cairo' date)]" | tee -a "$HOME/logs/time/android"