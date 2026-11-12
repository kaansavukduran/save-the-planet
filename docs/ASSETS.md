# Varlık envanteri

Kanonik dört karakter, kompakt takla paftası, Kurt depar ve Ömer süzülüşü **mevcut ve kullanılıyor**. Kaynaklar orijinal PNG, SHA-256 ve sürümle `assets/source/` + `assets/provenance.json` içinde. Drive'daki belgede bağlı 14 görselin hash'i hesaplandı; 14'ü de referans depodaki karşılığıyla birebir eşleşti (`source/DRIVE_ASSET_HASHES.json`). Yerel kanonik görseller açılıp incelendi. Kör eşit hücre bölme kullanılmadı.

361 bağımsız karakter karesi, ilgili alfa koşularıyla kırpılır; iki şeffaf piksel tampon ve ortak anatomik ölçek komşu kare taşmasını önler. Koşu, zıplama evreleri, son iniş pozu, takla, depar, süzülüş ve etkileşim kullanılır. Paftalardaki kullanılmayan silah pozları oyuna eklenmez. İniş aynı zıplama dizisinin son fiziksel pozudur; ayrı özel iniş paftası üretilmedi.

`frontier-parkour.png` kaynak/alpha kaydı korunur. Türetilen prop adları: forest-arch (satır 0 sütun 0), pipe-arch (1,0), log (2,1), barrier (2,2), rocks (2,3), grass-left/right (3,0/1), industrial-left/right (3,2/3). Çalışma zamanında gerekli olanlar kullanılır. Yükseltilmiş platformların çarpışma yüzeyi açık renk çizgiyle belirginleştirilir.

Çevre siluetleri, fan/kapak/kol/dişli açık-kapalı durumları, bitkisel sofra ve bakım alanı özgün Godot çizimidir. Küçük hayvan bekleme/yürüme/dinlenme görselleri basit özgün pixel şekilleridir. Daha ayrıntılı bireysel hayvan ve insan pozları, özel kapak açma/gözlem/sakin yaklaşma animasyonları **uyarlanabilir / eksik kalite işi** olarak kalır; genel etkileşim pozu bunların tamamlandığı iddiası değildir.

Ses ve müzik, `scripts/audio.gd` içinde özgün sinüs dalgalarından üretilen WAV örnekleridir; üçüncü taraf sample yoktur. Yazı tipi DejaVu Sans; lisansı `assets/fonts/LICENSE.txt` içinde. Referans deponun MPL-2.0 lisansı ve AI görsel sınırlamaları `LICENSE` ve `THIRD_PARTY_NOTICES.md` içinde korunur.
