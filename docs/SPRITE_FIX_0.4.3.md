# 0.4.3 · karakterlerin zemine ve gövdeye sabitlenmesi

Kullanıcı ana menüde ve animasyonlarda karakterlerin aşağı/yanlara kaydığını bildirdi. Aynı oyunun gerçek kareleri incelendi; diğer proje Aion Endless Run yalnız karşılaştırma için okundu, değiştirilmedi.

## Doğrulanan hata

Eski kayıtlar bazı kareleri göz/iris koordinatına göre hizalıyordu. Göz kapandığında yanlış landmark veya interpolasyon, sprite'ın tamamını taşıyordu. Orijinal veride Aion idle döngüsünde görünür alt sınır fizik kökünün **16,15 oyun pikseli** altına iniyor; Baykuş'un yatay kayıt salınımı **12,38 piksele** ulaşıyordu. Bunlar physics hareketi değil, çizim kayıt hatasıydı. Önceki metadata eşitliği/oynanış testleri bunu yakalamamıştı.

## Düzeltme

- Göz koordinatı yerine incelenmiş gövde silüeti ve taban çizgisi kullanılır. Nötr duruşun ayak desteğinden her karakter için tek yatay pivot ofseti çıkarılır; koşarken hareket eden tek tek ayaklar yeniden merkezleme amacıyla takip edilmez.
- Her karede sprite düğümünü yuvarlanmış başka konuma taşımak kaldırıldı. Düğüm fizik gövdesinin kökünde kalır; texture-space offset aynı pivot etrafında aynalanır. Böylece yön değişimi ve UI ölçeği aynı ayak referansını kullanır.
- Kuzu taklasının sabit dönme merkezi/radyusu korunur. Çarpışma şekilleri, hızlar, kamera, oyun kayıt şeması ve kontroller değiştirilmez.
- Kaynak paftalar, provenance dosyaları ve türetilmiş PNG'ler değiştirilmedi. `unchanged-art-sha256.json` mevcut kaynak/türev görsellerin byte özdeşliğini doğrular. Yalnız kayıt metadata'sı ve render yerleşimi düzeltildi.
- Read-only render snapshot yalnız debug Web QA ve native testlerde kullanılır; release QA köprüsü kapalıdır.

## Gerçek sonuçlar

| Kontrol | Sonuç |
|---|---|
| Native Sprite2D/gerçek alpha sınırı, 1.248 kare-yön-ölçek birleşimi | PASS 56/56 |
| Dört hero tam idle/blink döngüsü, tarayıcı animasyonu | PASS |
| Gerçek sağ/sol hareket, durma, zıplama/iniş, portrait resize | PASS; toplam browser 19/19 |
| On bölüm/native kampanya | PASS 120/120 |
| Kritik kabul, tünel/takla ve paylaşılan kaynaklar | PASS 24/24 |
| Kayıt/giriş kalitesi | PASS 38/38 |
| Bağımsız süreçte kayıt açma | PASS |

Native test, yalnız JSON değerini değil Sprite2D'nin gerçek texture alpha sınırını ve dönüşümünü ölçer. Tüm ayakta pozlarda alt sınır hatası **0**, idle yatay sayısal farkı en çok **0,00004** oyun pikselidir. Takla için mevcut sabit dönme merkezi korunur, aşağı taşma olmaması kontrol edilir. Koşu/zıplama içindeki çizilmiş bacak, gövde ve kanat hareketleri korunur; animasyon dondurulmaz.

Kanıt: `evidence/sprite-fix/`. Önce/sonra paftaları teşhis için oluşturulmuştur; oyun grafikleri yeniden çizilmiş değildir. İlk snapshot test yardımcısı Sprite2D.offset'ı hesaba katmıyordu; gerçek render dönüşümüyle düzeltildi. Bu test yardımcısı hatası oyun hatası olarak sayılmaz.

## Canlı yayın ve paketler

[Güncel oyunu aç](https://save-the-planet-mauve.vercel.app/play?v=0.4.3). Production `dpl_CthDpExHmaxYWUNACGcT8dtYtrEX` READY; kaynak `00e1c954b5b9d847d2dd16da690f464a3bf4bfec`, tag `aa344c7b47fb0663`. [Kaynak CI](https://github.com/kaansavukduran/save-the-planet/actions/runs/43302513627) campaign/browser işleri PASS; yeni native ve browser hizalama regresyonları kapsamda.

Gerçek release pikselleriyle ayrıca karşılaştırıldı: 24 eski sürüm görüntüsünde Aion için en çok 480, Baykuş için 48 renk pikseli yolun altındaki örnek alana taşıyordu. Aynı 24 canlı 0.4.3 görüntüsünde iki karakter için değer **0**. `evidence/sprite-fix/pixels/` gerçek screenshot'ları ve renk maskesi/aralık sınırlarını içerir; QA köprüsü kullanılmadı. Bu ölçüm fiziksel cihaz veya bütün görüntü koşulları için garanti değildir.

Kullanıcının gönderdiği görüntünün 2048×1024 çözünürlüğünde de 16 canlı kare ölçüldü: iki karakterin yol altındaki örnek alana taşan renk pikseli yine **0**, v0.4.3 başlığı doğrulandı. `evidence/sprite-fix/user-resolution/`.

Canlı ilk görev/kayıt/release5 ve 390×844 dokunmatik4 PASS; öğretim atlama adımı Escape ile yapıldı, fiziksel telefon değildir. Temiz kaynaktan Web/Linux/Windows portable+NSIS üretildi. Paket kaynak/sürüm/CRC/ELF/PE/SHA8 ve temiz Linux gerçek pencere PASS. Dört paket+manifest Drive metadata ile ad/boyut/klasör açısından doğrulandı; uzak checksum connector'dan gelmedi.

Fiziksel telefon/Xbox/Windows testleri ve önceki 60 FPS/sanat/hedef süre kapıları açık kalır. [Teslim ve indirmeler](DELIVERY.md). Sonraki rapor commit'leri test edilen oyun kodunu değiştirmez.
