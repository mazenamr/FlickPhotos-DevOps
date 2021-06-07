#!/bin/bash

timestamp=$(TZ='Africa/Cairo' date +"%Y-%m-%d_%T")
lock="$HOME/flags/apidocs-test.lck"

cd $HOME
[ ! -d "main" ] && (./files/scripts/apidocs-build.sh || exit -1)
cd main

# setup
set -o pipefail

cd NewDocs

# test
touch $lock
# no tests yet so just echo
echo "api docs test successfull" | tee -a "$HOME/logs/apidocs/test_$timestamp" &&
    rm $lock

[ -f $lock ] &&
    echo -e "Subject: API Docs Tests Failed\nAPI docs tests failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    rm $lock &&
    exit -1
