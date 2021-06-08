#!/bin/bash

cd $HOME
[ ! -d "main" ] && (./files/scripts/web-build.sh || exit -1)
cd main

# setup
set -o pipefail

cd Frontend

# deploy
[ ! -d "/var/www/web" ] && mkdir /var/www/web
rm -rf /var/www/web/*

cp -r build/* /var/www/web/

pm2 -s delete static-page-server-4000
pm2 -s serve /var/www/web 4000 --spa
pm2 -s save

echo "Web deployed at [$(TZ='Africa/Cairo' date)]" | tee -a "$HOME/logs/time/web"
