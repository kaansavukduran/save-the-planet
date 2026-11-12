# AIONIA · güncel normatif kaynak kaydı

Kaynak: https://docs.google.com/document/d/16jj2cwbm8SiVWqDy3N3dzqxTlLoK7JR2_aH6hl4noWY/edit

12.11.2026: belgenin tamamı yeniden okundu; başlık metadatası v1.0, gövdesi **v1.4**. Tam güncel metin [v1.4 snapshot](source/AIONIA_v1.4_2026-11-12.txt) içinde; aşağıdaki v1.2 metni önceki uygulamanın tarihsel kaydıdır. Çelişkide v1.4 ve kullanıcının güncel talimatı geçerlidir. Kontrol seçimi [karar kaydında](CONTROL_DECISION.md) izlenir. Tüm kalite kapılarının geçtiği iddiası değildir.


AIONIA — EVRENSEL DİJİTAL ÜRÜN, TASARIM VE KALİTE STANDARTLARI
Sürüm 1.2 | 12 Kasım 2026 | Statü: Kullanıcı kuruluş kararlarına dayalı normatif referans
Üst marka: Fragaria Interactive | Oyun yayın markası: Fragaria Games | Kurgu evreni: AIONIA

0. KULLANIM KURALI
“AIONIA standartlarında oyun geliştir” dendiğinde bu belgeyi proje şartnamesi kabul et. Kullanıcının son açık talimatları bu belgeden üstündür. Mevcut projeyi, kaynakları ve referans görselleri önce incele. AIONIA oyun motoru üretme veya Godot'u yeniden yazma görevi YOKTUR. Mevcut Godot projesini ve uygun hazır özelliklerini kullan. Belgeye erişilemiyorsa erişmiş gibi davranma; kullanıcıdan bağlantı veya belgeyi iste. Kanon ve varlıklar için doğrulanmış kaynak dışında içerik uydurup kesinleşmiş kabul etme.

1. EVREN KİMLİĞİ
AIONIA, Fragaria Interactive çatısında özgün, çok dünyalı, genişlemeye açık bir kurgu evrenidir. Aion bir karakter olabilir; evrenin adı AIONIA'dır. AIONIA yalnızca bir oyun veya tek bir gezegen değildir. Atmosfer: sevimli, derin ve epik. Ne yalnızca çocukça şekerleme estetiği ne de sürekli kasvetli karanlık. Merak, keşif, sıcaklık, karakter duygusu, eski uygarlıklar ve büyük ölçekli gizem birlikte yaşayabilir. Her oyunun ekoloji veya veganlık temalı olması şart değildir. Oyunların tonu ve yaş hedefi proje bazında tanımlanır.

2. KANON VE DÜNYA İNŞASI
Kanon katmanları: ANA (kesin evren gerçekleri), YEREL (dünya/bölge), OYUN (oyun olayları), ALTERNATİF (ayrı süreklilik), TASLAK (onaysız). Yeni karakter, şehir, tarih veya tür eklerken mevcut kayıtlarla çelişki denetimi yap. Bilinmeyen bilgi = boşluk, otomatik icat edilecek gerçek değil. Önerilen lore'u “TASLAK” olarak işaretle. Karakter kimliği, türü, görünüşü, kişiliği, motivasyonu, ilişkileri, kökeni ve animasyon kaynakları kaydedilir. Dünya kayıtlarında coğrafya, ekosistem, kültür, tarih, teknoloji/büyü kuralları ve oyun bağlantıları bulunur. Yeni içerik mevcut kimliği koruyarak evreni genişletir.

3. GÖRSEL SANAT YÖNETİMİ
Öncelikli sanat dili: elle tasarlanmış hissi veren, okunaklı, ayrıntısı kontrollü 2D pixel art. Stil hedefi “cute + profound + epic”. Keskin piksel kenarları; tutarlı piksel ızgarası, oran, ışık yönü, gölgelendirme, renk ilişkisi ve görsel hiyerarşi. Bulanık büyütme, rastgele farklı piksel yoğunlukları, tutarsız karakter ölçekleri, aşırı efekt ve birbirinden kopuk hazır asset kolajı yasak. Yapay zekâ üretimi grafikler de aynı sanat denetiminden geçer. Palet, iç çözünürlük, tile boyutu, kamera ölçeği, referans siluet ve animasyon FPS değerleri her oyun için ART_BIBLE'da kararlaştırılır; evren genelinde keyfî tek sayı dayatılmaz. Pixel-perfect görünüm hedeflenir; ekran boyutları ve erişilebilirlik ayrıca test edilir.

