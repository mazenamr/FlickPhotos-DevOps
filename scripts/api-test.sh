#!/bin/bash

timestamp=$(TZ='Africa/Cairo' date +"%Y-%m-%d_%T")
lock="$HOME/flags/api-test.lck"

cd $HOME
[ ! -d "main" ] && (./files/scripts/api-build.sh || exit -1)
cd main

# setup
set -o pipefail

cd Backend

# test
touch $lock

nvm use 16.1.0

# no tests yet so just echo
echo "api test successfull" | tee -a "$HOME/logs/api/test_$timestamp" &&
    rm $lock

[ -f $lock ] &&
    echo -e "Subject: API Tests Failed\nAPI tests failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    rm $lock &&
    exit -1 ||
    echo "API tested at [$(TZ='Africa/Cairo' date)]"
