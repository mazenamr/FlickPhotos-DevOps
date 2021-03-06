#!/bin/bash

timestamp=$(TZ='Africa/Cairo' date +"%Y-%m-%d_%T")

cd $HOME/main

# setup
cd FrontEnd

set -o pipefail

# build
touch $HOME/flags/web-build.lck
npm install | tee -a "$HOME/logs/web/build_$timestamp" && npm run build | tee -a "$HOME/logs/web/build_$timestamp" && rm $HOME/flags/web-build.lck

[ -f "$HOME/flags/web-build.lck" ] &&
    echo -e "Subject: Web Build Failed\nWeb build failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    exit -1

# test
touch $HOME/flags/web-test.lck
# no tests yet so just echo
echo "web test successfull" | tee -a "$HOME/logs/web/test_$timestamp" && rm $HOME/flags/web-test.lck

[ -f "$HOME/flags/web-test.lck" ] &&
    echo -e "Subject: Web Tests Failed\nWeb tests failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    exit -1

# deploy
[ ! -d "/var/www/web" ] && mkdir /var/www/web
rm -rf /var/www/web/*

cp -r build/* /var/www/web/

pm2 -s delete static-page-server-4000
pm2 -s serve /var/www/web 4000 --spa
pm2 -s save

echo "Deployed at [$(TZ='Africa/Cairo' date)]" | tee -a "$HOME/logs/time/web"