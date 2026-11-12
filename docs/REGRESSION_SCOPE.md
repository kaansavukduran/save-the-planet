# Önceki oyun bildirimlerinin bu projeye uygulanması · 0.4.0

Kaynak tamamen okundu: https://docs.google.com/document/d/1cpr6yIwVOq2F9rQBlG1sSvFf0Wu9Iir0lJ_KDnqA5lE/edit . Bildirimler Aion Endless Run geçmişine aittir; Save the Planet'te güncel hata oldukları varsayılmaz. Referans depoda origin https://github.com/kaansavukduran/aion_endless_run.git olarak doğrulandı; kaynak belgedeki tireli URL otomatik doğru kabul edilmedi. Bu görevde referans depoya yazılmadı.

| ID | Uygulama ve gerçek durum |
|---|---|
| AER-001 Aion kare kayması | Kayıtlı alfa/pivot kaynakları korunur. Dünya konumu alt piksel, görsel poz piksele oturur. Bulut görüntüleri incelenir; fiziksel cihaz animasyon testi NOT TESTED. |
| AER-002 Ömer kayması | Mevcut agility/registered frame kaydı korunur; sınırlı süzülme fizik testi PASS. Gerçek hedef cihazda tüm kanat döngüleri NOT TESTED. |
| AER-003 dokunmatik | Save the Planet'te saldırı yerine yetenek/etkileşim vardır; yön+zıplama ve yön+yetenek Chromium emülasyonuyla test edilir. Fiziksel telefon ergonomisi NOT TESTED. |
| AER-004 aşağı kaydırarak takla | KAPSAM DIŞI: bu oyun aşağı swipe sözleşmesi kullanmaz. Kuzu yetenek düğmesi/J/X takla yapar, aşağı yön tek yönlü platformdan iner. İki işlev rastgele karıştırılmaz. |
| AER-005 taşmalar | Native modal scroll yalnız içerik sığmadığında kullanılır. Web rehberi dar portrede ve 200% metinle sınanır. Bütün oyun ekranlarının bütün cihazlarda taşmasız olduğu iddia edilmez. |
| AER-006 alt çubuk | Dokunmatik açıkken portreler yukarı alınır; ses/ayar kontrolleri odakla kaydırılır. Fiziksel notch/alt çubuk NOT TESTED; HTML canvas safe-area insets uygular. |
| AER-007 görsel bütünlük | Mevcut AIONIA paleti, keskin çerçeveler ve özgün karakterler korunur; yeni rastgele asset veya onaysız logo yok. Son sanat kapısı açık. |
| AER-008 portre/yatay performans | Ayrı portre/yatay oyun alanı, HUD/kamera ve kontrol yerleşimi uygulanır. Tam dokunmatik kampanya iki yönde çalıştırılır; bitmemiş test PASS sayılmaz. Fiziksel telefon FPS NOT TESTED. |
| AER-009 cüce yoğunluğu | KAPSAM DIŞI: bu oyunda mantar tetiklemeli cüce spawn sistemi yok. |
| AER-010 20 saniyelik endless seviye | KAPSAM DIŞI: bu ürün on bölümlük hikâye platform oyunudur. |
| AER-011 100. seviye kutlaması | KAPSAM DIŞI: endless seviye/boss ödül/XP sistemi yok; doğrulanmamış sekiz karakter/logo eklenmez. |
| AER-012 yükleme | Referansa dayalı siyah çilek/Fragaria Interactive/pixel yazı, gerçek byte ilerlemesine bağlı on segment/yüzde/sürüm, hata/yeniden deneme; bootstrap JS/WASM hatası, stall ve offline senaryoları sınanır. Firefox mobil ve offline PWA NOT TESTED; PWA kapalıdır. |
| AER-013 Xbox/gamepad | LB/RB, remap, deadzone, aktif ipucu ve güvenli disconnect eklenir. Tarayıcı Gamepad API fixture'ı sadece giriş üretir. Fiziksel Xbox/kol doğrulaması NOT TESTED; konsol yayını iddia edilmez. |

