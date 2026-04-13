# Audio Files for Minigames

Bu klasör minigame'ler için ses dosyalarını içerir.

## Mevcut Dosyalar

- `relaxing_music.mp3` - Minigamelerde çalması için Arka plan müziği 

## Eklenebilecek Ses Efektleri

Ses efektleri için aşağıdaki dosyaları ekleyebilirsiniz. Dosyalar eklendiğinde otomatik olarak çalışacaktır:

### Oyun Ses Efektleri

1. **`sfx_pop.mp3`** - Yumuşak pop sesi
   - Kullanım: Kart çevirme, bubble wrap gibi etkileşimler
   - Önerilen süre: 0.1-0.3 saniye
   - Fallback: Haptic feedback (light impact)

2. **`sfx_card_flip.mp3`** - Kart çevirme sesi
   - Kullanım: FocusMatchGame'de kart çevirirken
   - Önerilen süre: 0.2-0.4 saniye
   - Fallback: Haptic feedback (light impact)

3. **`sfx_match.mp3`** - Eşleşme sesi
   - Kullanım: FocusMatchGame'de kartlar eşleştiğinde
   - Önerilen süre: 0.3-0.5 saniye
   - Fallback: Haptic feedback (medium impact)

4. ZenFlowGame cizim yapılırken titreşim olsun ve oradaki çizimleri uygulama anlasın mesela yuvarlak çiz dedi yuvarlak çizince algılasın ve başka bir şekil çizmesini istesin.

5. **`sfx_breath_in.mp3`** - Nefes alma sesi
   - Kullanım: BioSyncBreathGame'de nefes alırken
   - Önerilen süre: 2-4 saniye
   - Fallback: Haptic feedback (selection click)

6. **`sfx_breath_out.mp3`** - Nefes verme sesi
   - Kullanım: BioSyncBreathGame'de nefes verirken
   - Önerilen süre: 2-4 saniye
   - Fallback: Haptic feedback (selection click)

7. **`sfx_click.mp3`** - Tıklama sesi
   - Kullanım: Genel buton tıklamaları
   - Önerilen süre: 0.1-0.2 saniye
   - Fallback: Haptic feedback (selection click)

8. **`sfx_success.mp3`** - Başarı sesi
   - Kullanım: Tüm eşleşmeler tamamlandığında, başarılı işlemler
   - Önerilen süre: 0.5-1 saniye
   - Fallback: Haptic feedback (heavy impact)

## Ses Dosyası Özellikleri

- **Format**: MP3 (önerilen) veya WAV
- **Bitrate**: 128 kbps veya daha düşük (dosya boyutunu küçük tutmak için)
- **Sample Rate**: 44.1 kHz
- **Süre**: Kısa efektler için 0.1-1 saniye, müzik için sınırsız

## Nasıl Eklenir?

1. Ses dosyalarını `assets/audio/` klasörüne kopyalayın
2. Dosya adlarını yukarıdaki isimlerle eşleştirin
3. Uygulamayı yeniden başlatın
4. Ses efektleri otomatik olarak çalışacaktır

## Notlar

- Ses dosyaları eklenmezse, sistem haptic feedback kullanılır
- Ses efektleri `SoundEffectService` tarafından yönetilir
- Arka plan müziği `RelaxingMusicPlayer` tarafından yönetilir
- Ses efektleri düşük gecikme modunda çalışır (low latency mode)

## Ücretsiz Ses Kaynakları

Ses efektleri için şu kaynakları kullanabilirsiniz:
- [Freesound.org](https://freesound.org/)
- [Zapsplat](https://www.zapsplat.com/)
- [Mixkit](https://mixkit.co/free-sound-effects/)

