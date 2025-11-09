# Services API

StackSave services provide core functionality for wallet management, blockchain interaction, and data persistence.

## WalletService

Main service for wallet connection and blockchain operations.

**Location**: `lib/services/wallet_service.dart`

### Properties

```dart
class WalletService extends ChangeNotifier {
  // Connection state
  bool isConnected;
  String? walletAddress;
  double balance;

  // WalletConnect
  WalletConnect? connector;
  SessionStatus? session;

  // Network
  int chainId;
  String networkName;
}
```

### Methods

#### connectWallet()

Connect to user's wallet via WalletConnect.

```dart
Future<bool> connectWallet() async
```

**Returns**: `bool` - `true` if connection successful

**Throws**:
- `WalletConnectionException` - If connection fails
- `UserRejectionException` - If user rejects connection

**Example**:
```dart
final walletService = Provider.of<WalletService>(context, listen: false);

try {
  final success = await walletService.connectWallet();
  if (success) {
    print('Connected: ${walletService.walletAddress}');
  }
} catch (e) {
  print('Connection failed: $e');
}
```

---

#### disconnect()

Disconnect wallet and clear session.

```dart
Future<void> disconnect() async
```

**Example**:
```dart
await walletService.disconnect();
```

---

#### getBalance()

Fetch USDC balance for connected wallet.

```dart
Future<double> getBalance() async
```

**Returns**: `double` - USDC balance

**Throws**: `NotConnectedException` - If wallet not connected

**Example**:
```dart
final balance = await walletService.getBalance();
print('Balance: $balance USDC');
```

---

#### sendTransaction()

Send a transaction to the blockchain.

```dart
Future<String> sendTransaction({
  required String to,
  required String data,
  String? value,
  int? gasLimit,
}) async
```

**Parameters**:
- `to` - Recipient address
- `data` - Transaction data (hex string)
- `value` - Amount to send (optional, hex string)
- `gasLimit` - Gas limit (optional)

**Returns**: `String` - Transaction hash

**Example**:
```dart
final txHash = await walletService.sendTransaction(
  to: '0x1234...',
  data: '0xabcd...',
  gasLimit: 100000,
);
```

---

### Events

Listen to wallet state changes:

```dart
walletService.addListener(() {
  if (walletService.isConnected) {
    print('Wallet connected!');
  }
});
```

---

## StorageService

Local data persistence service.

**Location**: `lib/services/storage_service.dart`

### Methods

#### saveGoal()

Save a savings goal locally.

```dart
Future<void> saveGoal(SavingsGoal goal) async
```

#### getGoals()

Retrieve all saved goals.

```dart
Future<List<SavingsGoal>> getGoals() async
```

#### updateGoal()

Update an existing goal.

```dart
Future<void> updateGoal(SavingsGoal goal) async
```

#### deleteGoal()

Delete a goal from local storage.

```dart
Future<void> deleteGoal(String goalId) async
```

**Example**:
```dart
final storage = StorageService();

// Save
await storage.saveGoal(myGoal);

// Retrieve
final goals = await storage.getGoals();

// Update
await storage.updateGoal(updatedGoal);

// Delete
await storage.deleteGoal('goal-123');
```

---

## NotificationService

Push notification management.

**Location**: `lib/services/notification_service.dart`

### Methods

#### initialize()

Initialize notification service.

```dart
Future<void> initialize() async
```

#### requestPermission()

Request notification permissions from user.

```dart
Future<bool> requestPermission() async
```

**Returns**: `bool` - `true` if permission granted

#### showNotification()

Display a local notification.

```dart
Future<void> showNotification({
  required String title,
  required String body,
  String? payload,
}) async
```

**Example**:
```dart
await notificationService.showNotification(
  title: 'Milestone Reached!',
  body: 'You\'ve saved 50% of your Emergency Fund',
  payload: 'goal-123',
);
```

#### scheduleMilestoneNotification()

Schedule a notification for goal milestone.

```dart
Future<void> scheduleMilestoneNotification({
  required String goalId,
  required double percentage,
}) async
```

---

## AnalyticsService

Track app usage and events.

**Location**: `lib/services/analytics_service.dart`

### Methods

#### logEvent()

