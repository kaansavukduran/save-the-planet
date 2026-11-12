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
| Son release ilk görev/kayıt reload/QA kapalı | PASS 3/3 | Temiz e43b096 kaynağından Web çıktısı; gerçek klavye girişleri. `evidence/forge/release/results.json`. |
| Paket bütünlüğü/sürüm/kaynak | PASS 8/8 | Web/Linux/Windows clean BUILD, ZIP CRC, ELF64, PE x64 ve dört dağıtım hash'i. `evidence/forge/packages/results.json`. |
| Temiz Linux arşivinde gerçek pencere | PASS | Xvfb 1400×1100/Mesa, gerçek Godot, xdotool klavye: hareket/zıplama/pause/390×844 resize. `evidence/forge/native-window/`; dummy audio, fiziksel donanım değildir. |
| GitHub kaynak CI | PASS | [43282344144](https://github.com/kaansavukduran/save-the-planet/actions/runs/43282344144), e43b096; campaign ve browser işleri başarılı. Yeni ekran testi CI kapsamındadır. |
| Vercel preview HTTP/kaynak/sürüm | PASS | READY, HTML/BUILD 200; SSO korunur. `evidence/forge/preview.json`. Uzak tarayıcı oynanışı NOT TESTED. |
| Drive yüklemeleri | PASS metadata | Dört paket ve manifest; ad/boyut/klasör doğrulandı. `evidence/forge/packages/drive-receipts.json`; uzak checksum yok. |
| 60 FPS yazılım GPU bütçesi | FAIL | QA: 180 rAF örneği, medyan 33,4 ms/P95 50,1 ms, 25 FPS Godot örneği. `evidence/forge/performance-qa.json`. Fiziksel donanım sonucu değildir. |
| Fiziksel telefon/tablet/Xbox/Windows/ses/ekran okuyucu | NOT TESTED | Chromium emülasyonu, Gamepad API veya headless fizik gerçek cihaz onayı değildir. |

QA profil örneğinde CPU kare monitörü 46,4 ms, fizik 6,4 ms, dünya `_draw` komutlarını hazırlama 0,6 ms ve 157 draw call. Bunlar tek monitor örnekleridir; dünya komut süresi GPU süresi değildir, CPU kare monitörü beklemeleri içerebilir. GPU darboğazı bu değerlerle tek başına kanıtlanmış sayılmaz. Başka oyun tarayıcısı açık olmadan ölçüldü. Toplam browser/WASM/GPU belleği, enerji ve giriş gecikmesi NOT TESTED. Performans hedefi kapatılmadı.

Dokunmatik fixture CDP ile gerçek giriş üretir; hızlı çift zıplama aynı Godot DOM giriş yolunda zamanlanmış TouchEvent kullanır. QA köprüsü yalnız debug + `--qa` koşulunda salt okunur durum yayınlar. Oyun ilerlemesi veya oyuncu koordinatı Web testinden enjekte edilmez. Ekran testi screenshot PNG piksellerini tarayıcı 2D canvas'ıyla okur; runtime bağımlılığı eklenmedi.

Son release, kaynak **e43b0964bd69b9223cc8704f9615bb7aaf34bf29**, temiz export; tag **7fdfb912df9d9577**. Chromium 156 / SwiftShader / 1152×648 / 180 rAF: yerel açılış 3167,6 ms, medyan **33,4 ms**, P95 **50 ms**. QA kapalı, Godot monitorü null; `evidence/forge/performance-release.json`. Ortam yenilendikten sonra alındı; önce/sonra yüzde performans kazancı iddia edilmez. 16,7 ms hedefi FAIL.

Native hızlı çıkış loglarında önceki ObjectDB cleanup uyarısı sürüyor; davranış testlerinin PASS sonucu bu uyarıyı çözülmüş saymaz. Kaynakta `git diff --check` ve Python test sözdizimi kontrolleri geçti. [Teslim](DELIVERY.md); önceki 0.4.0 indirmeleri bu yamanın paketleri değildir. Yerel paketler için kaynak ağacı temizdi; Vercel'in ham worktree farkı yalnız platformun değiştirdiği, PCK'den hariç vercel.json olarak kaydedildi.

Tam üç Web kampanyasının 112+112+112 sonuçları [0.4.0 raporuna](VALIDATION_0.4.md) aittir; 0.4.1 için tekrar çalışmış gibi gösterilmez. Android SDK/JDK/imza ortamı, final sanat onayı, Emre sprite'ı ve 2–3 saat hedef süre açık kalır.
