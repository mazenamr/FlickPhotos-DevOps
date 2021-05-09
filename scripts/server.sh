#!/bin/bash

apt-get update
apt-get upgrade
apt-get install npm nodejs nginx certbot python3-certbot-nginx git

npm install apidocs pm2
