#!/bin/bash

cd $HOME

# install system packages
apt-get -y update
apt-get -y upgrade
apt-get -y install certbot default-jre git msmtp nginx nodejs npm python3-certbot-nginx snapd zip

# setup ssh
mkdir .ssh
chmod 700 .ssh
ssh-keyscan -H git.flick.photos >> .ssh/known_hosts
ssh-keyscan -H github.com >> .ssh/known_hosts

# get secrets
git clone git@git.flick.photos:secrets.git

# add ssh key
cp secrets/ssh/* .ssh/
chmod 600 .ssh/id_ed25519
chmod 644 .ssh/id_ed25519.pub
cat .ssh/id_ed25519.pub >> .ssh/authorized_keys
eval `ssh-agent -s`
ssh-add .ssh/id_ed25519

# # setup prometheus
# sudo useradd --no-create-home --shell /bin/false prometheus
# sudo mkdir /etc/prometheus
# sudo mkdir /var/lib/prometheus
# sudo chown prometheus:prometheus /etc/prometheus
# sudo chown prometheus:prometheus /var/lib/prometheus
# curl -LO https://github.com/prometheus/prometheus/releases/download/v2.27.1/prometheus-2.27.1.linux-amd64.tar.gz
# tar xvfz prometheus-*.tar.gz
# sudo cp prometheus-2.27.1.linux-amd64/prometheus /usr/local/bin/
# sudo cp prometheus-2.27.1.linux-amd64/promtool /usr/local/bin/
# sudo chown prometheus:prometheus /usr/local/bin/prometheus
# sudo chown prometheus:prometheus /usr/local/bin/promtool
# sudo cp -r prometheus-2.27.1.linux-amd64/consoles /etc/prometheus
# sudo cp -r prometheus-2.27.1.linux-amd64/console_libraries /etc/prometheus
# sudo chown -R prometheus:prometheus /etc/prometheus/consoles
# sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries
# rm -rf prometheus-2.27.1.linux-amd64.tar.gz prometheus-2.27.1.linux-amd64
# sudo cp ./files/prometheus/prometheus.service /etc/systemd/system/prometheus.service
# sudo systemctl daemon-reload
# sudo systemctl start prometheus
# sudo systemctl enable prometheus

# #set grafana
# sudo apt-get install -y apt-transport-https
# sudo apt-get install -y software-properties-common wget
# wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
# echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
# sudo apt-get update
# sudo apt-get install grafana
# sudo systemctl daemon-reload
# sudo systemctl start grafana-server
# sudo systemctl enable grafana-server

# setup and run node exporter
sudo useradd --no-create-home --shell /bin/false node_exporter
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
tar xvf node_exporter-1.1.2.linux-amd64.tar.gz
sudo cp node_exporter-1.1.2.linux-amd64/node_exporter /usr/local/bin
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
rm -rf node_exporter-1.1.2.linux-amd64.tar.gz node_exporter-1.1.2.linux-amd64
sudo cp ./files/prometheus/node_exporter.service /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

cd $HOME

# install node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 14.16.1
nvm install 16.1.0
nvm alias default 16.1.0

# install npm packages
nvm use 16.1.0
npm install -g apidocs pm2

# setup pm2
pm2 startup systemd

# # setup gradle
# curl -s "https://get.sdkman.io" | bash
# source "$HOME/.sdkman/bin/sdkman-init.sh"
# sdk install gradle

# # setup android sdk and flutter
# snap install flutter --classic
# snap install androidsdk
# export PATH="$PATH:/snap/bin"
# yes | androidsdk --licenses

# setup smtp
cp secrets/settings/msmtprc /etc/

# get files
git clone git@github.com:mazenamr/FlickPhotos-DevOps.git files

# setup nginx
cp secrets/nginx/.htpasswd /etc/nginx/.htpasswd
cp files/nginx/api /etc/nginx/sites-available/
cp files/nginx/web /etc/nginx/sites-available/
cp files/nginx/files /etc/nginx/sites-available/
# cp files/nginx/prometheus /etc/nginx/sites-available/
# cp files/nginx/grafana /etc/nginx/sites-available/
ln -sf /etc/nginx/sites-available/web /etc/nginx/sites-enabled/web
ln -sf /etc/nginx/sites-available/api /etc/nginx/sites-enabled/api
ln -sf /etc/nginx/sites-available/files /etc/nginx/sites-enabled/files
# ln -sf /etc/nginx/sites-available/prometheus /etc/nginx/sites-enabled/prometheus
# ln -sf /etc/nginx/sites-available/grafana /etc/nginx/sites-enabled/grafana
cp -f files/nginx/nginx.conf /etc/nginx/nginx.conf
service nginx restart

# disable firewall
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F

# setup ssl
# certbot --nginx --agree-tos --redirect -n -m "admin@flick.photos" --keep --expand -d "flick.photos" -d "www.flick.photos"
# certbot --nginx --agree-tos --no-redirect -n -m "admin@flick.photos" --keep --expand -d "api.flick.photos"
# certbot --nginx --agree-tos --no-redirect -n -m "admin@flick.photos" --keep --expand -d "flick.photos" -d "www.flick.photos" -d "api.flick.photos" -d "files.flick.photos" -d "prometheus.flick.photos" -d "grafana.flick.photos"
certbot --nginx --agree-tos --no-redirect -n -m "admin@flick.photos" --keep --expand -d "flick.photos" -d "www.flick.photos" -d "api.flick.photos" -d "files.flick.photos"

# setup mongodb
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
apt-get update
apt-get install -y mongodb-org
systemctl start mongod
systemctl enable mongod

# deploy
cd files/scripts
chmod +x *.sh
./deploy.sh

# logout
logout