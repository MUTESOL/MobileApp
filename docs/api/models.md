# Models API

Complete reference for all data models in StackSave.

## SavingsGoal

Represents a user's savings goal.

**Location**: `lib/models/savings_goal.dart`

### Constructor

```dart
SavingsGoal({
  required String id,
  required String name,
  required double targetAmount,
  double currentAmount = 0.0,
  DateTime? deadline,
  GoalCategory category = GoalCategory.other,
  required DateTime createdAt,
  bool isActive = true,
})
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Unique goal identifier |
| `name` | `String` | User-friendly goal name |
| `targetAmount` | `double` | Target savings amount (USDC) |
| `currentAmount` | `double` | Current saved amount (USDC) |
| `deadline` | `DateTime?` | Optional target deadline |
| `category` | `GoalCategory` | Goal category |
| `createdAt` | `DateTime` | Creation timestamp |
| `isActive` | `bool` | Whether goal is active |

### Computed Properties

```dart
double get progress              // 0.0 to 1.0
double get percentageComplete    // 0 to 100
double get remainingAmount       // Amount left to reach target
bool get isCompleted            // Whether target is reached
bool get isOverdue              // Whether past deadline
int? get daysRemaining          // Days until deadline
```

### Methods

#### toJson()

Serialize to JSON.

```dart
Map<String, dynamic> toJson()
```

#### fromJson()

Deserialize from JSON.

```dart
factory SavingsGoal.fromJson(Map<String, dynamic> json)
```

#### copyWith()

Create a copy with modified properties.

```dart
SavingsGoal copyWith({
  String? id,
  String? name,
  double? targetAmount,
  double? currentAmount,
  DateTime? deadline,
  GoalCategory? category,
  DateTime? createdAt,
  bool? isActive,
})
```

### Example

```dart
final goal = SavingsGoal(
  id: 'goal-123',
  name: 'Emergency Fund',
  targetAmount: 10000,
  currentAmount: 5000,
  deadline: DateTime(2025, 12, 31),
  category: GoalCategory.emergency,
  createdAt: DateTime.now(),
);

print(goal.progress);           // 0.5
print(goal.percentageComplete); // 50.0
print(goal.isCompleted);        // false

// Update
final updated = goal.copyWith(currentAmount: 10000);
print(updated.isCompleted);     // true
```

---

## Transaction

Represents a blockchain transaction.

**Location**: `lib/models/transaction.dart`

### Constructor

```dart
Transaction({
  required String id,
  required String hash,
  required TransactionType type,
  required double amount,
  required String goalId,
  required DateTime timestamp,
  TransactionStatus status = TransactionStatus.pending,
  double? gasFee,
  String? errorMessage,
})
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Transaction ID |
| `hash` | `String` | Blockchain transaction hash |
| `type` | `TransactionType` | Deposit or withdrawal |
| `amount` | `double` | Transaction amount |
| `goalId` | `String` | Associated goal ID |
| `timestamp` | `DateTime` | Transaction time |
| `status` | `TransactionStatus` | Current status |
| `gasFee` | `double?` | Gas fee paid (optional) |
| `errorMessage` | `String?` | Error if failed (optional) |

### Enums

```dart
enum TransactionType {
  deposit,
  withdrawal,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
}
```

### Computed Properties

```dart
bool get isPending
bool get isCompleted
bool get isFailed
```

### Example

```dart
final tx = Transaction(
  id: 'tx-456',
  hash: '0xabcd...',
  type: TransactionType.deposit,
  amount: 500,
  goalId: 'goal-123',
  timestamp: DateTime.now(),
  status: TransactionStatus.completed,
  gasFee: 2.5,
);

print(tx.isCompleted); // true
```

---

## AppNotification

In-app notification.

**Location**: `lib/models/notification_model.dart`

### Constructor

```dart
AppNotification({
  required String id,
  required String title,
  required String message,
  required NotificationType type,
  required DateTime timestamp,
  bool isRead = false,
  Map<String, dynamic>? data,
})
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Notification ID |
| `title` | `String` | Notification title |
| `message` | `String` | Notification message |
| `type` | `NotificationType` | Type of notification |
| `timestamp` | `DateTime` | When created |
| `isRead` | `bool` | Read status |
| `data` | `Map<String, dynamic>?` | Additional data |

### Enums

```dart
enum NotificationType {
  milestone,
  deadline,
  transaction,
  alert,
  info,
}
```

### Example

```dart
final notification = AppNotification(
  id: 'notif-789',
  title: 'Milestone Reached!',
  message: 'You\'ve saved 50% of your Emergency Fund',
  type: NotificationType.milestone,
  timestamp: DateTime.now(),
  data: {'goalId': 'goal-123', 'percentage': 50},
);
```

---

## UserPreferences

User settings and preferences.

**Location**: `lib/models/user_preferences.dart`

### Constructor

```dart
UserPreferences({
  bool isDarkMode = false,
  String language = 'en',
  String currency = 'USD',
  bool notificationsEnabled = true,
  bool biometricEnabled = false,
  int autoLockMinutes = 5,
})
```

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `isDarkMode` | `bool` | `false` | Dark theme enabled |
| `language` | `String` | `'en'` | App language |
| `currency` | `String` | `'USD'` | Display currency |
| `notificationsEnabled` | `bool` | `true` | Notifications on/off |
| `biometricEnabled` | `bool` | `false` | Biometric auth |
| `autoLockMinutes` | `int` | `5` | Auto-lock timeout |

### Example

```dart
final prefs = UserPreferences(
  isDarkMode: true,
  language: 'en',
  biometricEnabled: true,
);

