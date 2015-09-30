#!/bin/bash
set -e

sudo apt-get -y install nginx
sudo update-rc.d -f nginx disable
sudo service nginx stop

sudo mkdir -p /etc/nginx/templates