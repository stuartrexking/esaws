#!/bin/bash
set -e

sudo update-rc.d -f nginx enable

sudo ufw allow 80/tcp
sudo ufw allow 443/tcp