Son çalıştırılan sonuçlar VALIDATION_0.4.md'de; bu tablo eski bildirimi çözüldü saymak yerine kapsamı ve kanıt sınırını korur.

## Save the Planet v1.4 geliştirmesinde yakalanan regresyonlar

- STP-014-01: dokunmatik Yap düğmesinin yalnız polling durumunu değiştirip etkileşim işleyicisini çağırmaması. Düzeltilen doğrudan sinyal; ilk fan görevi browser_v14.py içinde gerçek dokunmayla kontrol edilir.
- STP-014-02: yürürken ikinci parmakla portre seçiminin web fare emülasyonuna bağlı kalması. Gameplay portreleri doğrudan ScreenTouch alır; tam kampanyada Kuzu tüneli ve diğer zorunlu hero görevleri sınanır.
- STP-014-03: kısa yatay ekranda devam/geri eylemlerinin kaydırılan gövdede kaybolması. Godot konteynerleriyle sabit eylem alanı; beş ekran boyutunda pause, diyalog ve ayarlar testi.
- STP-014-04: her yeniden temalamada yeni SystemFont nesnesi üretiminin font hatası oluşturması. Font nesneleri yeniden kullanılır; native 120+24+30 test loglarında font hatası aranır.
- STP-014-05: native Godot boot'un JPEG kabul etmemesi. Kaynak PNG referansı kullanılır; native statik açılış ve web ölçülebilir yükleme farkı açıkça kaydedilir.
- STP-014-06: takılma zamanlayıcısının fatal yükleme hatasını gölgelemesi ve bootstrap JS dosyası yokken hata UI'sına ulaşılamaması. Browser shell hata/26 saniye/retry senaryoları.

Test sürücüsü onarımları oyun kusuru olarak sayılmaz: CDP touchEnd kalan parmakları değil bitecek parmakları alır; senkron CDP ACK gecikmesi çift zıplamayı iki ayrı yer zıplamasına çevirebilir; hızlı çift zıplama zamanlanmış DOM TouchEvent fixture ile aynı Godot DOM giriş yolunda sınanır (güvenilir fiziksel olay/telefon testi değildir); eski sabit 0.3.0 beklentisi proje sürümünden okunur. Test sırasında üretilen web klasörü yenilenmez; aksi takdirde eski içerik hash'leri 404 oluşturur.

- STP-014-07: açık temada dokunmatik tuşlarının koyu paneli koruması; tema rengine uyan %96 opak panel, iki temada okunabilir yazı/basılı durum ve görünür geri bildirim yüzeyi.
- STP-014-08: etkileşim kutusunun ayakta duran karakteri kapatması; HUD altındaki durum alanına taşındı, portrait kamera boşluğu yeniden düzenlendi ve gerçek render konumuyla çakışmama testi eklendi.
- STP-014-09: küçük portrede ses slider'ı dokunma yüksekliği; 68 mantıksal piksel, gerçek arayüzden ses değeri değiştirme/kayıt testi. Mobil otomatik kontroller kapalı diye etiketlenmez.

Test sürücüsü hareketi, yetenekle hedef zaten tamamlandıysa rastgele bir koordinatta durmayı zorlamaz; tamamlanma hâlâ gerçek oyun işleyicisinin bayrağıdır. Gamepad yaklaşmada analog hassasiyet, dokunmada uçurumdan önce karakter seçimi kullanılır. Gerçek kayıttan devam koşusu, sıfır kayıttan koşu olarak etiketlenmez.

- STP-014-10: fan durdurulmadan bahçe kapısı denenince güvenlik adımı geri bildiriminin bağlamsal kutu tarafından saklanması. Gerçek E girdili native kabul senaryosu önce FAIL verdi; geri bildirime kısa süre öncelik verildi ve diyalog/menü açıkken süresi tüketilmez. Aynı senaryo yeniden çalıştırılır.
