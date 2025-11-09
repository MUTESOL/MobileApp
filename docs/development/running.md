# Running the App

Learn how to run StackSave in development mode.

## Quick Start

```bash
# Run on connected device
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in debug mode (default)
flutter run --debug

# Run in profile mode
flutter run --profile

# Run in release mode
flutter run --release
```

---

## Device Selection

### List Devices

```bash
flutter devices
```

Output:
```
2 connected devices:

iPhone 14 Pro (mobile) • iOS 16.0
Chrome (web)           • chrome
```

### Run on Specific Device

```bash
# iOS Simulator
flutter run -d "iPhone 14 Pro"

# Android Emulator
flutter run -d emulator-5554

# Web
flutter run -d chrome

# Physical device
flutter run -d <device-id>
```

---

## Development Modes

### Debug Mode

Best for development with hot reload.

```bash
flutter run --debug
```

**Features**:
- Hot reload (press `r`)
- Hot restart (press `R`)
- Debug painting
- Performance overlay
- Inspector tools

### Profile Mode

Test performance without debug overhead.

```bash
flutter run --profile
```

**Features**:
- Performance profiling
- No debug assertions
- Some optimizations enabled

### Release Mode

Production-like build.

```bash
flutter run --release
```

**Features**:
- Full optimizations
- No debugging tools
- Smaller app size

---

## Hot Reload

### Using Hot Reload

While app is running, make code changes and press:
- `r` - Hot reload
- `R` - Hot restart
- `q` - Quit

**Example**:
1. Run `flutter run`
2. Edit `lib/screens/home_screen.dart`
3. Press `r` in terminal
4. See changes instantly!

### When to Use Hot Restart

Hot reload doesn't work for:
- Changes to `main()`
- Changes to global variables
- Changes to `initState()`
- Adding new files

Use hot restart (`R`) for these cases.

---

## Running on Different Platforms

### Android

**Emulator**:
```bash
# Start emulator
flutter emulators --launch <emulator-id>

# Run app
flutter run
```

**Physical Device**:
1. Enable USB debugging on device
2. Connect via USB
3. Run `flutter run`

### iOS (macOS only)

**Simulator**:
```bash
# Start simulator
open -a Simulator

# Run app
flutter run
```

**Physical Device**:
1. Connect iPhone via USB
2. Trust computer on device
3. Run `flutter run`

### Web

```bash
# Run in Chrome
flutter run -d chrome

# Specify port
flutter run -d chrome --web-port=8080
```

Access at: `http://localhost:8080`

---

## Environment Variables

### Pass Environment Variables

```bash
flutter run --dart-define=ENV=dev
flutter run --dart-define=API_KEY=your_key
```

**In Code**:
```dart
const env = String.fromEnvironment('ENV', defaultValue: 'prod');
const apiKey = String.fromEnvironment('API_KEY');
```

---

## Debugging

### Enable Debug Features

```bash
# Enable performance overlay
flutter run --enable-software-rendering

# Start with debug banner
flutter run --debug
```

### Debug in IDE

**VS Code**:
1. Open `Run and Debug` (Ctrl+Shift+D)
2. Select device
3. Press F5

**Android Studio**:
1. Select device from dropdown
2. Click Run button (▶)
3. Or press Shift+F10

---

## Common Issues

### Port Already in Use (Web)

```bash
flutter run -d chrome --web-port=8081
```

### Device Not Found

```bash
# Verify device connection
flutter devices

# Restart adb (Android)
adb kill-server
adb start-server

# Restart simulator (iOS)
killall Simulator
open -a Simulator
```

### Build Failed

```bash
flutter clean
flutter pub get
flutter run
```

---

## Development Tools

### Flutter Inspector

```bash
# Run with DevTools
flutter run --observatory-port=8888
```

Open DevTools at: `http://localhost:8888`

### Performance Overlay

Press `P` while app is running to toggle performance overlay.

### Widget Inspector

Press `I` to toggle widget inspector.

---

## Next Steps

- [Building for Production](building.md)
- [Testing](testing.md)
- [Development Setup](setup.md)
