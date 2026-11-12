# Uygulama planı · 2026-11-12

Kaynak: [tam geliştirme belgesi](https://docs.google.com/document/d/1zET837DgEs98lPp9jHPhCEplHGt82VC3yctOpXe786Y). Metin ve tüm tablolar `source/DEVELOPMENT_BRIEF_TR.txt` içinde saklandı.

Başlangıç: hedef main e415cb4da85ebd7fbce8b46abe9b67acbc976c4d, temiz çalışma ağacı. Referans 03fd1f4a400345847da7b0b471272ec75602a62a. Uygulanabilir AGENTS.md bulunmadı. Çalışma dalı `codex/godot-story`. Referans depoya yazılmaz.

1. M0: Eski HTML'nin tamamını, kanonik kaynak kayıtlarını, lisansları incele; eski uygulamayı arşivle. Kaynak erişim durumlarını kaydet.
2. M1–M2: Godot 4.6.3 Compatibility, tek fizik gövdesi, ortak hava/yetenek kaynakları, güvenli karakter değişimi, kamera, fizik platformları, yeniden atanabilir giriş ve kurtarılabilir kayıt.
3. M3: Sessiz Buluşma + Açılan Kapı, iki çözüm, dört karakterin katılması ve ziyaret edilebilir yaşam alanı. Gerçek oynanış kontrolü.
4. M4: Kaynak kirliliği, çok aşamalı arıtma, habitat, yuva koruma, sahada kanıt karşılaştırma, kıyıda bakım, bitkisel sofra ve üç aşamalı final. On ayrı bölüm, kalıcı dünya durumları ve story_complete.
5. M5: TR/EN, dokunmatik ve gamepad, menü girdi yalıtımı, animasyon, ses, erişilebilirlik ve kabul senaryoları.
6. M6: Resmî SHA ile eşleşen export şablonları; web, Linux, Windows portable/kurulum; Android imza ve araç zinciri durumuna göre release. Üretim ile platformda oynanış testini ayrı raporla.

İçerik süresi ölçülmeden 15–20 dakika veya 2–3 saat tamamlandı denmez. M3 son teslim sınırı değildir. Kapsamın açık işleri PROGRESS.md'de taşınır.

## AIONIA 0.2.0 uygulama sırası

1. 00_BAŞLA, standart ve 19 görseli incele; dosya hash'lerini, onay farklarını ve Emre eksikliğini kaydet.
2. İlk bölüme ortak native tema, hedef HUD, portreli takım, konuşmacılı diyalog, erişilebilir odak ve yumuşak kamera uygula.
3. Aynı görsel kuralları on bölüme taşı; gerçek TR/EN kampanyalarını, dokunmayı, kayıt güncellemesini ve yükleme/hata akışını test et.
4. Ölçülen performansla final sürümün temiz paketlerini ve korumalı preview'ını doğrula. Tasarım onayı, uzunluk, fiziksel cihaz ve Android açıklarını tamamlanmış saymadan devam noktasına taşı.