4. KARAKTER VE SPRITE SHEET STANDARDI
Önce Drive ve repo içindeki onaylı Aion, kurt, kuzu, baykuş ve diğer mevcut karakter paftalarını incele; bulunmayan varlığı varmış gibi gösterme. Kaynak karakterlerin özgün kimliğini, renklerini, oranlarını ve ayırt edici özelliklerini koru. Sprite sheet: kare/hücre ölçüsü, kare sayısı, animasyon adı, yön, pivot, hitbox, frame süresi, döngü bilgisi ve kaynak dosya tanımlansın. Gereken eylemler oyuna göre idle, walk, run, jump, fall, land, hurt, interact, attack vb. olabilir; eksik animasyonu sahte tekrarlarla tamamlanmış gösterme. Animasyon geçişleri, çarpışma, hizalama ve kamera ölçeği oyun içinde test edilir. Lisans/kaynak bilgisi korunur. Başka projeden izinsiz asset devşirilmez.

5. OYNANIŞ VE UX STANDARDI
Her oyun için önce tek cümlelik oyuncu vaadi, ana oyun döngüsü, kazanma/kaybetme koşulları ve 3 ayırt edici mekanik yaz. İlk oynanabilir dakikada hedef ve kontroller anlaşılmalı. Hareket hissi, geri bildirim, adil zorluk eğrisi, tutarlı kamera, okunabilir HUD, menüler, duraklatma, yeniden başlatma, ses ayarı, klavye ve gerekiyorsa dokunmatik kontrol özenle tasarlanır. Menü ve yükleme ekranı jenerik motor demosu gibi bırakılmaz; Fragaria/AIONIA kimliğine uygun özel tasarım yapılır. Hareket azaltma, ses kapatma, okunabilir kontrast ve alternatif girişler uygun kapsamda değerlendirilir. Görsel gösteriş oynanışı engellemez.

6. TEKNİK VE PERFORMANS
Godot tabanlı mevcut proje tercih edilir; bağımsız Aionia Engine inşa edilmeyecek. GDScript/C# seçimi mevcut kod tabanına göre yapılır. Kod küçük, anlaşılır, modüler ve belgeli olmalı; tek kullanımlık oyun için gereksiz soyutlama yapılmaz. Web hedefinde HTML5 export, yükleme, tarayıcı uyumluluğu, giriş, ses başlatma, asset boyutu ve mobil ekran sınırları test edilir. Windows çıktısı da proje hedefiyse ayrıca doğrulanır. Vercel kullanımı projeye göre yapılandırılır; dağıtım başarılı varsayılmaz. Hedef FPS, bellek, indirme boyutu ve yükleme süresi proje bazında ölçülür; ölçülmemiş sayı raporlanmaz.

7. ÜRETİM VE TESLİMAT KAPILARI
A. Kaynak denetimi: repo, Drive assetleri, sürüm, mevcut hatalar, lisans.
B. Tasarım belgesi: oyun vaadi, evren bağı, referanslar, mekanikler, sanat kuralları.
C. Dikey dilim: tek kısa bölümde gerçek hareket, animasyon, UI, ses, oyun döngüsü.
D. İçerik üretimi: karakterler, bölümler, etkileşimler; tekrar kullanılabilir ama özgün.
E. QA: açılış, giriş, çarpışma, animasyon, kayıt, ses, UI, hata durumları, hedef cihazlar.
F. Yayın: temiz build, doğrulanmış URL/çıktı, sürüm notu, bilinen eksikler.
Her kapıda PASS / FAIL / NOT TESTED kullan. “Çalışıyor” yalnızca çalıştırılmış ve gözlenmişse denir. Eksik varlık, kırık bağlantı, sahte placeholder veya oynanamaz demo teslim tamamlandı sayılmaz.

