#!/bin/bash
set -e

#update then upgrade all existing packages
echo "Adding mirrors"
curl -sS https://www.google.com.au/ > /dev/null
sudo sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse' /etc/apt/sources.list
sudo cat /etc/apt/sources.list
sudo apt-get update

#install dependencies
sudo apt-get -y install curl ntp zip unzip

#close all ports except ssh and ntp
#sudo ufw allow ssh
#sudo ufw allow ntp
#sudo ufw logging on
#sudo ufw --force enable

#set max open file limits
sudo bash -c 'cat <<EOF > /etc/security/limits.d/max.limits.conf
* soft nofile 32768
* hard nofile 32768
root soft nofile 32768
root hard nofile 32768
* soft memlock unlimited
* hard memlock unlimited
root soft memlock unlimited
root hard memlock unlimited
* soft as unlimited
* hard as unlimited
root soft as unlimited
root hard as unlimited
EOF'

sudo sysctl -w vm.max_map_count=131072
echo "vm.max_map_count = 131072" | sudo tee /etc/security/limits.conf > /dev/null
