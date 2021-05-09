#!/bin/bash

cd $HOME

# install system packages
apt-get update
apt-get upgrade
apt-get install npm nodejs nginx certbot python3-certbot-nginx git

# setup pm2
pm2 startup systemd

# install npm packages
npm install apidocs pm2

# get secrets
git clone git@flick.photos:secrets.git

# setup ssh
mkdir .ssh
cp secrets/ssh/* .ssh/
ssh-add .ssh/id_ed25519

# clone repos
git clone git@github.com:mazenamr/FlickPhotos-DevOps.git files
git clone git@github.com:MuhabCodes/Flickr-Photos.git

# setup nginx
cp files/nginx/* /etc/nginx/sites-available/
ln -sf /etc/nginx/sites-available/web /etc/nginx/sites-available/web
ln -sf /etc/nginx/sites-available/api /etc/nginx/sites-available/api
# ln -sf /etc/nginx/sites-available/mail /etc/nginx/sites-available/mail
service nginx restart

# setup ssl
certbot --nginx -n -m "admin@flick.photos" --keep -d "flick.photos" -d "www.flick.photos" -d "api.flick.photos" -d "mail.flick.photos"

# run deployment scripts
cd files/scripts
chmod +x *.sh
./apidocs.sh
./api.sh
./web.sh