8. REPO VE DOSYA KURALLARI
Her oyun bağımsız GitHub deposu olabilir. Projede /docs/AIONIA_STANDARD.md (bu belgenin sürümlü kopyası veya bağlantısı), /docs/ART_BIBLE.md, /docs/GAME_DESIGN.md, /docs/LORE_LINKS.md, /assets/sources, /assets/processed, /tests, /credits önerilir. Var olan projeyi zorla yeniden yapılandırma; uygun şekilde uyarlama yap. Drive normatif belge, repo ise uygulanabilir sürüm ve proje özelinde kararların kaydıdır. Kaynak dosyalarla işlenmiş çıktıları ayır. Değişiklikleri commit ve sürüm notuyla izle.

9. CODEX İÇİN DOĞRUDAN UYGULAMA KOMUTU
“AIONIA standartlarında oyun geliştir” ifadesi şu anlama gelir:
(1) Bu standardın güncel Drive belgesini ve projenin repo içi kopyasını oku, sürüm uyuşmazlığını bildir.
(2) Mevcut oyun, referans karakter paftaları, lore ve assetleri incele.
(3) AIONIA'nın sevimli-derin-epik kimliğine uygun, özgün, tutarlı pixel art ve oynanış tasarla.
(4) Godot'un mevcut altyapısını kullan; yeni motor yazma.
(5) Önce küçük oynanabilir dikey dilimi tamamla, sonra kapsamı genişlet.
(6) Animasyon, UI, ses, performans ve web dağıtımını gerçek testlerle doğrula.
(7) Kanon eklemelerini TASLAK olarak ayır; onaylanmamış lore'u resmileştirme.
(8) Değişen dosyaları, test sonuçlarını, eksikleri ve yayın durumunu açık raporla.
(9) Referanslar erişilemiyorsa durumu dürüstçe bildir; keyfî karakter veya asset ikamesi yapma.

10. KAPSAM DIŞI VE DEĞİŞİKLİK YÖNETİMİ
Bu standart bir oyun motoru geliştirme emri değildir. Yeni genel amaçlı engine, tüm oyun türleri için framework veya devasa lore ansiklopedisi zorunlu değildir. Sürüm değişiklikleri tarih, gerekçe ve önceki sürüm referansıyla kaydedilir. Kullanıcının açık onayı olmadan ana evren kimliği, marka hiyerarşisi ve mevcut karakterlerin temel tasarımı değiştirilmez.

