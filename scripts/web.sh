#!/bin/bash

cd $HOME
[ ! -d "Flickr-Photos" ] && git clone git@github.com:MuhabCodes/Flickr-Photos.git
cd Flickr-Photos
git clean -fxd
git reset --hard
git checkout main
git pull origin
cd FrontEnd
npm install && npm run build
[ ! -d /var/www/web ] && mkdir /var/www/web
rm -rf /var/www/web/*
cp -r build/* /var/www/web/
pm2 -s serve build 4000 --spa
