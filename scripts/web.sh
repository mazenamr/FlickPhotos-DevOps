#!/bin/bash

cd $HOME/main

# setup
cd FrontEnd

# build
touch $HOME/flags/web-build.lck
npm install && npm run build && rm $HOME/flags/web-build.lck

[ -f "$HOME/flags/web-build.lck" ] && exit -1

# test
touch $HOME/flags/web-test.lck
# no tests yet so just echo
echo "web test successfull" && rm $HOME/flags/web-test.lck

[ -f "$HOME/flags/web-test.lck" ] && exit -1

# deploy
[ ! -d "/var/www/web" ] && mkdir /var/www/web
rm -rf /var/www/web/*

cp -r build/* /var/www/web/
pm2 -s serve build 4000 --spa
