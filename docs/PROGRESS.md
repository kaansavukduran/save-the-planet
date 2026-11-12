# 0.4.2 · eski ziyaretçi düzeltmesi

Kullanıcının fotoğraflarındaki eski Canvas, gerçek arşiv HTML/worker ve bir saatlik cache ile yeniden üretildi. Yeni `/play` girişi ve kayıt silmeyen hedefli worker/cache emekliliği: 14/14 PASS. [Hotfix kaydı](HOTFIX_0.4.2.md). Henüz fiziksel telefon testi yapılmış sayılmaz; önceki 0.4.1 indirmeleri korunur.

Canlı production b224a759c61ab3437386c6f2ec6c77636f090f8c READY: https://save-the-planet-mauve.vercel.app/play . Gerçek canlı ilk görev/kayıt5 ve telefon boyutunda dokunmatik4 PASS. Sonraki rapor commit'i yeni oyun davranışı değildir.

# 0.4.1 · Forge devamı

Kullanıcı release/Vercel yayınını açıkça onayladı. Production READY: https://save-the-planet-mauve.vercel.app ; giriş/bypass istemeyen canlı Chromium ilk görev/kayıt testi **5/5 PASS**. [Yayın ve release kaydı](RELEASE_0.4.1.md); yeni test/rapor dosyaları oyun kodunu değiştirmez.

Kullanıcı mevcut devam noktasından geliştirmeyi sürdürmeyi seçti. [FORGE.md](../FORGE.md), [plan](PLAN_v0.4.1.md), [gerçek testler](VALIDATION_0.4.1.md). Görünür kamera alanına göre gökyüzü ve çevre sınırları, pause sırasında ekran döndürme ve girişe göre tünel tabelası düzeltildi. Eski gerçek pakette yakalanan üç ekran hatasının kanıtları korundu. Yeni ekran regresyonu CI'ya eklendi. Godot, kanonik sanat, D-pad kararı, fizik ve kayıt checkpoint'leri korunur.

Native 120+24+38 ve ayrı kayıt, Web UI48 ve ekran/döndürme24 PASS. Yazılım GPU 60 FPS bütçesi hâlâ FAIL; debug CPU/fizik/çizim ayrımı kaydedildi, dünya komut hazırlama süresi GPU darboğazı kanıtı sayılmaz. Fiziksel platform testleri, Android mevcut imza ortamı, nihai kanon ve süre hedefi önceki gibi açık. Önceki teslimler kaynak commit'leriyle sabittir; yeni yamanın indirmeleri diye sunulmaz.

Son oyun kaynağı e43b0964bd69b9223cc8704f9615bb7aaf34bf29. Kaynak CI iki işte PASS. Temiz Web/Linux/Windows+NSIS paketleri üretildi; sürüm/kaynak/CRC/ELF/PE/SHA 8/8, Linux pencere ve release3 PASS. Yeni Drive dosyaları/manifest metadata kontrol edildi; [güncel indirmeler](DELIVERY.md). Release 60 FPS kontrolü tekrar FAIL: medyan 33,4 ms/P95 50 ms. Bu dosyadan sonraki rapor commit'leri oyun kaynağını değiştirmez.

---

# 0.4.0 · AIONIA v1.4 devam kaydı

Son oyun kaynağı **a2058eaa27725c572cdd80420c8abb4108c14433**. [Teslim](DELIVERY_0.4.md), [gerçek testler](VALIDATION_0.4.md), [kontrol kararı](CONTROL_DECISION.md), [plan](PLAN_v0.4.md).

Kullanıcı D-pad + aksiyon düğmelerini açıkça seçti. Godot 4.6.3, dört mevcut karakter ve on bölüm/final korunur. Koyu/açık/sistem ve font tercihleri; portre/yatay kamera/HUD; dokunmatik ↓/yetenek/etkileşim/ikincil portre/pause; atlanabilir öğretim; sabit menü eylemleri; görünür güvenlik geri bildirimi; gerçek yüzde/sürüm ve hata kurtarmayla Fragaria web yükleme ekranı uygulandı. Gereksiz shell import kopyaları Web PCK'den çıkarıldı.

Gerçek durum: native 120+24+32 ve ayrı kayıt PASS. Sıfırdan dokunmatik TR 360×640 **112/112**, 844×390 **112/112**; gamepad EN **112/112** PASS. UI48, mahremiyet20, gamepad menü11, erişilebilir giriş12, yükleme12, yükseltme7, shipping3 PASS. Temiz kaynakla paketler üretildi; Linux penceresi, SHA/CRC/source ve Drive metadata kontrol edildi. Preview READY/HTTP200; mevcut SSO korunur. Sonraki belge/test commit'leri oynanış kodunu değiştirmez.

**Açık:** release yazılım GPU 60 FPS bütçesi FAIL (33,4 ms medyan, 50 ms P95). Fiziksel telefon/tablet/Xbox/Windows/ses/ekran okuyucu ve insan playtest NOT TESTED. Android release SDK/JDK/mevcut keystore ortamı eksik. Nihai logo/varyant onayı, Emre sprite'ı, 2–3 saat hedef içerik ve platform yayın QA kapıları açık. Native splash statik PNG referansıdır; Web fontu sandbox'ta motor fallback'ine çözülebilir.

