#!/bin/bash

cd $HOME/main
[ ! -d "main" ] && ./files/scripts/apidocs-build.sh || exit -1

# setup
set -o pipefail

cd NewDocs

# deploy
[ ! -d "/var/www/apidocs" ] && mkdir /var/www/apidocs
rm -rf /var/www/apidocs/*

cp -r build/* /var/www/apidocs/

echo "API Docs deployed at [$(TZ='Africa/Cairo' date)]" | tee -a "$HOME/logs/time/apidocs"