// Save
await storage.savePreferences(prefs);

// Update
final updated = prefs.copyWith(isDarkMode: false);
```

---

## WalletInfo

Wallet connection information.

**Location**: `lib/models/wallet_info.dart`

### Constructor

```dart
WalletInfo({
  required String address,
  String? name,
  required double balance,
  required String network,
  required DateTime connectedAt,
  bool isConnected = true,
})
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `address` | `String` | Wallet address |
| `name` | `String?` | Optional wallet name |
| `balance` | `double` | USDC balance |
| `network` | `String` | Network name |
| `connectedAt` | `DateTime` | Connection time |
| `isConnected` | `bool` | Connection status |

### Computed Properties

```dart
String get shortAddress // "0x1234...5678"
```

### Example

```dart
final wallet = WalletInfo(
  address: '0x1234567890abcdef',
  balance: 1250.50,
  network: 'Ethereum Mainnet',
  connectedAt: DateTime.now(),
);

print(wallet.shortAddress); // "0x1234...cdef"
```

---

## GoalCategory

Goal category enum with extensions.

**Location**: `lib/models/savings_goal.dart`

### Enum Values

```dart
enum GoalCategory {
  emergency,
  vacation,
  education,
  home,
  car,
  wedding,
  investment,
  retirement,
  gift,
  other,
}
```

### Extensions

```dart
extension GoalCategoryExtension on GoalCategory {
  String get displayName;  // User-friendly name
  String get icon;         // Emoji icon
}
```

### Example

```dart
final category = GoalCategory.emergency;

print(category.displayName); // "Emergency Fund"
print(category.icon);        // "🚨"
```

---

## Common Patterns

### Creating Models

```dart
// From scratch
final goal = SavingsGoal(
  id: Uuid().v4(),
  name: 'My Goal',
  targetAmount: 1000,
  createdAt: DateTime.now(),
);

// From JSON (API response)
final json = {'id': '123', 'name': 'My Goal', ...};
final goal = SavingsGoal.fromJson(json);
```

### Updating Models

```dart
// Use copyWith for immutability
final updated = goal.copyWith(currentAmount: 500);

// Original unchanged
print(goal.currentAmount);    // 0
print(updated.currentAmount); // 500
```

### Serialization

```dart
// To JSON
final json = goal.toJson();
final jsonString = jsonEncode(json);

// From JSON
final decoded = jsonDecode(jsonString);
final goal = SavingsGoal.fromJson(decoded);
```

---

## Validation

### Model Validation

```dart
extension SavingsGoalValidation on SavingsGoal {
  String? validate() {
    if (name.isEmpty) return 'Name required';
    if (targetAmount <= 0) return 'Target must be positive';
    if (currentAmount < 0) return 'Amount cannot be negative';
    return null;
  }

  bool get isValid => validate() == null;
}

// Usage
if (!goal.isValid) {
  print('Error: ${goal.validate()}');
}
```

---

## Model Collections

### GoalsList

Helper class for goal collections:

```dart
class GoalsList {
  final List<SavingsGoal> goals;

  GoalsList(this.goals);

  double get totalSaved => goals.fold(0.0, (sum, g) => sum + g.currentAmount);
  double get totalTarget => goals.fold(0.0, (sum, g) => sum + g.targetAmount);
  double get overallProgress => totalSaved / totalTarget;

  List<SavingsGoal> get activeGoals => goals.where((g) => g.isActive).toList();
  List<SavingsGoal> get completedGoals => goals.where((g) => g.isCompleted).toList();

  SavingsGoal? getById(String id) {
    try {
      return goals.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }
}

// Usage
final goalsList = GoalsList([goal1, goal2, goal3]);
print(goalsList.totalSaved);
print(goalsList.overallProgress);
```

---

## Testing Models

```dart
void main() {
  group('SavingsGoal', () {
    test('calculates progress correctly', () {
      final goal = SavingsGoal(
        id: '1',
        name: 'Test',
        targetAmount: 100,
        currentAmount: 50,
        createdAt: DateTime.now(),
      );

      expect(goal.progress, 0.5);
      expect(goal.percentageComplete, 50.0);
    });

    test('JSON serialization works', () {
      final goal = SavingsGoal(
        id: '1',
        name: 'Test',
        targetAmount: 100,
        createdAt: DateTime.now(),
      );

      final json = goal.toJson();
      final restored = SavingsGoal.fromJson(json);

      expect(restored.id, goal.id);
      expect(restored.name, goal.name);
    });
  });
}
```

---

## Next Steps

- [Services](services.md) - Services that use these models
- [NotificationModel](notification-model.md) - Detailed notification model
- [Data Models Architecture](../architecture/data-models.md) - Design patterns

---

Need help? Check [API Reference](services.md) or [FAQ](../resources/faq.md).
