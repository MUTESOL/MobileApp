# Project Structure

Understanding StackSave's codebase organization and architecture.

## Directory Overview

```
stacksave/
├── android/                 # Android native code
├── ios/                     # iOS native code
├── lib/                     # Main application code
│   ├── constants/          # App-wide constants
│   ├── models/             # Data models
│   ├── screens/            # UI screens/pages
│   ├── services/           # Business logic & APIs
│   ├── widgets/            # Reusable UI components
│   └── main.dart           # App entry point
├── design/                  # Image assets
├── fonts/                   # Custom fonts
├── docs/                    # Documentation (GitBook)
├── test/                    # Unit and widget tests
├── web/                     # Web platform support
├── windows/                 # Windows desktop support
├── linux/                   # Linux desktop support
├── macos/                   # macOS desktop support
└── pubspec.yaml            # Dependencies configuration
```

## Core Directories

### `/lib` - Application Code

The heart of StackSave. All Dart/Flutter code lives here.

#### `/lib/constants`
App-wide constant values:
- **colors.dart**: Color palette and theme colors
- Future: API endpoints, configuration values

**Example** (colors.dart):
```dart
class AppColors {
  static const Color primary = Color(0xFF00D09E);
  static const Color background = Color(0xFFF5F5F5);
  // ...
}
```

#### `/lib/models`
Data structures and business entities:
- **notification_model.dart**: Notification data structure

**Purpose**: Define shape of data used throughout app

**Example**:
```dart
class NotificationModel {
  final NotificationType type;
  final String title;
  final String description;
  final DateTime dateTime;
  // ...
}
```

#### `/lib/screens`
Full-page UI components (one screen = one file):

| File | Purpose |
|------|---------|
| `launch_a_screen.dart` | Splash screen with logo |
| `launch_b_screen.dart` | Onboarding/welcome screen |
| `home_screen.dart` | Main dashboard |
| `add_goals_screen.dart` | Create new savings goal |
| `add_saving_screen.dart` | Deposit to existing goal |
| `portfolio_screen.dart` | View all goals overview |
| `profile_screen.dart` | User profile & settings |
| `notification_screen.dart` | Notifications list |
| `withdraw_screen.dart` | Withdraw from goals |
| `main_navigation.dart` | Bottom navigation wrapper |

**Navigation**: Screens navigate between each other using `Navigator.push()`.

#### `/lib/services`
Business logic and external integrations:
- **wallet_service.dart**: WalletConnect V2 integration

**Purpose**: Separate business logic from UI

**Pattern**: Services use ChangeNotifier for state management

**Example**:
```dart
class WalletService extends ChangeNotifier {
  String? _walletAddress;

  Future<void> connectWallet() async {
    // Connection logic
    notifyListeners(); // Update UI
  }
}
```

#### `/lib/widgets`
Reusable UI components used across multiple screens:
- Custom buttons
- Goal cards
- Progress bars
- Common layouts

**Purpose**: DRY principle - write once, use everywhere

#### `/lib/main.dart`
Application entry point:
- App initialization
- Provider setup
- Root widget configuration
- Theme setup

**Key code** (main.dart:8-17):
```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletService()),
      ],
      child: const MyApp(),
    ),
  );
}
```

### `/design` - Assets

Visual assets used in the app:
- `logo-stacksave.png` - Main logo
- `logo-white.png` - Light theme logo
- `fire.png` - Streak icon
- `Car.png`, `Salary.png`, `Group.png` - Goal category icons

**Usage**:
```dart
Image.asset('design/logo-stacksave.png')
```

### `/fonts` - Typography

Custom Poppins font family:
- `Poppins-Regular.ttf` - Normal weight (400)
- `Poppins-Medium.ttf` - Medium weight (500)
- `Poppins-SemiBold.ttf` - Semi-bold weight (600)
- `Poppins-Bold.ttf` - Bold weight (700)

**Configuration** (pubspec.yaml:92-100):
```yaml
fonts:
  - family: Poppins
    fonts:
      - asset: fonts/Poppins-Regular.ttf
      - asset: fonts/Poppins-Medium.ttf
        weight: 500
      # ...
```

### `/test` - Tests

Unit tests, widget tests, and integration tests:
- `widget_test.dart` - Widget tests
- Future: Service tests, model tests, integration tests

**Run tests**:
```bash
flutter test
```

### `/docs` - Documentation

GitBook documentation (this documentation):
- Organized by topic
- Markdown format
- Linked via SUMMARY.md

## File Naming Conventions

### Dart Files
- **Snake case**: `my_file_name.dart`
- **Descriptive**: `add_goals_screen.dart` not `screen1.dart`
- **Suffixed**: `_screen.dart`, `_service.dart`, `_model.dart`

### Classes
- **Pascal case**: `MyClassName`
- **Matches file**: File `wallet_service.dart` contains `WalletService`

### Assets
- **Descriptive names**: `logo-stacksave.png`
- **Lowercase with hyphens**: `my-asset-name.png`

## Architecture Patterns

