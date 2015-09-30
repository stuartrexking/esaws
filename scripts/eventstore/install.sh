#!/bin/bash
set -e

curl https://apt-oss.geteventstore.com/eventstore.key | sudo apt-key add -
echo "deb [arch=amd64] https://apt-oss.geteventstore.com/ubuntu/ trusty main" | sudo tee /etc/apt/sources.list.d/eventstore.list > /dev/null
sudo apt-get update
sudo apt-get install -y eventstore-oss

#override auto start
echo 'manual' | sudo tee /etc/init/eventstore.override > /dev/null