Sonraki somut sıra: gerçek cihaz + safe-area/iki yön/giriş/ses matrisi; GPU profili ve kare bütçesi düzeltmeleri; doğrulanmış sanat kaynakları; insanla zorluk/süre/erişilebilirlik testi; Android mevcut imza yapılandırması; Windows kurulum/güncelleme/kaldırma ve imza/resource-branding. Kalite kapıları kapanmadan üretim hazır diye işaretleme. Arka planda kendiliğinden devam sözü yoktur; bu dosya başlangıç noktasıdır.

---

# Güncel ilerleme · 0.3.0 · 12 Kasım 2026

AIONIA v1.1 teknoloji bağımsız talebi için mevcut Godot oyunu iyileştirildi. Kaynak URL'nin metni v1.2, başlığı v1.0 olarak okundu; fark kaydedildi. [Taslak PR #1](https://github.com/kaansavukduran/save-the-planet/pull/1) korunur; main birleştirilmedi. Önceki durum PROGRESS_0.2.md içinde.

## Uygulanan işler

- Ürün, hedef gruplar ve mevcut teknoloji DESIGN_BRIEF'te tanımlandı; yeni motor/framework eklenmedi.
- Kayıt tür/boyut/sayısal doğrulaması; bozuk/gelecek sürümü koruma, gerçek yazma hatası HUD'ı ve yeniden deneme; başarısız checkpoint'e sahte kayıt mesajı yok.
- Açık iptal/onaylı yerel veri silme; diğer uygulama verilerini koruma; silme sonrası odak/reload'un eski ilerlemeyi geri getirmesini engelleyen ilerlemesiz işaret. Web IDBFS unlink yarışı düzeltilip test tekrarlandı.
- Gamepad LB/RB, dinamik ipuçları, remap, deadzone, disconnect/reconnect güvenli pause. Native erişilebilir kontrol adları ve azaltılmış kamera hareketi.
- Semantik web yardım/mahremiyet rehberi; dar portre ve 200% metin. Genel JS eval kullanmayan depolama köprüsü ve gerçek bootstrap hash'li CSP; host güvenlik başlıkları.
- Önceki karakter/sprite kaynakları ve pixel art kimliği korundu. Özgün olmayan yeni asset veya onaysız logo/varyant eklenmedi.

## Gerçek doğrulama durumu

120 kampanya +24 kritik +30 yeni native davranış kontrolü ve ayrı süreç kayıt okuma PASS. TR gerçek klavye kampanyası 112/112, hata yok. Kontrolcü menülerinin 11 kontrolü PASS. Mahremiyet/erişilebilirlik/yükleme/güncelleme son koşularının kayıtları VALIDATION_0.3.md'de izlenir. Tam EN Gamepad API kampanyası tekrarında 112/112 ve 0 JS/konsol hatasıyla geçti. İlk denemenin 61. kontrolündeki test varış hatası ve FAIL kanıtı saklandı; yardımcının gövde durduktan sonraki konum kontrolü düzeltildi. Tarayıcı veri/güvenlik20, gamepad menü11, erişilebilirlik12 ve shell7 PASS; export güncellemesinde kayıt korundu.

## Açık kapsam / devam noktası

1. Fiziksel hedef cihazlarda performans/erişilebilirlik ve tam kontrolcü akışını doğrula. Web/Native paketleri ve HTTP preview bu görevde üretildi/test edildi; uzak tarayıcı oynanışı ve fiziksel donanım onayları hâlâ açıktır.
2. Fiziksel Xbox/kol, telefon, Windows kurulum/oynanış, duyulabilir ses ve ekran okuyucu testlerini yap. Sanal Gamepad API ve bulut görüntüleri fiziksel cihaz onayı değildir.
3. Hedef 60 FPS için fiziksel cihaz profiler ölçümü ve anlamlı optimizasyon; bulut SwiftShader örnekleri hâlâ yaklaşık25 FPS. Toplam browser belleği/enerji/input latency NOT TESTED.
4. Hedef oyun süresi, özel bakım/gözlem animasyonları, çevrenin son sanat geçişi ve Emre'nin doğrulanmış sprite kaynağı açıktır. Onaysız kanon/logoyu uydurma. Android için mevcut SDK/keystore ortamı olmadan release APK üretme.
5. İnsanlarla yeni kullanıcı/ileri yaş/engelli/sessiz kullanım, keyif ve eğitim etkisini değerlendir. “Herkes için tamamen erişilebilir” ve final yayın kalitesi iddia edilmez. Bazı hızlı headless kapanışlarında audio cleanup uyarısı hâlâ görülebilir.

Arka planda kendiliğinden devam sözü verilmez; bu dosya sonraki çalışmanın somut başlangıcıdır.

## Son teslim kaydı

fe504a17bee8ab322fb28aced2bdb1159fcb2497 temiz kaynak: web/Linux/Windows portable+NSIS üretildi; arşiv/hash/BUILD doğrulandı. Gerçek release web3/3 ve temiz Linux penceresi PASS. Drive0.3 dosyaları/manifesti boyut/klasörle doğrulandı; eski0.2 korundu. Vercel READY/HTTP200/header kontrolleri PASS; runtime config paket dışına alındı. Native CI120+24+ayrı kayıt+30 PASS. İndirmeler/SSO preview DELIVERY.md içinde. Kaynak kodu bu commit'te sabittir; sonraki belge commit'leri yeni oynanış sürümü değildir.
