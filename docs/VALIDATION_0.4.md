# Save the Planet 0.4.0 · AIONIA v1.4 gerçek doğrulama

12 Kasım 2026. Son oyun kaynağı: `a2058eaa27725c572cdd80420c8abb4108c14433`. Godot **4.6.3.stable.official.7d41c59c4** korunur. Standart belgesinin tek sekmesi tamamen okundu; gövdesi v1.4, dosya başlığı eski v1.0. [Tam kaynak kopyası](source/AIONIA_v1.4_2026-11-12.txt). Kullanıcı **D-pad + aksiyon düğmeleri** seçimini açıkça onayladı; [karar kaydı](CONTROL_DECISION.md).

Bu geliştirme teslimi bütün AIONIA üretim kapılarının kapandığı veya fiziksel cihaz sertifikası alındığı iddiası değildir. Önceki 0.3 sonuçları yeni sonuç yerine sayılmaz.

## Çalıştırılan kabul ve regresyonlar

| Senaryo | Sonuç | Kanıt ve sınır |
|---|---|---|
| Gerçek Godot fiziğiyle on bölüm | PASS · 120 kontrol | `tests/campaign.gd`: hareket, etkileşimler, gerekli dünya koşulları, dört karakter, yaşam alanı ve final. Dünya bayrakları/oyuncu konumu tur sırasında enjekte edilmez. |
| Kritik mekanikler | PASS · 24 kontrol | `acceptance.gd`: paylaşılan hava kaynakları, depar/duvar, tünel ve doğrulanan çarpışmalar, platformdan inme, menü/odak ve kayıt kurtarma. Odaklı senaryolar konum hazırlığı kullanır; tam oynanış turu diye sunulmaz. |
| Kalite ve hata kurtarma | PASS · 32 kontrol | `quality.gd`: yanlış/büyük/yeni sürüm kayıtları, gerçek dosya yazma hatası, yeniden atama/çakışma, deadzone/disconnect, hareket azaltma, veri silme ve güvenli adım eksikken görünür açıklama. Son iki kontrol gerçek E girdisiyle önce FAIL verdi, düzeltme sonrası geçti. |
| Ayrı süreçte kayıt | PASS | `save_read.gd`: başka Godot sürecinin yazdığı veri tekrar açıldı. |
| Dikey dokunmatik tam kampanya | PASS · 112/112 | TR, **360×640**, boş tarayıcı oturumu/seviye 0 başlangıcı; on bölüm, final, yaşam alanı, reload ve devam. |
| Yatay dokunmatik tam kampanya | PASS · 112/112 | TR, **844×390**, boş oturumdan aynı tam kapsam. |
| Dokunmatik gerçek kayıttan devam | PASS · 35 + 35 | Önceki gerçek koşunun değiştirilmemiş browser storage_state kaydından **8. bölümde** başlanarak iki yönde son üç bölüm/final/reload. Bunlar 112 kontrollük sıfırdan koşulara karıştırılmaz. |
| Gamepad tam kampanya | PASS · 112/112 | EN, 1152×648, yalnız tarayıcı Gamepad API fixture: analog yaklaşma, dört karakter, on bölüm/final/kayıt. Fiziksel Xbox değildir. |
| Gamepad menüleri | PASS · 11/11 | Klavyesiz başlat/geri, gerçek RS yeniden ataması, eski X atamasının kalkması, bağlantı kopması/yeniden bağlanma ve reload. |
| AIONIA v1.4 UI/UX | PASS · 48/48 | İlk açılışta OS açık olsa bile koyu; sistem fontu isteği; gerçek byte yüzdesi ve sürüm; öğretim/geç; iki parmak/çift zıplama; karakteri kapatmayan hedef alanı; havada dönüşte konum/dünya korunması; 320×568, 390×844, 844×390, 768×1024, 1024×768; 44 CSS px eylem alanı; menüler; açık/sistem tema, font ve büyük metin kalıcılığı; ses slider'ının gerçek değeri/kaydı/dokunma alanı. |
| Mahremiyet, CSP, hata kurtarma | PASS · 20/20 | İlk ziyaret kayıt yaratmaz; gerçek izinsiz inline script engellenir; depolama reddi/kurtarma, yerel veri silme/iptal, hızlı reload'da eski verinin dönmemesi, başka uygulamanın verisi ve SW scope'unun korunması. Beklenen CSP engeli ayrı tutulur. |
| Erişilebilir giriş/odak regresyonu | PASS · 12/12 | Klavyeyle ayarlar, TR/EN/büyük metin/hareket azaltma kalıcılığı, yön+zıplama/yetenek çoklu dokunması, canvas blur ile pause ve takılı tuş bırakma. |
| Gerçek yükleme ve hata durumları | PASS · 12/12 | Byte callback, engine hazır olunca kapatma, kullanıcı girdisiyle AudioContext running; WASM 503 ve retry; hata 26 saniye sonra hâlâ doğru; bootstrap JS 503 ve retry; 27 saniye bekleyen gerçek PCK isteği için stall mesajı; tarayıcı offline olayı; iframe rehberi ve odaklı hareket. Ses duyulabilirliği değildir. |
| 0.3 → 0.4 yükseltme | PASS · 7/7 | `fe504a17` kaynağından ayrı checkout'ta yeniden üretilen 0.3 release'te ilk görev oynandı. Aynı origin yeni release'e geçirildi; kayıt/ayarlar korunur, yeni tema/font varsayılanları gelir, schema 2 korunur, yeni hash'li varlıklar yüklenir. Test kayıt içeriğini düzenlemez. Arşivdeki Drive ZIP ile byte özdeşliği iddia edilmez. |
| Son shipping Web | PASS · 3/3 | Telemetri yok; gerçek klavye girdisiyle ilk fan görevi; hemen reload ile kayıt. Kaynak a2058ea, release tag **1c7a12c8f53c1839**. |
| Son Linux paketi | PASS | Temiz yeni klasörden ELF x86_64 açıldı. Xvfb/Mesa gerçek Godot penceresinde D, Space, Esc ve 390×844 pencere dönüşü; görüntüler incelendi. Dummy audio; fiziksel GPU/hoparlör değildir. |
| Paket bütünlüğü | PASS · 7 kontrol | ZIP CRC, ELF/PE x64, gömülü exe SHA-256, sürüm/kaynak/temiz çalışma ağacı ve dört dağıtım hash'i. Gerçek NSIS kurulum üretildi; Windows'ta yürütülmedi. |
| Kaynak CI | PASS | [a2058ea doğrulaması](https://github.com/kaansavukduran/save-the-planet/actions/runs/43274184288): native 120+24+32 ve ayrı kayıt; browser 48+20+11. Aynı dalın yinelenen push/PR işi concurrency ile iptal edilir. |
| Vercel preview | PASS · HTTP kapsamı | READY; a2058ea/0.4.0 için HTML ve BUILD 200; gerçek marka/sürüm, CSP meta, no-cache/ETag/nosniff/referrer/permissions başlıkları. Mevcut SSO korunur. Uzak tarayıcıda oynanış **NOT TESTED**. |

Ham sonuçlar, arşiv BUILD kimlikleri ve loglar [evidence/v0.4/results](evidence/v0.4/results) altındadır. QA ve release ayrı export'tur. Tam kampanya koşularının build kimlikleri kendi JSON'larında; sonraki UI geri bildirim düzeltmesi son native kabul ve CI'da ayrıca sınandı. Aynı ikiliyi bütün cihazlarda çalıştırdığımız iddia edilmez.

## Dokunma testinin yöntemi

Hareket/eylem/menüler CDP dokunmasıdır. Bu yazılım GPU ortamında senkron CDP onay gecikmesi, iki zıplama arasında karakterin yere inmesine yol açtı. Hızlı çift zıplama zamanlanmış **DOM TouchEvent fixture** ile Godot'un aynı DOM giriş ve fizik yoluna gönderilir; gerçek sayaç 2 olur. Oyuncu koordinatı veya hedef bayrakları yazılmaz. Bu emülasyon fiziksel, güvenilir donanım olayı testi değildir.

Test sürücüsü hareket ederken geç karakter seçip uçurumdan düşmek yerine güvenli yerde seçer; gamepad hedefe yaklaşırken analog hassasiyet kullanır. Yetenekle gerçek hedef zaten tamamlandığında rastgele bir koordinatta durmayı zorlamaz. Eski başarısız koşuların görüntüleri `regressions/` altında tarihsel olarak saklanır; başarısız JSON sonuçları sonradan PASS'e çevrilmez.

## Görsel, font ve performans sınırları

Normal UI varsayılanı Godot **SystemFont**; yerleşik DejaVu seçeneği/fallback'i saklanır. Native Linux sorgusu Noto Sans çözdü. Bu Web ortamında motor **Open Sans SemiBold** çözüyor; cihazın gerçek sistem fontuna erişildiği iddia edilmez. Bu sınır ayarlarda da açıklanır. Branded dekoratif yükleme yazısı OFL Press Start 2P'dir.

Web yüklemesi siyah zemin, kaynağı doğrulanmış çilek, Fragaria Interactive, on segment, gerçek callback yüzdesi ve gerçek sürüm kullanır. **00_BAŞLA nihai logo/karakter varyant onayını hâlâ bekletiyor.** Native boot PNG referansıyla statiktir; Web kompozisyonunun ve ölçülebilir indirme yüzdesinin birebir native karşılığı diye sunulmaz. Windows imza/resource-branding ve gerçek kurulum QA kapıları açıktır.

Renk token'larında normal metin 12,7:1; ikincil metin 5,68–6,23:1; ana düğme durumları 5,93–9,36:1; opaklığa göre modellenen dokunmatik durumları en az 8,04:1. Bunlar bütün ekranlar/donanımlar için WCAG sertifikası değildir.

| Ölçüm | Gerçek sonuç |
|---|---|
| İzole release, Chromium 156 / SwiftShader, 1152×648, ilk bölümde sabit oyuncu, 180 rAF örneği | Medyan **33,4 ms**, P95 **50 ms**. Yerel açılış **3003,7 ms**. Başka oyun tarayıcısı açık değildi. |
| 60 FPS / 16,7 ms kare bütçesi | **FAIL** bu yazılım GPU ortamında. rAF tarayıcı kare ölçümüdür; shipping build içinden Godot FPS telemetrisi açılmadı. Gerçek GPU/telefon FPS **NOT TESTED**. |
| Ayrı QA ölçümü | Godot **26 FPS**, 157 draw call, static allocator **26.550.435 byte**. Toplam browser/WASM/GPU belleği **NOT TESTED**. |
| Web paket boyutu | Ölçülen PCK karşılaştırması **11.377.396 → 10.507.900 byte**, yaklaşık **%7,6** azalma. Shell'e ait gereksiz Godot import kopyaları çıkarıldı. Bu FPS A/B iyileşme iddiası değildir. |

## Açık kapılar / devam noktası

- **NOT TESTED:** fiziksel telefon/tablet/Xbox, gerçek notch ve sistem jestleri, tek/iki el ergonomisi, Windows çalıştırma/kurulum/kaldırma, duyulabilir ses, ekran okuyucuyla tam oyun ve insan katılımcı eğlence/zorluk testi; Firefox/Safari hedefleri.
- **NOT TESTED / ortam eksik:** Android release. ANDROID_HOME, JAVA_HOME ve mevcut release keystore yapılandırması eksik; APK üretilmedi, yeni imza anahtarı oluşturulmadı.
- **FAIL:** bu ortamın 60 FPS bütçesi; gerçek donanım profillemesi ve düzeltme işi açık.
- Nihai logo/karakter varyant onayı ve doğrulanmış Emre sprite'ı eksik. Referans görülmeden tasarım uydurulmadı.
- On bölüm/final oynanır, fakat kompakt içerik **2–3 saat hedefinin tamamlandığı** anlamına gelmez; içerik genişletme ve insan süre testi açık.
- Headless test çıkışında bilinen ObjectDB cleanup uyarısı sürüyor; font `fd is null` ve JPEG splash hataları düzeltildi. Çıkış uyarısı çözüldü diye gösterilmez.

Sonraki çalışma gerçek cihaz matrisi, performans profili, sanat onayları, hedef içerik süresi ve platform yayın kapılarıyla başlar. [Paketler/yayın](DELIVERY.md), [devam kaydı](PROGRESS.md).
