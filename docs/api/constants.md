# Constants API

Application constants and configuration values.

## App Constants

**Location**: `lib/constants/app_constants.dart`

### App Information

```dart
class AppConstants {
  static const String appName = 'StackSave';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '100';
}
```

---

## Blockchain Constants

**Location**: `lib/constants/blockchain_constants.dart`

### Contract Addresses

```dart
class ContractAddresses {
  // Ethereum Mainnet
  static const String stackSaveMainnet = '0xABCD...EF01';
  static const String usdcMainnet = '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';

  // Polygon (when available)
  static const String stackSavePolygon = '0xABCD...EF01';
  static const String usdcPolygon = '0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174';

  // Testnet (Goerli)
  static const String stackSaveGoerli = '0xTEST...ADDR';
  static const String usdcGoerli = '0xTEST...USDC';
}
```

### Network Configuration

```dart
class NetworkConfig {
  static const int ethereumMainnet = 1;
  static const int goerli = 5;
  static const int polygon = 137;
  static const int mumbai = 80001;
  static const int bsc = 56;
  static const int arbitrum = 42161;

  static const String ethereumMainnetRpc = 'https://mainnet.infura.io/v3/...';
  static const String goerliRpc = 'https://goerli.infura.io/v3/...';
  static const String polygonRpc = 'https://polygon-rpc.com';
  static const String mumbaiRpc = 'https://rpc-mumbai.maticvigil.com';

  static String getRpcUrl(int chainId) {
    switch (chainId) {
      case ethereumMainnet:
        return ethereumMainnetRpc;
      case goerli:
        return goerliRpc;
      case polygon:
        return polygonRpc;
      case mumbai:
        return mumbaiRpc;
      default:
        return ethereumMainnetRpc;
    }
  }

  static String getNetworkName(int chainId) {
    switch (chainId) {
      case ethereumMainnet:
        return 'Ethereum Mainnet';
      case goerli:
        return 'Goerli Testnet';
      case polygon:
        return 'Polygon';
      case mumbai:
        return 'Mumbai Testnet';
      default:
        return 'Unknown Network';
    }
  }
}
```

### Gas Configuration

```dart
class GasConfig {
  static const int defaultGasLimit = 200000;
  static const int depositGasLimit = 150000;
  static const int withdrawGasLimit = 100000;
  static const int createGoalGasLimit = 250000;

  static const double gasBufferMultiplier = 1.2; // 20% buffer
}
```

---

## UI Constants

**Location**: `lib/constants/ui_constants.dart`

### Colors

```dart
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF00D09E);
  static const Color primaryDark = Color(0xFF00B089);
  static const Color primaryLight = Color(0xFF33DCAF);

  // Secondary colors
  static const Color secondary = Color(0xFF2E3A59);
  static const Color accent = Color(0xFFFFB800);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Neutral colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFBDBDBD);

  // Category colors
  static const Map<GoalCategory, Color> categoryColors = {
    GoalCategory.emergency: Color(0xFFE53935),
    GoalCategory.vacation: Color(0xFF1E88E5),
    GoalCategory.education: Color(0xFF43A047),
    GoalCategory.home: Color(0xFFFB8C00),
    GoalCategory.car: Color(0xFF8E24AA),
    GoalCategory.wedding: Color(0xFFD81B60),
    GoalCategory.investment: Color(0xFF00897B),
    GoalCategory.retirement: Color(0xFF3949AB),
    GoalCategory.gift: Color(0xFFF4511E),
    GoalCategory.other: Color(0xFF757575),
  };
}
```

### Typography

```dart
class AppTypography {
  static const String fontFamily = 'Inter';

  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
  );
}
```

### Spacing

```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
```

### Border Radius

```dart
class AppBorderRadius {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double round = 999.0;
}
```

---

## API Constants

**Location**: `lib/constants/api_constants.dart`

### Endpoints

```dart
class ApiEndpoints {
  static const String baseUrl = 'https://api.stacksave.io';

  static const String goals = '/api/v1/goals';
  static const String transactions = '/api/v1/transactions';
  static const String notifications = '/api/v1/notifications';
  static const String analytics = '/api/v1/analytics';
}
```

### Timeouts

```dart
class ApiTimeouts {
  static const Duration connect = Duration(seconds: 30);
  static const Duration receive = Duration(seconds: 30);
  static const Duration send = Duration(seconds: 30);
}
```

---

## Storage Constants

**Location**: `lib/constants/storage_constants.dart`

### Storage Keys

```dart
class StorageKeys {
  // Wallet
  static const String walletAddress = 'wallet_address';
  static const String walletSession = 'wallet_session';
  static const String chainId = 'chain_id';

  // User preferences
  static const String isDarkMode = 'is_dark_mode';
  static const String language = 'language';
  static const String currency = 'currency';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String biometricEnabled = 'biometric_enabled';

  // Data
  static const String goals = 'goals';
  static const String transactions = 'transactions';
  static const String notifications = 'notifications';

  // App state
  static const String lastSyncTime = 'last_sync_time';
  static const String onboardingCompleted = 'onboarding_completed';
}
```

