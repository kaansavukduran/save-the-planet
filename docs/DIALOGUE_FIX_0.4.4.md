# 0.4.4 · okunabilir konuşma ve kesintisiz müzik

13 Kasım 2026. Kullanıcının görüntüsündeki “Kurt” başlığı dikine yazılıyor, gövde metni kaydırma alanının altında kalıyor ve konuşmada müzik susuyordu.

## Doğrulanan neden

Önceki gerçek UI'da Kurt etiketine **1 px** genişlik ayrılıyordu; etiket **5 satır / 192 px** yüksekliğe çıkıp metin alanını dolduruyordu. Aynı anda müzik düğümü dünyanın PAUSABLE sürecini miras alıyordu: `can_process=false`, `stream_paused=true`. Dünya dururken ses de duruyordu.

## Uygulanan değişiklik

- Konuşmacı portresi, genişleyen isim ve gerçek çoklu-sayfa sayacı kaydırma alanının dışında sabit başlıkta durur. Devam/Geç eylemleri sabit alttadır; yalnız konuşma metni gerektiğinde kayar.
- Gövde metninin sağında 12 mantıksal piksel gutter ayrılır. Kısa konuşmada scrollbar gerekmez; uzun/büyük metinde çubuk yazıyı veya eylemleri kapatmaz.
- English Wolf/Lamb/Owl adları da doğru portreyi seçer. Devam sayfaları konuşmacıyı korur; sayfa sayısı gerçek bölünmüş metne dayanır. Metin kelimelerinin kaybolmadığı doğrulanır.
- Ses dünyadan bağımsız işlenir. Konuşmada müzik durmadan 220 ms içinde kullanıcının seçtiği seviyenin %65'ine iner, kapanınca aynı sürede seçilen seviyeye döner. Kayıtlı ses tercihi değiştirilmez; sessiz tercih açılmaz. Kısa etkileşim efektleri de dünya durdu diye beklemez.
- Dünya, tehlike, hareket ve kaynaklar okurken duraklatılmaya devam eder. Kayıt şeması, karakter kaynakları ve önceki sprite hizası korunur.

## Gerçek testler

- **181/181 native diyalog/ses kontrolü PASS:** TR/EN, 2048×1024, 844×390, 390×844, 320×568; normal/büyük metin; yatay Kurt/Wolf adı, metin alanı/gutter/taşma, devam sayfalarında bütün kelimeler, sabit eylemler, ses kazancı ve mute koruması. 42 px font fixture'ı gerçekten kaydırma gerektirir; uygulamada yeni bir 42 px ayar sunulduğu iddia edilmez.
- **29/29 gerçek browser kontrolü PASS:** normal yeni oyun/görev akışı, iki dil, ekran döndürme, gerçek dokunmatik konuşma ve Devam, müzik/mute/progress reload. CI tarihsel baseline paketi olmadan 28 pozitif kontrolü çalıştırır.
- Gerçek 0.4.3 release'te konuşma PCM tepe değeri **0**, dünya devam ederken **0,0220** ölçüldü. Yeni konuşmalarda **0,0131–0,0149** RMS tepe örnekleri ölçüldü. WebAudio analyser pass-through olarak gerçek çıkışı gözler; oyun ilerlemesi veya kaynaklar enjekte edilmez. Bu, fiziksel hoparlör/kulaklık testi değildir.
- Kurt'la gerçek hareket/E etkileşimi TR/EN Godot X11/Mesa penceresinde açılıp görüntülendi. Pencere 2048×1024, iç Godot viewport 1080×540'tır; `visual/tr-wolf.png` ve `en-wolf.png` iç viewport görüntüleridir. Bölüm başlangıcı test fixture'ında ikinci bölüme ayarlanır, etkileşim normal handler'dır.
- Native kampanya120, kabul24, kalite38, sprite56 ve ayrı süreç kayıt açma PASS. Önceki karakter hizası regresyonu korunur.

Kanıt `evidence/dialogue-fix/` altında. Fiziksel cihaz, duyulan ses, ekran okuyucu ve önceki performans/sanat/hedef süre kapıları açık kalır. Çalıştırılmamış paket/test tamamlanmış sayılmaz.

## Canlı yayın · 13 Kasım 2026

Production READY, kaynak `808f1633dadf7868bc471cceb1b31231552effa0`. [Oyna](https://save-the-planet-mauve.vercel.app/play?v=0.4.4). Canlı normal yeni oyun/görev etkileşimi **5/5 PASS**, dokunmatik portre/görev/döndürme/reload **4/4 PASS**. Gerçek ilk konuşmada RMS tepe0,01446, görev konuşmasında0,01472; efektin bitmesinden sonra müzik sürer. JS hatası0; shipping QA köprüsü yok. Canlı Kurt konuşmasına ilerleme enjekte edilmedi; Kurt/Wolf doğrulaması yukarıdaki gerçek native etkileşim ve debug browser layout testleridir.

[Kaynak CI](https://github.com/kaansavukduran/save-the-planet/actions/runs/43315063362) campaign/browser işleri PASS. Yeni Web/Linux/Windows paket kontrolü8/8 PASS; temiz Linux arşivi gerçek X11/Mesa penceresinde test edildi (Dummy audio; fiziksel ses testi değildir). Drive beş dosyada ad/boyut/klasör metadata PASS, yerel SHA doğrulandı; uzak checksum alınmadı. [Paketler](DELIVERY.md).

Canlı BUILD source aynı, content_tag02e6c55d5c97b401. Vercel yalnız vercel.json'u değiştirmiş olarak raporlar; dirty=true gizlenmez. Yerel temiz üç export metadata'sı kanıtta; PCK byte eşitliği iddia edilmez. Yayın/yerel test ve üretim kayıtları evidence/dialogue-fix altında korunur. Önceki performans FAIL ve fiziksel cihaz/ses/Windows/insan erişilebilirliği NOT TESTED durumları değişmez.
