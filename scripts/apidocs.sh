#!/bin/bash

cd $HOME/main

# setup
cd docs
mkdir build
[ ! -d "build" ] && mkdir build
rm -rf build/*

# build
touch $HOME/flags/apidocs-build.lck
npm install && npx apidoc -e node_modules/ -o build/ && rm $HOME/flags/apidocs-build.lck

[ -f "$HOME/flags/apidocs-build.lck" ] && exit -1

# test
touch $HOME/flags/apidocs-test.lck
# no tests yet so just echo
echo "api docs test successfull" && rm $HOME/flags/apidocs-test.lck

[ -f "$HOME/flags/apidocs-test.lck" ] && exit -1

# deploy
[ ! -d "/var/www/apidocs" ] && mkdir /var/www/apidocs
rm -rf /var/www/apidocs/*

cp -r build/* /var/www/apidocs/