11. AIONIA EVRENSEL DİJİTAL ÜRÜN STANDARDI — v1.1 KAPSAM GÜNCELLEMESİ (12.11.2026)
Bu bölüm, önceki oyun/Godot/pixel-art merkezli hükümleri kapsam bakımından GEÇERSİZ KILAR. AIONIA standartları yalnızca oyunlar için değildir: Flutter mobil uygulamaları, React/Vue/Svelte web siteleri, masaüstü araçları, SaaS, eğitim uygulamaları, interaktif deneyimler ve Godot oyunları dahil her dijital ürün için geçerlidir. AIONIA standardı bir yazılım çatısı, motor veya zorunlu teknoloji seçimi DEĞİLDİR. Ürün tipi, hedef kitle, güvenlik ve bakım gereksinimleri hangi teknolojiye uygunsa o seçilir. Godot, Flutter, React, native mobil veya başka bir teknoloji şart değildir.
MARKA VE GÖRSEL KAPSAM: Fragaria Interactive ana marka; AIONIA adı ürünün AIONIA evrenine ait olduğunu veya AIONIA tasarım standardıyla geliştirildiğini bağlama göre ifade edebilir. AIONIA karakterleri, pixel art ve lore yalnızca uygun projelerde kullanılır. Bankacılık, sağlık, eğitim veya verimlilik uygulamalarına zorla maskot, oyunlaştırma, pixel art ya da epik anlatı eklenmez. Görsel kimlik: sıcak ama profesyonel, özgün ama sade, özenli ama gösterişten uzak; ürüne uygun renk, tipografi, boşluk, ikon, hareket ve bileşen sistemi. Marka görselleri yalnızca onaylı kaynaklardan alınır.
HERKES İÇİN KULLANILABİLİRLİK: Yeni kullanıcı, ileri yaşta kullanıcı, düşük dijital okuryazarlık, engelli kullanıcı, küçük ekran, düşük performanslı cihaz, zayıf bağlantı ve farklı dil/yerel ayarlar hesaba katılır. “Herkes için uygun” mutlak bir iddia değil, açık hedef kullanıcı grupları ve erişilebilirlik testleriyle izlenen amaçtır. Açık dil, öngörülebilir gezinme, görünür durum, anlaşılır geri bildirim, geri alma/iptal, hata önleme ve kurtarma, mantıklı varsayılanlar, tutarlı bileşenler, klavye erişimi, ekran okuyucu etiketleri, odak göstergeleri, yeterli kontrast, metin büyütme, dokunma hedefleri, azaltılmış hareket, renk dışı durum işaretleri, erişilebilir formlar, boş/yükleniyor/hata/çevrimdışı durumları tasarlanır. Uygun olduğunda WCAG 2.2 AA hedef alınır; doğrulanmadan uyumluluk iddia edilmez.
ÜRÜN TASARIM SÜRECİ: (1) Kullanıcı, görev ve bağlamı tanımla. (2) En önemli akışları ve bilgi mimarisini belirle. (3) Tasarım token'ları ve bileşenleri seç. (4) İlk çalışan uçtan uca akışı oluştur. (5) Kullanılabilirlik, erişilebilirlik, performans, güvenlik, gizlilik ve hata durumlarını test et. (6) Bulguları düzelt. (7) Gerçek sürüm/dağıtım durumunu raporla. Tasarım kararlarını gerçek kullanıcılara ve ürüne göre uyarlamak esastır.
TEKNİK KALİTE: Kod okunabilir, test edilebilir, sürdürülebilir ve platform normlarına uygun olmalıdır. Mobilde dokunmatik gezinme, izinler, güvenli veri saklama ve farklı ekranlar; webde responsive düzen, semantik erişilebilirlik ve ağ hataları; masaüstünde klavye, pencere boyutlandırma ve yerel entegrasyon; oyunlarda kontrol hissi, animasyon, kamera ve oyun döngüsü ayrı ayrı değerlendirilir. Güvenlik ve mahremiyet, performans, pil/veri tüketimi ve lokalizasyon proje gereksinimleridir.
CODEX KISA KOMUTUNUN YENİ ANLAMI: “AIONIA standartlarında geliştir” = önce bu belgenin en güncel sürümünü oku; ürünün türünü, kullanıcılarını ve mevcut teknolojisini denetle; teknoloji değiştirmeden veya motor üretmeden uygun tasarım sistemi, erişilebilirlik, sezgisel UX, güvenilir işlevsellik, özgün görsel kalite ve gerçek QA uygula. Pixel art, lore ve karakter kullanımı yalnızca istenen veya uygun AIONIA evreni ürünlerinde zorunlu olabilir. İlgisiz ürünlerde bu varlıkları kullanma. Test edilmemiş sonucu tamamlandı deme.
DEĞİŞİKLİK KAYDI: v1.0 oyun ve Godot odaklıydı. v1.1 ile evrensel, teknoloji-bağımsız dijital ürün standardına genişletildi. Önceki bölümler yalnızca oyun/evren projelerine uygulanabilir uzmanlık ekleri olarak yorumlanır; çelişkide bu bölüm önceliklidir.

12. OYUN REGRESYON STANDARDI — AION ENDLESS RUN
AIONIA oyunları geliştirilirken önceki kullanıcı hata bildirimleri regresyon testlerine dönüştürülür. Aion Endless Run için özel kayıt: https://docs.google.com/document/d/1cpr6yIwVOq2F9rQBlG1sSvFf0Wu9Iir0lJ_KDnqA5lE/edit . Yeni sürümde karakter animasyonu, mobil kontroller, UI taşmaları, pixel-art tutarlılığı, denge, Fragaria etkinliği ve yükleme ekranı sorunları tekrar test edilmelidir. Önceki kullanıcı bildirimi güncel hata kanıtı değildir. PASS / FAIL / NOT TESTED ayrımı korunur. Oyun dışı ürünlere bu oyuna özgü testler zorla uygulanmaz.

