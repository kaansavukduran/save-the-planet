# Save the Planet · ART_BIBLE · 0.3.0

Normatif kaynak: [güncel AIONIA kaydı](AIONIA_STANDARD.md), 12.11.2026. Proje kararları aşağıdadır; evrenin tamamı için yeni kanon değildir.

## Görsel karar

Sevimli karakter siluetleri, sakin ve okunaklı kurtarma alanları; uzak katmanlarda daha büyük bir dünyanın hissi. Ekoloji/hayvan hakları bu oyunun yerel temasıdır. Fragaria Interactive üst marka, Fragaria Games oyun yayın markası, AIONIA evrendir.

- İç tasarım alanı: 960×540. Dünya birimi = tasarım pikseli. 32 px modül çevre ayrıntılarında kılavuzdur, karakter kaynaklarını 32 px hücreye zorlamaz.
- Kanonik kaynakların gerçek alfa sınırları ve anatomik pivotları kullanılır. Ortak dünya ölçeği korunur. Kamera/karakter çizim dönüşümleri piksele oturtulur; fizik alt piksel doğrulukta kalır.
- Ana gövde: 30×54 çarpışma, taklada 30×26. Rendered karakter yüksekliği kaynağa göre yaklaşık 50–65 px; uç kanat/kuyruk fizik kutusuna sıkıştırılmaz.
- Dünya paleti: gece laciverti #142333, derin arduvaz #233b4a, sisli petrol #456b76, adaçayı #7caa9c, yaprak #5c8a70, güneş/etkileşim #efcd89, kâğıt #f2e5c7; ana eylem için çilek tonlu #a93f59. Çilek referansından renk ilişkisi alınır; bu görsel son onaylı logo ilan edilmez.
- Işık üst soldan, gölge sağ alttan. Etkileşim objesi aydınlık kenar + şekil/ikon; dekor daha düşük kontrast. Oynanabilir zemin açık üst çizgiyle seçilir.
- Uzak sırt, ağaç ve ön plan farklı paralaks hızlarında; karakter ve tehlike düzlemi sabittir. Kamera bakış yönünü yumuşakça izler, karakter değişimi kamerayı yenilemez.
- Arayüz: keskin piksel çerçeveler, sıcak kâğıt metni, lacivert zemin, altın odak; 44 px ve üzeri temel düğme hedefi. 17/18 px gövde, 22 px büyük metin; DejaVu Türkçe glifleri ve lisansı korunur. Hiyerarşi renk yanında boyut, çerçeve ve metinle sağlanır.
- Pixel-perfect hedef doğal 1×/2× ölçeklerde doğrulanır. Telefon için küçülme gerektiğinde nearest filtre ve ayrı kontrol yerleşimi kullanılır; her fiziksel boyutta matematiksel tamsayı ölçek varmış gibi raporlanmaz.

## Kaynak ve onay matrisi

| Kimlik | İncelenen kaynak | Kullanım / onay sınırı |
|---|---|---|
| Aion | canonical-base, ana referans, turnaround, T poz A/B, canonical/motion | Mevcut pembe/cyan karakter sprite'ı korunur. A/B arka kuyruk farkı yeni ana kanon diye seçilmez. |
| Kurt | T poz modelleme, canonical/motion | Gri-mor gövde, krem detay ve turkuaz göz korunur. Taslak paftadaki ayrıntıların tamamı kesinleşmiş sayılmaz. |
| Kuzu | v01 T poz, v02 pafta, canonical/motion | Mevcut oyunda zaten bulunan altın haleli sprite korunur; halesiz v01 ile rastgele birleştirilmez. |
| Ömer | Açık kanat modelleme pozu, canonical/motion | Kahverengi-krem gövde ve kehribar göz korunur. Ayrı adlandırılmış T poz dosyası bulunduğu iddia edilmez. |
| Emre | T poz modelleme paftası | Bej tüy, yeşil göz, açık gömlek, kırmızı kravat, koyu pantolon. Pafta TASLAK 01 etiketli; doğrulanmış sprite/animasyon yok. Kimlik korunur, yeni kesin sprite uydurulmaz. |
| Fragaria | Çilek JPEG referansı | İncelendi ve kaynak saklandı. Son logo onayı doğrulanmadı; yayıncı adı metinle kullanılır. |

19 orijinal referansın kimlik/hash kaydı `source/AIONIA_REFERENCES.json` içinde. Paftalar değiştirilmeden `assets/source/aionia-references` altında; çalışma zamanı türevleri `assets/derived` altında. Adında canonical geçmesi kendi başına kullanıcı onayı sayılmaz. Eski kullanılan dört sprite ile yeni arşiv birebir eşleşir.

## Animasyon sözleşmesi

`data/sprites.json`: atlas, gerçek satır, kare sayısı, alfa crop'u, kaynak, pivot/offset ve ortak ölçek. `docs/ANIMATION_REGISTRY.md`: eylem/FPS/döngü/hitbox kaydı. Sprite sheet bütünü karakter yerine çizilmez. Mevcut pozların yeniden zamanlanması yeni çizilmiş animasyon sayılmaz. Eksik özel eylemler açık kalır.

## Kontrast kontrolü

Hesaplanan sRGB metin oranları: kâğıt #f2e5c7 / ana düğme #a93f59 **4,74:1**; beyaz / hover #b9546b **4,62:1**; kâğıt / panel #1d3040 **10,85:1**; altın / gece #142333 **10,44:1**. İlk çilek düğme tonu 3,97:1 olduğu için koyulaştırıldı. Bu hesaplar bütün piksel/altyazı ve tüm ekranlarda erişilebilirlik onayı anlamına gelmez.

## 0.3.0 platform uygulaması

Mevcut görsel kimlik ve kaynak karakterler korunur. Sabit 960×540 viewport render'ı ve nearest ölçek; kamera/özgün sprite ölçüleri değişmez. UI gövde font override'ı her kare yerine tercihler değişince uygulanır. Web metin rehberi aynı renk/kenar/focus dilini semantik dialog/tabloyla taşır; rem yazılar 200% büyütmeyle sınanır. Oyun alanı safe-area insets içine yerleşir. Bu, bütün telefonlarda native oyunun metninin yeterince büyük olduğu veya çentiklerin fiziksel olarak test edildiği iddiası değildir.

Aktif gamepad ipuçları ve okunaklı hata metni, yeni rastgele ikon/mascot eklemek yerine görevi açıklar. Pause düğmesi yalnız oynanışta görünür. Motion azaltma, dekor/yanıp sönme yanında kamera smoothing/bakış payını da sınırlar. Son sanat kapısı hâlâ açıktır.
