#!/bin/bash

cd $HOME

# install system packages
apt-get -y update
apt-get -y upgrade
apt-get -y install certbot git msmtp nginx nodejs npm python3-certbot-nginx

# install npm packages
npm install -g apidocs pm2

# setup pm2
pm2 startup systemd

# setup ssh
mkdir .ssh
chmod 700 .ssh
ssh-keyscan -H git.flick.photos >> .ssh/known_hosts
ssh-keyscan -H github.com >> .ssh/known_hosts

# get secrets
git clone git@git.flick.photos:secrets.git

# setup smtp
cp secrets/settings/msmtprc /etc/

# add ssh key
cp secrets/ssh/* .ssh/
chmod 600 .ssh/id_ed25519
chmod 644 .ssh/id_ed25519.pub
cat .ssh/id_ed25519.pub >> .ssh/authorized_keys
ssh-add .ssh/id_ed25519

# clone repos
git clone git@github.com:mazenamr/FlickPhotos-DevOps.git files
git clone git@github.com:MuhabCodes/Flickr-Photos.git main

# setup nginx
cp files/nginx/api /etc/nginx/sites-available/
cp files/nginx/web /etc/nginx/sites-available/
ln -sf /etc/nginx/sites-available/web /etc/nginx/sites-enabled/web
ln -sf /etc/nginx/sites-available/api /etc/nginx/sites-enabled/api
# ln -sf /etc/nginx/sites-available/mail /etc/nginx/sites-available/mail
# ln -sf /etc/nginx/sites-available/files /etc/nginx/sites-available/files
service nginx restart

# disable firewall
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F

# setup ssl
# certbot --nginx --agree-tos --redirect -n -m "admin@flick.photos" --keep --expand -d "flick.photos" -d "www.flick.photos" -d "api.flick.photos"
# certbot --nginx --agree-tos --redirect -n -m "admin@flick.photos" --keep --expand -d "files.flick.photos" -d "mail.flick.photos"
certbot --nginx --agree-tos --redirect -n -m "admin@flick.photos" --keep --expand -d "flick.photos" -d "www.flick.photos" -d "api.flick.photos"

# setup mongodb
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
apt-get update
apt-get install -y mongodb-org
systemctl start mongod
systemctl enable mongod

# run deployment scripts
cd files/scripts
chmod +x *.sh
./deploy.sh
