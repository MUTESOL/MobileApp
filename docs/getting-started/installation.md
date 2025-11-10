# Installation

This guide will help you set up StackSave for development or personal use.

## Prerequisites

Before you begin, ensure you have the following installed:

### Required Software

1. **Flutter SDK** (version 3.9.2 or higher)
   - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
   - Follow the installation guide for your operating system

2. **Dart SDK** (included with Flutter)
   - Automatically installed with Flutter

3. **IDE** (choose one)
   - **Android Studio** - Recommended for Android development
   - **VS Code** with Flutter extension
   - **IntelliJ IDEA** with Flutter plugin

### Platform-Specific Requirements

#### For Android Development
- Android Studio 2022.1 or later
- Android SDK (API level 21 or higher)
- Java Development Kit (JDK) 11 or higher
- Android device or emulator

#### For iOS Development (macOS only)
- Xcode 14.0 or later
- CocoaPods
- iOS device or simulator
- Apple Developer account (for physical device testing)

### Web3 Requirements

- A crypto wallet app on your phone:
  - MetaMask Mobile
  - Trust Wallet
  - Rainbow Wallet
  - Or any WalletConnect-compatible wallet

## Installation Steps

### 1. Verify Flutter Installation

Open a terminal and run:

```bash
flutter doctor
```

This command checks your environment and displays a report. Ensure all required components show a checkmark (✓).

### 2. Clone the Repository

```bash
git clone https://github.com/MUT-TANT/MobileApp.git
cd stacksave
```

> **Note:** If you want to try the app through our GitHub repo, please use the **main** branch for the stable version.

### 3. Install Dependencies

```bash
flutter pub get
```

This downloads all required packages defined in `pubspec.yaml`.

### 4. Configure WalletConnect (Optional)

StackSave uses WalletConnect V2. The default configuration should work, but you can customize:

1. Get a free project ID from [WalletConnect Cloud](https://cloud.walletconnect.com/)
2. Update the project ID in your code (in the wallet connection screen)

### 5. Verify Installation

Run the app in debug mode:

```bash
flutter run
```

If you have multiple devices/emulators, select the target:

```bash
flutter devices  # List available devices
flutter run -d <device-id>  # Run on specific device
```

## Platform-Specific Setup

### Android Setup

1. **Enable USB Debugging** on your Android device:
   - Settings → About Phone → Tap "Build Number" 7 times
   - Settings → Developer Options → Enable USB Debugging

2. **Connect your device** via USB and verify:
   ```bash
   flutter devices
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

### iOS Setup (macOS only)

1. **Install CocoaPods**:
   ```bash
   sudo gem install cocoapods
   ```

2. **Install iOS dependencies**:
   ```bash
   cd ios
   pod install
   cd ..
   ```

3. **Open Xcode** and sign the app:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select your development team under "Signing & Capabilities"

4. **Run the app**:
   ```bash
   flutter run -d iPhone
   ```

## Troubleshooting

### Common Issues

#### "Flutter command not found"
- Add Flutter to your PATH:
  ```bash
  export PATH="$PATH:`pwd`/flutter/bin"
  ```
- Or follow Flutter's [PATH setup guide](https://flutter.dev/docs/get-started/install)

#### "SDK version mismatch"
- Update Flutter:
  ```bash
  flutter upgrade
  ```

#### "Gradle build failed" (Android)
- Clean the build:
  ```bash
  flutter clean
  flutter pub get
  cd android && ./gradlew clean && cd ..
  flutter run
  ```

#### "CocoaPods not installed" (iOS)
- Install CocoaPods:
  ```bash
  sudo gem install cocoapods
  pod setup
  ```

#### Dependencies won't install
- Clear pub cache:
  ```bash
  flutter pub cache repair
  flutter pub get
  ```

## Verify Installation

After successful installation, you should see:
- ✅ Splash screen with StackSave logo
- ✅ Onboarding/launch screen
- ✅ "Connect Wallet" button

## Next Steps

- [Quick Start Guide](quick-start.md) - Learn the basics
- [Connecting Your Wallet](connecting-wallet.md) - Set up WalletConnect
- [Creating Your First Goal](first-goal.md) - Start saving

## Getting Help

If you encounter issues:
- Check [Troubleshooting](../resources/troubleshooting.md)
- Review [FAQ](../resources/faq.md)
- Open an [issue on GitHub](https://github.com/yourusername/stacksave/issues)
