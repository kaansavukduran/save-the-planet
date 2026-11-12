# Save the Planet 0.2.0 · teslim kaydı

12 Kasım 2026. Fragaria Interactive / Fragaria Games / AIONIA. **Oynanabilir geliştirme sürümü; nihai yayın onayı değil.** Dört karakterli beş perde/on bölüm, hayvanların ayrı sonuçları ve gezilebilir final uygulanıp gerçek TR/EN tarayıcıda oynandı. Kaynak commit `a87199ed085ae260f6a9a2dc151d74dee96c1bf1`.

- [Taslak PR #1](https://github.com/kaansavukduran/save-the-planet/pull/1): inceleme için açıldı; main birleştirilmedi.
- [Gerçek Linux oynanış görüntüsü](https://drive.google.com/file/d/1TJGx24qkW576S3_0ByR_LVPyfBGkt7dk/view).
- [Korumalı web preview](https://save-the-planet-ktkxh1rc2-vegan-axolotl.vercel.app): Vercel hesabı/ekip erişimi gerekebilir. READY, HTML/BUILD HTTP 200 doğrulandı; uzak tarayıcı oynanışı test edilmedi.
- [Windows taşınabilir ZIP](https://drive.google.com/file/d/1FwDq5qIEHvnHAwVmeDEmO9G91cZCSCeE/view): üretildi, ZIP/hash/PE64 doğrulandı; Windows'ta çalıştırılmadı.
- [Windows kurulum EXE](https://drive.google.com/file/d/17UirbSPU1zAY-EthNt676tTFYQdgmqzd/view): gerçek NSIS; kullanıcı klasörüne kurulum, kayıtları koruyan kaldırıcı. Kurulum/kaldırma fiziksel Windows'ta test edilmedi, Authenticode yok.
- [Linux x86_64 tar.gz](https://drive.google.com/file/d/1CL0EqtuTN4taKAfoOoUiy1qdlgoh-s1j/view): temiz klasörde gerçek Xvfb/Mesa penceresiyle açıldı; hareket/zıplama/pause gözlendi. Fiziksel ses testi yok.
- [Web ZIP](https://drive.google.com/file/d/16joC4OLqJpx_0-mjgykN5fYyouT9uFbw/view): gerçek Godot WASM/PCK; HTTP sunucusuyla aç. Release smoke 3/3, kayıt reload PASS; dosyaya çift tıklayarak file:// açılışı desteklenmez.
- [SHA-256 manifesti](https://drive.google.com/file/d/190cLnCEm-AJJzTgu7YdTQofI-KbdLWGV/view): önceki 0.1 manifesti aynı dosya ID'sinde 0.2 ile güncellendi. Yerel kopyası evidence/results/SHA256SUMS.json.
- [Drive teslim/test raporu](https://drive.google.com/file/d/1PA6FovS5dOjtxbnGZYpwAtfgAAWZ0NRl/view).
- [GitHub CI PASS](https://github.com/kaansavukduran/save-the-planet/actions/runs/43228077335).

Drive'da dört paketin boyutu ve dağıtım klasörüne ait oluşu yeniden okundu; connector uzak checksum alanını sunmadığı için uzak hash doğrulaması iddia edilmez. Paketlerin BUILD.json kaynak/target bilgisi ve yerel SHA-256 kayıtları incelendi. Sunucu preview içerik kimliği yerel export'tan farklıdır; aynı ikili dosya oldukları iddia edilmez.

## Açık kapsam

[VALIDATION.md](VALIDATION.md) bütün 24 kabul senaryosunu PASS / FAIL / NOT TESTED olarak açıklar. [PROGRESS.md](PROGRESS.md) devam noktasını korur. Son sanat/özel animasyonlar, hedef süre ve fiziksel cihaz QA tamamlanmadı. Emre'nin taslak paftası incelendi, doğrulanmış sprite/animasyonu yok; final logo veya onaysız varyant uydurulmadı. Android release SDK/keystore ortamı eksik, APK üretilmedi. İzole yazılım GPU'da 25 FPS ölçüldü; 60 FPS kapısı o ortamda FAIL.
