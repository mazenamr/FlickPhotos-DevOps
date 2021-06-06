#!/bin/bash

cd $HOME/main
[ ! -d "main" ] && ./files/scripts/api-test.sh || exit -1

# setup
set -o pipefail

cd Backend

# deploy
[ ! -d "/var/www/api" ] && mkdir /var/www/api
rm -rf /var/www/api/*

cp -r ./* /var/www/api/

cd /var/www/api
pm2 -s delete server
pm2 -s start ./bin/server.js
pm2 -s save

echo "API deployed at [$(TZ='Africa/Cairo' date)]" | tee -a "$HOME/logs/time/api"
