#!/bin/bash
set -e

sudo rm /etc/nginx/sites-enabled/default

sudo mv /tmp/upstart-consul-template-nginx-eventstore.conf /etc/init/consul-template-nginx-eventstore.conf
sudo mv /tmp/nginx-eventstore-template.ctmpl /etc/nginx/templates/nginx-eventstore-template.ctmpl

sudo start consul-template-nginx-eventstore