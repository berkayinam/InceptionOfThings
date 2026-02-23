# Inception of Things - Part 1: K3s and Vagrant

## 🎯 Projenin Amacı (Amaç Ne?)
[cite_start]Bu bölümün temel amacı, sanallaştırma araçları (Vagrant) kullanarak sıfırdan "Infrastructure as Code" (IaC - Kod olarak Altyapı) mantığıyla minimal bir Kubernetes (K3s) cluster'ı kurmaktır[cite: 45, 58]. K3s, Rancher tarafından geliştirilen, özellikle IoT (Nesnelerin İnterneti) cihazları ve kaynak kısıtlı ortamlar için tasarlanmış hafif bir Kubernetes dağıtımıdır.

## 📋 Bizden İstenenler Nelerdi?
Proje dokümanı bizden şu mimariyi kurmamızı bekliyordu:
1. [cite_start]**İki Adet Sanal Makine:** Biri `berkayS` (Server), diğeri `berkaySW` (Server Worker) adında iki Linux makinesi ayağa kaldırmak[cite: 46, 51, 52, 53].
2. [cite_start]**Özel Ağ (Private Network):** Makinelerin birbirleriyle haberleşebilmesi için Server'a `192.168.56.110`, Worker'a ise `192.168.56.111` statik IP adreslerini atamak[cite: 54, 55].
3. [cite_start]**K3s Roller:** Server makinesine K3s'i "Controller (Master)" modunda, Worker makinesine ise "Agent (Worker)" modunda kurmak[cite: 59, 60, 61].
4. [cite_start]**Otomasyon:** Tüm bu indirme, ağ atama ve cluster'a dahil etme işlemlerinin sadece `vagrant up` komutuyla insan müdahalesi olmadan otomatik yapılmasını sağlamak[cite: 49].

## 🧠 Bunu Neden Yaptık? (Önemi Nedir?)
* **Dağıtık Mimariyi Anlamak:** Kubernetes tek bir dev bilgisayar yerine, işi küçük makinelere (node) böler. Server (Master) node beyindir; işleri dağıtır ve API sunucusunu barındırır. Worker node ise kas gücüdür; uygulamaların (pod'ların) asıl çalıştığı yerdir.
* **Token Mekanizması (Güvenlik):** Worker makinesi cluster'a katılırken, Server'ın oluşturduğu `/var/lib/rancher/k3s/server/node-token` dosyasına ihtiyaç duyar. Bu projede, iki farklı sanal makine arasında bu güvenlik şifresini ortak bir klasör (`/vagrant`) üzerinden taşıyarak makine-makine (M2M) güvenli iletişimini manuel olarak kurguladık.
* **Race Condition (Yarış Durumu) Çözümü:** İki makine aynı anda kurulurken Worker'ın, Server'ın token'ı oluşturmasını beklemesi gerektiğini (while döngüsü ile) tecrübe ettik.
