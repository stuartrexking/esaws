#!/bin/bash
set -e

INT_ADDR=$(cat /tmp/eventstore-int-addr | tr -d '\n')
EXT_ADDR=$(cat /tmp/eventstore-ext-addr | tr -d '\n')
SERVER_COUNT=$(cat /tmp/eventstore-server-count | tr -d '\n')

echo $INT_ADDR
echo $EXT_ADDR
echo $SERVER_COUNT

echo "Installing Event Store..."
curl https://apt-oss.geteventstore.com/eventstore.key | sudo apt-key add -
echo "deb [arch=amd64] https://apt-oss.geteventstore.com/ubuntu/ trusty main" | sudo tee /etc/apt/sources.list.d/eventstore.list > /dev/null
sudo apt-get update
sudo apt-get install -y eventstore-oss

cat <<EOF > /tmp/eventstore.conf
Log: "/var/log/eventstore"
MemDb: True
IntIp: "$INT_ADDR"
ExtIp: "$EXT_ADDR"
ClusterSize: "$SERVER_COUNT"
ClusterDns: "eventstore.service.consul"
ClusterGossipPort: 2112
EOF

sudo mv /tmp/eventstore.conf /etc/eventstore/eventstore.conf

sudo service eventstore start

echo "server=/eventstore.service.consul/127.0.0.1#8600" | sudo tee /etc/dnsmasq.d/10-consul > /dev/null
sudo service dnsmasq restart

echo '{"service": {"name": "eventstore", "port": 1113}}' | sudo tee /etc/consul.d/eventstore.json > /dev/null
sudo restart consul