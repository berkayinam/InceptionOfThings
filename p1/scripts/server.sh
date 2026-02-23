#!/bin/bash

rm -f /vagrant/scripts/node-token

export INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --bind-address=192.168.56.110"
curl -sfL https://get.k3s.io | sh -

# K3s servisi ayağa kalkıp token'ı oluşturana kadar bekle
while [ ! -f /var/lib/rancher/k3s/server/node-token ]; do
  sleep 2
done

# Token oluştuktan sonra Worker'ın okuması için ortak klasöre kopyala
sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/scripts/node-token
