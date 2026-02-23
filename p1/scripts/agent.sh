#!/bin/bash
# Server token dosyasını ortak klasöre koyana kadar bekle
while [ ! -f /vagrant/scripts/node-token ]; do
  sleep 2
done

# Dosya geldiğinde oku ve K3s kurulumunu başlat
TOKEN=$(cat /vagrant/scripts/node-token)

export K3S_URL="https://192.168.56.110:6443"
export K3S_TOKEN=$TOKEN
export INSTALL_K3S_EXEC="--node-ip=192.168.56.111"

curl -sfL https://get.k3s.io | sh -
