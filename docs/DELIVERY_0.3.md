# Save the Planet 0.3.0 · doğrulanmış geliştirme teslimi

12 Kasım2026 · Fragaria Interactive / Fragaria Games / AIONIA. Kaynak commit `fe504a17bee8ab322fb28aced2bdb1159fcb2497`. Yerel web/Linux/Windows export anında çalışma ağacı temizdi. Sonraki belge/kanıt commit'leri oynanış kodunu değiştirmez. Nihai sanat/süre ve tüm fiziksel platform onayı henüz yoktur.

- [Taslak PR #1](https://github.com/kaansavukduran/save-the-planet/pull/1): mevcut dal güncellendi; main birleştirilmedi.
- [0.3 web preview](https://save-the-planet-dknkh61u8-vegan-axolotl.vercel.app): READY, doğru source commit/0.3.0, HTML ve BUILD HTTP200, CSP meta ve güvenlik başlıkları doğrulandı. Mevcut Vercel SSO nedeniyle hesap/ekip erişimi gerekebilir. Uzak browser oynanışı NOT TESTED.
- [Web ZIP](https://drive.google.com/file/d/1icleFxO65VuV67PojucEZy3daVsYZUIF/view): 19.130.153 byte; HTTP sunucusuyla aç. Gerçek release browser'da ilk görev/reload/telemetri yok3/3 PASS.
- [Linux x86_64 tar.gz](https://drive.google.com/file/d/1dw_pFh6acJFOB6AWKbfumoh8vS8DmKLF/view): 36.725.526 byte; temiz klasörde Xvfb/Mesa gerçek Godot penceresi, klavye hareket/zıplama/pause PASS. Ses Dummy backend; fiziksel hoparlör NOT TESTED.
- [Windows portable ZIP](https://drive.google.com/file/d/1GNPl9ME4P6nWFtd9V_W3tEcZgjaRjncC/view): 45.672.871 byte; arşiv/BUILD/hash/PE x64 doğrulandı. Windows'ta çalıştırılmadı.
- [Windows NSIS kurulum](https://drive.google.com/file/d/1VRt-qV2nW-JbVGIv6sTHzHHoI5sJAy4F/view): 35.533.191 byte; gerçek kurulum üretildi. Kullanıcı klasörü, kaldırıcı ve kayıt sürekliliği akışı. Fiziksel Windows kurulum/kaldırma ve Authenticode NOT TESTED/yapılandırılmamış.
- [0.3 SHA-256 manifesti](https://drive.google.com/file/d/1KJkFj1IHix9-_DWMg83uTXXM1_j8Mb90/view): Drive'daki sürümlü dosya adlarını kullanır; yerel kopya evidence/v0.3/results/Drive-SHA256SUMS.json. Build klasörü adları için SHA256SUMS.json da korunur.
- [Drive teslim/test raporu](https://drive.google.com/file/d/1Vomy8PsvOtzBlM9L0nOL_ydtuwnyJv3w/view).
- [Gerçek Linux oynanış görüntüsü](https://drive.google.com/file/d/1-vCuXz1RgbQRbT6WPpNsHpwUGyWj5ON5/view).
- [Kaynak CI PASS](https://github.com/kaansavukduran/save-the-planet/actions/runs/43244440583): web export,120 kampanya,24 kritik, ayrı kayıt süreci ve30 kalite kontrolü.

Dört Drive paketinin boyutları/hedef klasörü metadata ile tekrar doğrulandı. Connector uzak checksum sunmadı; uzak hash doğrulandı denmez. Yerel arşiv ve SHA-256 doğrulaması yapıldı. 0.2 dosyaları/manifesti değiştirilmedi; [önceki teslim](DELIVERY_0.2.md) korunur.

Sunucu içerik kimliği770dfbac902d81c4, yerel release bf1462ad1b2965d2; aynı PCK ikilisi oldukları iddia edilmez. Sunucu raw worktree farkı yalnız platformun değiştirdiği vercel.json. Hosting config runtime export'undan çıkarıldı ve yerel PCK'de yokluğu kontrol edildi. Meta detayları evidence/v0.3/results/vercel-preview.json içinde.

Android release betiği eksik SDK/JAVA_HOME/mevcut keystore yapılandırması nedeniyle BLOCKED çıktı; APK yok. Fiziksel Xbox/telefon, ekran okuyucuyla tam oyun, insan katılımcı ve tüm hedef cihaz performansı NOT TESTED. Bulut60FPS hedefi FAIL; son örnek24FPS. [Gerçek testler](VALIDATION_0.3.md), [devam noktası](PROGRESS.md), [mahremiyet/güvenlik](PRIVACY_AND_SECURITY.md).
