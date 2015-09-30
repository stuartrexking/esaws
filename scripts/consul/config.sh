#!/bin/bash
set -e

JOIN_ADDRS=$(cat /tmp/consul-server-addr | tr -d '\n')

cat >/tmp/consul-join << EOF
export CONSUL_JOIN="${JOIN_ADDRS}"
EOF

sudo mv /tmp/consul-join /etc/service/consul-join
chmod 0644 /etc/service/consul-join

SERVER_COUNT=$(cat /tmp/consul-server-count | tr -d '\n')

cat >/tmp/consul_flags << EOF
export CONSUL_FLAGS="-server -bootstrap-expect=${SERVER_COUNT} -data-dir=/mnt/consul"
EOF

sudo mv /tmp/consul_flags /etc/service/consul
chmod 0644 /etc/service/consul