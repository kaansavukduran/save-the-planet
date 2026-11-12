# Vercel proje simgesi · 13 Kasım 2026

Önceki canlı production `/favicon.ico` adresinde HTTP404 dönüyordu. `/play` HTML'i yalnız Godot'un `index.icon.png` ve Apple simgesini bildiriyordu. Vercel kartında varsayılan simge görüldüğü kullanıcı görüntüsünden biliniyor; dashboard'un iç tarayıcı/önbellek algoritması doğrulanmış değil.

Mevcut `assets/icon.svg` gezegen simgesi korunur. Web export onun Godot tarafından üretilen 128×128 PNG'sini `/favicon.png` olarak kopyalar; aynı PNG byte'larını standart ICO kapsayıcısında `/favicon.ico` olarak sunar. SVG de `/favicon.svg` adresindedir. HTML üçünü açıkça bildirir; sabit adresler Vercel'de no-cache ile yeniden doğrulanır. Yeni sanat, görüntü kütüphanesi, kayıt şeması veya oynanış değişikliği yoktur. Oyun sürümü0.4.4 kalır; ayrı bir native paket/release üretilmez.

Yerel gerçek Chromium: normal oyun girişi, dört simge HTTP/MIME, PNG/ICO byte eşleşmesi, özgün SVG, üç simgenin decode edilmesi ve normal yeni oyun/kayıt kontrol edildi. Kanıt `evidence/favicon/local` altında; canlı yayın sonucu ayrıca eklenecek. Vercel oturumlu proje kartının görünümü henüz NOT TESTED; dosyaların yayımlanması dashboard önbelleğinin anında değiştiği anlamına gelmez.

İlk testte DOM içindeki bütün ikon href'lerinin statik kalması beklendi ve bir kontrol FAIL oldu. Godot çalışma anında kendi PNG linkini blob URL'ye günceller; tarayıcılar için bu beklenen davranıştır. Test crawler'ın okuduğu gerçek HTTP HTML'ini kontrol edecek şekilde düzeltildi. Engine icon id'si korundu; ICO/SVG linkleri ayrıca sabit kalır. Son yerel koşu10/10 PASS; ilk test varsayımı kanıtı saklandı.

## Canlı sonuç

Production `dpl_4aTXURdhC6ZUP2pdHcWCzkR96qjK` READY. Kaynak `c1ea89480eb5544be728be501deedcb981b18da0`. https://save-the-planet-mauve.vercel.app/favicon.ico artık HTTP200, gerçek128×128 ikon; PNG/SVG de HTTP200 ve no-cache. Gerçek Chromium normal kök girişini /play'e takip edip oyunu açtı; tüm10 kontrol PASS. Vercel oturumlu proje kartı görünümü NOT TESTED; kart kendi önbelleğini yenileyene kadar eski varsayılan görünebilir. Panel yenileme önerisi bu belirsizliği gizlemez.

İlk canlı testin APIRequestContext alt istemcisi dış ağa proxy üzerinden çıkmadığı için ECONNREFUSED verdi. Aynı görseller normal browser sayfasından same-origin fetch ile istendiğinde tamamı geçti; ürün kodu için ağ koruması değiştirilmedi. İlk ağ hatası kanıtı saklandı. Kaynak CI native campaign işi PASS, browser işi bu kayıt sırasında çalışıyor; tamamlandı diye işaretlenmez. Önceki0.4.4 CI sonuçları ve kalite kapıları geçerlidir. Bu küçük Web yayınında yeni native paket/release yoktur.
