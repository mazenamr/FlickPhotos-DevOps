#!/bin/bash

cd $HOME
[ ! -d "main" ] && (./files/scripts/apidocs-build.sh || exit -1)
cd main

# setup
set -o pipefail

cd NewDocs

nvm use 16.1.0

# deploy
[ ! -d "/var/www/apidocs" ] && mkdir /var/www/apidocs
rm -rf /var/www/apidocs/*

cp -r build/* /var/www/apidocs/

echo "API Docs deployed at [$(TZ='Africa/Cairo' date)]" | tee -a "$HOME/logs/time/apidocs"
