# 0.4.0 · AIONIA v1.4

- Varsayılan koyu ve sistem fontu isteği; kalıcı açık/sistem tema ve font alternatifi. Web font erişimi sınırlaması UI'da açıklanır.
- Kullanıcı onaylı D-pad + aksiyonlar, portre/yatay için ayrı HUD/kamera/menü, 44px hedeflenen kontroller, atlanabilir öğretim ve ikinci parmakla karakter/pause.
- Dokunmatik etkileşim işleyicisi ve kaybolan menü eylemleri düzeltildi. Bağlamsal ipucu karakteri kapatmaz; güvenlik geri bildirimi saklanmaz.
- Referans çilekli siyah Fragaria yükleme ekranı: pixel yazı, on segment, gerçek byte yüzdesi/sürüm, JS/WASM hatası, stall/offline/retry. Native açılış sınırlaması ayrı.
- Shell'e ait gereksiz import kopyaları Web PCK'den çıkarıldı; lisanslar Web kökünde de dağıtılır.
- Üç tam browser kampanyası ve kayıt yükseltmesi doğrulandı. Sonuçlar ve açık kalite kapıları [0.4 test raporunda](VALIDATION_0.4.md).

Önceki sürüm notları aşağıda korunur.

---

# Save the Planet 0.3.0 · geliştirme sürümü

AIONIA v1.1 teknoloji bağımsız kalite yaklaşımı mevcut Godot oyununa uygulanır; kaynak dokümanın metni okumada v1.2 idi. Ürün/hedef gruplar, gerçek QA ve güvenlik/mahremiyet sınırları repoda kaydedildi.

- Bozuk/büyük/yeni sürüm kaydını koruma, görünür yazma hatası ve gerçek retry; başarısız checkpoint kaydına başarılı mesaj yok.
- Yerel ilerleme/ayar/geçmiş için iptal/onaylı silme, başka uygulama verisini koruma ve hızlı reload'da eski IDB kaydının geri gelmesini engelleme.
- LB/RB, aktif giriş ipuçları, klavye/gamepad remap, çakışma mesajı, deadzone ve güvenli disconnect/reconnect; azaltılmış kamera hareketi.
- Aynı görsel kimlikle semantik web yardım/mahremiyet rehberi, 200% metin ve küçük ekran düzeni. JS eval içermeyen depolama köprüsü, gerçek hash'li CSP, host güvenlik başlıkları ve scope'a bağlı eski worker temizliği.
- Dört karakter/on bölüm/final ve kaynak görseller korunur. Başka motor, framework veya rastgele asset eklenmez.

Sonuçlar VALIDATION_0.3.md, sınırlar PROGRESS.md, yayın/indirmeler DELIVERY.md içindedir. Fiziksel cihaz/kol/ekran okuyucu, son sanat/hedef süre ve Android release koşulları tamamlanmadı. 60FPS bulut hedefi karşılanmadı; final/evrensel erişilebilirlik onayı iddia edilmez.

---

# Save the Planet 0.2.0 · geliştirme sürümü

Fragaria Interactive / Fragaria Games / AIONIA, 12 Kasım 2026.

- Dört karakterli Godot kampanyası: beş perde, on bölüm, bireysel hayvan sonuçları ve gezilebilir final. Önceki Canvas kaynakları legacy/ altında korunur.
- AIONIA 00_BAŞLA ve standart v1.0 uygulama kaydı; 19 kaynak pafta/çilek referansı, hash ve görsel onay sınırları.
- Ortak native Godot teması, hedef odaklı HUD, karakter portreleri, konuşmacılı sayfalı diyalog, net klavye/gamepad odağı, başlatma ve kurtarılabilir indirme hatası ekranı.
- Katmanlı çevre siluetleri, yumuşak yön bakışlı kamera, yuvarlanmış görsel konumlar ve hareket hızına uygun animasyon zamanı.
- Menüde giriş yalıtımı, sınırlı ortak hava hakları, güvenli tünel geçişi, gerçek hareketli platformlar; eşzamanlı web kayıt snapshot’ı ve geçerli yedek.
- TR/EN, büyük yazı, azaltılmış efekt, yeniden atanabilir tuşlar, ayrı müzik/efekt ayarı, çoklu dokunmatik kontrol.

Bu sürüm final yayın onayı değildir. Eksik özel animasyonlar ve Emre sprite’ı, tam sanat yönetimi, hedef oynanış süresi, Android release araç/imza ortamı, fiziksel Windows/telefon/gamepad ve insan katılımcı testleri açıktır. Son test sonuçları docs/VALIDATION.md, devam noktası docs/PROGRESS.md içindedir. Varsayılan olmayan cihazlarda akıcı deneyim doğrulanmış sayılmaz.
