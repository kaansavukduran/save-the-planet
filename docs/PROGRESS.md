# Gerçek ilerleme · 2026-11-12

Durum: Godot 0.1.0 geliştirme sürümü. M3'te durulmadı; beş perde / on bölüm ve etkileşimli epilog uygulandı. Yayın kalitesinin ve hedef sürenin tamamlandığı iddia edilmez.

| Aşama | Durum | Kanıt / kalan |
|---|---|---|
| M0 inceleme | Uygulandı | Temiz e415cb4 başlangıcı; kaynak 03fd1f4. Eski uygulama legacy/ içinde korunur. Menüde hareket hatası gerçek Chromium'da ölçüldü. |
| M1 Godot temel | Uygulandı, derlendi, açıldı | 4.6.3 + resmî SHA512 şablonları; tek gövde, kamera, giriş, kayıt. |
| M2 dört karakter | Uygulandı, kritik senaryolar geçti | Paylaşılan hava kaynakları; depar hız sınırı; tünelde büyük gövdeyi reddetme; 361 kayıtlı animasyon karesi. |
| M3 ilk iki bölüm | Senaryolar tamamlandı | Headless fizik ve gerçek Chromium klavye ile iki bölüm + yaşam alanı. Süre 15–20 dakika hedefi henüz karşılanmış sayılmaz. |
| M4 kalan sekiz + final | Uygulandı; headless kampanya geçti | 118 kontrol, 10 zorunlu hedef kümesi ve çıkış, story_complete, dört birey durumu. Gerçek tarayıcı tüm kampanya testi sürüyor. |
| M5 bütünlük | Kısmen doğrulandı | 19 kritik kabul kontrolü geçti. TR/EN, büyük metin, dokunmatik, fiziksel gamepad, düşük efekt ve tam görsel kapsam doğrulaması açık. |
| M6 paketler / yayın | Hazırlanıyor | Gerçek web export açıldı. Linux/Windows portable ve NSIS kurulum betikleri hazır. Android SDK + özel release imza ayarları yok; APK üretilmedi. |

## Bilinen sınırlar

- Her bölüm şimdilik kısa, kompakt oynanışa sahiptir. 8–12 dakika/bölüm ve 2–3 saat toplam hedefi doğrulanmadı; bu hedeflere ulaşıldığı söylenmez.
- Ana karakter animasyonları kanonik kaynaklardan; küçük hayvanlar ve insan destekçiler basit özgün pixel çizimdir. Özel gözlem/kapak açma/bakım için daha ayrıntılı pozlar hâlâ sanat iyileştirmesi gerektirir.
- Gri Çark finali üç aşamalı görev ve tehlike dizisidir; tek büyük, ayrıntılı animasyonlu boss görseli yoktur.
- İsteğe bağlı ustalık için üst rotalar vardır; ayrı başarı/ustalık kayıt sistemi henüz yoktur.
- PWA/çevrimdışı web sözü verilmez; bu sürüm PWA değildir. Native paketler yerel kaynak içerir.
- Android release anahtarı yaratılmadı/değiştirilmedi. Fiziksel Android ve Windows testleri yapılmadı.
- İnsan katılımcılı oynanış/eğitim etkisi testi yapılmadı.

## Devam noktası

Gerçek Chromium kampanya sonucunu docs/VALIDATION.md'ye aktar; yeni hata varsa düzelt. Dokunmatik, odak, TR/EN, büyük metin ve kayıttan devamı gerçek tarayıcıda sına. Linux/Windows paketlerini üret ve Linux paketini temiz klasörden aç. Vercel hedefini doğrula, test edilmiş dalı preview olarak yayımla. Ardından süre, sanat ve fiziksel cihaz açıklarını kapat. Tam sonuçları bu dosyada güncelle; arka planda kendiliğinden devam sözü verme.