---

## Validation Constants

**Location**: `lib/constants/validation_constants.dart`

### Limits

```dart
class ValidationLimits {
  // Goal
  static const int goalNameMinLength = 1;
  static const int goalNameMaxLength = 50;
  static const double goalMinAmount = 1.0;
  static const double goalMaxAmount = 1000000.0;

  // Transaction
  static const double minDeposit = 1.0;
  static const double maxDeposit = 100000.0;
  static const double minWithdrawal = 1.0;

  // USDC decimals
  static const int usdcDecimals = 6;
}
```

### Patterns

```dart
class ValidationPatterns {
  static final RegExp ethereumAddress = RegExp(r'^0x[a-fA-F0-9]{40}$');
  static final RegExp transactionHash = RegExp(r'^0x[a-fA-F0-9]{64}$');
  static final RegExp amount = RegExp(r'^\d+(\.\d{1,6})?$');
}
```

---

## Time Constants

**Location**: `lib/constants/time_constants.dart`

```dart
class TimeConstants {
  // Durations
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration transactionTimeout = Duration(minutes: 5);
  static const Duration blockchainPollInterval = Duration(seconds: 2);
  static const Duration notificationDismissDelay = Duration(seconds: 5);

  // Refresh intervals
  static const Duration balanceRefreshInterval = Duration(seconds: 30);
  static const Duration goalsRefreshInterval = Duration(minutes: 1);

  // Blockchain
  static const int requiredConfirmations = 12;
  static const int ethereumBlockTime = 15; // seconds
}
```

---

## Feature Flags

**Location**: `lib/constants/feature_flags.dart`

```dart
class FeatureFlags {
  // Network support
  static const bool polygonEnabled = false;
  static const bool bscEnabled = false;
  static const bool arbitrumEnabled = false;

  // Features
  static const bool automatedSavingsEnabled = false;
  static const bool interestEarningEnabled = false;
  static const bool socialFeaturesEnabled = false;
  static const bool analyticsEnabled = true;
  static const bool crashReportingEnabled = true;

  // Development
  static const bool debugMode = false;
  static const bool mockWalletEnabled = false;
  static const bool testnetMode = false;
}
```

---

## Error Messages

**Location**: `lib/constants/error_messages.dart`

```dart
class ErrorMessages {
  // Wallet
  static const String walletNotConnected = 'Please connect your wallet';
  static const String walletConnectionFailed = 'Failed to connect wallet';
  static const String wrongNetwork = 'Please switch to the correct network';

  // Transactions
  static const String insufficientBalance = 'Insufficient USDC balance';
  static const String insufficientGas = 'Insufficient ETH for gas fees';
  static const String transactionFailed = 'Transaction failed';
  static const String transactionCancelled = 'Transaction cancelled';

  // Goals
  static const String goalNotFound = 'Goal not found';
  static const String goalNameRequired = 'Goal name is required';
  static const String invalidTargetAmount = 'Invalid target amount';

  // Network
  static const String networkError = 'Network connection error';
  static const String timeoutError = 'Request timed out';

  // Generic
  static const String unknownError = 'An unknown error occurred';
}
```

---

## Success Messages

**Location**: `lib/constants/success_messages.dart`

```dart
class SuccessMessages {
  static const String walletConnected = 'Wallet connected successfully';
  static const String goalCreated = 'Goal created successfully';
  static const String depositSuccess = 'Deposit successful';
  static const String withdrawalSuccess = 'Withdrawal successful';
  static const String goalCompleted = 'Congratulations! Goal completed';
}
```

---

## Routes

**Location**: `lib/constants/routes.dart`

```dart
class Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String addGoal = '/add-goal';
  static const String goalDetails = '/goal-details';
  static const String portfolio = '/portfolio';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String settings = '/settings';
}
```

---

## Usage Examples

### Using Constants

```dart
// Colors
Container(
  color: AppColors.primary,
  child: Text(
    'StackSave',
    style: AppTypography.heading1.copyWith(
      color: AppColors.surface,
    ),
  ),
)

// Spacing
Padding(
  padding: EdgeInsets.all(AppSpacing.md),
  child: ...,
)

// Validation
if (amount < ValidationLimits.minDeposit) {
  throw Exception('Amount too small');
}

// Network
final rpcUrl = NetworkConfig.getRpcUrl(NetworkConfig.ethereumMainnet);
```

### Environment-Based Configuration

```dart
class Config {
  static bool get isProduction => !FeatureFlags.debugMode;
  static String get apiUrl => isProduction
      ? 'https://api.stacksave.io'
      : 'https://api-dev.stacksave.io';
}
```

---

## Next Steps

- [Services API](services.md) - Backend services
- [Models API](models.md) - Data models
- [Widgets API](widgets.md) - UI components

---

Need help? Check [Development Guide](../development/setup.md) or [FAQ](../resources/faq.md).
