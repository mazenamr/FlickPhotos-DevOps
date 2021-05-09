#!/bin/bash

cd $HOME
[ ! -d "Flickr-Photos" ] && git clone git@github.com:MuhabCodes/Flickr-Photos.git
cd Flickr-Photos
git checkout main
git pull origin
cd Backend
[ ! -d "secret" ] && mkdir secret
if [ -f "$HOME/secrets/api/.env" ]; then
    cp $HOME/secrets/api/.env secret/.env
elif [ ! -f "secret/.env" ]; then
    echo "secrets not found"
    exit
fi
npm install && pm2 -s delete server && pm2 start bin/server.js && pm2 -s save
