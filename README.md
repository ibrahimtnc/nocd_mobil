# OCD Coach - OCD Resilience & Coping App (MVP)

Premium Flutter uygulaması, OCD (Obsessive-Compulsive Disorder) başa çıkma teknikleri için ERP (Exposure Response Prevention) yaklaşımı kullanır.

## Özellikler

- **Trust-First Onboarding**: Kullanıcı gizliliğine öncelik veren onboarding akışı
- **Anxiety Tracking**: 1-10 arası kaygı seviyesi takibi
- **Thought Analysis**: Düşünceleri analiz etme ve bilimsel açıklamalar
- **Mini-Games**: Dikkat dağıtma ve grounding için 3 farklı mini-oyun
  - Bubble Wrap (Tactile)
  - Neon Trace (Focus)
  - Breath Synchronizer (Bio)
- **Scientific Analysis**: OpenAI ile bilimsel analiz ve cognitive reframing

## Teknoloji Stack

- **Framework**: Flutter (Latest Stable)
- **Architecture**: Feature-First Clean Architecture
- **State Management**: Riverpod (with Code Generation)
- **Navigation**: GoRouter
- **Local Storage**: Hive (Data stays on device for privacy)
- **Backend**: Firebase Auth (Anonymous), Firebase Functions (OpenAI proxy)
- **UI Packages**: google_fonts, fl_chart, flutter_animate, vibration

## Kurulum

### 1. Dependencies Yükleme

```bash
flutter pub get
```

### 2. Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Firebase Setup

Firebase projesi kurulumu için `FIREBASE_SETUP.md` dosyasına bakın.

```bash
# Firebase CLI kurulumu
npm install -g firebase-tools

# Firebase login
firebase login

# Firebase initialize
firebase init

# Firebase Functions deploy
cd functions
npm install
cd ..
firebase deploy --only functions
```

### 4. Firebase Options

Firebase projesi kurulduktan sonra:

```bash
flutterfire configure
```

Bu komut `firebase_options.dart` dosyasını otomatik oluşturur.

## Proje Yapısı

```
lib/
├── src/
│   ├── core/           # Core utilities, theme, constants
│   ├── features/       # Feature modules
│   │   ├── onboarding/
│   │   ├── home/
│   │   ├── negotiation/
│   │   ├── minigames/
│   │   └── analysis/
│   └── shared/         # Shared models and services
├── main.dart
└── app.dart
```

## Kullanım

1. Uygulamayı başlatın: `flutter run`
2. İlk açılışta onboarding akışını tamamlayın
3. Home screen'de kaygı seviyenizi ve düşüncenizi girin
4. Negotiation ekranında bekleme süresini seçin
5. Mini-game ile bekleyin
6. Bilimsel analizi görüntüleyin

## Design System

- **Primary Color**: Deep Sage Green (#4A7C59)
- **Secondary**: Soft Beige (#F5F5DC)
- **Accent**: Muted Lavender (#967BB6)
- **Anxiety High**: Terracotta (#E2725B)
- **Anxiety Low**: Soft Teal (#88D8B0)
- **Typography**: Nunito (Google Fonts)

## Notlar

- Tüm kullanıcı verileri cihazda saklanır (Hive)
- Firebase Auth sadece anonymous sign-in kullanır
- OpenAI API çağrıları Firebase Functions üzerinden proxy edilir
- Uygulama bir tıbbi cihaz değildir, coaching tool'dur

## Lisans

Private project - All rights reserved
