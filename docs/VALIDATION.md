# Güncel rapor: 0.3.0

[AIONIA v1.1 uygulaması ve gerçek sonuçlar](VALIDATION_0.3.md). Aşağıdaki metin 0.2.0 tarihsel kaydıdır; yeni sürümün sonucu yerine sayılmaz.

# Gerçek doğrulama · 0.2.0 · 2026-11-12

Godot 4.6.3.stable.official.7d41c59c4; Linux x86_64 (6.18.57), Chromium 156.0.8078.79, 1152×648, SwiftShader WebGL2 yazılım GPU. Telefon yerleşim kontrolü 844×390 emülasyondur; fiziksel cihaz testi değildir. Headless test, gerçek görüntü ve oynanış yerine sayılmaz.

## Çalıştırılan testler

| Test | Sonuç | Gerçek kapsam |
|---|---|---|
| tests/campaign.gd | PASS | Gerçek CharacterBody2D ve girişle 120 kontrol, 10 bölüm, bütün zorunlu hedef/çıkışlar, dört birey ve gezilebilir final; 0 retry. Bayraklar doğrudan enjekte edilmez. |
| tests/acceptance.gd | PASS | Son çalıştırmada 24 kontrol; hava kaynakları, depar/duvar, tünel, platform, menü, odak, sanal gamepad, tekrarlı kurtarma, kayıt kurtarma/sürüm sınırı. Senaryo kurulumu konumu hazırlar; gerçek eylem/fizik işleyicileri çalışır. |
| tests/save_read.gd | PASS | Ayrı Godot süreci önceki sürecin bölüm/karakter/açılış/ilerleme kaydını okudu. |
| tests/browser_campaign.py · TR | PASS | Gerçek Godot WASM/PCK, yalnız klavye ile on bölüm, opsiyonel tohum yatağı, final, yaşam alanı, hemen reload ve devam. 112 kontrol, 0 konsol/JS hatası. |
| tests/browser_campaign.py · EN | PASS | Aynı tam hikâye İngilizce menü/başlıklarla: 112 kontrol, 0 konsol/JS hatası. |
| Son çizim sürümü · ilk bölüm | PASS | 15 gerçek tarayıcı kontrolü; çıkış, reload ve devam dahil. |
| tests/browser_accessibility.py | PASS | 12 kontrol: klavyeyle ayarlar, büyük metin/TR-EN/düşük efekt kaydı, yön+zıplama ve yön+yetenek çoklu dokunma, gerçek canvas blur ve takılı tuşu bırakma. |
| tests/browser_shell.py | PASS | 7 kontrol: gerçek byte ilerlemesi, motor açılınca yüklemeyi kapatma, kullanıcı girdisiyle AudioContext running, kasıtlı WASM 503 hatası, yeniden denemeyle gerçek oyunu açma, iframe tam sayfa bağlantısı ve odaklı hareket. Fiziksel duyulabilir ses testi değildir. |
| tests/web_update.py | PASS | Aynı origin üzerinde 39b831ddf9799703 → b49818f97a604eef gerçek farklı export'ları; dünya kaydı korunur, yalnız yeni JS/WASM/PCK indirilir, 0 hata. |
| Nihai Linux/Windows paketleri | PASS | Temiz a87199e kaynağından 0.2 export; arşiv bütünlüğü, SHA-256, BUILD kaynak/target kimliği, Linux çalıştırma izni ve Windows PE x64 doğrulandı. Linux temiz klasörden Xvfb/Mesa penceresinde açıldı; gerçek klavyeyle hareket/zıplama/pause görüntüleri incelendi. Windows üzerinde EXE/kurulum çalıştırma NOT TESTED. |
| Vercel son preview | PASS | a87199e için READY; yetkili connector ile HTML ve BUILD.json HTTP 200, doğru kaynak commit/0.2.0 ve HTML içerik kimliği. Mevcut SSO korunur. Uzak tarayıcı oynanışı NOT TESTED. |
| Release web smoke | PASS | tests/browser_release.py: telemetri yok, gerçek klavyeyle fan hedefi, hemen reload ile kayıt; 3/3 kontrol, 0 konsol/JS hatası. |
| Drive aktarımı | PASS | Dört 0.2 paket ve güncellenen SHA manifesti yüklenip dosya boyutu/hedef klasörü yeniden okundu. Connector uzak checksum alanını sunmadı; uzak hash doğrulandı denmez. |

