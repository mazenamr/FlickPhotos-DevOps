#!/bin/bash

timestamp=$(TZ='Africa/Cairo' date +"%Y-%m-%d_%T")
lock="$HOME/flags/apidocs-build.lck"

cd $HOME/main
[ ! -d "main" ] && ./files/scripts/update.sh || exit -1

# setup
set -o pipefail

cd NewDocs
[ ! -d "build" ] && mkdir build
rm -rf build/*

# build
touch $lock
npm install | tee -a "$HOME/logs/apidocs/build_$timestamp" &&
    npx apidoc -e node_modules/ -o build/ | tee -a "$HOME/logs/apidocs/build_$timestamp" &&
    rm $lock

[ -f $lock ] &&
    echo -e "Subject: API Docs Build Failed\nAPI docs build failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    rm $lock &&
    exit -1