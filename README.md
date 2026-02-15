# FoodScan AI

Offline-first paketli gıda analiz uygulaması. Kullanıcılar kamera ile içindekiler bölümünü tarar, uygulama on-device OCR ile okur, yerel veritabanı ile eşleştirir, 0-100 sağlık skoru üretir ve alerjen uyarısı verir.

## Temel Özellikler

- ✅ **Tamamen Offline** - İnternet bağlantısı gerektirmez
- 📷 **On-Device OCR** - Google ML Kit ile kamera görüntüsünden metin tanıma
- 🗄️ **Yerel Veritabanı** - Drift (SQLite) ile ingredient matching
- 📊 **Sağlık Skoru** - 0-100 arası otomatik skor hesaplama
- ⚠️ **Alerjen Uyarısı** - Potansiyel allerjen tespit ve uyarı sistemi

## Teknoloji Stack

- **Framework**: Flutter
- **State Management**: flutter_bloc (BLoC pattern)
- **Dependency Injection**: get_it + injectable
- **Database**: drift (SQLite ORM)
- **OCR**: google_mlkit_text_recognition
- **Error Handling**: dartz (Either<Failure, T>)

## Mimari

Clean Architecture ile 3 katmanlı yapı:
- **Data Layer**: Repository implementations, DataSources, Models
- **Domain Layer**: Entities, Use Cases, Repository interfaces (pure Dart)
- **Presentation Layer**: BLoC, Pages, Widgets

## Kurulum

```bash
# Dependencies yükle
flutter pub get

# Kod üretimi (injectable, drift)
dart run build_runner build --delete-conflicting-outputs

# Uygulamayı çalıştır
flutter run
```

## Geliştirme

```bash
# Watch mode (kod üretimi)
dart run build_runner watch --delete-conflicting-outputs

# Testleri çalıştır
flutter test

# Kod analizi
flutter analyze

# Kod formatlama
dart format .
```

## Proje Yapısı

```
lib/
├── core/
│   ├── di/              # Dependency injection setup
│   ├── error/           # Failure classes
│   └── utils/           # Shared utilities
└── features/
    └── <feature_name>/
        ├── data/        # Repository impl, DataSource, Models
        ├── domain/      # Use Cases, Entities, Interfaces
        └── presentation/ # BLoC, Pages, Widgets
```

## Katkıda Bulunma

Her yeni feature için:
1. Feature-first klasör yapısı kullan
2. Domain katmanında pure Dart (Flutter bağımlılığı yok)
3. Her use case için unit test yaz
4. `Either<Failure, T>` pattern ile hata yönetimi

Detaylı mimari ve geliştirme kuralları için `CLAUDE.md` dosyasına bakın.

## Lisans

[LICENSE dosyası eklenecek]