QA telemetrisi yalnız debug export + --qa için salt okunurdur; testler dünya ilerlemesini JS ile yazmaz. Release sürümü bu kanalı açmaz. Tam kampanyaların QA içerik kimliği 554c9cc6eff9003c; sonraki renk/çizim kırpma sürümü b49818f97a604eef ilk bölüm, erişilebilirlik, yükleme/hata ve güncelleme testlerinden geçti. Son gamepad Start düzeltmesi headless sanal gamepad olaylarıyla doğrulandı.

## Belgedeki 24 kabul senaryosu

PASS yalnız açıklanan ortam/kapsam için geçerlidir. Eksiksiz son sanat ve fiziksel platform onayı değildir.

| No | Sonuç | Kanıt / sınır |
|---|---|---|
| 01 Yeni oyun | PASS | Gerçek klavyeyle yeni oyun → kısa kontrol tanıtımı → fan hedefi → ilk etkileşim. İlk kez oynayan insan katılımcı testi NOT TESTED. |
| 02 Görsel bütünlük ve gerekli tüm varlıklar | FAIL | Dört özgün sprite doğru kaynaklardan görünür; özel bakım/gözlem pozları ve tüm çevrenin son sanat geçişi eksik. Emre için doğrulanmış sprite yok. |
| 03 Havada Aion/Ömer | PASS | 30 geçiş, biten zıplama/süzülme/cooldown yenilenmiyor; işaretli hava akımı da sonlu. |
| 04 Kurt deparı | PASS | Gerçek kapalı duvara karşı geçişte hız ≤420, duvar aşılmıyor. |
| 05 Kuzu tüneli | PASS | Gerçek 26 px takla ile girme; büyük gövde içeride reddedilir, dışarıda açılır. |
| 06 Hareketli platform | PASS | Temas/taşınma ve karakter geçişi fizik testi; tarayıcı kampanyasında nehir geçidi ve görünür karakter. Fiziksel cihaz kamera testi NOT TESTED. |
| 07 Tekrarlanan kurtarma | PASS | Duru kendi yürür; sahneyi tekrar açınca tek birey/tek sonuç. |
| 08 Kayıttan devam | PASS | Ayrı süreç ve gerçek tarayıcı reload; final/yaşam alanı/açılışlar/dünya bayrakları korunur. |
| 09 Bozuk/eski kayıt | PASS | Bozuk ana dosyadan geçerli yedek; şema 1 geçişi; gelecekteki şema üzerine yazmayı reddetme. |
| 10 Menü/diyalog | PASS | Fizik/tehlike/cooldown donar; kapanış zıplama/yeteneği tekrar etmez. Gerçek browser takım menüsü de sınandı. |
| 11 Odak kaybı | PASS | Headless bildirim + gerçek canvas blur; dönüşte basılı yön kalmıyor. |
| 12 Çoklu dokunma | PASS | Gerçek Chromium dokunma olaylarıyla yön+zıplama ve yön+yetenek birlikte. Fiziksel telefon NOT TESTED. |
| 13 Klavye/gamepad menü | PASS | Gerçek klavye menüleri + Godot sanal D-pad/A/Start. Fiziksel gamepad NOT TESTED. |
| 14 TR/EN, büyük yazı | PASS | Tam TR/EN kampanya ve incelenen büyük yazı/telefon ekranları. Bütün kombinasyonların insan erişilebilirlik incelemesi NOT TESTED. |
| 15 Sessiz/düşük efektin anlaşılabilirliği | NOT TESTED | Tercih kaydı/uygulama sınandı; tehlikeler şekil ve durumla da çizilir. Sessiz oynayan insanla anlam test edilmedi. |
| 16 Kirlilik | PASS | Tekrar gelen atık, kaynağı durdurma ve çok aşamalı arıtma gerçek oynanışta tamamlandı. |
| 17 Kanıt | PASS | Kaynak/tarih/birim/kapsam görünür kurgu kayıtları; yeterli kanıt yok sonucu ilerletiyor, zorunlu quiz/onay yok. |
| 18 Alternatif rota | PASS | Ağır bariyer kapalıyken gerçek üst parkurdan aşma headless testi. |
| 19 Tam hikâye | PASS | 10 zorunlu hedef/çıkış, story_complete, etkileşimli final TR/EN gerçek tarayıcıda. Hedef 2–3 saat süre karşılanmadı. |
| 20 Temiz paket | PASS | 0.2 ZIP/tar üyeleri, hash/BUILD, ELF/PE türü/izinler; gerçek release web ve temiz Linux pencere smoke testi. Windows çalıştırma NOT TESTED. |
| 21 Web güncellemesi | PASS | Aynı origin kayıt + yeni hash'li dosyalar, sıfır hata. |
| 22 Çevrimdışı/PWA | NOT TESTED | PWA kapalı; web çevrimdışı açılış sözü yok. |
| 23 Android arka plan dönüşü | NOT TESTED | Release SDK/keystore yapılandırması eksik; fiziksel Android çalıştırılmadı. |
| 24 Hikâye/etik | PASS | Mercimekli sofra eylemi, habitatta kalan yaban bireyleri, bakımın sürmesi ve gezilebilir final gerçek oynanışta. Eğitim etkisi araştırması NOT TESTED. |