Log an analytics event.

```dart
Future<void> logEvent(String name, [Map<String, dynamic>? parameters]) async
```

**Example**:
```dart
await analytics.logEvent('goal_created', {
  'goal_name': 'Emergency Fund',
  'target_amount': 10000,
});
```

#### setUserId()

Set user identifier for analytics.

```dart
Future<void> setUserId(String userId) async
```

#### logScreen()

Log screen view.

```dart
Future<void> logScreen(String screenName) async
```

---

## BlockchainService

Interact with smart contracts.

**Location**: `lib/services/blockchain_service.dart`

### Methods

#### createGoal()

Create a new savings goal on blockchain.

```dart
Future<String> createGoal({
  required String name,
  required double targetAmount,
  DateTime? deadline,
}) async
```

**Returns**: `String` - Transaction hash

#### deposit()

Deposit funds to a goal.

```dart
Future<String> deposit({
  required String goalId,
  required double amount,
}) async
```

#### withdraw()

Withdraw funds from a goal.

```dart
Future<String> withdraw({
  required String goalId,
  required double amount,
}) async
```

#### getGoalData()

Fetch goal data from blockchain.

```dart
Future<SavingsGoal> getGoalData(String goalId) async
```

**Example**:
```dart
final blockchain = BlockchainService();

// Create goal
final txHash = await blockchain.createGoal(
  name: 'Vacation',
  targetAmount: 5000,
  deadline: DateTime(2025, 12, 31),
);

// Deposit
await blockchain.deposit(goalId: 'goal-1', amount: 500);

// Fetch data
final goal = await blockchain.getGoalData('goal-1');
```

---

## BiometricService

Handle biometric authentication.

**Location**: `lib/services/biometric_service.dart`

### Methods

#### isAvailable()

Check if biometric authentication is available.

```dart
Future<bool> isAvailable() async
```

#### authenticate()

Authenticate user with biometrics.

```dart
Future<bool> authenticate({
  required String reason,
}) async
```

**Parameters**:
- `reason` - Reason shown to user

**Returns**: `bool` - `true` if authentication successful

**Example**:
```dart
final canUseBiometrics = await biometric.isAvailable();

if (canUseBiometrics) {
  final authenticated = await biometric.authenticate(
    reason: 'Authenticate to confirm withdrawal',
  );

  if (authenticated) {
    // Proceed with sensitive operation
  }
}
```

---

## Service Locator

Access services throughout the app.

### Setup

```dart
void setupServiceLocator() {
  final getIt = GetIt.instance;

  getIt.registerSingleton<WalletService>(WalletService());
  getIt.registerSingleton<StorageService>(StorageService());
  getIt.registerSingleton<NotificationService>(NotificationService());
  getIt.registerSingleton<AnalyticsService>(AnalyticsService());
  getIt.registerSingleton<BlockchainService>(BlockchainService());
  getIt.registerSingleton<BiometricService>(BiometricService());
}
```

### Usage

```dart
final walletService = GetIt.I<WalletService>();
final storage = GetIt.I<StorageService>();
```

---

## Error Handling

All services may throw exceptions. Always use try-catch:

```dart
try {
  await walletService.connectWallet();
} on WalletConnectionException catch (e) {
  print('Connection failed: ${e.message}');
} on UserRejectionException {
  print('User rejected connection');
} catch (e) {
  print('Unknown error: $e');
}
```

---

## Testing Services

### Mock Services

```dart
class MockWalletService extends Mock implements WalletService {}

void main() {
  test('connects wallet successfully', () async {
    final mockWallet = MockWalletService();

    when(mockWallet.connectWallet()).thenAnswer((_) async => true);
    when(mockWallet.isConnected).thenReturn(true);
    when(mockWallet.walletAddress).thenReturn('0x1234...');

    final result = await mockWallet.connectWallet();

    expect(result, true);
    expect(mockWallet.isConnected, true);
  });
}
```

---

## Next Steps

- [WalletService Details](wallet-service.md) - Complete WalletService API
- [Models](models.md) - Data models used by services
- [Constants](constants.md) - Configuration constants

---

Need help? Check [Development Guide](../development/setup.md) or [FAQ](../resources/faq.md).
