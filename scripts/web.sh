#!/bin/bash

cd $HOME
[ ! -d "Flickr-Returns" ] && git clone git@github.com:MuhabCodes/Flickr-Returns.git
cd Flickr-Returns
git checkout main
git pull origin
cd FrontEnd
npm install && npm run build
rm -rf /var/www/web/*
cp -r build/* /var/www/web/
