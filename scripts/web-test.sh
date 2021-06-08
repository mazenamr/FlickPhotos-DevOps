#!/bin/bash

timestamp=$(TZ='Africa/Cairo' date +"%Y-%m-%d_%T")
lock="$HOME/flags/web-test.lck"

cd $HOME
[ ! -d "main" ] && (./files/scripts/web-build.sh || exit -1)
cd main

# setup
set -o pipefail

cd Frontend

# test
touch $lock

nvm use 14.16.1

# no tests yet so just echo
echo "web test successfull" | tee -a "$HOME/logs/web/test_$timestamp" &&
    rm $lock

[ -f $lock ] &&
    echo -e "Subject: Web Tests Failed\nWeb tests failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    rm $lock &&
    exit -1 ||
    echo "Web tested at [$(TZ='Africa/Cairo' date)]"
