# Doğrulama günlüğü

2026-11-12, Linux x86_64 bulut ortamı, Godot 4.6.3.stable.official.7d41c59c4. Chromium 156.0.8078.79, 1152×648, SwiftShader WebGL2 (yazılım GPU). Bu sonuç fiziksel telefon/oyuncu performansını temsil etmez.

- Başlangıç web uygulaması: ayarlar açıkken D basılı tutuldu; x 261.2 → 362.4. Oyun menünün arkasında ilerledi. localStorage boştu. Canvas 1120×580, görüntülenen alan 1280×673 idi.
- `tests/campaign.gd`: gerçek CharacterBody2D çarpışmaları ve giriş eylemleriyle on bölümü kat eder. Görev/kurtarma/çıkış bayrakları doğrudan enjekte edilmez. 118 kontrol geçti. Bu görüntüsüz test görsel doğrulama değildir.
- `tests/acceptance.gd`: 19 kritik kontrol geçti. Ayrı senaryo hazırlıkları karakter konumunu kurar; gerçek giriş, fizik ve etkileşim işleyicilerini sınar. Havada geçiş, depar, tünel, platform, menü, odak bırakma, tekrarlı kurtarma, kayıt kurtarma/sürüm geçişi kapsanır.
- `tests/save_read.gd`: ayrı Godot sürecinde disk kaydı yeniden okundu; oyuncu, bölüm, karakter açılışları ve tamamlanan bölümler korundu.
- Release Web: gerçek WASM/PCK Chromium'da açıldı ve klavyeyle yüründü; konsol hatası yok. İlk denemede adlandırılmamış audio worklet dosyaları 404 verdi; hash adlandırması düzeltildi.
- Gerçek Chromium kampanya testi `tests/browser_campaign.py` ile sürüyor. Bu test yalnız debug QA çıktısındaki salt okunur telemetriyi okur; klavye dışında ilerleme yazmaz. Yayın sürümünde telemetri etkin değildir.

Sonuç verileri `work/` içinde; doğrulanmış son sonuçlar teslim öncesi `docs/evidence/` altına kopyalanır.
