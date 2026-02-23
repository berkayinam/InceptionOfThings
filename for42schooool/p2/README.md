# Inception of Things - Part 2: K3s, Ingress ve Uygulama Dağıtımı

## 🎯 Projenin Amacı
Bu bölümün amacı, tek bir K3s node'u üzerinde birden fazla web uygulamasını barındırmak ve dışarıdan gelen trafiği **Ingress** adı verilen bir yönlendirici (Reverse Proxy) ile doğru uygulamalara dağıtmaktır.

## 📋 Bizden İstenenler
1. **Tek Makine:** Worker node olmadan, sadece `berkayS` (192.168.56.110) adında tek bir sanal makine kurmak.
2. **Üç Farklı Uygulama:** K3s üzerinde 3 farklı basit web uygulaması (Deployment) çalıştırmak.
3. **Replika (Yüksek Erişilebilirlik):** İkinci uygulamanın (`app2`) tam 3 adet kopyasını (replica) çalıştırmak.
4. **Ingress Yönlendirmesi:** - `app1.com` isteği -> App 1'e
   - `app2.com` isteği -> App 2'ye
   - Diğer tüm istekler (Default) -> App 3'e yönlendirilmeli.

## 📂 Dosyaların İşlevleri
* **`Vagrantfile`:** `berkayS` adında tek bir sanal makine oluşturur ve IP atamasını yapar. İşletim sistemi kurulduğunda `server.sh` betiğini tetikler.
* **`scripts/server.sh`:** Makinenin içine K3s'i kurar. K3s ayağa kalktıktan sonra `apps.yaml` dosyasını `kubectl apply -f` komutuyla sisteme yükleyerek otomatik dağıtımı sağlar.
* **`confs/apps.yaml`:** Kubernetes deklarasyon dosyasıdır. İçerisinde şunlar bulunur:
  * **Deployment:** Uygulamaların hangi Docker imajından (`nginx:alpine`) kaç adet (replica) çalıştırılacağını belirler.
  * **Service:** Pod'lara (konteynerlere) sabit bir IP adresi ve port (80) sağlayarak K3s içindeki ağ haberleşmesini ayarlar.
  * **Ingress:** Dış dünyadan gelen HTTP isteklerinin başlığındaki (Header) "Host" bilgisine bakarak (örn: `app1.com`), trafiği doğru Service'e yönlendiren Traefik kurallarını içerir.
