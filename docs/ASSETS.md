# Varlık envanteri

Kanonik dört karakter, kompakt takla paftası, Kurt depar ve Ömer süzülüşü **mevcut ve kullanılıyor**. Kaynaklar orijinal PNG, SHA-256 ve sürümle `assets/source/` + `assets/provenance.json` içinde. Drive'daki belgede bağlı 14 görselin hash'i hesaplandı; 14'ü de referans depodaki karşılığıyla birebir eşleşti (`source/DRIVE_ASSET_HASHES.json`). Yerel kanonik görseller açılıp incelendi. Kör eşit hücre bölme kullanılmadı.

361 bağımsız karakter karesi, ilgili alfa koşularıyla kırpılır; iki şeffaf piksel tampon ve ortak anatomik ölçek komşu kare taşmasını önler. Koşu, zıplama evreleri, son iniş pozu, takla, depar, süzülüş ve etkileşim kullanılır. Paftalardaki kullanılmayan silah pozları oyuna eklenmez. İniş aynı zıplama dizisinin son fiziksel pozudur; ayrı özel iniş paftası üretilmedi.

`frontier-parkour.png` kaynak/alpha kaydı korunur. Türetilen prop adları: forest-arch (satır 0 sütun 0), pipe-arch (1,0), log (2,1), barrier (2,2), rocks (2,3), grass-left/right (3,0/1), industrial-left/right (3,2/3). Çalışma zamanında gerekli olanlar kullanılır. Yükseltilmiş platformların çarpışma yüzeyi açık renk çizgiyle belirginleştirilir.

Çevre siluetleri, fan/kapak/kol/dişli açık-kapalı durumları, bitkisel sofra ve bakım alanı özgün Godot çizimidir. Küçük hayvan bekleme/yürüme/dinlenme görselleri basit özgün pixel şekilleridir. Daha ayrıntılı bireysel hayvan ve insan pozları, özel kapak açma/gözlem/sakin yaklaşma animasyonları **uyarlanabilir / eksik kalite işi** olarak kalır; genel etkileşim pozu bunların tamamlandığı iddiası değildir.

Gri Çark finalinde büyük dönen makine, durdurulmuş çekirdek ve üç aşamalı gösterge özgün Godot çizimidir. Kapak açık/kapalı geçişi hareketli çizimle gösterilir. Kuzu’nun işaretli tohum yatağı ve Ömer’in sınırlı kaynağı kullanan hava akımları görsel karşılık bulur.

Ses ve müzik, `scripts/audio.gd` içinde özgün sinüs dalgalarından üretilen WAV örnekleridir; üçüncü taraf sample yoktur. Yazı tipi DejaVu Sans; lisansı `assets/fonts/LICENSE.txt` içinde. Referans deponun MPL-2.0 lisansı ve AI görsel sınırlamaları `LICENSE` ve `THIRD_PARTY_NOTICES.md` içinde korunur.

## AIONIA 0.2.0 kaynak incelemesi

00_BAŞLA ve standart v1.0 tamamen okundu. 19 özgün resim indirildi ve açılarak incelendi: çilek referansı, beş karakterin mevcut paftaları, Aion A/B T pozları ve turnaround, dört canonical/motion çifti. Tam hash/Drive kaydı `source/AIONIA_REFERENCES.json`; karar matrisi `ART_BIBLE.md`. Emre’nin taslak paftası mevcut, doğrulanmış oyun sprite’ı/animasyonu yok. Kaynaklar export dışında saklanır; arşivde bulunması oyunda animasyonunun uygulandığı anlamına gelmez. Yeni hazır grafik kütüphanesi eklenmedi.

Kalın DejaVu fontu aynı lisansla eklendi. Yeni native tema ve paralaks çevre siluetleri `scripts/skin.gd` / `scripts/world.gd` içindedir. Marka son logo yerine metinle sunulur. Kaynak ızgarası ve ayrıntı yoğunluğunu tüm çevreye taşıyan nihai sanat geçişi henüz tamamlanmadı.
