# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**FoodScan AI** - Offline-first Flutter application for packaged food analysis. Users scan ingredient labels with camera, app performs on-device OCR, matches against local DB, generates 0-100 health score, and provides allergen warnings.

**Critical Constraint**: Completely offline, no API calls, all processing on-device.

## Architecture

Clean Architecture with strict 3-layer separation:

```
lib/
├── core/               # Shared utilities, DI, error handling
├── features/
│   └── <feature_name>/
│       ├── data/       # Repository impl, DataSource, Models
│       ├── domain/     # Use Cases, Entities, Repository interfaces (pure Dart, no Flutter deps)
│       └── presentation/  # Screens, Widgets, BLoC
```

**Key Principles**:
- Domain layer is pure Dart - zero framework dependencies
- UI layer contains no business logic
- All failures handled via `Either<Failure, T>` pattern (dartz)
- Feature-first modular organization

## Tech Stack

### Core Dependencies
- **OCR**: `google_mlkit_text_recognition` - on-device text recognition
- **Database**: `drift` - SQLite ORM for local ingredient database
- **State Management**: `flutter_bloc` - BLoC pattern
- **Dependency Injection**: `get_it` + `injectable` - service locator pattern
- **Error Handling**: `dartz` - functional Either<L,R> types

### Architecture Patterns
- Clean Architecture (3-layer: Data/Domain/Presentation)
- BLoC for state management
- Repository pattern for data access
- Use Case pattern (single responsibility per use case)

## Common Commands

```bash
# Get dependencies
flutter pub get

# Generate code (injectable, drift, etc.)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs

# Run the app
flutter run

# Run all tests
flutter test

# Run specific test file
flutter test test/features/<feature>/domain/usecases/<usecase>_test.dart

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Format code
dart format .

# Build release APK
flutter build apk --release

# Build release iOS
flutter build ios --release
```

## Development Guidelines

### Creating New Features

Every new feature follows this structure:

```
features/
└── <feature_name>/
    ├── data/
    │   ├── datasources/
    │   │   └── <feature>_local_datasource.dart
    │   ├── models/
    │   │   └── <model>_model.dart
    │   └── repositories/
    │       └── <feature>_repository_impl.dart
    ├── domain/
    │   ├── entities/
    │   │   └── <entity>.dart
    │   ├── repositories/
    │   │   └── <feature>_repository.dart  # interface only
    │   └── usecases/
    │       └── <action>_<resource>.dart
    └── presentation/
        ├── bloc/
        │   ├── <feature>_bloc.dart
        │   ├── <feature>_event.dart
        │   └── <feature>_state.dart
        ├── pages/
        │   └── <feature>_page.dart
        └── widgets/
            └── <widget_name>.dart
```

### Testing Requirements

- **Mandatory**: Write unit tests for every use case
- Test domain logic in isolation (no Flutter dependencies)
- Mock repositories and datasources using Mockito
- Verify `Either<Failure, Success>` return types

Example test structure:
```dart
// test/features/<feature>/domain/usecases/<usecase>_test.dart
void main() {
  late MockRepository mockRepository;
  late UseCaseName useCase;

  setUp(() {
    mockRepository = MockRepository();
    useCase = UseCaseName(mockRepository);
  });

  test('should return success when...', () async {
    // arrange
    // act
    // assert
  });
}
```

### Error Handling Pattern

All repository methods and use cases return `Either<Failure, T>`:

```dart
// Domain layer
abstract class FeatureRepository {
  Future<Either<Failure, Entity>> getEntity(String id);
}

// Use case
class GetEntity {
  Future<Either<Failure, Entity>> call(String id) async {
    return await repository.getEntity(id);
  }
}

// BLoC handles failures
result.fold(
  (failure) => emit(ErrorState(message: _mapFailureToMessage(failure))),
  (data) => emit(SuccessState(data: data)),
);
```

**Important**: Failure details must not leak to UI. Map failures to user-friendly messages in presentation layer.

## Database (Drift)

### Ingredient Database
- Seed data loaded at app initialization
- **Read-only**: App does not mutate ingredient data
- Schema updates via drift migrations
- Local SQLite database

Common drift patterns:
```dart
// Define table
class Ingredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  // ...
}

// DAO for queries
@DriftAccessor(tables: [Ingredients])
class IngredientsDao extends DatabaseAccessor<AppDatabase> {
  Future<List<Ingredient>> getAllIngredients() => select(ingredients).get();
}
```

## OCR Integration

Using `google_mlkit_text_recognition` for on-device text recognition:

1. Capture image from camera
2. Process with ML Kit TextRecognizer
3. Extract ingredient text
4. Parse and match against local DB
5. Generate health score

**No network calls** - all ML models are bundled with app.

## Scoring System

### Current Implementation
Rule-based scorer (interface-backed for future extensibility)

### Future Architecture
Scorer and Parser are behind interfaces - prepared for ONNX/TFLite model integration:

```dart
abstract class IngredientScorer {
  Future<int> calculateScore(List<Ingredient> ingredients);
}

// Current: RuleBasedScorer
// Future: MLModelScorer (ONNX/TFLite)
```

When implementing ML models, swap implementation via DI without changing domain contracts.

## Dependency Injection

Using `get_it` + `injectable`:

```dart
// Register services
@module
abstract class AppModule {
  @lazySingleton
  TextRecognizer get textRecognizer => TextRecognizer();

  @lazySingleton
  AppDatabase get database => AppDatabase();
}

// Injectable repositories and use cases
@LazySingleton(as: FeatureRepository)
class FeatureRepositoryImpl implements FeatureRepository { ... }

@lazySingleton
class GetEntity {
  final FeatureRepository repository;
  GetEntity(this.repository);
}
```

Run code generation after adding injectable annotations:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Code Quality Rules

1. **No business logic in UI layer** - all logic belongs in domain/data layers
2. **Domain layer is pure Dart** - no `package:flutter` imports in domain
3. **Use cases have single responsibility** - one action per use case
4. **All data mutations go through repository** - never access datasources directly from BLoC
5. **Ingredient DB is immutable** - app only reads, never writes to ingredient data
6. **Offline-first always** - no network dependencies, all features work without internet

## Project Initialization

If starting fresh:

```bash
# Create Flutter project
flutter create .

# Add dependencies to pubspec.yaml:
# - google_mlkit_text_recognition
# - drift
# - drift_dev (dev)
# - flutter_bloc
# - get_it
# - injectable
# - injectable_generator (dev)
# - build_runner (dev)
# - dartz

# Get dependencies
flutter pub get

# Setup initial structure
mkdir -p lib/core lib/features

# Run initial code generation
dart run build_runner build --delete-conflicting-outputs
```

## Performance Considerations

- OCR processing can be intensive - run on background isolate if needed
- DB queries should be indexed properly for ingredient matching
- Consider pagination for large result sets
- ML Kit models are optimized for on-device performance

## Localization

App is in Turkish ("saglik" = health), ensure all user-facing strings support Turkish locale.
