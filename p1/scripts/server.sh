#!/bin/bash
export INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --bind-address=192.168.56.110"
curl -sfL https://get.k3s.io | sh -
sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/scripts/node-token
