# Development Setup

Get your development environment ready for StackSave development.

## Prerequisites

### Required Software

- **Flutter SDK**: >= 3.0.0
- **Dart SDK**: >= 3.0.0 (comes with Flutter)
- **Git**: Latest version
- **IDE**: VS Code or Android Studio

### Platform-Specific

**For Android**:
- Android Studio
- Android SDK (API 21+)
- Java JDK 11+

**For iOS** (Mac only):
- Xcode 14+
- CocoaPods
- iOS 12.0+

---

## Installation

### 1. Install Flutter

**macOS/Linux**:
```bash
# Download Flutter
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

**Windows**:
1. Download Flutter SDK from [flutter.dev](https://flutter.dev)
2. Extract to `C:\src\flutter`
3. Add `C:\src\flutter\bin` to PATH
4. Run `flutter doctor`

### 2. Verify Installation

```bash
flutter doctor -v
```

Should show:
```
✓ Flutter (Channel stable, 3.x.x)
✓ Android toolchain
✓ Xcode (macOS only)
✓ Chrome
✓ VS Code / Android Studio
```

---

## Clone Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/stacksave.git
cd stacksave

# Install dependencies
flutter pub get
```

---

## Environment Setup

### 1. API Keys

Create `.env` file in project root:

```env
# Blockchain
INFURA_API_KEY=your_infura_key
ALCHEMY_API_KEY=your_alchemy_key

# WalletConnect
WALLETCONNECT_PROJECT_ID=your_project_id

# Analytics (optional)
FIREBASE_API_KEY=your_firebase_key
```

Get API keys from:
- Infura: [infura.io](https://infura.io)
- Alchemy: [alchemy.com](https://alchemy.com)
- WalletConnect: [cloud.walletconnect.com](https://cloud.walletconnect.com)

### 2. Configuration

Update `lib/config/env.dart`:

```dart
class Env {
  static const String infuraApiKey = String.fromEnvironment(
    'INFURA_API_KEY',
    defaultValue: '',
  );

  static const String walletConnectProjectId = String.fromEnvironment(
    'WALLETCONNECT_PROJECT_ID',
    defaultValue: '',
  );
}
```

---

## IDE Setup

### VS Code

**Install Extensions**:
- Flutter
- Dart
- GitLens
- Error Lens

**Settings** (`.vscode/settings.json`):
```json
{
  "dart.lineLength": 80,
  "editor.formatOnSave": true,
  "editor.rulers": [80],
  "[dart]": {
    "editor.defaultFormatter": "Dart-Code.dart-code"
  }
}
```

### Android Studio

1. Install Flutter plugin
2. Install Dart plugin
3. Configure Dart SDK path
4. Enable Dart Analysis

---

## Android Setup

### 1. Install Android Studio

Download from [developer.android.com](https://developer.android.com/studio)

### 2. Install SDK

```bash
# Open Android Studio
# Tools > SDK Manager
# Install:
- Android SDK Platform 33
- Android SDK Build-Tools
- Android Emulator
```

### 3. Accept Licenses

```bash
flutter doctor --android-licenses
```

### 4. Create Emulator

```bash
# List available devices
flutter emulators

# Create emulator
flutter emulators --create
```

---

## iOS Setup (macOS only)

### 1. Install Xcode

Download from Mac App Store

### 2. Install Command Line Tools

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

### 3. Install CocoaPods

```bash
sudo gem install cocoapods
```

### 4. Setup iOS Dependencies

```bash
cd ios
pod install
cd ..
```

---

## Web Setup

### Enable Web

```bash
flutter config --enable-web
```

### Install Chrome

Flutter uses Chrome for web development.

---

## Verify Setup

### Run Doctor

```bash
flutter doctor -v
```

All items should have ✓

### Test Run

```bash
# List devices
flutter devices

# Run on device
flutter run
```

---

## Troubleshooting

### Flutter Doctor Issues

**Android license not accepted**:
```bash
flutter doctor --android-licenses
```

**Xcode not properly installed**:
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

**CocoaPods issues**:
```bash
sudo gem install cocoapods
pod repo update
```

### Build Errors

**Pub get failed**:
```bash
flutter clean
flutter pub get
```

**Gradle issues**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
```

---

## Next Steps

- [Running the App](running.md)
- [Building for Production](building.md)
- [Code Style Guide](code-style.md)

---

Need help? Check [FAQ](../resources/faq.md) or [Troubleshooting](../resources/troubleshooting.md).
