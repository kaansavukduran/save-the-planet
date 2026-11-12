# Save the Planet · güncel tasarım kaynağı

Fragaria Interactive / AIONIA. Godot 4.6.3, GDScript, yandan 2D pixel/sprite kurtarma-platform macerası. Türkçe/İngilizce. On bölüm ve final tek ortak Godot projesindedir. Eski tasarım `legacy/GDD.md` arşivinde; yeni kapsam için `docs/source/DEVELOPMENT_BRIEF_TR.txt` esas alınır.

Dört arkadaşın tek ortak fizik gövdesi vardır. Aion çift zıplama ve akış; Melun Bilge Kurt depar ve ağır düzenek; Kuzu gerçek takla ve alçak geçit; Baykuş Ömer sınırlı süzülüş ve kanıt inceleme kullanır. Hava hakları, cooldown, hız sınırı ve hasar koruması karakter değişiminde korunur. Dar tünelde büyük gövde reddedilir. Menü ve diyalog oyunu durdurur.

| Perde | Bölümler | Öğrenme ve tamamlanma |
|---|---|---|
| Çitin Ötesi | Sessiz Buluşma / Açılan Kapı | Gürültü ve yolu düzelt, Duru kendi yürüsün; Kuzu/Kurt/Ömer katılır. Ağır bariyer veya üst parkur. Yaşam alanı. |
| Nehrin İzinde | Geri Dönen Kirlilik / Nehrin Geçidi | Görünen atık tekrar gelir; kaynağı kapatmadan bitmez. Akış, filtre, bekleme, denetim. |
| Kurdun Geçidi | Bölünmüş Orman / Korkunun Adı | İki rota, uzaktan habitat koridoru; makine ve koridor güvenliği, yuva yerinde kalır. |
| Yeşil Vitrin, Sessiz Kıyı | Yeşil Vitrin / Sessiz Kıyı | Kurgu kayıtların kaynak/tarih/birim/kapsamını karşılaştır, yeterli bilgi yok geçerli; enerji kesme, güvenli bakım alanı, Aslı müdahalesi. |
| Birlikte Açılan Yol | Birlikte Hazırlık / Birlikte Açılan Yol | Güvenli çıkış, zararlı hat ayrımı, bakım beslemesi sürer, insan sofrasında mercimekli alternatif uygulanır. Gözlem → alt sistemler → çıkışı koruma. |

Final `story_complete` kaydeder; etkileşimli yaşam alanı ve bölüm seçimi açık kalır. Duru bakım alanında, yaban bireyleri orman/yuvasında, kıyı bireyi bakımda kalır. Bireyler para, can veya işçi değildir. İnsanların vegan seçimi, diğer türlerin biyolojisiyle karıştırılmaz. Fantastik akış yeteneği gerçek su güvenliği değildir. SDG temaları onay/ortaklık iddiası değildir; zorunlu quiz yoktur.

Kayıt şema 2: sabit kimlikli dünya bayrakları, birey durumu, açılmış karakterler, bölüm, güvenli checkpoint ve tercihler. Atomik temp → replace, son geçerli backup. Bozuk/eski/yeni sürüm sınırları test edilir. Retry dünya bayraklarını geri almaz. Cihazlar arası bulut senkronu yoktur.

Kontroller A/D/oklar, Space, J, E, 1–4, Q, Esc, Tab; S/aşağı tek yönlü platformdan inme. Klavye yeniden atanır. Gamepad soyut eylemler, dokunmatik bağımsız temas kimlikleri kullanır. Hikâye ve standart mod; ayrı müzik/efekt, büyük metin, azaltılmış efekt, konuşma geçmişi.

Hedef süreler 8–12 dakika/bölüm ve 2–3 saat toplamdır; mevcut kompakt 0.2.0 bunları karşılamış sayılmaz. Gerçek doğrulama ve açık sanat/platform işleri `docs/PROGRESS.md` ve `docs/VALIDATION.md` içindedir.

AIONIA standartları `docs/AIONIA_STANDARD.md`, proje sanat kararları `docs/ART_BIBLE.md`, kanon/onay sınırları `docs/LORE_LINKS.md` içinde. Fragaria Interactive üst marka, Fragaria Games yayıncı, AIONIA evrendir. Paletli native arayüz, hedef/etkileşim ayrımı, konuşmacılı sayfalı diyalog, gerçek ilerlemeli yükleme ve kurtarılabilir hata ekranı kullanılır. Kamera yumuşak yön bakışı tek gövdeyi izler. Azaltılmış efekt hasar yanıp sönmesini de kapatır.
