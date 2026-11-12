# Save the Planet 0.4.4 · okunabilir konuşma ve kesintisiz müzik

13 Kasım 2026. Oyna: https://save-the-planet-mauve.vercel.app/play?v=0.4.4

Kurt/Wolf adı yatay, portre ve devam eylemleri sabit; uzun konuşmalar ayrı gövdede kayar. Müzik konuşma sırasında durmaz, kullanıcının seviyesinin %65'ine yumuşakça iner, çıkışta eski seviyesine döner. Sessiz tercih ve ilerleme korunur. Önceki sprite hizası ve eski ziyaretçi önbellek düzeltmeleri korunur.

Gerçek testler: native diyalog/ses181, browser29 (CI tarihsel paket olmadan28), native kampanya120/kabul24/kalite38/sprite56 ve ayrı kayıt PASS. Canlı yayın5 ve telefon boyutunda gerçek dokunmatik4 PASS; ilk ve görev konuşmalarında gerçek WebAudio PCM sürer. Fiziksel hoparlör/telefon/Xbox/Windows çalıştırma NOT TESTED. [Kaynak CI iki işte PASS](https://github.com/kaansavukduran/save-the-planet/actions/runs/43315063362).

Yeni paketler:

- Web ZIP: https://drive.google.com/file/d/1zPYufZ_zAHt0bMQ4x6zvHOR-yagNuTM_/view
- Linux x86_64: https://drive.google.com/file/d/1ANtELqbxY3l07g1njpSOz-wXWOu42cMB/view
- Windows portable x64: https://drive.google.com/file/d/1iHG_gOZZnT8kl9n6rgYCpzOTReV9IT8R/view
- Windows Setup: https://drive.google.com/file/d/1ymTI6DId11YUa6Fu17pMsIPULHdmRdFh/view
- SHA-256: https://drive.google.com/file/d/1EEWFtmv8XpEXf1GwesKd1C2OspwlQuGy/view

Kaynak: 808f1633dadf7868bc471cceb1b31231552effa0. Temiz yerel kaynaktan Web/Linux/Windows portable+Setup üretildi. Sürüm/kaynak/CRC/ELF/PE/SHA kontrolü8/8 PASS; temiz Linux arşivi gerçek X11/Mesa penceresinde açılıp hareket/zıplama/pause/resize test edildi. Windows çalıştırma/kurulum/kaldırma NOT TESTED.

Drive dosyalarının adı/boyutu/proje klasörü metadata ile doğrulandı. Yerel SHA256 doğrulandı; connector uzak checksum dönmediği için uzak hash doğrulandı denmez. Paketler GitHub asset'i olarak değil Drive bağlantılarıyla sunulur. Önceki release/paketler korunur. Windows Setup'a çift tıkla veya portable ZIP'i açıp SaveThePlanet.exe çalıştır. Linux arşivini açıp SaveThePlanet.x86_64 çalıştır. Web ZIP bir HTTP sunucusunda çalıştırılır.

Production READY: dpl_7n3CQZGxJffs2tvg3XpVzPeERZy7. Canlı BUILD content_tag02e6c55d5c97b401; Vercel'in yalnız vercel.json değişikliği metadata'da dirty=true görünür. Yerel üç export dirty=false; canlı ve yerel paketin byte'ları aynı diye iddia edilmez.

[Detaylı testler](DIALOGUE_FIX_0.4.4.md), [devam noktası](../FORGE.md), [önceki 0.4.3](DELIVERY_0.4.3.md). Android/imza, nihai sanat/hedef süre, fiziksel platform ve önceki 60 FPS kapıları açık kalır. Geliştirme ön sürümüdür; sonraki rapor commit'leri oyun kodunu değiştirmez.
