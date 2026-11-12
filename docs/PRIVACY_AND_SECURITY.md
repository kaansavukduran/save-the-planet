# Yerel veri, güvenlik ve mahremiyet · 0.3.0

Oyun kendi hesabını, reklamını, analitik servisini veya telemetri alıcısını kullanmaz. Runtime dosyaları aynı web origin'inden alınır; native paket oyun için sunucu gerektirmez. Web hostu/Vercel ve erişim koruması dosya isteklerinde IP/tarayıcı gibi erişim verilerini işleyebilir. Bu belge sağlayıcının kendi politikasının yerine geçmez.

## Veri ve kullanıcı kontrolü

İlerleme, açılan karakterler, birey durumları, ayarlar ve önceden yazılmış oyun diyalog geçmişi yerelde saklanır. İsim/e-posta/konum gibi profil alanları yoktur. Kayıt şema 2 ve mevcut web anahtarı korunur; 0.2 kayıtlarıyla ilerleme devam edebilir. Kaydın içeriği şifrelenmez ve cihazlar arasında senkronize edilmez; kullanıcı veya aynı origin'deki kod veriyi değiştirebilir. Kayıt otoriter bir sunucu kaydı değildir.

Ayarlar → Yerel veriler ve mahremiyet → Sil. İptal ilk odaklanmış eylemdir. Açık onayla sadece bu oyunun primary/.bak/.tmp kayıt içeriği ve iki localStorage snapshot'ı silinir; diğer dosya/uygulama anahtarları korunur. Otomatik odak kaydı silinen ilerlemeyi yeniden yaratmaz. Yeni yolculuk veya açık ayar değişikliği kaydetmeyi tekrar başlatır. Boş ilk ziyaret yeni ilerleme kaydı yazmaz.

Tarayıcıda `fragaria.save-the-planet.erase-marker=1` ilerleme içermeyen silme işaretidir. IndexedDB eşzamanlaması bitmeden hızlı reload olursa eski dosyanın geri gelmesini önler. Devam eden IDBFS okumalarıyla yarışmamak için web dosyaları önce sıfırlanır, sonraki güvenli açılışta işaret kontrolüyle kaldırılır. Native dosyalar doğrudan kaldırılır. Yeni açık kayıt başlarken temizlenir. Bu işaret, ilerlemenin/ayarların/geçmişin tutulduğu anlamına gelmez. Tarayıcı önbelleği, başka origin'ler ve host erişim kayıtları oyun içinden silinmez. İzin/alan kısıtı tüm silmeyi engellerse başarı mesajı verilmez.

## Güven sınırları ve hata kurtarma

Disk/web kaydı güvenilmeyen veri kabul edilir. JSON boyutu 256 KiB ile sınırlandırılır; tam sayı kimlikleri, aktif karakter, dizi/bayrak/kayıt sayıları, sonlu koordinat/ses değerleri ve diyalog sınırları doğrulanır. Uygun geçerli yedek denenir. Gelecek şema yüklemede ve kayıt sonradan değişmişse yazma sırasında korunur; okunamayan kaydın üzerine normal tercih/otomatik kayıt yazılmaz. Yeni yolculukla değiştirme açık onay ister. Yazma/backup/rename ve browser snapshot başarısızlığı görünür uyarı verir; checkpoint başarısız kaydı başarılı diye duyurmaz.

Kaydedilen metin JavaScript kodu olarak eval edilmez. Native JavaScriptBridge, istisna yakalayan ve yalnız oyuna ait anahtarları kabul eden küçük DOM depolama arayüzünü çağırır. QA yalnız debug + --qa ile salt okunur yerel test verisi sunar; release sürümünde yoktur ve ağa gönderilmez.

## Web politikası

Export HTML'i gerçek inline bootstrap için SHA-256 CSP hash'i üretir. Genel JavaScript `unsafe-eval` yok; WebAssembly için `wasm-unsafe-eval` vardır. Bağlantı/script kaynağı self, worker için gerekli blob, nesneler/form gönderimi/base URI kapalıdır. Stil için native canvas/DOM düzeninin gerektirdiği inline style açıktır; tam bir CSP/penetrasyon sertifikası iddia edilmez. Kayıt metni DOM'a HTML diye eklenmez; hata ayrıntısı textContent kullanır.

Vercel yapılandırması nosniff, kısıtlı referer ve kullanılmayan kamera/mikrofon/konum/ödeme/USB izinlerini kapatan başlıklar ekler. Gamepad/fullscreen iframe kullanımını ve mevcut SSO korumasını keyfî biçimde kaldırmaz. Yerel test sunucusunun Vercel başlıklarını sunduğu varsayılmaz; uzak başlık doğrulaması ayrıca raporlanır.

Release keystore/parolalar `.gitignore` ile dışarıda; Android imza kimliği değiştirilmez. Windows Authenticode ve fiziksel kurulum testi hâlâ açık. Ekran okuyucu, fiziksel cihaz, çok sekmeli eşzamanlı oyun ve bağımsız penetrasyon denetimi test edilmeden onaylanmış sayılmaz.

Hosting yapılandırması `vercel.json` ve `.vercel/` metadata çalışma zamanı export'una dahil edilmez. Provider'ın build sırasında kendi yapılandırmasını değiştirmesi ham BUILD değişim listesinde görünür; bu liste sessizce temiz diye işaretlenmez.
