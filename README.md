# Save the Planet

Fragaria Interactive / Fragaria Games / AIONIA. Hayvan hakları, veganlık ve ekolojik ilişkileri eylem ve sonuçlarla ele alan Godot 4.6.3 / GDScript platform macerası. Dört karakter, beş perde, on bölüm, ziyaret edilebilir yaşam alanı ve kayıtlı final. **0.2.0 geliştirme sürümü**; hedef oyun süresi, görsel son kalite ve tüm fiziksel platform testleri henüz tamamlanmadı.

```sh
godot --path .
```

A/D veya oklar hareket, Space zıplama, J yetenek, E etkileşim, 1–4 karakter, Q takım, Esc duraklat, Tab defter; S/aşağı platformdan inme. Takım menüsü durdurur. Tuşlar ayarlardan değişir. Gamepad ve isteğe bağlı dokunmatik kontroller vardır.

Gerçek web export: `python3 packaging/build_web.py`, ardından `python3 -m http.server 8000 --directory build/web`. Native paketleme: `python3 packaging/build_native.py`. [Build ve platform ayrıntıları](docs/BUILD.md), [uygulama planı](docs/IMPLEMENTATION_PLAN.md), [gerçek ilerleme ve devam noktası](docs/PROGRESS.md), [doğrulama](docs/VALIDATION.md), [güncel tasarım](GDD.md).

Eski Canvas uygulaması `legacy/` içinde korunur; yeni oyun gerçekten `project.godot` ve `scenes/main.tscn` üzerinden çalışır. Dağıtım çıktısı Godot WASM/PCK'dir. PWA/çevrimdışı web desteği iddia edilmez. Kayıt yerel cihaz/tarayıcıya aittir.

Kanonik görsellerin kaynakları ve dönüşümleri [assets/provenance.json](assets/provenance.json), kullanım koşulları [LICENSE](LICENSE), [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) ve [varlık envanteri](docs/ASSETS.md) içindedir. Kaynak depo: https://github.com/kaansavukduran/save-the-planet .

AIONIA standartları ve kaynak paftaları incelendi; [sanat kararları](docs/ART_BIBLE.md), [oyuncu vaadi ve döngüsü](docs/GAME_DESIGN.md), [kanon sınırları](docs/LORE_LINKS.md) kayıtlıdır. Bu sürüm onaylanmamış logo/karakter varyantlarını kesin kanon ilan etmez. Emre’nin doğrulanmış animasyon kaynağı, nihai sanat geçişi, hedef süre ve fiziksel cihaz testleri açıktır.
