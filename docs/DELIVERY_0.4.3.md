# Save the Planet 0.4.3 · karakter kayması düzeltmesi

Oyna: https://save-the-planet-mauve.vercel.app/play?v=0.4.3

Göz kırpma ve animasyon sırasında aşağı/yanlara kayan karakterlerin ayak/gövde hizası düzeltildi. Sprite düğümü fizik kökünde kalır, yön değişimi aynı pivotta yapılır. Özgün kaynak ve türetilmiş PNG dosyaları değiştirilmedi. Kayıt şeması, fizik, hızlar ve kontroller korunur.

Gerçek testler: Sprite2D/alpha 56 kontrol ve 1.248 kare-yön-ölçek birleşimi; tarayıcı animasyonu/oynanış 19; native kampanya120/kabul24/kalite38 ve ayrı kayıt PASS. Canlı ilk görev/kayıt5, telefon boyutunda dokunmatik4, eski/yeni release pikselleri3 PASS. Eski Aion/Baykuş'taki aşağı taşma canlı yeni sürümde görülmedi. CI iki işte PASS: https://github.com/kaansavukduran/save-the-planet/actions/runs/43302513627

Yeni paketler, ad/boyut/klasör metadata ile doğrulanan Drive indirmeleri:
- Web ZIP: https://drive.google.com/file/d/1ikQH_YvAIrCdkWAuGgitYyMkG45t23PN/view
- Linux x86_64: https://drive.google.com/file/d/1qWPf4PzbylaON-GvPVXX_4USk4DsGK-J/view
- Windows portable x64: https://drive.google.com/file/d/1H-J_Glg7xYDaS1AGkG26U8l66XF1sjRq/view
- Windows Setup: https://drive.google.com/file/d/11EY5eHS0JB3sfbTiKJ-GsDGe2kKXeV76/view
- SHA-256: https://drive.google.com/file/d/1Woxi84xOdGiUSQ68kXpV4tDNqmwR4xhz/view

Kaynak: 00e1c954b5b9d847d2dd16da690f464a3bf4bfec. Paket bütünlüğü/source8 ve temiz Linux pencere PASS. Windows çalıştırma ve fiziksel telefon/Xbox NOT TESTED. Android/imza, nihai sanat, hedef süre ve 60 FPS kapıları açık. Geliştirme ön sürümüdür; önceki release'ler korunur. Paketler GitHub asset'i olarak değil Drive bağlantılarıyla sunulur.

## Paketi açma ve doğrulama sınırı

Windows Setup dosyasına çift tıkla; portable ZIP'i açıp SaveThePlanet.exe çalıştır. Linux arşivini açıp SaveThePlanet.x86_64 çalıştır. Web ZIP için HTTP sunucusu kullan veya canlı oyun bağlantısını aç.

Yerel export sırasında çalışma ağacı temizdi; BUILD kayıtları ve yerel SHA256 doğrulandı. Dört paket ve manifestin Drive adı/boyutu/proje klasörü metadata ile kontrol edildi. Uzak checksum connector'dan dönmedi; uzak hash doğrulandı denmez. Gerçek kayıtlar evidence/sprite-fix/packages altında.

[Ayrıntılı testler](SPRITE_FIX_0.4.3.md), [devam noktası](../FORGE.md). Önceki [0.4.1](DELIVERY_0.4.1.md), [0.4.2 Web](HOTFIX_0.4.2.md), [0.4.0](DELIVERY_0.4.md), [0.3.0](DELIVERY_0.3.md) ve [0.2.0](DELIVERY_0.2.md) korunur. Sonraki rapor commit'leri oyun kodunu değiştirmez.
