# 0.4.1 · gerçek test sonuçları

12 Kasım 2026. Aynı Godot 4.6.3 altyapısı, dört mevcut karakter, on bölüm ve kayıt şeması korunur. Bu yama ekran alanının çizimini ve tünel ipucunu düzeltir; yeni içerik/süre veya nihai sanat onayı değildir.

| Senaryo | Sonuç | Kanıt / sınır |
|---|---|---|
| Eski 0.4.0 pakette ekran regresyonu | FAIL, beklenen | 18 kontrolün üçü: 1920×720/2560×720 sağ kenar, 390×1000 üst kenar. `evidence/forge/before/results.json`; hatalı görüntüler korundu. |
| Yeni pakette çizim/döndürme | PASS 24/24 | Altı ekran boyutunda gerçek WebGL görüntüsünün kenar pikselleri; gövde/ilerleme korunması, kahramanın görünmesi ve pause sırasında döndürme. `evidence/forge/render/`. |
| AIONIA v1.4 dokunmatik/UI | PASS 48/48 | Gerçek Godot Web: fan etkileşimi, iki parmak, çift zıplama, döndürme, menüler, tema/font/büyük metin/ses ve reload. `evidence/forge/ui/`. |
| Tam native kampanya | PASS 120/120 | On bölüm/final/yaşam alanı, gerçek fizik ve etkileşim işleyicileri. `evidence/forge/native/campaign-results.json`. |
| Kritik kabul senaryoları | PASS 24/24 | Paylaşılan kaynaklar, tünel, hareketli platform, pause ve diğer mevcut regresyonlar. `evidence/forge/native/acceptance-results.json`. |
| Kayıt/giriş/kalite | PASS 38/38 | Önceki 32 kontrol + tünel ipucunun J/V/X/RS/dokunmatik/TR-EN izlemesi. `evidence/forge/native/quality-results.json`. |
| Ayrı süreçte kayıt açma | PASS | `evidence/forge/native/save_read.log`. |
| 60 FPS yazılım GPU bütçesi | FAIL | QA: 180 rAF örneği, medyan 33,4 ms/P95 50,1 ms, 25 FPS Godot örneği. `evidence/forge/performance-qa.json`. Fiziksel donanım sonucu değildir. |
| Fiziksel telefon/tablet/Xbox/Windows/ses/ekran okuyucu | NOT TESTED | Chromium emülasyonu, Gamepad API veya headless fizik gerçek cihaz onayı değildir. |

QA profil örneğinde CPU kare monitörü 46,4 ms, fizik 6,4 ms, dünya `_draw` komutlarını hazırlama 0,6 ms ve 157 draw call. Bunlar tek monitor örnekleridir; dünya komut süresi GPU süresi değildir, CPU kare monitörü beklemeleri içerebilir. GPU darboğazı bu değerlerle tek başına kanıtlanmış sayılmaz. Başka oyun tarayıcısı açık olmadan ölçüldü. Toplam browser/WASM/GPU belleği, enerji ve giriş gecikmesi NOT TESTED. Performans hedefi kapatılmadı.

Dokunmatik fixture CDP ile gerçek giriş üretir; hızlı çift zıplama aynı Godot DOM giriş yolunda zamanlanmış TouchEvent kullanır. QA köprüsü yalnız debug + `--qa` koşulunda salt okunur durum yayınlar. Oyun ilerlemesi veya oyuncu koordinatı Web testinden enjekte edilmez. Ekran testi screenshot PNG piksellerini tarayıcı 2D canvas'ıyla okur; runtime bağımlılığı eklenmedi.

Native hızlı çıkış loglarında önceki ObjectDB cleanup uyarısı sürüyor; davranış testlerinin PASS sonucu bu uyarıyı çözülmüş saymaz. Kaynakta `git diff --check` ve Python test sözdizimi kontrolleri geçti. Paket/export ve release smoke sonucu ayrıca kaydedilecek; önceki 0.4.0 indirmeleri bu yamanın paketleri değildir.

Tam üç Web kampanyasının 112+112+112 sonuçları [0.4.0 raporuna](VALIDATION_0.4.md) aittir; 0.4.1 için tekrar çalışmış gibi gösterilmez. Android SDK/JDK/imza ortamı, final sanat onayı, Emre sprite'ı ve 2–3 saat hedef süre açık kalır.
