# 0.4.2 · eski Canvas ekranından güvenli geçiş

Kullanıcı, production ana adresinde eski “Çitin Ötesi / Kanıt Atlası” Canvas ekranını gördüğünü iki ekran görüntüsüyle bildirdi. Görüntüdeki başlık/DOM depodaki `legacy/index.html` ile eşleşti. Sunucu ve alias kontrolünde 0.4.1 doğru production paketiydi; temiz Chromium testi bu eski ziyaretçi durumunu kapsamamıştı.

Eski `legacy/vercel.json` HTML dahil bir saatlik HTTP önbelleği veriyordu. Arşiv worker'ı `save-the-planet-v1` cache'ini network'ten önce okuyor; yeni yayında eski worker URL'leri 404 dönüyordu. Eski HTML cache'ten sunulursa yeni HTML'nin unregister kodu hiç çalışmaz. Bu mekanizma gerçek eski HTML/worker ile yeniden üretildi. Kullanıcının telefonunun iç önbelleği uzaktan incelenmedi; fotoğraf tek başına hangi önbelleğin tuttuğunu kanıtlamaz.

## Değişiklik

- Yeni giriş `/play`, mevcut eski `/` ve `/index.html` cache anahtarlarından ayrıdır. Ana adres `/play` girişine yönlenir. Yeni giriş no-store; mevcut HTML ve oyun asset hash politikası korunur.
- Arşivdeki iki worker URL'si artık 404 yerine emeklilik betiği sunar. Betik yalnız bilinen oyun cache'ini bırakır; kayıt/IndexedDB/localStorage silmez, ilgisiz pencereleri yönlendirmez.
- Güncel shell yalnız bilinen root worker'ları unregister eder, yalnız `save-the-planet-v1` cache'ini kaldırır; oyun giriş URL'lerini yeniden doğrular. Tüm origin verisi veya browser cache'i topluca silinmez.
- Oyun sürümü tarayıcı başlığında ve yardım ekranında görünür. Window.title kullanılır; uygulamanın adı/user-data yolu değiştirilmez.
- Godot, karakter grafikleri, dünya fiziği, kayıt şeması ve onaylı kontroller korunur. 0.4.2 bu Web geçiş düzeltmesidir; yeni native/Android paket üretildiği iddia edilmez.

## Gerçek test

`tests/browser_legacy_upgrade.py`: **14/14 PASS**. Önce normal hareket/etkileşimle Godot kaydı oluşturulur; sonra gerçek eski Canvas ve worker aynı origin'e yüklenir. Sunucu güncel Godot sunarken eski ekranın cache'ten kaldığı gösterilir. `/play` girişi yeni oyunu açar; gerçek flag/completed korunur; başka localStorage/cache/worker ve açık başka pencere korunur; eski kayıt kaldırılır; QA kapalıdır; sonraki root ziyareti de yeni oyunda kalır.

Kanıt `evidence/legacy-upgrade/accepted/`; 390×844 Chromium/SwiftShader görünümü. Önceki test/uygulama denemeleri saklandı. İlk fixture accepted socket'te klasörü seçtiği için Chromium preconnect'i sahte eski sunucuya bağlayabiliyordu; klasör artık her istekte seçilir. Başlık testinde düşük seviye DisplayServer yerine Window.title kullanımı gerekti. Bunlar gizlenmiş PASS değildir; başarısız kayıtlar korunur.

CI aynı arşiv HTML/worker'ı kullanır; geçmiş sunucunun eksik worker yanıtı fixture'da 404 ile kurulur. Yerel koşuda gerçek 0.4.1 export'tan 0.4.2'ye geçildi. Fiziksel telefon, tarayıcıların otomatik worker kontrol zamanlaması ve tüm eski cihaz durumları NOT TESTED. Canlı yayın sonucu ayrıca kaydedilir.
