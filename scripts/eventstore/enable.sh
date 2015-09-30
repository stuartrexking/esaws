#!/bin/bash
set -e

sudo rm /etc/init/eventstore.override

sudo ufw allow 1112/tcp
sudo ufw allow 1113/tcp
sudo ufw allow 2112/tcp
sudo ufw allow 2113/tcp