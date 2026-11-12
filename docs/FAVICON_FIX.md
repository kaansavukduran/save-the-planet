# Vercel proje simgesi · 13 Kasım 2026

Önceki canlı production `/favicon.ico` adresinde HTTP404 dönüyordu. `/play` HTML'i yalnız Godot'un `index.icon.png` ve Apple simgesini bildiriyordu. Vercel kartında varsayılan simge görüldüğü kullanıcı görüntüsünden biliniyor; dashboard'un iç tarayıcı/önbellek algoritması doğrulanmış değil.

Mevcut `assets/icon.svg` gezegen simgesi korunur. Web export onun Godot tarafından üretilen 128×128 PNG'sini `/favicon.png` olarak kopyalar; aynı PNG byte'larını standart ICO kapsayıcısında `/favicon.ico` olarak sunar. SVG de `/favicon.svg` adresindedir. HTML üçünü açıkça bildirir; sabit adresler Vercel'de no-cache ile yeniden doğrulanır. Yeni sanat, görüntü kütüphanesi, kayıt şeması veya oynanış değişikliği yoktur. Oyun sürümü0.4.4 kalır; ayrı bir native paket/release üretilmez.

Yerel gerçek Chromium: normal oyun girişi, dört simge HTTP/MIME, PNG/ICO byte eşleşmesi, özgün SVG, üç simgenin decode edilmesi ve normal yeni oyun/kayıt kontrol edildi. Kanıt `evidence/favicon/local` altında; canlı yayın sonucu ayrıca eklenecek. Vercel oturumlu proje kartının görünümü henüz NOT TESTED; dosyaların yayımlanması dashboard önbelleğinin anında değiştiği anlamına gelmez.

İlk testte DOM içindeki bütün ikon href'lerinin statik kalması beklendi ve bir kontrol FAIL oldu. Godot çalışma anında kendi PNG linkini blob URL'ye günceller; tarayıcılar için bu beklenen davranıştır. Test crawler'ın okuduğu gerçek HTTP HTML'ini kontrol edecek şekilde düzeltildi. Engine icon id'si korundu; ICO/SVG linkleri ayrıca sabit kalır. Son yerel koşu10/10 PASS; ilk test varsayımı kanıtı saklandı.
