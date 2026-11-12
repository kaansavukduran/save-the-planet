# Önceki oyun bildirimlerinin bu projeye uygulanması · 0.3.0

Kaynak tamamen okundu: https://docs.google.com/document/d/1cpr6yIwVOq2F9rQBlG1sSvFf0Wu9Iir0lJ_KDnqA5lE/edit . Bildirimler Aion Endless Run geçmişine aittir; Save the Planet'te güncel hata oldukları varsayılmaz. Referans depoda origin https://github.com/kaansavukduran/aion_endless_run.git olarak doğrulandı; kaynak belgedeki tireli URL otomatik doğru kabul edilmedi. Bu görevde referans depoya yazılmadı.

| ID | Uygulama ve gerçek durum |
|---|---|
| AER-001 Aion kare kayması | Kayıtlı alfa/pivot kaynakları korunur. Dünya konumu alt piksel, görsel poz piksele oturur. Bulut görüntüleri incelenir; fiziksel cihaz animasyon testi NOT TESTED. |
| AER-002 Ömer kayması | Mevcut agility/registered frame kaydı korunur; sınırlı süzülme fizik testi PASS. Gerçek hedef cihazda tüm kanat döngüleri NOT TESTED. |
| AER-003 dokunmatik | Save the Planet'te saldırı yerine yetenek/etkileşim vardır; yön+zıplama ve yön+yetenek Chromium emülasyonuyla test edilir. Fiziksel telefon ergonomisi NOT TESTED. |
| AER-004 aşağı kaydırarak takla | KAPSAM DIŞI: bu oyun aşağı swipe sözleşmesi kullanmaz. Kuzu yetenek düğmesi/J/X takla yapar, aşağı yön tek yönlü platformdan iner. İki işlev rastgele karıştırılmaz. |
| AER-005 taşmalar | Native modal scroll yalnız içerik sığmadığında kullanılır. Web rehberi dar portrede ve 200% metinle sınanır. Bütün oyun ekranlarının bütün cihazlarda taşmasız olduğu iddia edilmez. |
| AER-006 alt çubuk | Dokunmatik açıkken portreler yukarı alınır; ses/ayar kontrolleri odakla kaydırılır. Fiziksel notch/alt çubuk NOT TESTED; HTML canvas safe-area insets uygular. |
| AER-007 görsel bütünlük | Mevcut AIONIA paleti, keskin çerçeveler ve özgün karakterler korunur; yeni rastgele asset veya onaysız logo yok. Son sanat kapısı açık. |
| AER-008 portre/yatay performans | Metin rehberi portrede kullanılabilir; platform oyunu yatay önceliklidir. Küçük portrede tam oyun ergonomisi ve fiziksel telefon FPS NOT TESTED. |
| AER-009 cüce yoğunluğu | KAPSAM DIŞI: bu oyunda mantar tetiklemeli cüce spawn sistemi yok. |
| AER-010 20 saniyelik endless seviye | KAPSAM DIŞI: bu ürün on bölümlük hikâye platform oyunudur. |
| AER-011 100. seviye kutlaması | KAPSAM DIŞI: endless seviye/boss ödül/XP sistemi yok; doğrulanmamış sekiz karakter/logo eklenmez. |
| AER-012 yükleme | Gerçek byte ilerlemesi, Fragaria Games metni, sürüm, hata/yeniden deneme; zayıf indirme senaryosu sınanır. Firefox mobil ve offline PWA NOT TESTED; PWA kapalıdır. |
| AER-013 Xbox/gamepad | LB/RB, remap, deadzone, aktif ipucu ve güvenli disconnect eklenir. Tarayıcı Gamepad API fixture'ı sadece giriş üretir. Fiziksel Xbox/kol doğrulaması NOT TESTED; konsol yayını iddia edilmez. |

Son çalıştırılan sonuçlar VALIDATION_0.3.md'de; bu tablo eski bildirimi çözüldü saymak yerine kapsamı ve kanıt sınırını korur.
