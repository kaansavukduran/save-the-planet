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

Fiziksel telefon/Xbox/Windows testleri ve önceki 60 FPS/sanat/hedef süre kapıları açık kalır. Canlı yayın/CI sonucu tamamlandığında bu kayda eklenir; henüz çalıştırılmayan paket tamamlanmış gösterilmez.
