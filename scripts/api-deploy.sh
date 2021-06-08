#!/bin/bash

cd $HOME
[ ! -d "main" ] && (./files/scripts/api-test.sh || exit -1)
cd main

# setup
set -o pipefail

cd Backend

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# deploy
[ ! -d "/var/www/api" ] && mkdir /var/www/api
rm -rf /var/www/api/*

cp -r ./* /var/www/api/

nvm use 16.1.0

cd /var/www/api
pm2 -s delete server
pm2 -s start ./bin/server.js
pm2 -s save

echo "API deployed at [$(TZ='Africa/Cairo' date)]" | tee -a "$HOME/logs/time/api"
