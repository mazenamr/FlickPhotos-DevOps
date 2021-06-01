#!/bin/bash

cd $HOME
[ ! -d "flags" ] && mkdir flags
[ ! -d "main" ] && git clone git@github.com:MuhabCodes/Flickr-Photos.git main
cd main
git clean -fxd
git reset --hard
git checkout main
git pull origin