13. ZORUNLU GAMEPAD / XBOX KOLU STANDARDI (12.11.2026)
AIONIA standardıyla geliştirilen HER OYUN, tasarım başlangıcından itibaren Xbox tarzı kontrolcü ve genel gamepad ile tam oynanabilir olacak şekilde planlanır. Bu zorunluluk oyunlar içindir; oyun dışı mobil/web uygulamalarında gamepad zorunlu değildir. Kontrolcüyle temel oynanış, ana menü, ayarlar, duraklatma, sonuç ekranı, diyalog, envanter ve ilgili tüm temel akışlar tamamlanabilir olmalıdır. Analog çubuk, D-pad, A/B/X/Y, omuz ve tetik tuşları türüne uygun atanır. Klavye/fare ve dokunmatik desteği korunur. Aktif giriş yöntemine göre tuş ipuçları güncellenir; odak göstergesi, menü gezinme, tuş yeniden atama, titreşim kapatma, uygun deadzone ve bağlantı kesilmesi/yeniden bağlanma davranışı uygulanır. Oyuncu kontrolcüyle klavye veya fareye mecbur bırakılmamalıdır. Web hedefinde Gamepad API/tarayıcı desteği ve gerçek Xbox kolu veya eşdeğer fiziksel cihazla doğrulama yapılır. PASS / FAIL / NOT TESTED kaydı olmadan gamepad uyumluluğu doğrulandı denmez. Xbox koluyla oynanabilme, Xbox konsoluna yayınlanabilme veya konsol sertifikasyonu anlamına gelmez.

14. AIONIA v1.2 — BÜTÜNSEL UI/UX, TASARIM UYUMU VE KALİTE FORGE (12.11.2026)
Bu bölüm v1.1'i genişletir ve oyun, Flutter, web, masaüstü, mobil, SaaS, eğitim ve diğer dijital ürünlerde geçerlidir. İlgili ürünün türüne göre uygulanır. Kullanıcının son açık talimatları önceliklidir. Genel amaç: kullanımı kolay, estetik, dengeli, bütünsel, erişilebilir ve özgün bir deneyim. “AI slop” sayılan rastgele şablon/asset karışımları kabul edilmez.

14.1 ÜRÜN KİMLİĞİ VE TEMASAL BÜTÜNLÜK
Her proje için tek sayfalık DESIGN_BRIEF hazırla: hedef kullanıcı, ana görev, hedef cihazlar, ton, üç tasarım sıfatı, kaçınılacak üç anti-pattern, marka/evren ilişkisi, örnek ekranlar. Ürün için tutarlı bir görsel dil oluştur: renk, tipografi, ikon ailesi, kenar biçimi, gölge, boşluk, grid, hareket, ses ve illüstrasyon aynı dünyaya ait hissettirmeli. İlgisiz maskot, fantastik efekt, gradient, emoji, kart, animasyon veya oyun öğesi sırf dekorasyon için eklenmez. Fragaria markası, AIONIA evreni ve bağımsız uygulama kimliği birbirine karıştırılmaz. Pixel art yalnızca ürünün bağlamına uygunsa kullanılır. Logo ve karakterler doğrulanmış kaynaklardan alınır; kaynak yoksa uydurulmaz.

14.2 BİLGİ MİMARİSİ, KATEGORİLER VE BAŞLIKLAR
Navigasyon önce kullanıcı görevlerine göre gruplanır; geliştirici kod modüllerine göre değil. Her kategori birbirinden anlamlı biçimde ayrılır, çakışmalar ve mükerrer girişler giderilir. Kategori adları kısa, anlaşılır, tutarlı ve yerelleştirilebilir olmalı; başlıklar hiyerarşik (sayfa > bölüm > alt bölüm), taranabilir ve içerikle doğrudan ilgili olmalı. Aynı işlev farklı yerlerde farklı adlarla sunulmaz. Menü derinliği gereksiz artırılmaz; önemli eylemler kolay bulunur. Breadcrumb, arama, filtre, sıralama ve sekmeler yalnızca içerik hacmi gerektiriyorsa eklenir. Her ekranın tek belirgin birincil eylemi bulunur; ikincil ve tehlikeli eylemler ayrılır. Bilgi yoğunluğu ürünün görevine göre dengelenir.

14.3 GÖRSEL HİYERARŞİ VE DENGE
Tutarlı spacing ölçeği, tipografi hiyerarşisi, hizalama ve okunabilir satır uzunluğu kullan. Görsel ağırlık işlev önemini yansıtmalı; rastgele büyütülmüş CTA, fazla büyük başlık, tekrar eden kartlar, gereksiz boşluk ve aşırı kalabalık engellenir. Bir ekranda benzer kartlar gerçekten karşılaştırılabilir içeriğe hizmet etmeli. Karanlık ve açık temalar, kontrast ve durum renkleri tasarlanır. Renk tek başına bilgi taşımamalı. Mikro animasyonlar geri bildirim için kullanılır; gösteriş amacıyla sürekli hareket, parıltı veya titreşim eklenmez. Reduced-motion seçeneğine saygı gösterilir.

