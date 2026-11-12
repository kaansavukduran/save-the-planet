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
| Browser yerel veri/güvenlik | PASS | Son20 kontrol; CSP gerçekten izinsiz inline script'i reddetti, depolama reddi görünür/kurtarılır, silme/iptal/başka uygulama verisi/hızlı reload ve başka scope'taki service worker korunması doğrulandı. Beklenen CSP reddi dışında 0 hata. |
| Çoklu dokunma/odak/tercihler | PASS | 12; gerçek Chromium girdileriyle yön+zıplama/yetenek; TR/EN/büyük metin/düşük efekt; canvas blur/reload. |
| Shell yükleme/hata/iframe | PASS | 7; gerçek byte callback, WASM503 → Retry, AudioContext running ve iframe yardımından tam sayfa bağlantısı. Duyulabilir ses NOT TESTED. |
| Export güncellemesi | PASS | Aynı origin üzerinde 39b831ddf9799703 → dd8a1a51569ad289, kayıt korundu; yalnız yeni engine dosyaları, 0 hata. |
| Release web | PASS | Temiz fe504a1 kaynağı, gerçek release3/3: QA telemetrisi yok, ilk hedef gerçek klavye, reload kaydı. |
| Native Linux | PASS | Aynı kaynak temiz arşiv, Xvfb/Mesa gerçek pencere/klavye: yeni oyun, hareket, zıplama ve pause görüntüleri incelendi. Fiziksel donanım/ses NOT TESTED. |
| Windows paket üretimi | PASS | Gerçek PE64 export + NSIS; ZIP/tar/SHA/BUILD/izin doğrulandı. Windows çalıştırma/kurulum NOT TESTED. |
| Vercel preview/header | PASS | READY, HTML/BUILD200, doğru source commit ve sürüm; CSP meta, nosniff/referrer/permissions-policy sunuluyor. Uzak browser oynanışı NOT TESTED. |
| Drive teslimi | PASS | Dört0.3 paket ve yeni manifest; size/parent doğrulandı. Uzak hash connector tarafından sunulmadı. |
| Android release | NOT TESTED | Betik gerçekten çalıştı, eksik ANDROID_HOME/JAVA_HOME/keystore path-user-password nedeniyle BLOCKED. APK üretilmedi. |

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

Görsel incelemede dar ekran ve 200% metinde sticky rehber düğmesi içeriği örtüyordu. Rehber gövdesi ayrı scroll bölgesi, düğme ayrılmış footer alanı yapıldı. Ölçülmüş iki örtüşmeme kontrolüyle browser veri/güvenlik toplamı20/20, 0 beklenmedik hata; yeni görüntüler insan gözüyle incelendi.

Vercel dirty kaydı araştırıldı: 2b3f16b sunucu manifesti `M vercel.json` ve `.vercel/` üretim metadata'sını bildirdi. İlk PCK'de `vercel.json` yolu gerçekten bulundu. Hosting yapılandırması/dot metadata tüm export preset'lerinden dışlandı ve `.vercel/` ignore edildi. Ham worktree değişimleri manifestte kalır; temiz kaynak veya eşit PCK hash'i doğrulanmadan iddia edilmez.

## Son kaynak ve dağıtım

Paket commit fe504a17bee8ab322fb28aced2bdb1159fcb2497, temiz yerel çalışma ağacı. [CI PASS](https://github.com/kaansavukduran/save-the-planet/actions/runs/43244440583). Web release bf1462ad1b2965d2 üzerinde3/3 smoke; yayın sürümünde test telemetrisi yok. Linux gerçek pencere görüntüleri evidence/v0.3/native altında; fiziksel ses değil Dummy backend. Windows yürütülmedi. Android guard çıktı metni ayrıca kaydedildi.

[Preview](https://save-the-planet-dknkh61u8-vegan-axolotl.vercel.app)770dfbac902d81c4 kimliğiyle aynı source commit'i bildirir; raw dirty farkı M vercel.json olarak korunur. Native/paket ve sunucu PCK hash'lerinin eşit olduğu iddia edilmez. Provider config'in runtime PCK'den çıkarıldığı yerelde doğrulandı. Seçili HTTP başlıkları ve tüm kaynak kimlikleri sonuç JSON'unda; erişim koruması kaldırılmadı. Tam indirme bağlantıları DELIVERY.md içindedir.
