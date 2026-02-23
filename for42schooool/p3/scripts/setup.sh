#!/bin/bash

echo "🚀 Inception of Things - P3 Kurulumu Başlıyor..."

# 1. Sistemi Güncelle ve Docker için Gerekli Paketleri Kur
echo "📦 Docker bağımlılıkları kuruluyor..."
sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg -y

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 2. Docker'ı Kur
echo "🐳 Docker Engine kuruluyor..."
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# 3. Kubectl'i Kur
echo "☸️ Kubectl kuruluyor..."
curl -sL "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" --output /tmp/kubectl
sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl

# 4. K3d'yi Kur
echo "🛠 K3d kuruluyor..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# 5. K3d Cluster'ını Oluştur (Senin port ayarlarınla)
echo "🌐 iot-cluster oluşturuluyor..."
sudo k3d cluster create iot-cluster --port "8888:80@loadbalancer" --port "8080:8080@loadbalancer"

# Kubeconfig ayarlarını çek (Kubectl'in çalışabilmesi için şart)
mkdir -p ~/.kube
sudo k3d kubeconfig get iot-cluster > ~/.kube/config
sudo chmod 600 ~/.kube/config

# 6. Gerekli Namespaceleri Yarat
kubectl create namespace argocd
kubectl create namespace dev

# 7. ArgoCD'yi Kur
echo "🐙 ArgoCD kuruluyor..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# 8. ArgoCD podlarının hazır olmasını bekle
echo "⏳ ArgoCD podları ayağa kalkıyor, lütfen bekleyin (Bu işlem biraz sürebilir)..."
sleep 10
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

# 9. ArgoCD GitOps Yapılandırmasını (confs) Uygula
echo "🔗 GitHub reposu ArgoCD'ye bağlanıyor..."
kubectl apply -f ../confs/argocd-app.yaml

# 10. Admin Şifresini Al ve Arayüzü Başlat
echo "------------------------------------------------"
echo -n "🔑 ArgoCD Admin Şifreniz: "
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo ""
echo "------------------------------------------------"
echo "✅ Kurulum tamamlandı! ArgoCD arayüzü 8080 portunda arka planda başlatılıyor..."

# Port yönlendirmesini arka planda başlat (&) ve her adresten erişime aç (0.0.0.0)
kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 0.0.0.0 &
