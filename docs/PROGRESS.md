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
