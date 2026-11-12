# Save the Planet

**[Güncel oyunu aç](https://save-the-planet-mauve.vercel.app/play)** · [0.4.1 native indirmeleri](https://github.com/kaansavukduran/save-the-planet/releases/tag/v0.4.1) · [0.4.2 Web düzeltmesi](docs/HOTFIX_0.4.2.md)

Fragaria Interactive / Fragaria Games / AIONIA. Hayvan hakları, veganlık ve ekolojik neden-sonuç ilişkisini eylemlerle ele alan **Godot 4.6.3 / GDScript** platform macerası. Dört karakter, beş perde/on bölüm, ziyaret edilebilir yaşam alanı ve kayıtlı final. **0.4.1 geliştirme sürümü**; nihai sanat, hedef süre ve fiziksel platform QA henüz tamamlanmadı. Güncel devam kaydı: [FORGE.md](FORGE.md).

```sh
godot --path .
```

A/D veya oklar hareket, Space zıplama, J yetenek, E etkileşim, 1–4 karakter, Q takım, Esc duraklat, Tab defter; S/aşağı platformdan inme. Gamepad: sol çubuk/D-pad, A zıplama, X yetenek, B etkileşim/geri, Y takım, LB/RB karakter, Start pause/devam, View defter. Ayarlardan klavye/gamepad atamaları, analog eşik, ses, büyük metin, azaltılmış hareket ve dokunmatik düzen değişir. Web'de **F1 / ?** metin rehberi açar.

0.4 yenilikleri: AIONIA v1.4 doğrultusunda varsayılan koyu tema ve sistem fontu isteği; kalıcı Koyu/Açık/Sistem ve font tercihi; ayrı dikey/yatay HUD, kamera ve menüler; otomatik dokunmatik algılama, platformdan inme ve ilk kullanım öğretimi; ikinci parmakla portre seçimi; sabit menü eylemleri; gerçek indirme verisine bağlı siyah Fragaria yükleme ekranı. Native sistem fontu OS üzerinden çözülür; Godot Web tarayıcı yerel font erişimi yerine motorun okunabilir yedek fontunu kullanabilir. [Kullanıcı seçimi: D-pad + aksiyon düğmeleri](docs/CONTROL_DECISION.md).

Korunan 0.3 özellikleri: görünür kayıt hata/kurtarma akışı; bozuk/büyük/yeni sürüm kaydı için koruma; açık onaylı yerel veri silme ve hızlı reload'da eski kaydın geri dönmesini engelleme; girişe göre ipuçları, gamepad remap/hotplug; kamera hareketini azaltma; semantik web rehberi ve hash tabanlı CSP. Reklam/analitik/oyun hesabı yoktur. [Mahremiyet ve güvenlik sınırları](docs/PRIVACY_AND_SECURITY.md).

0.4.1 düzeltmeleri: ultrawide/uzun portre gökyüzü ve çevre çizimi, pause sırasında yeniden boyutlandırma, yeniden eşlemeye ve aktif girişe uyan tünel tabelası. Altı boyutta gerçek ekran regresyonu CI kapsamındadır; 60 FPS bütçesi açık kalır.

Web export: `python3 packaging/build_web.py`, ardından `python3 -m http.server 8000 --directory build/web`. Native paketleme: `python3 packaging/build_native.py`. [Build](docs/BUILD.md), [teslim/yayın durumu](docs/DELIVERY.md), [güncel ilerleme](docs/PROGRESS.md), [gerçek test raporu](docs/VALIDATION_0.4.1.md), [GDD](GDD.md).

[AIONIA güncel kaynak kaydı](docs/AIONIA_STANDARD.md), [ürün/hedef kullanıcı özeti](docs/DESIGN_BRIEF.md), [v1.4 uygulama planı](docs/PLAN_v0.4.md), [sanat kararları](docs/ART_BIBLE.md), [kanon sınırları](docs/LORE_LINKS.md). Güncel normatif belgenin gövdesi v1.4 olarak tamamen yeniden okundu; teknoloji bağımsız yaklaşım mevcut Godot oyununa uygulanır. Pixel art/karakterler bu mevcut AIONIA oyununa uygundur; başka bir teknoloji veya genel motor eklenmedi.

Eski Canvas kaynakları `legacy/` altında korunur. Yeni oyun `project.godot` / `scenes/main.tscn` üzerinden gerçek Godot'tur. PWA/çevrimdışı web sözü yoktur. Fiziksel Xbox/telefon/Windows, ekran okuyucuyla tam oyun ve insan katılımcı testleri yapılmadı; evrensel erişilebilirlik veya WCAG 2.2 AA sertifikası iddia edilmez. Android release SDK/keystore ortamı eksiktir. Emre'nin doğrulanmış sprite'ı ve final logo/varyant onayları hâlâ açıktır; yeni tasarım uydurulmadı.

Kaynak/lisans: [provenance](assets/provenance.json), [LICENSE](LICENSE), [üçüncü taraf bildirimleri](THIRD_PARTY_NOTICES.md), [varlık envanteri](docs/ASSETS.md). Önceki [0.3](docs/DELIVERY_0.3.md) ve [0.2](docs/DELIVERY_0.2.md) teslimleri korunur; 0.4 diye sunulmaz.
