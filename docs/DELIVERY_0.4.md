# Save the Planet 0.4.0 · geliştirme teslimi

12 Kasım 2026. Son oyun kaynağı **a2058eaa27725c572cdd80420c8abb4108c14433**. Yerel Web/Linux/Windows export anında çalışma ağacı temizdi; BUILD.json kayıtları korunur. Sonraki test/rapor commit'leri oyun kodunu değiştirmez. AIONIA v1.4 kontrol seçimi kullanıcı onaylı D-pad + aksiyon düğmeleridir.

- [Taslak PR #1](https://github.com/kaansavukduran/save-the-planet/pull/1).
- [0.4 web önizleme](https://save-the-planet-ps3p5k5sk-vegan-axolotl.vercel.app): READY, HTML/BUILD 200 ve doğru kaynak/sürüm doğrulandı. Mevcut Vercel SSO nedeniyle hesap erişimi gerekebilir. Uzak tarayıcı oynanışı NOT TESTED.
- [Web ZIP](https://drive.google.com/file/d/1-pZGlHhUqoW137970kGjteS4cHWjWpnv/view): **20.418.148 byte**. HTTP sunucusuyla aç; son release gerçek ilk görev/reload/telemetri yok 3/3 PASS.
- [Linux x86_64 tar.gz](https://drive.google.com/file/d/1iqms0C8KBipic1MjM5klmpXnA5f3Z5-9/view): **38.106.529 byte**. Temiz klasörde gerçek Godot Xvfb/Mesa penceresi ve klavye/pause/portrait resize PASS. Dummy audio, fiziksel cihaz değildir.
- [Windows portable ZIP](https://drive.google.com/file/d/1r43CGax0Cku7StlKNnHziVrO7oemgtvf/view): **47.056.164 byte**. PE x64/CRC/BUILD/SHA doğrulandı; Windows'ta çalıştırılmadı.
- [Windows NSIS kurulum](https://drive.google.com/file/d/1Pygw2DSLd6Vo43F372zEzlLfsnBAa--z/view): **36.848.217 byte**. Gerçek kurulum paketi üretildi; Windows kurulum/kaldırma, resource-branding ve Authenticode kapıları açık.
- [0.4 SHA-256 manifesti](https://drive.google.com/file/d/1Y86pcLG8A_D0zo1gj8vJVpim_nad5qFH/view).
- [Drive test raporu](https://drive.google.com/file/d/1FLUuLKznFYInarLZjx4tCcYbyG0DoEAh/view).
- [Dikey oyun görüntüsü · emülasyon](https://drive.google.com/file/d/1sBcr5Xq9sHxAJHjyBQmqCfJeOpTGjfeI/view).
- [Kaynak CI PASS](https://github.com/kaansavukduran/save-the-planet/actions/runs/43274184288): native 120+24+32/ayrı kayıt ve browser 48+20+11.

Dört yeni Drive dosyasının adları, boyutları ve distribution klasörü metadata ile yeniden doğrulandı. Connector uzak checksum döndürmedi; **uzak hash doğrulandı denmez**. Yerel arşiv/ikili/SHA-256 doğrulandı. Sürümlü dosya adlarını kullanan manifest `evidence/v0.4/results/Drive-SHA256SUMS.json`; build klasörü adları için SHA256SUMS.json da korunur. Önceki [0.3](DELIVERY_0.3.md) ve [0.2](DELIVERY_0.2.md) paketleri değiştirilmedi.

Yerel release tag **1c7a12c8f53c1839**, sunucu tag **1827e59f2d7e46cf**. Aynı PCK ikilisi oldukları iddia edilmez. Sunucu raw worktree farkı yalnız platformun değiştirdiği vercel.json; bu dosya runtime PCK'den hariçtir. Mevcut SSO gevşetilmedi.

[Gerçek PASS / FAIL / NOT TESTED raporu](VALIDATION_0.4.md): üç tam browser turu 112+112+112 PASS; 60 FPS yazılım GPU bütçesi FAIL. Fiziksel telefon/tablet/Xbox/Windows/ses/ekran okuyucu NOT TESTED. Android SDK/imza ortamı eksik; APK yok. Nihai sanat onayları ve 2–3 saat içerik hedefi açık; üretim onayı verilmiş sayılmaz.
