#!/bin/bash
# Token'ı server.sh'ın oluşturduğu dosyadan okuyalım
TOKEN=$(cat /vagrant/scripts/node-token)

export K3S_URL="https://192.168.56.110:6443"
export K3S_TOKEN=$TOKEN
export INSTALL_K3S_EXEC="--node-ip=192.168.56.111"

curl -sfL https://get.k3s.io | sh -
