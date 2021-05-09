#!/bin/bash

cd $HOME
[ ! -d "Flickr-Returns" ] && git clone git@github.com:MuhabCodes/Flickr-Returns.git
cd Flickr-Returns
git checkout main
git pull origin
cd docs
rm -rf /var/www/apidocs/*
npx apidoc -e node_modules/ -o /var/www/apidocs;
