# create new user with sudo privileges - https://www.digitalocean.com/community/tutorials/how-to-add-and-delete-users-on-an-ubuntu-14-04-vps
adduser tom
visudo
# add line tom ALL=(ALL:ALL) ALL

# install meteor
curl https://install.meteor.com/ | sh

# install node 0.10.44
curl -sL https://deb.nodesource.com/setup_0.10 | sudo -E bash -
sudo apt-get install -y build-essential nodejs

# install forever
sudo npm install forever -g
sudo npm install forever-monitor

# install git
sudo apt-get install git

# clone repo
git clone repo && cd repo

# check to make sure app works - type command and check in ip_address:3000
PORT=3000 meteor run

# Install latest stable version of nginx - [link](http://nginx.org/en/linux_packages.html#stable)
# first get [signing key](http://nginx.org/keys/nginx_signing.key) copy to nginx_signing.key
sudo apt-key add nginx_signing.key

# add config to /etc/apt/sources.list - add these lines and replace `codename` with `trusty` for Ubuntu 14.4
# deb http://nginx.org/packages/ubuntu/ codename nginx
# deb-src http://nginx.org/packages/ubuntu/ codename nginx

sudo apt-get update
sudo apt-get install nginx

# build meteor app into js bundle
cd ~/repo
meteor update --release 1.3.1
npm install
rm -rf ~/bundle
meteor build --directory ~

# initialize server modules
cd ~/bundle/programs/server
npm install

# shift previous build to backup and run app with forever.js
rm -rf ~/backup
mv ~/portal ~/backup
mv ~/bundle ~/portal
mkdir ~/logs

export PORT=8080
cd ~/portal
forever start -a -l ~/logs/forever.logs -o ~/logs/portal.out -e ~/logs/portal.err main.js

# nginx config - https://www.digitalocean.com/community/tutorials/how-to-deploy-a-meteor-js-application-on-ubuntu-14-04-with-nginx




