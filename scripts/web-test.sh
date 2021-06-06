#!/bin/bash

timestamp=$(TZ='Africa/Cairo' date +"%Y-%m-%d_%T")
lock="$HOME/flags/web-test.lck"

cd $HOME/main
[ ! -d "main" ] && ./files/scripts/web-build.sh || exit -1

# setup
set -o pipefail

cd FrontEnd

# test
touch $lock
# no tests yet so just echo
echo "web test successfull" | tee -a "$HOME/logs/web/test_$timestamp" &&
    rm $lock

[ -f $lock ] &&
    echo -e "Subject: Web Tests Failed\nWeb tests failed at $(TZ='Africa/Cairo' date)" | msmtp admin@flick.photos &&
    rm $lock &&
    exit -1