## Performans ve ölçüm sınırları

Hedef 60 FPS. İzole yerel Chromium, SwiftShader, 1152×648, ilk bölüm başlangıcı, oyuncu boşta: 120 requestAnimationFrame aralığı, medyan **33,4 ms**, p95 **50,1 ms**. Godot monitörü örneğinde **25 FPS**, **156 draw call**, **27.751.223 byte statik allocator belleği**. Yerel başlangıç **3.219,8 ms**. Bu statik bellek sayısı toplam WASM veya tarayıcı belleği değildir. Toplam bellek ve fiziksel GPU NOT TESTED. Bu ortamda 60 FPS kapısı **FAIL**; fiziksel hedef cihazlar için sonuç çıkarılmaz. Önceki izole ölçüm 23 FPS idi; bu fark performans garantisi sayılmaz.

Dünya süslerinin ekran dışı çizimleri sınırlandı; zemin/ot ayrıntıları kamera hareketinde yer değiştirmeyen dünya ızgarasına bağlandı. Sadece bu değişiklik nedeniyle tüm cihazların akıcı olduğu söylenmez. Son gerçek oynanış kanıtları evidence/tr, evidence/en, evidence/aionia ve evidence/results altındadır.

## AIONIA kapıları

| Kapı | Sonuç | Gerekçe |
|---|---|---|
| A Kaynak denetimi | PASS | Tam brief, 00_BAŞLA/standart v1.0, 19 yeni görsel, 14 eski hash, repo/lisans/kullanıcı değişiklikleri incelendi. |
| B Tasarım | PASS | GDD, GAME_DESIGN, ART_BIBLE, LORE_LINKS ve animasyon kaydı mevcut; onaysız kanon açıkça taslak. |
| C Dikey dilim | PASS | İlk bölüm gerçek motor, giriş, animasyon, UI, ses bağlamı, kurtarma/çıkış/kayıt ile oynandı. |
| D Tam içerik ve son sanat | FAIL | On bölüm oynanır; hedef süre ve tam özgün sanat/özel animasyon işleri tamamlanmadı. |
| E Hedef cihaz QA | NOT TESTED | Bulut/otomasyon testleri var; fiziksel telefon, gamepad, Windows ve insan katılımcı testi yok. |
| F Nihai yayın | FAIL | Web/Linux/Windows paketleri ve korumalı preview doğrulandı; bütün hedef platformlar için final yayın kapısı açık: Android release yok, fiziksel Windows/telefon QA yapılmadı, sanat/süre hedefleri bitmedi. |

