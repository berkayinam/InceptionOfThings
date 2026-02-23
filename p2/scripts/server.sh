#!/bin/bash
# Temel araçları kur
apt-get update -y
apt-get install -y curl net-tools

# K3s'i Server modunda kur
export INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --bind-address=192.168.56.110"
curl -sfL https://get.k3s.io | sh -

# K3s ayağa kalkana kadar 10 saniye bekle
sleep 10

# Kubernetes objelerini (Deployment, Service, Ingress) otomatik uygula
kubectl apply -f /vagrant/confs/apps.yaml
