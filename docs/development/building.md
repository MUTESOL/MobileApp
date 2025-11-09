# Building for Production

Build StackSave for distribution on Android, iOS, and Web.

## Build Commands

### Android

```bash
# Build APK (debug)
flutter build apk --debug

# Build APK (release)
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release

# Build specific flavor
flutter build apk --flavor production --release
```

### iOS

```bash
# Build for iOS (creates .app)
flutter build ios --release

# Build IPA for distribution
flutter build ipa --release

# Build for specific configuration
flutter build ios --release --no-codesign
```

### Web

```bash
# Build for web
flutter build web --release

# Build with base href
flutter build web --base-href /stacksave/

# Build for specific renderer
flutter build web --web-renderer canvaskit
```

---

## Android Release

### 1. Create Keystore

```bash
keytool -genkey -v -keystore ~/stacksave-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias stacksave
```

### 2. Configure Signing

Create `android/key.properties`:
```
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=stacksave
storeFile=../stacksave-key.jks
```

Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 3. Build Release

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## iOS Release

### 1. Configure Signing

In Xcode:
1. Open `ios/Runner.xcworkspace`
2. Select Runner target
3. Signing & Capabilities tab
4. Select your team
5. Enable "Automatically manage signing"

### 2. Update Version

In `pubspec.yaml`:
```yaml
version: 1.0.0+1  # version+build_number
```

### 3. Build Archive

```bash
flutter build ipa --release
```

Or in Xcode:
1. Product > Archive
2. Wait for archive
3. Distribute App

---

## Build Configuration

### Version Numbers

**Update in `pubspec.yaml`**:
```yaml
version: 1.0.0+1
# Format: major.minor.patch+build
```

**Version Codes**:
- `1.0.0` - User-facing version
- `+1` - Build number (increment each build)

### App Icons

**Generate icons**:
```bash
# Install flutter_launcher_icons
flutter pub add dev:flutter_launcher_icons

# Configure in pubspec.yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"

# Generate
flutter pub run flutter_launcher_icons
```

### Splash Screen

**Using flutter_native_splash**:
```bash
flutter pub add dev:flutter_native_splash
```

Configure in `pubspec.yaml`:
```yaml
flutter_native_splash:
  color: "#00D09E"
  image: assets/splash/splash.png
  android: true
  ios: true
```

Generate:
```bash
flutter pub run flutter_native_splash:create
```

---

## Obfuscation

### Enable Code Obfuscation

```bash
flutter build apk --obfuscate --split-debug-info=build/app/outputs/symbols

flutter build ipa --obfuscate --split-debug-info=build/ios/outputs/symbols
```

**Benefits**:
- Protects source code
- Reduces app size
- Maintains stack traces with symbols

---

## Build Optimization

### Reduce App Size

```bash
# Split APKs by ABI
flutter build apk --split-per-abi --release

# Enable ProGuard (Android)
# In android/app/build.gradle:
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    }
}
```

### Tree Shaking

Automatically enabled in release builds.

Remove unused code:
```bash
flutter build apk --release --tree-shake-icons
```

---

## CI/CD

### GitHub Actions

Create `.github/workflows/build.yml`:
```yaml
name: Build

on:
  push:
    branches: [ main ]

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk --release

  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter build ios --release --no-codesign
```

---

## Distribution

### Android

**Google Play Console**:
1. Upload `.aab` file
2. Fill in store listing
3. Set pricing & distribution
4. Submit for review

### iOS

**App Store Connect**:
1. Upload `.ipa` via Xcode or Transporter
2. Complete App Information
3. Submit for review

### Web

**Deploy to hosting**:
```bash
# Build
flutter build web --release

# Deploy build/web/ folder to:
# - Firebase Hosting
# - Netlify
# - Vercel
# - GitHub Pages
```

---

## Build Troubleshooting

### Android Build Fails

```bash
# Clean and rebuild
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

### iOS Build Fails

```bash
# Clean iOS build
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter clean
flutter build ios
```

### Web Build Issues

```bash
# Clear web cache
flutter clean
rm -rf build/web
flutter build web --release
```

---

## Next Steps

- [Testing](testing.md)
- [Development Setup](setup.md)
- [Code Style](code-style.md)