## Bulunan ve düzeltilen hatalar

Başlangıç Canvas oyununda menü arkasında hareket vardı; yeni Godot pause sistemiyle gerçek testte giderildi. Web ilk export'unda worklet 404, hemen reload kaybı ve oyun kolunda A kabul eksikliği bulundu/düzeltildi. AIONIA geçişinde Ayarlar geri hedefi düzeltildikten sonra Start bir üst menüye dönerek oyunu duraklatılmış bırakıyordu; son kritik test bunu ve buna bağlı dört sonraki kontrolü FAIL verdi. Start doğrudan devam, Escape/B geri olarak düzeltildi; tekrarında 24/24 PASS. İlk ana düğme kontrastı 3,97:1 idi; koyulaştırılıp 4,74:1 yapıldı. İlk ham indirme hatası kullanıcı mesajı ve isteğe bağlı teknik ayrıntı ile değiştirildi.

Bazı önceki hızlı headless kapanışlarında AudioStreamWAV/PlaybackWAV için ObjectDB cleanup uyarısı görüldü. Son acceptance çalıştırmasında tekrar etmedi; bütün kapanış yollarında çözüldüğü iddia edilmez. Oynanış testlerinde JS/parse hatası yok. İnsanlarla keyif, sıkılma, öğretim etkisi ve karşılaştırmalı Aion Endless Run testi yapılmadı.

## Paket ve dağıtım kanıtı

Kaynak kod commit: `a87199ed085ae260f6a9a2dc151d74dee96c1bf1`; paket üretim anında çalışma ağacı temiz. Yerel release web kimliği `7be7892d191477ca`; gerçek release smoke testi bu çıktıyı oynadı. [GitHub CI](https://github.com/kaansavukduran/save-the-planet/actions/runs/43228077335) PASS (web export + 120 kampanya + 24 kritik + ayrı kayıt süreci). Paketler evidence/results/packages.json ve SHA256SUMS.json ile kayıtlıdır.

[Vercel preview](https://save-the-planet-ktkxh1rc2-vegan-axolotl.vercel.app) aynı kaynak commit'ini, sürüm 0.2.0 ve `d6efeb0a71532833` sunucu içerik kimliğini bildirir. Sunucuda `working_tree_dirty: true` olduğu manifestte aynen korunmuştur; yerel paketle aynı PCK hash'i iddia edilmez. HTML yeni hash'i referanslıyor. Uzak derleme için hangi üretilen/import dosyasının değiştiği araştırılacak; bu preview temiz paket kanıtı yerine kullanılmaz. Erişim koruması değiştirilmedi, uzak uçtan uca browser testi NOT TESTED.

Paket boyutları: web ZIP 19.113.358 byte; Linux tar.gz 36.711.541 byte; Windows portable ZIP 45.659.249 byte; Windows NSIS 35.518.227 byte. Yükleyicide engine/data için gözlenen sıkıştırılmamış toplam yaklaşık 43,4 MiB; yerel başlangıç ağ üzerinden gerçek kullanıcı indirme süresi değildir. Linux testinde ses Dummy backend idi; gerçek hoparlör testi NOT TESTED. Xvfb/Mesa V-Sync desteklemiyor uyarısı verdi; native 60 FPS garantisi çıkarılmaz.

Android build betiği gerçekten çalıştırıldı ve eksik ANDROID_HOME, JAVA_HOME, GODOT_ANDROID_KEYSTORE_RELEASE_PATH/USER/PASSWORD nedeniyle açık BLOCKED hatasıyla çıktı. APK oluşturulmadı; debug veya imzasız çıktı release diye sunulmadı.
