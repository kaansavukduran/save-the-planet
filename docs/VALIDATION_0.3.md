# 0.3.0 gerçek test raporu · AIONIA v1.1 uygulaması

12 Kasım 2026. Godot 4.6.3; Linux x86_64 / Chromium 156.0.8078.79, SwiftShader yazılım GPU. Yatay 1152×648; metin rehberi küçük portre 360×640 ve 200% kök yazı büyütmeyle sınanır. Fiziksel cihaz testi değildir.

| Test | Sonuç | Kapsam |
|---|---|---|
| Headless tam hikâye | PASS | 120 gerçek fizik/eylem kontrolü, 10 bölüm/final. |
| Kritik senaryolar | PASS | 24; ortak hava bütçesi, depar/duvar/tünel/platform, menü, odak, kayıt yedeği/sürümü. |
| Ayrı süreç kayıt | PASS | Gerçek disk kaydı yeni Godot sürecinde okundu. |
| Yeni kalite kontrolleri | PASS | 30; hatalı/büyük kayıt, gerçek yazma hatası ve görünürlüğü, sahte checkpoint mesajını engelleme, remap/çakışma, analog eşik, disconnect, azaltılmış kamera, iptal/onay ve silme sonrası otomatik kaydı engelleme. |
| TR klavye tam kampanya | PASS | Gerçek browser 112 kontrol, 0 JS/konsol hatası; final/reload/devam. QA f4444d4641d69e40. |
| EN Gamepad API tam kampanya | PASS | Tekrarda 112 kontrol/0 JS-konsol hatası; 10 bölüm, final, reload/devam tamamen kontrolcü girdileriyle. İlk 61 kontrollük FAIL koşusu korunur. Fiziksel kol NOT TESTED. |
| Gamepad API menü/remap/hotplug | PASS | 11 kontrol; klavyesiz A/B menüler, RS remap/etiket/gerçek yetenek, eski X kaldırma, disconnect release/pause, reconnect açık resume, reload'da atama korunması. Fiziksel kol değildir. |
| Browser yerel veri/güvenlik | PASS | Son18 kontrol; CSP gerçekten izinsiz inline script'i reddetti, depolama reddi görünür/kurtarılır, silme/iptal/başka uygulama verisi/hızlı reload ve başka scope'taki service worker korunması doğrulandı. Beklenen CSP reddi dışında 0 hata. |
| Çoklu dokunma/odak/tercihler | PASS | 12; gerçek Chromium girdileriyle yön+zıplama/yetenek; TR/EN/büyük metin/düşük efekt; canvas blur/reload. |
| Shell yükleme/hata/iframe | PASS | 7; gerçek byte callback, WASM503 → Retry, AudioContext running ve iframe yardımından tam sayfa bağlantısı. Duyulabilir ses NOT TESTED. |
| Export güncellemesi | PASS | Aynı origin üzerinde 39b831ddf9799703 → dd8a1a51569ad289, kayıt korundu; yalnız yeni engine dosyaları, 0 hata. |
| Release/native paketler ve remote preview | NOT TESTED | 0.3 kaynak sabitlendikten sonra gerçek export/smoke test yapılacak; 0.2 paketleri 0.3 diye sunulmaz. |

## Testin sınırı ve kalite kapıları

A Kaynak/ürün denetimi PASS; B tasarım/kapsam PASS; C çalışan temel deneyim PASS. D nihai sanat/hedef süre FAIL. E fiziksel cihaz/ekran okuyucu/insan katılımcı QA NOT TESTED; bulut 60 FPS hedefi FAIL. F nihai tüm platform yayın kapısı açık; Android SDK/imza yok, Windows fiziksel çalıştırılmadı. WCAG 2.2 AA veya evrensel erişilebilirlik sertifikası iddia edilmez. Proje dışı endless-runner mekanikleri REGRESSION_SCOPE.md'de gerekçeli kapsam dışında.

QA yalnız debug + --qa için salt okunur; kampanya testleri görev veya konum bayrağı yazmaz, klavye/Gamepad API girdileri üretir. Hatalı kayıt ve güvenlik testleri kendi izole profilinde kötü veri/depolama reddi kurar; bunu doğal kampanya ilerlemesi olarak sunmaz. Yeni CSP yüzünden testin sayfa içi string eval beklemesi engellendi; CSP kapatılmadan DevTools üzerinden dışarıdan polling'e geçildi.

## Bulunan/düzeltilenler

- JSON içindeki yanlış aktif karakter türü int dönüşümünü bozabiliyordu; gerçek yedekten kurtarma ile doğrulandı.
- Kayıt hatası yalnız başlıkta kalıyor ve checkpoint her durumda saved diyordu; kalıcı HUD uyarısı ve dürüst sonuç eklendi.
- Silme/odak/reload yarışında eski IDB kaydının geri dönmesi işaretle engellendi. İlk browser testinde IDBFS queued read ile unlink yarışı konsol hatası verdi; web'de önce içeriği sıfırlayıp sonraki güvenli açılışta kaldırma ile tekrar17/17 ve sıfır beklenmedik hata.
- Title Settings'te Start veya New Journey onayında iptal dünyayı istemsiz başlatabiliyordu; başlığa güvenli dönüş eklendi ve gerçek girişle sınandı.
- Giriş ipuçları klavyede kalıyordu; gamepad remap dahil aktif yöntemden gelir. Tuş çakışması sessizce bozuk eşleme yaratmaz.
- Eski worker temizliğinin başka scope'taki aynı adlı sw.js dosyasını kaldırmaması için scope/URL eşleşmesi daraltıldı; başka scope'taki worker reload sonrası hâlâ aktif; regresyon PASS.

Bütün son sonuçlar evidence/v0.3/results içinde sürümlenir. Bazı hızlı headless kapanışlarında AudioStreamWAV/playback ObjectDB cleanup uyarısı var; runtime JS hatası yok diye bu uyarı çözülmüş sayılmaz.

Tam klavye kampanyası f4444d4641d69e40, tam Gamepad API kampanyası ve son browser paketi dd8a1a51569ad289 QA çıktısıyla oynandı. Sonraki yalnız çakışma mesajını menü üstüne taşıyan UI düzenlemesi ek Native kalite testiyle doğrulandı (toplam30); hikâye/fizik değişmedi. Testin simüle Gamepad API nesnesi yalnız tuş/eksen üretir, görev/konum yazmaz. Fiziksel Xbox için sonuç çıkarılmaz.

## İzole performans örneği

Aynı Linux/Chromium/SwiftShader, 1152×648 CSS/canvas, a1l1 başlangıcı ve boşta oyuncu, diğer oyun tarayıcıları kapalı; 180 requestAnimationFrame örneği. Önce0.2: medyan33,4ms/p95 66,6ms, Godot25FPS, statik allocator27.776.831 byte, yerel başlangıç2459,1ms. Son0.3 QA2b51e35d3bc5cfee: medyan33,4ms/p95 50,1ms, Godot24FPS, statik allocator26.179.397 byte, yerel başlangıç3021,6ms. Bunlar tekil örneklerdir; nedensel hızlanma veya hedef cihaz garantisi çıkarılmaz. **60FPS kapısı bu ortamda FAIL.** Statik allocator toplam WASM/browser belleği değildir; toplam bellek, enerji ve giriş gecikmesi NOT TESTED. Shell işlev testi başka browser ile eşzamanlıydı; oradaki FPS bağımsız benchmark yerine kullanılmaz.
