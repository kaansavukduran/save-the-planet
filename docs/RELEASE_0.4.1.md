# 0.4.1 · kullanıcı onaylı yayın

12 Kasım 2026. Kullanıcı release ve Vercel yayını için açık onay verdi. Nihai sanat onayı veya açık kalite kapılarının kapandığı varsayılmadı.

- Oyna: https://save-the-planet-mauve.vercel.app
- GitHub geliştirme release'i: https://github.com/kaansavukduran/save-the-planet/releases/tag/v0.4.1
- Vercel production: `dpl_DMPNrWeKQScazFSWkwhNUecj8L1j`, READY. Kaynak `18beed6ac8eab4fc592849f2037517d239b2fa9e`; son oyun kodu `e43b0964bd69b9223cc8704f9615bb7aaf34bf29`. İçerik tag'i `bcf65934d8e9723c`.

Ana adres kullanıcı girişi ve bypass token olmadan HTTP 200 verir. Mevcut preview koruması değiştirilmedi. İki CI işi son yayın kaynağında PASS: https://github.com/kaansavukduran/save-the-planet/actions/runs/43284224037 .

## Gerçek canlı test

Chromium 156 / SwiftShader, 1152×648: **5/5 PASS**. Ana adresin girişsiz açılması, 0.4.1/source kontrolü, QA köprüsünün kapalı olması, gerçek klavye hareketi ve etkileşimle ilk fan görevinin tamamlanması, aynı origin'de reload sonrası kaydın korunması. Kanıt: `evidence/forge/public/results.json`, `first-goal.png`, `test.log`; tekrar betiği `reproduce.py`. Oyun durumu/koordinat enjekte edilmedi.

İlk test sürümünde Playwright APIRequestContext metadata bağlantısı ECONNREFUSED verdi; oyun menüsü açılmıştı. Metadata tarayıcının normal aynı origin fetch'iyle okunarak yardımcı onarıldı; ilk başarısız kayıt/görüntü saklandı. Bu olay oyun yükleme hatası veya düzeltilen oyun kusuru diye sayılmaz.

GitHub ikili dosya yükleme servisi 401 döndürdü. Release, doğrulanmış dört Drive paketini ve SHA-256 manifestini bağlantı olarak içerir; GitHub release asset'i yüklenmiş gibi gösterilmez. Normal GitHub API ile release yayını tamamlandı. Kimlik dosyası arama adımı otomatik incelemede reddedildi ve terk edildi; standart erişim dışından kimlik bilgisi alınmadı.

Bu yayın oynanabilir bir geliştirme sürümüdür. Yazılım GPU 60 FPS bütçesi FAIL; fiziksel telefon/tablet/Xbox/Windows/ses/ekran okuyucu ve insan playtest NOT TESTED. Android imza ortamı, nihai sanat ve hedef süre açık. [Ayrıntılı kalite raporu](VALIDATION_0.4.1.md), [paketler](DELIVERY.md).