14.4 PLATFORM UYARLAMASI VE RESPONSIVE KALİTE
Aynı ürünün mobil, tablet, masaüstü ve web sürümleri aynı işlevsel kimliği korur ama aynı piksel yerleşimini zorla kopyalamaz. Dar ekranlarda tek sütun, büyük ekranlarda uygun çok sütun, okunabilir içerik genişliği ve mantıklı gezinme tercih edilir. Safe-area, klavye açılması, ekran yönü, zoom, sistem yazı büyüklüğü, tarayıcı çubukları, katlanabilir cihazlar, fare/klavye/dokunmatik ve gerektiğinde gamepad hesaba katılır. Hiçbir kritik buton, isim, form alanı, menü veya sonuç paneli alt çubuk, çentik ya da sabit katman altında gizlenmez. Yatay kaydırma yalnızca gerçekten iki boyutlu içerik gerektiriyorsa kabul edilir. Breakpoint değerleri proje bazında belirlenir ve test edilir; sadece masaüstü ekran görüntüsünden mobil kalite iddia edilmez.

14.5 HERKES İÇİN KULLANILABİLİRLİK VE ERİŞİLEBİLİRLİK
İlk kez kullanan, deneyimli, yaşlı, düşük dijital okuryazarlıklı, farklı dil konuşan ve engelli kullanıcılar için anlaşılır dil ve öngörülebilir etkileşim hedeflenir. Açık etiket, açıklayıcı hata mesajı, geri alma/iptal, kayıp veri önleme, klavye odak sırası, görünür focus, ekran okuyucu etiketleri, metin büyütme, yeterli kontrast, büyük ve aralıklı dokunma alanları, alternatif giriş, renk dışında şekil/metin ile durum bildirimi ve hareket azaltma değerlendirilir. Web için uygun kapsamda WCAG 2.2 AA hedeflenir; otomatik test tek başına uyumluluk kanıtı değildir. WCAG 2.2 AA dokunma hedefi 24x24 CSS px veya tanımlı istisnalarla sağlanır; rahat kullanım için çoğu dokunmatik kontrolde 44x44 veya platformun önerdiği daha büyük alan hedeflenebilir. Metin için olağan AA kontrast hedefi 4.5:1, büyük metin için 3:1; ilgili UI sınırları için 3:1. Kaynak: https://www.w3.org/TR/WCAG22/ . Kullanıcı testleri ve ekran okuyucu testleri olmadan “herkes için tamamen erişilebilir” iddiası kurulmaz.

14.6 ETKİLEŞİM DURUMLARI VE GERİ BİLDİRİM
Her önemli bileşen normal, hover (uygunsa), focus, pressed, disabled, loading, success, error ve empty durumları için tasarlanır. İşlem devam ederken geri bildirim verilir, ancak sahte ilerleme yüzdesi gösterilmez. Formlar girilen veriyi korur; hata nerede ve nasıl düzeltileceği açıklanır. Yıkıcı işlemlerde uygun onay veya geri alma bulunur. İnternet kopması, yetki reddi, boş veri, zaman aşımı ve oturum sonu için anlamlı kurtarma yolu sağlanır. Kullanıcının kontrolü elinden alınmaz; beklenmedik pop-up, otomatik ses, zorunlu animasyon ve gereksiz bildirim kullanılmaz.

14.7 ÖZGÜNLÜK VE ANTI-AI-SLOP KAPISI
Yalnızca “modern, premium, şık” gibi belirsiz promptlarla teslim yapılmaz. Her tasarım kararı hedef görev, kullanıcı ve marka ile gerekçelendirilir. Aynı jenerik gradient/kart/badge/ikon kalıbının her projeye kopyalanması, tutarsız ikon aileleri, anlamsız metinler, sahte veriler, yanlış karakter sprite'ları, rastgele animasyonlar ve içerikten kopuk dekorasyon kalite kusurudur. Gerekirse tasarım sadeleştirilir. Özgünlük, aşırı süs değil, ayırt edici ama işlevsel etkileşim ve iyi sanat yönetimidir. Telif/lisans kaynağı olmayan asset kullanılmaz.

