#!/bin/bash

cd $HOME
[ ! -d "Flickr-Photos" ] && git clone git@github.com:MuhabCodes/Flickr-Photos.git
cd Flickr-Photos
git clean -fxd
git reset --hard
git checkout docs_master
git pull origin
cd docs
[ ! -d /var/www/apidocs ] && mkdir /var/www/apidocs
rm -rf /var/www/apidocs/*
npx apidoc -e node_modules/ -o /var/www/apidocs;
