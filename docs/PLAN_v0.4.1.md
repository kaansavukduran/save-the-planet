# 0.4.1 · devam planı

Kullanıcı “Forge” açıklamasında mevcut devam noktasından geliştirmeyi sürdürmeyi seçti. Mevcut Godot 4.6.3, dört kanonik karakter, on bölüm, kayıt verisi ve onaylı D-pad + aksiyon düzeni korunur. Normatif kaynak aynı oturumda bütünüyle okunan AIONIA v1.4 belgesidir; `source/AIONIA_v1.4_2026-11-12.txt` snapshot'ı ve önceki kaynak/kanon sınırları geçerlidir.

1. Açık performans hedefini yeniden ölç; ekran oranına bağlı çizim sorunlarını gerçek pakette yeniden üret.
2. Kamera alanına göre gökyüzü/çevre çizimini, duraklatılmış ekran döndürmeyi ve tünelin aktif giriş ipucunu düzelt.
3. Eski pakette FAIL veren ekran testi ekle; aynı testi yeni pakette, mevcut dokunmatik/UI ve native kampanya/kabul testleriyle çalıştır.
4. Debug QA'da CPU/fizik/çizim ölçümlerini ayır; release çıktısında QA köprüsü bulunmadığını doğrula. Geliştirme ölçümünü fiziksel cihaz performansı diye sunma.
5. Somut sonuçları ve açık kalan işleri FORGE.md / PROGRESS.md içinde kaydet; testleri taslak PR'ın CI kapsamına ekle. Nihai yayın ve sanat onayı iddiasında bulunma.

Yeni motor, framework, runtime bağımlılığı, uydurulmuş karakter/logo veya yeni kontrol tercihi eklenmez. Bu yama hedef oyun süresinin ve henüz yapılmamış fiziksel cihaz testlerinin yerine geçmez.
