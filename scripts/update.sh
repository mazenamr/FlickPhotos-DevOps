#!/bin/bash

cd $HOME

[ ! -d "logs" ] && mkdir logs
cd logs
[ ! -d "time" ] && mkdir time
[ ! -d "api" ] && mkdir api
[ ! -d "apidocs" ] && mkdir apidocs
[ ! -d "web" ] && mkdir web

cd $HOME

[ ! -d "flags" ] && mkdir flags
rm -rf flags/*

[ ! -d "files" ] && git@github.com:mazenamr/FlickPhotos-DevOps.git files
cd files
git clean -fxd
git reset --hard
git checkout main
git pull origin

cd $HOME

[ ! -d "secrets" ] && git clone git@git.flick.photos:secrets.git
cd secrets
git clean -fxd
git reset --hard
git checkout main
git pull origin

cd $HOME

[ ! -d "main" ] && git clone git@github.com:MuhabCodes/Flickr-Photos.git main
cd main
git clean -fxd
git reset --hard
git checkout main
git pull origin