14.8 BİLEŞEN VE DESIGN TOKEN SİSTEMİ
Proje ölçeğine uygun renk token'ları (background/surface/text/primary/danger/success), tipografi ölçeği, boşluk ölçeği, köşe ve kenarlık sistemi, ikon boyutları, motion süreleri ve durum bileşenleri tanımlanır. Flutter Theme, CSS variables, Godot Theme veya platformun doğal tasarım sistemleriyle uygulanabilir. Yeni framework zorunlu değildir. Bileşenler tekrarlıysa ortaklaştırılır; tek kullanım için aşırı soyutlama yapılmaz. Tasarım token'ları hem açık hem koyu temada doğrulanır.

14.9 ÖLÇÜLEBİLİR UX VE PERFORMANS
Ana görev tamamlama oranı, görev süresi, hata oranı, yanlış dokunma, geri dönüş, okunabilirlik, açılış süresi, kaydırma/animasyon akıcılığı, bellek ve enerji kullanımı proje türüne göre ölçülür. Eşikler cihaz ve ürün hedeflerine göre önceden belirlenir; sahte skor veya doğrulanmamış yüzde verilmez. Oyunlarda kontrol hissi, input latency ve gamepad ile tam akış; uygulamalarda form, arama, filtre, kayıt, hata kurtarma ve veri bütünlüğü özellikle test edilir.

14.10 TASARIM REGRESYONU VE GERÇEK CİHAZ QA
Her ana ekran için referans ekran görüntüsü ve beklenen davranış kaydı tutulur. Küçük telefon, büyük telefon, tablet, masaüstü ve hedef web tarayıcıları için yatay/dikey, light/dark, uzun metin, Türkçe/İngilizce, 200% zoom/yazı büyütme, boş/hata/yükleniyor, klavye açılması ve giriş yöntemi senaryoları test edilir. Pixel fark testi tek başına yeterli değildir; işlevsel ve insan gözüyle değerlendirme gerekir. Eski kullanıcı şikâyetleri kalıcı regresyon vakalarına dönüştürülür. Her kontrol PASS / FAIL / NOT TESTED olarak raporlanır; kanıt ve sürüm belirtilir.

14.11 KALİTE KAPILARI VE TESLİMAT
Aşama A: mevcut ürün, geçmiş şikâyetler, kaynak assetler ve hedef kitle denetimi.
Aşama B: bilgi mimarisi, ekran listesi, kullanıcı akışları ve tasarım ilkeleri.
Aşama C: çalışan uçtan uca dikey dilim/temel görev.
Aşama D: responsive ve erişilebilirlik testleri; tutarsızlık onarımı.
Aşama E: performans, güvenlik, gizlilik, hata kurtarma, regresyon ve gerçek cihaz testleri.
Aşama F: sürüm raporu; değişen dosyalar, ekran görüntüleri, PASS/FAIL/NOT TESTED, bilinen kusurlar ve yayın durumu.
Kritik kullanıcı akışı FAIL iken ürün “tamamlandı” olarak sunulmaz. Kullanıcının açık talebi olmadan görsel kimlik, kategori isimleri veya ana gezinme kökten değiştirilmez.

14.12 CODEX / GELİŞTİRİCİ İÇİN YORUM KURALI
“AIONIA standartlarında geliştir” dendiğinde bu v1.2 bölümünü ve v1.1 genel kuralları oku. Önce proje türünü ve mevcut teknolojiyi tespit et. UI/UX, başlık/kategori düzeni, tematik bütünlük, cihaz uyumu, user-friendly ve erişilebilirlik, anti-AI-slop, test ve gerçek teslim kanıtı öncelikli olsun. Oyun ise zorunlu Xbox/gamepad standardı ve oyun regresyon kayıtlarını da uygula. Uygulama ise oyuna özgü pixel art, lore, gamepad ve motor şartlarını dayatma. Referanslara erişilemiyorsa erişilmiş gibi davranma.
DEĞİŞİKLİK KAYDI: v1.2, v1.1'i UI/UX, bilgi mimarisi, tematik tutarlılık, platform adaptasyonu, erişilebilirlik, anti-AI-slop ve ölçülebilir kalite kapılarıyla genişletir. Çelişen eski oyun-merkezli genel hükümler yerine v1.2 kapsam yorumu geçerlidir.
