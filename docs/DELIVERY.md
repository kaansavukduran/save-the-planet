# Save the Planet 0.4.1 · geliştirme teslimi

**Kullanıcı onayıyla yayında:** [Tarayıcıda oyna](https://save-the-planet-mauve.vercel.app) · [GitHub release](https://github.com/kaansavukduran/save-the-planet/releases/tag/v0.4.1). Ana adres giriş istemez; canlı ilk görev/kayıt testi 5/5 PASS. [Yayın kaydı](RELEASE_0.4.1.md). GitHub ikili yüklemesi 401 verdiği için release aşağıdaki doğrulanmış Drive paketlerine bağlanır.

12 Kasım 2026. Son oyun kaynağı **e43b0964bd69b9223cc8704f9615bb7aaf34bf29**. Web/Linux/Windows export sırasında yerel çalışma ağacı temizdi; BUILD kayıtları `evidence/forge/packages/` içinde. Sonraki rapor commit'leri oyun kodunu değiştirmez. Godot 4.6.3, mevcut sanat kaynakları ve onaylı D-pad + aksiyon düzeni korunur.

Geniş/uzun ekranlardaki gökyüzü boşluğu, görünür çevre sınırları, pause sırasında ekran döndürme ve tünelin aktif giriş ipucu düzeltildi. On bölüm/final/yaşam alanı ve mevcut kayıtlar korunur.

- [Taslak PR #1](https://github.com/kaansavukduran/save-the-planet/pull/1); main birleştirilmedi.
- [0.4.1 Web önizleme](https://save-the-planet-n1gwmooth-vegan-axolotl.vercel.app): READY, HTML/BUILD HTTP 200, sürüm/kaynak/CSP/header kontrolü PASS. Mevcut Vercel SSO korunur; uzak tarayıcı oynanışı NOT TESTED.
- [Web ZIP](https://drive.google.com/file/d/16e2F2Y1sfglAYAeJQB9s7c_tHFwZ9yzV/view): **20.418.877 byte**. HTTP sunucusuyla aç; son release ilk görev/kayıt reload/QA kapalı 3/3 PASS.
- [Linux x86_64 tar.gz](https://drive.google.com/file/d/1L6Ux3U2AviWxio-4KhwI13NdSr3ifm12/view): **38.107.434 byte**. Temiz arşivden gerçek Godot penceresi, klavye hareket/zıplama/pause/portre resize PASS; Xvfb/Mesa/dummy audio, fiziksel cihaz değildir.
- [Windows portable ZIP](https://drive.google.com/file/d/1BdCi7GH6wjowrBNtXA6maks5AoXN43c7/view): **47.056.816 byte**. CRC/PE x64/BUILD/SHA kontrolü PASS; Windows'ta çalıştırılmadı.
- [Windows NSIS kurulum](https://drive.google.com/file/d/1ZbsE98Y39ap0nG0f3gZT4_UAX7XnhjdU/view): **36.846.435 byte**. Kurulum paketi üretildi; Windows kurulum/güncelleme/kaldırma ve Authenticode NOT TESTED.
- [0.4.1 SHA-256 manifesti](https://drive.google.com/file/d/1Wj0gvINBfV1rnHYVYmJNDIcihJ2yBqBU/view).
- [Drive doğrulama raporu](https://drive.google.com/file/d/17BHl8A_GAYNAL_DwiGp-cGVbhf68kS1r/view).
- [Kaynak CI PASS](https://github.com/kaansavukduran/save-the-planet/actions/runs/43282344144): native kampanya/kabul/kayıt/kalite ve browser UI/ekran/mahremiyet/gamepad menü.

Beş Drive dosyasının adı, boyutu ve hedef klasörü metadata ile yeniden doğrulandı. Connector uzak checksum sağlamadı; uzak hash doğrulandı denmez. Yerel arşivlerin SHA-256 değerleri doğrulandı. [Sürümlü adlarla manifest](evidence/forge/packages/Drive-SHA256SUMS.json), [Drive metadata kayıtları](evidence/forge/packages/drive-receipts.json).

Yerel Web tag **7fdfb912df9d9577**, Vercel tag **9c0eb2add6e6b6c0**; aynı PCK ikilisi oldukları iddia edilmez. Sunucunun ham worktree farkı yalnız platformun değiştirdiği vercel.json; runtime PCK'den hariçtir. Kimlik bilgisi veya bypass token kaydedilmez.

[Gerçek PASS / FAIL / NOT TESTED raporu](VALIDATION_0.4.1.md), [devam noktası](../FORGE.md). Release yazılım GPU 60 FPS bütçesi hâlâ FAIL (33,4 ms medyan / 50 ms P95). Fiziksel telefon/tablet/Xbox/Windows/ses/ekran okuyucu ve insan playtest NOT TESTED. Android SDK/JDK/mevcut imza ortamı, nihai sanat ve 2–3 saat hedef süre açık; üretim onayı verilmiş sayılmaz.

Önceki [0.4.0](DELIVERY_0.4.md), [0.3.0](DELIVERY_0.3.md) ve [0.2.0](DELIVERY_0.2.md) paketleri korunur.
