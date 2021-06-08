#!/bin/bash

timestamp=$(TZ='Africa/Cairo' date +"%Y-%m-%d_%T")
lock="$HOME/flags/apidocs-build.lck"

cd $HOME
[ ! -d "main" ] && (./files/scripts/update.sh || exit -1)
cd main

# setup
set -o pipefail

cd NewDocs

[ ! -d "build" ] && mkdir build
rm -rf build/*

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# build
touch $lock

nvm use 16.1.0

npm install | tee -a "$HOME/logs/apidocs/build_$timestamp" &&
    npx apidoc -e node_modules/ -o build/ | tee -a "$HOME/logs/apidocs/build_$timestamp" &&
    rm $lock

[ -f $lock ] &&
    echo -e "Subject: API Docs Build Failed\nAPI docs build failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    rm $lock &&
    exit -1 ||
    echo "API Docs built at [$(TZ='Africa/Cairo' date)]"
