#!/bin/bash

timestamp=$(TZ='Africa/Cairo' date +"%Y-%m-%d_%T")

cd $HOME/main

# setup
cd Backend

[ ! -d "secret" ] && mkdir secret
if [ -f "$HOME/secrets/api/.env" ]; then
    cp $HOME/secrets/api/.env secret/.env
elif [ ! -f "secret/.env" ]; then
    echo ".env not found"
    exit -1
fi

set -o pipefail

# build
touch $HOME/flags/api-build.lck
npm install | tee -a "$HOME/logs/api/build_$timestamp" && rm $HOME/flags/api-build.lck

[ -f "$HOME/flags/api-build.lck" ] &&
    echo -e "Subject: API Build Failed\nAPI build failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    exit -1

# test
touch $HOME/flags/api-test.lck
# no tests yet so just echo
echo "api test successfull" | tee -a "$HOME/logs/api/test_$timestamp" && rm $HOME/flags/api-test.lck

[ -f "$HOME/flags/api-test.lck" ] &&
    echo -e "Subject: API Tests Failed\nAPI tests failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    exit -1

# deploy
[ ! -d "/var/www/api" ] && mkdir /var/www/api
rm -rf /var/www/api/*

cp -r ./* /var/www/api/

cd /var/www/api
pm2 -s delete server
pm2 -s start ./bin/server.js
pm2 -s save

echo "Deployed at [$(TZ='Africa/Cairo' date)]" | tee -a "$HOME/logs/time/api"