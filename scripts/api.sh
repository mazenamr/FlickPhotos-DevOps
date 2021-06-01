#!/bin/bash

cd $HOME/main

# setup
cd Backend

[ ! -d "secret" ] && mkdir secret
if [ -f "$HOME/secrets/api/.env" ]; then
    cp $HOME/secrets/api/.env secret/.env
elif [ ! -f "secret/.env" ]; then
    echo "secrets not found"
    exit -1
fi

# build
touch $HOME/flags/web-build.lck
npm install && rm $HOME/flags/api-build.lck

[ -f "$HOME/flags/api-build.lck" ] && exit -1

# test
touch $HOME/flags/api-test.lck
# no tests yet so just echo
echo "api test successfull" && rm $HOME/flags/api-test.lck

[ -f "$HOME/flags/api-test.lck" ] && exit -1

# deploy
[ ! -d "/var/www/api" ] && mkdir /var/www/api
rm -rf /var/www/api/*

cp -r bin/* /var/www/api/

cd /var/www/api

pm2 -s delete server
pm2 -s start server.js
pm2 -s save
