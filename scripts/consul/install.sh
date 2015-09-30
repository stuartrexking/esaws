#!/bin/bash
set -e

cd /tmp
wget https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip -O consul.zip

unzip consul.zip >/dev/null
sudo chmod +x consul
sudo mv consul /usr/local/bin/consul
sudo mkdir -p /etc/consul.d
sudo mkdir -p /mnt/consul
sudo mkdir -p /etc/service

echo 'manual' | sudo tee /etc/init/consul.override > /dev/null
echo 'manual' | sudo tee /etc/init/consul-join.override > /dev/null

sudo mv /tmp/consul-upstart.conf /etc/init/consul.conf
sudo mv /tmp/consul-upstart-join.conf /etc/init/consul-join.conf

 curl -L "https://github.com/hashicorp/consul-template/releases/download/v0.10.0/consul-template_0.10.0_linux_386.tar.gz" | sudo tar -C /usr/local/bin --strip-components 1 -zx