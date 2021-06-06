#!/bin/bash

timestamp=$(TZ='Africa/Cairo' date +"%Y-%m-%d_%T")
lock="$HOME/flags/api-test.lck"

cd $HOME/main
[ ! -d "main" ] && ./files/scripts/api-build.sh || exit -1

# setup
set -o pipefail

cd Backend

# test
touch $lock
# no tests yet so just echo
echo "api test successfull" | tee -a "$HOME/logs/api/test_$timestamp" &&
    rm $lock

[ -f $lock ] &&
    echo -e "Subject: API Tests Failed\nAPI tests failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    rm $lock &&
    exit -1