#!/bin/bash

timestamp=$(TZ='Africa/Cairo' date +"%Y-%m-%d_%T")
lock="$HOME/flags/web-build.lck"

cd $HOME/main
[ ! -d "main" ] && ./files/scripts/update.sh || exit -1

# setup
set -o pipefail

cd FrontEnd

# build
touch $lock
npm install | tee -a "$HOME/logs/web/build_$timestamp" &&
    npm run build | tee -a "$HOME/logs/web/build_$timestamp" &&
    rm $lock

[ -f $lock ] &&
    echo -e "Subject: Web Build Failed\nWeb build failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    rm $lock &&
    exit -1