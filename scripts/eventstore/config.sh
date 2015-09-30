#!/bin/bash
set -e

INT_ADDR=$(cat /tmp/eventstore-int-addr | tr -d '\n')
EXT_ADDR=$(cat /tmp/eventstore-ext-addr | tr -d '\n')
SERVER_COUNT=$(cat /tmp/eventstore-server-count | tr -d '\n')

echo $INT_ADDR
echo $EXT_ADDR
echo $SERVER_COUNT

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

echo "server=/eventstore.service.consul/127.0.0.1#8600" | sudo tee /etc/dnsmasq.d/10-consul > /dev/null
sudo service dnsmasq restart

echo '{"service": {"name": "eventstore", "port": 1113}}' | sudo tee /etc/consul.d/eventstore.json > /dev/null
sudo restart consul