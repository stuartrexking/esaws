#!/bin/bash
set -e

sudo apt-get install -y dnsmasq
sudo update-rc.d -f dnsmasq disable
sudo /etc/init.d/dnsmasq stop