#!/bin/bash

cd $HOME

[ ! -d "flags" ] && mkdir flags
rm -rf flags/*

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