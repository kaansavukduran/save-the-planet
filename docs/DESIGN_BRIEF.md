# Save the Planet · ürün ve tasarım özeti · 0.3.0

**Amaç:** Dört arkadaşın yetenekleriyle güvenli yollar açılan, yardımın sonuçlarının bireylerin kendi hareketlerinde görüldüğü bir platform macerası. Hayvan hakları, vegan alternatif ve ekolojik neden-sonuç ilişkisi eylemlerle işlenir.

**Kullanıcılar:** Türkçe veya İngilizce okuyan yeni/deneyimli oyuncular; sakin Story modu isteyenler; klavye, gamepad veya dokunmatik kullananlar. Aileyle oynanabilir bir ton hedeflenir; resmî yaş derecelendirmesi ve çocuk/ileri yaş/engelli katılımcı testleri yapılmadı. Görsel platform takibi gereklidir; kör oyuncular için tam erişim doğrulanmadı. “Herkes için tamamen erişilebilir” denmez.

**Ana görev:** Yeni yolculuk → kısa kontrol tanıtımı → fanı kapat → hayvan için güvenli koşullar → kendi yürüyüşünü gözle → arkadaşın katılması → çıkış ve güvenli kayıt. Sonraki on bölüm aynı döngüyü farklı bağlamlarda genişletir.

**Teknoloji:** Mevcut Godot 4.6.3/GDScript, Compatibility; web WASM, Linux/Windows export, Android release hazırlığı. Motor veya framework değiştirilmez. Native Theme/Control/Camera2D ve tarayıcının semantik dialog'u kullanılır; çalışma zamanına yeni kütüphane eklenmez.

**Cihazlar:** Öncelik yatay masaüstü/tarayıcı ve yatay dokunmatik. Küçük portrede metin rehberi kullanılabilir; platform oyununun küçük portre ergonomisi ve fiziksel telefon performansı doğrulanmadı. Xbox tipi genel gamepad tam akış hedefidir; sanal olaylar ve tarayıcı Gamepad API testi fiziksel kol onayı yerine geçmez.

**Ton:** Sıcak, okunaklı, meraklı. Üç sıfat: sakin, tutarlı, özgün. Kaçınılanlar: hayvanı puana/işçiye dönüştürme; rastgele grafik/marka kolajı; kaydedilmediği halde kaydedildi geri bildirimi.

**Marka/evren:** Fragaria Interactive üst marka, Fragaria Games oyun yayın markası, AIONIA bu oyunun evrenidir. Bu nedenle mevcut karakter/pixel art uygundur. Son logo ve onaysız varyantlar icat edilmez. Emre'nin eksik doğrulanmış sprite'ı açık kalır.

**Ekranlar:** Başlangıç, hedef HUD + takım, konuşmacılı diyalog, pause, ayarlar/giriş eşlemesi, nasıl oynanır, yerel veriler/mahremiyet ve silme onayı, bölüm seçimi, yaşam alanı/final. Web ayrıca gerçek yükleme/indirme hatası/yeniden deneme ve semantik F1 rehberi sunar.

**Tasarım sistemi:** ART_BIBLE ve PlanetSkin; lacivert/kâğıt/altın/çilek tonları, keskin çerçeveler, tutarlı native düğme/focus, gerçek durum metni ve renk dışında uyarı işareti. Rehber için rem tabanlı yazılar, dar ekranda sarılan tablo, en az 44 CSS px HTML düğmeleri. Native oyunun her fiziksel boyutta 44 CSS px hedef sunduğu iddia edilmez.

**Mevcut açıklar:** Kompakt süre, özel animasyonlar ve son sanat, fiziksel cihaz/kol/ses QA, Windows çalıştırma ve Android SDK/keystore. Bulut SwiftShader ölçümünde 60 FPS karşılanmadı. Kullanıcı araştırması, WCAG 2.2 AA onayı ve ekran okuyucuyla tam oyun testi yok.
