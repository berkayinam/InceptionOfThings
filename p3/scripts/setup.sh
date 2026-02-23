#!/bin/bash

# 1. K3d Cluster'ını oluştur (8888 ve 8080 portlarını dışarı açarak)
k3d cluster create iot-cluster --port "8888:80@loadbalancer" --port "8080:8080@loadbalancer"

# 2. Gerekli Namespaceleri yarat
kubectl create namespace argocd
kubectl create namespace dev

# 3. ArgoCD'yi kur
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 4. ArgoCD podlarının hazır olmasını bekle (otomasyon için bekleme süresi)
echo "ArgoCD podları ayağa kalkıyor, lütfen bekleyin..."
sleep 10

kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

# 5. ArgoCD'nin GitHub'ı izlemesini sağlayan yapılandırmayı (confs içindeki dosyayı) uygula
kubectl apply -f ../confs/argocd-app.yaml

# 6. İlk admin şifresini ekrana yazdır
echo "------------------------------------------------"
echo "ArgoCD Admin Şifreniz:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
echo "------------------------------------------------"
echo "ArgoCD Arayüzüne erişmek için aşağıdaki komutu çalıştırın ve tarayıcıda https://localhost:8080 adresine gidin:"
echo "kubectl port-forward svc/argocd-server -n argocd 8080:443"
