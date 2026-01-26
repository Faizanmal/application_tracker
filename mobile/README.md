# JobScouter Mobile

This is the Flutter mobile application for JobScouter, a comprehensive job application tracking platform.

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio or VS Code with Flutter extension
- iOS Simulator (macOS only) or Android Emulator

### Installation

1. Navigate to the mobile directory:
   ```bash
   cd mobile
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Set up your development environment:
   - For Android: Install Android Studio and create an emulator
   - For iOS: Install Xcode (macOS only)

4. Run the app:
   ```bash
   flutter run
   ```

### Building for Production

#### Android APK
```bash
flutter build apk --release
```

#### iOS (macOS only)
```bash
flutter build ios --release
```

## Features

- Job application tracking
- Interview management
- Reminder notifications
- Analytics dashboard
- Offline support
- Cross-platform (iOS, Android)

## Tech Stack

- Flutter
- Dart
- Provider for state management
- HTTP for API calls
- SQLite for local storage

## Project Structure

- `lib/` - Main application code
  - `core/` - Core utilities and configurations
  - `data/` - Data layer (models, repositories)
  - `providers/` - State management
  - `ui/` - UI components and screens
- `android/` - Android-specific code
- `ios/` - iOS-specific code
- `assets/` - Images, fonts, and other assets

## Testing

Run tests with:
```bash
flutter test
```

## Contributing

1. Follow Flutter best practices
2. Write tests for new features
3. Update documentation as needed

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
