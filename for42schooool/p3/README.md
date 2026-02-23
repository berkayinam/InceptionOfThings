# Inception of Things - Part 3: K3d ve GitOps (ArgoCD)

## 🎯 Projenin Amacı
Bu bölümün amacı, sanal makinelerin (Vagrant/VirtualBox/Parallels) getirdiği hantallıktan kurtularak, Kubernetes'i doğrudan Docker üzerinde (K3d) çalıştırmak ve **GitOps** felsefesini kullanarak uygulamaları otomatik olarak dağıtmaktır (Continuous Deployment).

## 📋 Bizden İstenenler
1. **K3d (K3s in Docker):** Sanal makine yerine Docker container'ları içinde çalışan bir Kubernetes cluster'ı kurmak.
2. **İki Adet Namespace:** `argocd` (Araçlar için) ve `dev` (Uygulamamız için) adında izole alanlar yaratmak.
3. **ArgoCD Entegrasyonu:** ArgoCD'yi kurup, GitHub'daki bir depoyu (repository) izlemesini sağlamak.
4. **Wil42 Uygulaması:** GitHub'daki ayar dosyasına `wil42/playground:v1` imajını koyup, sistemin bunu otomatik ayağa kaldırmasını; ardından repoda `v2` olarak değiştirildiğinde sistemin otomatik güncellenmesini (Auto-Sync) kanıtlamak.

## 🧠 Savunma Soruları ve Cevapları (Kavramlar)

* **Neden K3d Kullandık?** Vagrant ile tam bir işletim sistemi (Ubuntu) sanallaştırıyorduk. K3d ise doğrudan Mac'in Docker Engine'ini kullanarak K3s'i saniyeler içinde ayağa kaldırır. Çok daha az kaynak (RAM/CPU) tüketir ve CI/CD süreçleri için mükemmeldir.
* **GitOps Nedir?** Altyapı ve uygulama dağıtım süreçlerinin tek doğruluk kaynağı (Single Source of Truth) olarak Git'in (GitHub vb.) kullanılmasıdır. Sunucuya manuel müdahale edilmez; değişiklikler Git'e pushlanır, sistem kendini buna göre eşitler.
* **ArgoCD Nasıl Çalışır (Pull vs Push)?** Geleneksel yöntemlerde (örneğin Jenkins) kod sunucuya "itilir" (Push). ArgoCD ise "Pull" (Çekme) mantığıyla çalışır. Kubernetes kümesinin içinde yaşar, sürekli GitHub reposunu izler. Eğer repodaki YAML dosyası ile mevcut K8s durumu arasında fark varsa, K8s'i repodaki duruma çeker (Senkronize eder).
