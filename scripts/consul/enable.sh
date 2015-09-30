#!/bin/bash
set -e

sudo rm /etc/init/consul.override
sudo rm /etc/init/consul-join.override

sudo ufw allow 8300/tcp
sudo ufw allow 8301
sudo ufw allow 8302
sudo ufw allow 8400/tcp
sudo ufw allow 8500/tcp
sudo ufw allow 8600