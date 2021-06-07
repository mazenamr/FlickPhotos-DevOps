#!/bin/bash

timestamp=$(TZ='Africa/Cairo' date +"%Y-%m-%d_%T")
lock="$HOME/flags/api-build.lck"

cd $HOME
[ ! -d "main" ] && (./files/scripts/update.sh || exit -1)
cd main

# setup
set -o pipefail

cd Backend

# get secrets
[ ! -d "secret" ] && mkdir secret

if [ -f "$HOME/secrets/api/.env" ]; then
    cp $HOME/secrets/api/.env secret/.env
elif [ ! -f "secret/.env" ]; then
    echo ".env not found"
    exit -1
fi

if [ -f "$HOME/secrets/api/serviceAccountKey.json" ]; then
    cp $HOME/secrets/api/serviceAccountKey.json secret/serviceAccountKey.json
elif [ ! -f "secret/serviceAccountKey.json" ]; then
    echo "serviceAccountKey.json not found"
    exit -1
fi

# build
touch $lock
npm install | tee -a "$HOME/logs/api/build_$timestamp" &&
    rm $lock

[ -f $lock ] &&
    echo -e "Subject: API Build Failed\nAPI build failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    rm $lock &&
    exit -1 ||
    echo "API built at [$(TZ='Africa/Cairo' date)]"
