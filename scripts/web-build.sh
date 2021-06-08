#!/bin/bash

timestamp=$(TZ='Africa/Cairo' date +"%Y-%m-%d_%T")
lock="$HOME/flags/web-build.lck"

cd $HOME
[ ! -d "main" ] && (./files/scripts/update.sh || exit -1)
cd main

# setup
set -o pipefail

cd Frontend

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# build
touch $lock

nvm use 14.16.1

npm install | tee -a "$HOME/logs/web/build_$timestamp" &&
    npm run build | tee -a "$HOME/logs/web/build_$timestamp" &&
    rm $lock

[ -f $lock ] &&
    echo -e "Subject: Web Build Failed\nWeb build failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    rm $lock &&
    exit -1 ||
    echo "Web built at [$(TZ='Africa/Cairo' date)]"