### MVVM-like Structure

```
┌──────────┐
│  Screen  │ ← UI Layer (Views)
└────┬─────┘
     │ uses
┌────▼─────┐
│ Service  │ ← Business Logic (ViewModels)
└────┬─────┘
     │ uses
┌────▼─────┐
│  Model   │ ← Data Layer (Models)
└──────────┘
```

### Separation of Concerns

| Layer | Responsibility | Examples |
|-------|---------------|----------|
| **Screens** | Display UI, handle user input | HomeScreen, ProfileScreen |
| **Services** | Business logic, API calls | WalletService |
| **Models** | Data structures | NotificationModel |
| **Widgets** | Reusable UI components | Custom buttons, cards |

### State Management

**Provider pattern**:
1. Services extend `ChangeNotifier`
2. Registered in `MultiProvider` at app root
3. Screens use `Provider.of<T>()` or `context.watch<T>()`
4. Services call `notifyListeners()` to trigger UI updates

**Example flow**:
```dart
// 1. Service changes state
class WalletService extends ChangeNotifier {
  void connect() {
    _isConnected = true;
    notifyListeners(); // Triggers rebuild
  }
}

// 2. Screen listens
final walletService = Provider.of<WalletService>(context);
if (walletService.isConnected) {
  // Show connected UI
}
```

## Key Design Decisions

### Why Flutter?

- **Cross-platform**: iOS and Android from one codebase
- **Fast development**: Hot reload, rich widgets
- **Performance**: Native compiled code
- **Community**: Large ecosystem, packages

### Why Provider?

- **Simple**: Easy to understand and implement
- **Efficient**: Only rebuilds affected widgets
- **Standard**: Recommended by Flutter team
- **Lightweight**: No heavy dependencies

### Why WalletConnect V2?

- **Standard**: Industry-standard wallet protocol
- **Compatible**: 200+ wallets supported
- **Secure**: End-to-end encrypted
- **Maintained**: Active development, good docs

## Code Organization Best Practices

### Screen Structure

Typical screen file structure:
```dart
// 1. Imports
import 'package:flutter/material.dart';

// 2. Screen widget (StatefulWidget or StatelessWidget)
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

// 3. State class
class _MyScreenState extends State<MyScreen> {
  // State variables

  @override
  void initState() {
    // Initialization
  }

  @override
  Widget build(BuildContext context) {
    // UI tree
  }

  // Helper methods
}
```

### Service Structure

Typical service file structure:
```dart
// 1. Imports
import 'package:flutter/foundation.dart';

// 2. Service class
class MyService extends ChangeNotifier {
  // Private state
  String? _data;

  // Public getters
  String? get data => _data;

  // Public methods
  Future<void> fetchData() async {
    // Logic
    notifyListeners();
  }

  // Private helpers
  void _helper() {
    // ...
  }
}
```

## Dependencies

### Main Dependencies

From `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8      # iOS style icons
  reown_appkit: ^1.7.3         # WalletConnect V2
  provider: ^6.1.2             # State management
  intl: ^0.20.2                # Date formatting
  image_picker: ^1.0.7         # Profile photo picker
```

### Dev Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0        # Code quality
```

## Build Configuration

### Version

From `pubspec.yaml`:
```yaml
version: 1.0.0+1
# Format: MAJOR.MINOR.PATCH+BUILD_NUMBER
```

### SDK Constraints

```yaml
environment:
  sdk: ^3.9.2
```

### Asset Registration

```yaml
flutter:
  uses-material-design: true
  assets:
    - design/logo-stacksave.png
    - design/logo-white.png
    # ... more assets
```

## Navigation Flow

### App Navigation Graph

```
LaunchAScreen (Splash)
    ↓ (auto after 2s)
LaunchBScreen (Onboarding)
    ↓ (user: Connect Wallet)
HomeScreen ←→ Portfolio ←→ Profile
    ↓
  [Various Action Screens]
    ├─ AddGoalsScreen
    ├─ AddSavingScreen
    ├─ WithdrawScreen
    └─ NotificationScreen
```

### Navigation Implementation

**Stack-based navigation** using Flutter Navigator:
- Push new screens onto stack
- Pop to return to previous screen
- Replace to substitute current screen

**Example** (main.dart:60-64):
```dart
Navigator.of(context).pushReplacement(
  MaterialPageRoute(
    builder: (context) => const LaunchBScreen(),
  ),
);
```

## Platform-Specific Code

### Android (`/android`)
- Gradle build configuration
- AndroidManifest.xml
- Native integrations

### iOS (`/ios`)
- Xcode project
- Info.plist
- CocoaPods configuration

### Shared Logic
Most code in `/lib` works across all platforms thanks to Flutter's abstraction.

## Next Steps

- [State Management](state-management.md) - Deep dive into Provider
- [Navigation Flow](navigation.md) - Detailed navigation patterns
- [Data Models](data-models.md) - Model structure and usage

---

**Related**: [API Reference](../api/services.md) | [Development Setup](../development/setup.md)
