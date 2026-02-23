⚠️ Düzeltilmesi Gereken 2 Kritik Kural İhlali
1. İşletim Sistemi Kuralı (Kesin Kalma Sebebi):
Değerlendirme belgesi Bölüm 1 ve Bölüm 2 için açıkça şu şartı koşuyor: "Vagrantfile'da her iki sanal makine için de CentOS'un en son kararlı sürümünün kullanıldığını kontrol edin". Biz şu ana kadar bento/ubuntu-22.04 kullanmıştık. Bunu mutlaka CentOS yapmalıyız.
+1

Çözüm: P1 ve P2 klasörlerindeki Vagrantfile dosyalarında BOX_NAME = "bento/ubuntu-22.04" yazan satırı BOX_NAME = "bento/centos-stream-9" (veya centos/stream9) olarak değiştirmelisin. (Bento'nun CentOS versiyonu VirtualBox ile kusursuz çalışır).

2. GitHub Depo (Repository) İsmi:
Belgede Bölüm 3 için: "Gruptan birinin login isminin Github deposunun adına konulduğunu kontrol edin (örn: login 'wil' ise isim 'wil_config' veya 'wil-ception' olabilir)" yazıyor. Senin reponun adı sadece InceptionOfThings.

Çözüm: GitHub reponun adını ayarlardan berkayinam_InceptionOfThings veya berkayinam-iot olarak değiştirmelisin ve ArgoCD (argocd-app.yaml) içindeki linki de buna göre güncellemelisin.

🧠 42 Değerlendirmesi (Defense) İçin Teorik Çalışma Rehberi
Değerlendirme belgesi senden bazı kavramları "basit bir şekilde açıklamanı" açıkça talep ediyor. Belgedeki sorulara göre hazırladığım, değerlendirmede hayat kurtaracak çalışma rehberini aşağıda bulabilirsin


# Inception of Things - Teorik Savunma Rehberi


## 1. Temel Kavramlar (Bölüm 1 ve 2 İçin)

[cite_start]**Soru: K3s'in temel çalışma mantığı nedir?** [cite: 65]
* **Cevap:** K3s, IoT (Nesnelerin İnterneti) cihazları ve kaynak kısıtlı ortamlar için Rancher tarafından geliştirilmiş çok hafif bir Kubernetes dağıtımıdır. Normal Kubernetes'ten farkı, gereksiz ve ağır modüllerin çıkarılmış olması ve her şeyin tek bir çalıştırılabilir dosya (binary) içine sıkıştırılmış olmasıdır. Veritabanı olarak ağır olan `etcd` yerine hafif olan `SQLite` kullanır.

[cite_start]**Soru: Vagrant'ın temel çalışma mantığı nedir?** [cite: 66]
* **Cevap:** Vagrant, sanal makine (VirtualBox, VMware vb.) ortamlarını tek bir metin dosyası (`Vagrantfile`) üzerinden kodlayarak yönetmemizi sağlayan bir araçtır. Amacı "Benim bilgisayarımda çalışıyordu, sunucuda çalışmıyor" sorununu çözmektir. Manuel kurulum yapmak yerine ağ ayarlarını, RAM/CPU miktarını ve kurulum betiklerini otomatikleştirerek hızlı ve tekrarlanabilir sanal ortamlar sağlar.

## 2. Modern Altyapı (Bölüm 3 İçin)

[cite_start]**Soru: K3d'nin temel çalışma mantığı nedir?** [cite: 67]
* **Cevap:** K3d, "K3s in Docker" anlamına gelir. K3s cluster'larını sanal makineler (VM) yerine doğrudan Docker konteynerleri içinde çalıştırmamızı sağlar. Vagrant gibi tam bir işletim sistemini ayağa kaldırmadığı için saniyeler içinde açılır, bilgisayarı yormaz ve CI/CD (Sürekli Entegrasyon/Sürekli Dağıtım) testleri için mükemmeldir.


[cite_start]**Soru: Sürekli Entegrasyon (Continuous Integration) ve ArgoCD nedir?** [cite: 68]
* **Cevap:** Sürekli Entegrasyon, yazılımcıların kodlarında yaptıkları değişikliklerin otomatik olarak test edilip ana sisteme birleştirilmesidir. ArgoCD ise bu sürecin CD (Continuous Deployment - Sürekli Dağıtım) kısmını üstlenir ve "GitOps" felsefesini kullanır. ArgoCD, Kubernetes kümesinin içinde yaşar ve GitHub depomuzu sürekli izler. [cite_start]GitHub'daki kod durumu ile sunucudaki durum arasında bir fark görürse, sistemi otomatik olarak GitHub'daki duruma eşitler (Sync)[cite: 174].

## 3. Kubernetes Obje Mantığı

[cite_start]**Soru: Namespace ve Pod arasındaki fark nedir?** [cite: 145]
* **Cevap:** * **Pod:** Kubernetes içindeki en küçük yapıtaşıdır. İçerisinde uygulamamızın çalıştığı bir veya birden fazla Docker konteynerini barındırır. (Bu projede Wil42'nin web uygulaması bir pod içinde çalışır).
    * **Namespace:** Kubernetes cluster'ını mantıksal olarak parçalara bölen "sanal odalardır". Projeleri ve kaynakları birbirinden izole etmek için kullanılır. (Bu projede sistem araçları `argocd` odasında, bizim uygulamamız ise `dev` odasında birbirine karışmadan çalışır).

## 4. Uygulamalı Gösterim Notları (Evaluator İstediğinde Yapılacaklar)

* [cite_start]**Ağ Kontrolü:** Evaluator `ifconfig eth1` komutunu yazdırarak `192.168.56.110` IP'sini görmek isteyecek[cite: 88, 114, 115].
* [cite_start]**Uygulama Sayıları:** `kubectl get all -n kube-system` (veya kendi namespace'in) çalıştırıldığında, `app2`'nin gerçekten 3 kopyası (replica) olduğunu göstereceksin[cite: 121, 122].
* [cite_start]**GitOps Sihri:** Bölüm 3'te ArgoCD çalıştıktan sonra, v1 uygulamasını tarayıcıda göstereceksin[cite: 169]. [cite_start]Ardından GitHub'a girip `v1`'i `v2` olarak değiştireceksin[cite: 172, 173]. [cite_start]ArgoCD'nin bu değişikliği algılayıp sistemi güncellediğini evaluator'a anlatarak açıklayacaksın[cite: 174]. [cite_start]Eğer otomatik güncellemezse, ArgoCD arayüzünden manuel olarak "Sync" butonuna basıp göstereceksin[cite: 176, 177]..
