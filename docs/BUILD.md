# Çalıştırma, export ve paketleme

Godot **4.6.3 standard**, GDScript, Compatibility. Sürüm resmî release SHA512 listesiyle doğrulanır; `packaging/SHA512-SUMS-4.6.3.txt` değişmedi. Kaynak: https://github.com/godotengine/godot/releases/tag/4.6.3-stable .

```sh
godot --path .
python3 packaging/build_web.py
python3 -m http.server 8000 --directory build/web
python3 packaging/build_native.py
```

`setup_godot.py`, motor ve eşleşen şablonları `.ci-godot/` içine indirir. Linux x86_64 build host gerekir. XDG konumları proje `work/` altında tutulur. İnternet yalnız resmî dosyaları edinmek içindir. Çalışma zamanı haricî hizmet, hesap veya sunucu gerektirmez.

Native çıktılar `dist/SaveThePlanet-Windows-Portable.zip`, `dist/SaveThePlanet-Setup.exe`, `dist/SaveThePlanet-Linux-x86_64.tar.gz`; ek web arşivi `dist/SaveThePlanet-Web.zip`. Windows/Linux PCK ikiliye gömülür. NSIS kurulum EXE'si kullanıcı klasörüne kurar, Başlat kısayolu ve kaldırıcı oluşturur; oyun kayıtlarını silmez. NSIS yoksa kurulum üretilemediği açıkça yazılır. Windows Authenticode yapılandırılmadı.

Android yalnız release akışı: `python3 packaging/build_android.py`. Paket ID: `com.fragariainteractive.savetheplanet`, kod 2, sürüm 0.2.0. İlk Godot Android kimliği; eski depoda Android projesi/APK bulunmuyordu. Sonraki sürümlerde değiştirilmemeli. Gerekli SDK ve imza değişkenleri betiğin hata mesajında adlarıyla listelenir. Anahtar/parola repoya girmez. Hazır imza kimliği yokken yeni anahtar otomatik oluşturulmaz.

Kanonik sprite üretimi: Pillow ile `python3 packaging/derive_sprites.py`. Kaynak paftalar değiştirilmez; alfa koşuları ve anatomik hizalama kaydı kullanılır. Prop türevlerinin kaynak satır/sütunları `docs/ASSETS.md` içinde kayıtlıdır.

## Vercel

Framework Other, `python3 packaging/build_web.py`, çıktı `build/web`. Tek iş parçacığı; COOP/COEP zorlanmaz. JS, WASM, PCK ve audio worklet adları ortak içerik kimliği taşır. HTML yeniden doğrulanır. Yükleme çubuğu Godot'un gerçek byte callback'ini kullanır; hata ve yeniden deneme düğmesi vardır. PWA kapalıdır; eski kök `sw.js` kontrolü temizlenir. Web kaydı IndexedDB dosyalarına ek olarak aynı origin üzerinde eşzamanlı localStorage snapshot/son geçerli yedek tutar. Bu güncelleme iki depoyu da silmez. Tam ekran ve ses kullanıcı etkileşimine bağlıdır. Iframe kullanırken `allow="autoplay; fullscreen; gamepad"` ver ve ayrıca tam sayfa açılış bağlantısı sun. Gerçek Vegan Türkiye alanında üçüncü taraf kayıt kalıcılığı ayrıca sınanmalıdır.

## Testler

```sh
godot --headless --fixed-fps 60 --path . --script tests/campaign.gd
godot --headless --fixed-fps 60 --path . --script tests/acceptance.gd
godot --headless --path . --script tests/save_read.gd
STP_WEB_QA=1 python3 packaging/build_web.py
python3 tests/browser_campaign.py
```

QA web `build/web-qa` içine export-debug ile çıkar. `-- --qa` koşulunda sadece okunan test telemetrisi vardır. `build/web` release'tir ve bu koşulu sağlayamaz. Tarayıcı testleri Playwright + Chromium gerektirir; onlar oyun/runtime bağımlılığı değildir.

## 0.2.0 doğrulanmış çıktılar

Paket kaynak commit'i a87199ed085ae260f6a9a2dc151d74dee96c1bf1, üretim anında temiz çalışma ağacı. Gerçek release web ve temiz Linux pencere smoke testleri çalıştırıldı; Windows EXE/NSIS sadece üretim/arşiv/PE olarak doğrulandı. Android build betiği gerekli SDK/imza değişkenleri yokken BLOCKED verir. Güncel indirmeler docs/DELIVERY.md, yerel SHA manifesti docs/evidence/results/SHA256SUMS.json içinde.

Son release smoke: `python3 tests/browser_release.py`. Bu test release klasörünü yerel HTTP sunucusuyla açar; ilk hedefi gerçek girişle yapar ve kayıt reload'unu sınar. Chromium/Playwright yalnız geliştirme test aracıdır. Native pencere kanıtları Xvfb 1280×720, Mesa ve xdotool ile temiz arşivden elde edildi; gerçek donanım testinin yerine geçmez.
