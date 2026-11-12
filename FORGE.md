# Save the Planet · geliştirme devam kaydı

**0.4.2 Web hotfix yayında:** https://save-the-planet-mauve.vercel.app/play . Kullanıcının eski Canvas ekranı gerçek cache ile yeniden üretildi; yeni giriş ve hedefli emeklilik 14/14, canlı oyun/kayıt 5/5, telefon boyutunda dokunmatik 4/4 PASS. [Ayrıntı ve sınırlar](docs/HOTFIX_0.4.2.md). Son yayın kaynağı b224a759c61ab3437386c6f2ec6c77636f090f8c; sonraki rapor commit'leri oyun kodunu değiştirmez. Önceki temiz tarayıcı testi eski ziyaretçiyi kapsamıyordu.

**Onaylı 0.4.1 yayında:** https://save-the-planet-mauve.vercel.app · [GitHub release](https://github.com/kaansavukduran/save-the-planet/releases/tag/v0.4.1). Vercel production READY; canlı ilk görev/kayıt/QA kapalı testleri 5/5 PASS. [Yayın kaydı](docs/RELEASE_0.4.1.md). Aşağıdaki açık kalite kapıları geçerlidir.

Proje: `kaansavukduran/save-the-planet`, Godot 4.6.3 / GDScript. AIONIA v1.4 ve kullanıcının onayladığı D-pad + aksiyon düğmeleri geçerlidir. Mevcut dört karakterin kaynakları korunur; başka projelerdeki tasarım/anahtar/onaylar bu oyun için yetki sayılmaz.

## 0.4.1 · ekran çizimi ve giriş ipuçları

[Uygulama planı](docs/PLAN_v0.4.1.md). 1920×720/2560×720 sağ kenar ve 390×1000 üst kenar gökyüzü boşlukları, gerçek 0.4.0 Web paketinde yeniden üretildi. Gökyüzü ve çevre çizim sınırları görünür kamera alanından hesaplanır; menü duraklatılmışken de viewport değişikliği yeniden çizim ister. Dünya koordinatları/kayıt checkpoint'leri değişmez. Tünel tabelası aktif klavye/gamepad eşlemesini ve dokunmatik eylem adını izler.

Debug QA, CPU kare/fizik ve dünya çizim komutlarını hazırlama sürelerini ayrıca raporlar. Sonuncusu GPU süresi değildir. Release QA köprüsü kapalı kalır.

Son oyun kaynağı **e43b0964bd69b9223cc8704f9615bb7aaf34bf29**. Temiz kaynaktan Web/Linux/Windows portable+NSIS üretildi; arşiv/hash/source ve Linux gerçek pencere kontrolü PASS. Release ilk görev/reload/QA kapalı 3/3 PASS. Beş Drive dosyası ad/boyut/klasör metadata ile doğrulandı. [Teslim ve indirmeler](docs/DELIVERY.md), [0.4.1 doğrulaması](docs/VALIDATION_0.4.1.md), [kaynak CI PASS](https://github.com/kaansavukduran/save-the-planet/actions/runs/43282344144). Önceki [0.4.0 paketleri](docs/DELIVERY_0.4.md) kaynak commit'iyle sabittir.

## Açık kalite kapıları

- Yazılım GPU 60 FPS bütçesi önceki koşuda FAIL; düzeltildi diye işaretleme. Fiziksel GPU profili, toplam browser/WASM/GPU belleği, enerji ve giriş gecikmesi henüz doğrulanmadı.
- Fiziksel telefon/tablet iki yön/safe-area/dokunmatik/ses, Xbox, Windows kurulum/kaldırma, ekran okuyucu ve insan playtest NOT TESTED.
- Android release SDK/JDK/mevcut imza ortamı eksik; anahtar uydurma veya başka uygulamanın anahtarını kullanma.
- Nihai logo/varyant onayları, Emre'nin doğrulanmış sprite kaynağı ve 2–3 saat hedef içerik/süre doğrulaması açık.
- Hızlı headless çıkışta ObjectDB cleanup uyarısı devam ediyor; testlerin davranış PASS sonucu bu uyarının çözüldüğü anlamına gelmez.

Sonraki çalışma: ölçülen darboğaza göre anlamlı optimizasyon ve hedef cihaz testi; ardından doğrulanmış sanat kaynakları, insanla zorluk/süre/erişilebilirlik değerlendirmesi ve platform yayın kapıları. Arka planda otomatik devam sözü verilmez.
