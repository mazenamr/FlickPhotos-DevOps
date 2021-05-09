#!/bin/bash

cd $HOME
[ ! -d "Flickr-Returns" ] && git clone git@github.com:MuhabCodes/Flickr-Returns.git
cd Flickr-Returns
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
npm install && pm2 delete server && pm2 start ./bin/server.js && pm2 save
