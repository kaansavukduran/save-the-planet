# Çalışma zamanı animasyon kaydı

Kaynak JSON'ları gerçek rect/bounds/runs/origin/scale verisini saklar. Kare sayısı satıra göre 6–8 arasında değişir; eşit hücre varsayılmaz. İsimlendirme mevcut kaynağı kesin sanat onayı saymaz.

| Eylem | Kaynak/satır | FPS / döngü | Pivot / çarpışma |
|---|---|---|---|
| Idle | canonical-{hero}, 0 | 7 / döngü | Kaynak anatomik pivot; 30×54 |
| Koşu | canonical-{hero}, 1 | 13 / döngü | Aynı ortak ölçek; 30×54 |
| Yavaş hareket | Aynı koşu pozları, daha yavaş zamanlama | 7 / döngü | Yeni çizilmiş walk animasyonu iddiası değil |
| Yükseliş/düşüş/iniş | canonical-{hero}, 2 | 11/9, son iniş pozu | Fizik evresine göre; 30×54 |
| Etkileşim | canonical-{hero}, 3 | 7 / kısa eylem | Genel poz; özel gözlem/bakım çizimleri eksik |
| Kuzu takla | canonical-rolls, 2 | 13 / döngü | Kompakt merkez; 30×26 |
| Kurt depar | agility-wolf, 0 | 13 / döngü | Anatomik pivot; 30×54 |
| Ömer süzülüş | agility-owl, 0 | 7 / döngü | Aynı hava bütçesi; 30×54 |

Sağ yön kaynağı sola yalnız görsel flip ile döner; fizik/kamera çoğaltılmaz. Komşu kare sızıntısı kaynak alfa koşularıyla engellenir. Emre için doğrulanmış hareket kaydı yoktur. Ayrı özel animasyon gerektiren işler kalite açıkları olarak korunur.
