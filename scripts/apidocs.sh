#!/bin/bash

cd $HOME/main

# setup
cd docs
mkdir build
[ ! -d "build" ] && mkdir build
rm -rf build/*

# build
touch $HOME/flags/apidocs-build.lck
npm install && npx apidoc -e node_modules/ -o build/ && rm $HOME/flags/apidocs-build.lck

[ -f "$HOME/flags/apidocs-build.lck" ] &&
    echo -e "Subject: API Docs Build Failed\nAPI docs build failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    exit -1

# test
touch $HOME/flags/apidocs-test.lck
# no tests yet so just echo
echo "api docs test successfull" && rm $HOME/flags/apidocs-test.lck

[ -f "$HOME/flags/apidocs-test.lck" ] &&
    echo -e "Subject: API Docs Tests Failed\nAPI docs tests failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    exit -1

# deploy
[ ! -d "/var/www/apidocs" ] && mkdir /var/www/apidocs
rm -rf /var/www/apidocs/*

cp -r build/* /var/www/apidocs/

echo $(TZ='Africa/Cairo' date) > $HOME/apidocs