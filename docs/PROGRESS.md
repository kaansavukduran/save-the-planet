# Gerçek ilerleme · 2026-11-12 · 0.2.0

**Oynanabilir geliştirme sürümü.** Godot 4.6.3 üzerinde dört karakter, beş perde/on bölüm ve gezilebilir final uygulandı. İlk kesitte durulmadı. Tam yayın kalitesi, hedef oyun süresi ve bütün AIONIA kapıları tamamlandı denmez.

| Aşama | Gerçek durum | Kanıt / açık |
|---|---|---|
| M0 kaynaklar | İncelendi | Temiz e415cb4 başlangıcı; referans 03fd1f4, legacy korunur. Brief tablolarıyla tam okundu. AIONIA 00_BAŞLA/v1.0 ve 19 pafta incelendi. |
| M1 Godot temel | Uygulandı, derlendi, açıldı | Resmî 4.6.3/SHA512; tek gövde/kamera, giriş, atomik kayıt + web snapshot. |
| M2 dört karakter | Uygulandı, senaryolar geçti | 361 kayıtlı kare; sonlu hava kaynakları, hız sınırı, güvenli tünel geçişi. Yeni varyantlar kesin kanon seçilmedi. |
| M3 ilk iki bölüm | Gerçek oynanışla doğrulandı | Duru ve dört arkadaş, iki rota, yaşam alanı. İlk bölüm son arayüzle yeniden 15/15 kontrol. 15–20 dakika hedefi karşılanmadı. |
| M4 diğer sekiz + final | Uygulandı, senaryolar tamamlandı | 120 headless kontrol; TR/EN gerçek Chromium kampanyaları 112'şer kontrol, hata yok; final/reload/devam. |
| M5 kullanılabilirlik/AIONIA | İyileştirildi, kısmen doğrulandı | Native tema/HUD/portre/diyalog/yükleme/hata, kamera/animasyon zamanlaması. 24 kritik +12 erişilebilirlik +7 shell kontrolü PASS. Son sanat/cihaz performansı açık. |
| M6 paket/yayın | Son sürüm hazırlanıyor | 0.2 kodu sabitlenince Linux/Windows/web paketleri yeniden üretilecek. Android release SDK/imza yapılandırması yok; APK yok. |

## Devam eden açık işler

- Kompakt bölümlerin anlamlı keşif/parkur/bakım etkileşimleriyle genişlemesi: 8–12 dakika/bölüm ve 2–3 saat toplam hedefi **karşılanmadı**. Süreyi boş bekleme veya metinle şişirme.
- Dört karakterin özel gözlem, sakin yaklaşma, bakım/kapak pozları ve daha ayrıntılı bireysel hayvan/insan sanatı eksik. Genel etkileşim pozu tam özel animasyon diye sunulmaz.
- Emre'nin TASLAK 01 model paftası incelendi; doğrulanmış sprite/animasyon kaynağı yok. Kimlik/logoyu yeniden uydurma. 00_BAŞLA son logo ve varyant onaylarını açık bırakıyor; yalnız bu onaya bağlı tasarım kararları bekler, bağımsız işler sürdürülebilir.
- Son çevre/sprite ayrıntı yoğunluğu ve doğal piksel ölçeği sanat geçişi, daha ayrıntılı Gri Çark final yönetimi açıktır. Rastgele hazır grafik eklenmedi.
- Yazılım GPU'da 60 FPS hedefi FAIL: izole Chromium/Godot ölçümü 25 FPS. Fiziksel GPU/telefon performansı ve toplam bellek NOT TESTED. Ölçümleri docs/VALIDATION.md'de ortamıyla raporla.
- Android ANDROID_HOME/JAVA_HOME + mevcut release keystore yapılandırması eksik. Yeni imza kimliği yaratılmadı. Windows kurulum/oynanış, fiziksel gamepad/telefon ve Android arka plan/ses dönüşü NOT TESTED.
- İnsan katılımcılı ilk dakika anlama, keyif, sessiz kullanım ve eğitim etkisi testleri NOT TESTED. Ayrı ustalık/başarı kayıt sistemi henüz yok.
- PWA kapalı; çevrimdışı web iddiası yok. Bazı önceki headless kapanışlarında audio cleanup uyarısı görüldü; son acceptance'da tekrarlanmadı, bütün yollar için çözüldü denmez.

## Somut devam noktası

Önce test edilmiş 0.2 kaynak commit'inden web/Linux/Windows portable/NSIS üret; Linux'u temiz klasörden gerçek pencereyle aç, paket hash/metadata kayıtlarını yenile. Vercel preview HTTP/BUILD kimliğini doğrula, Drive'a yalnız son çıktıları koy ve incelemeye hazır draft PR aç. Ardından bu dosyadaki açık süre/sanat/cihaz işlerini sırayla kapat. Test edilmemiş platformları PASS sayma. Sonuçlar docs/VALIDATION.md ve evidence/results içinde. Arka planda kendiliğinden devam sözü verilmez.
