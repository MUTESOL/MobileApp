# Data Models

StackSave uses well-defined data models to represent application entities. These models ensure type safety, maintainability, and clear data structures.

## Core Models

### SavingsGoal

Represents a user's savings goal.

**Location**: `lib/models/savings_goal.dart`

```dart
class SavingsGoal {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;
  final GoalCategory category;
  final DateTime createdAt;
  final bool isActive;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.deadline,
    this.category = GoalCategory.other,
    required this.createdAt,
    this.isActive = true,
  });

  // Computed properties
  double get progress {
    if (targetAmount == 0) return 0;
    return (currentAmount / targetAmount).clamp(0.0, 1.0);
  }

  double get percentageComplete {
    return progress * 100;
  }

  double get remainingAmount {
    return (targetAmount - currentAmount).clamp(0.0, double.infinity);
  }

  bool get isCompleted => currentAmount >= targetAmount;

  bool get isOverdue {
    if (deadline == null) return false;
    return DateTime.now().isAfter(deadline!) && !isCompleted;
  }

  int? get daysRemaining {
    if (deadline == null) return null;
    final difference = deadline!.difference(DateTime.now());
    return difference.inDays;
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'deadline': deadline?.toIso8601String(),
      'category': category.toString(),
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      category: _categoryFromString(json['category'] as String?),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  // Copy with method
  SavingsGoal copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    GoalCategory? category,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  static GoalCategory _categoryFromString(String? value) {
    switch (value) {
      case 'GoalCategory.emergency':
        return GoalCategory.emergency;
      case 'GoalCategory.vacation':
        return GoalCategory.vacation;
      case 'GoalCategory.education':
        return GoalCategory.education;
      // ... other categories
      default:
        return GoalCategory.other;
    }
  }
}
```

---

### GoalCategory

Enum for goal categories.

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

extension GoalCategoryExtension on GoalCategory {
  String get displayName {
    switch (this) {
      case GoalCategory.emergency:
        return 'Emergency Fund';
      case GoalCategory.vacation:
        return 'Vacation';
      case GoalCategory.education:
        return 'Education';
      case GoalCategory.home:
        return 'Home';
      case GoalCategory.car:
        return 'Car';
      case GoalCategory.wedding:
        return 'Wedding';
      case GoalCategory.investment:
        return 'Investment';
      case GoalCategory.retirement:
        return 'Retirement';
      case GoalCategory.gift:
        return 'Gift';
      case GoalCategory.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case GoalCategory.emergency:
        return '🚨';
      case GoalCategory.vacation:
        return '✈️';
      case GoalCategory.education:
        return '🎓';
      case GoalCategory.home:
        return '🏠';
      case GoalCategory.car:
        return '🚗';
      case GoalCategory.wedding:
        return '💒';
      case GoalCategory.investment:
        return '📈';
      case GoalCategory.retirement:
        return '🏖';
      case GoalCategory.gift:
        return '🎁';
      case GoalCategory.other:
        return '⭐';
    }
  }
}
```

---

### Transaction

Represents a blockchain transaction.

**Location**: `lib/models/transaction.dart`

```dart
class Transaction {
  final String id;
  final String hash;
  final TransactionType type;
  final double amount;
  final String goalId;
  final DateTime timestamp;
  final TransactionStatus status;
  final double? gasFee;
  final String? errorMessage;

  Transaction({
    required this.id,
    required this.hash,
    required this.type,
    required this.amount,
    required this.goalId,
    required this.timestamp,
    this.status = TransactionStatus.pending,
    this.gasFee,
    this.errorMessage,
  });

  bool get isPending => status == TransactionStatus.pending;
  bool get isCompleted => status == TransactionStatus.completed;
  bool get isFailed => status == TransactionStatus.failed;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hash': hash,
      'type': type.toString(),
      'amount': amount,
      'goalId': goalId,
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString(),
      'gasFee': gasFee,
      'errorMessage': errorMessage,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      hash: json['hash'] as String,
      type: _typeFromString(json['type'] as String),
      amount: (json['amount'] as num).toDouble(),
      goalId: json['goalId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: _statusFromString(json['status'] as String),
      gasFee: (json['gasFee'] as num?)?.toDouble(),
      errorMessage: json['errorMessage'] as String?,
    );
  }

  Transaction copyWith({
    String? id,
    String? hash,
    TransactionType? type,
    double? amount,
    String? goalId,
    DateTime? timestamp,
    TransactionStatus? status,
    double? gasFee,
    String? errorMessage,
  }) {
    return Transaction(
      id: id ?? this.id,
      hash: hash ?? this.hash,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      goalId: goalId ?? this.goalId,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      gasFee: gasFee ?? this.gasFee,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  static TransactionType _typeFromString(String value) {
    switch (value) {
      case 'TransactionType.deposit':
        return TransactionType.deposit;
      case 'TransactionType.withdrawal':
        return TransactionType.withdrawal;
      default:
        return TransactionType.deposit;
    }
  }

  static TransactionStatus _statusFromString(String value) {
    switch (value) {
      case 'TransactionStatus.pending':
        return TransactionStatus.pending;
      case 'TransactionStatus.completed':
        return TransactionStatus.completed;
      case 'TransactionStatus.failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.pending;
    }
  }
}

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

---

### AppNotification

Represents an in-app notification.

**Location**: `lib/models/notification_model.dart`

```dart
class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;
  final Map<String, dynamic>? data;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'data': data,
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: _typeFromString(json['type'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  static NotificationType _typeFromString(String value) {
    switch (value) {
      case 'NotificationType.milestone':
        return NotificationType.milestone;
      case 'NotificationType.deadline':
        return NotificationType.deadline;
      case 'NotificationType.transaction':
        return NotificationType.transaction;
      case 'NotificationType.alert':
        return NotificationType.alert;
      default:
        return NotificationType.info;
    }
  }
}

enum NotificationType {
  milestone,
  deadline,
  transaction,
  alert,
  info,
}

extension NotificationTypeExtension on NotificationType {
  String get icon {
    switch (this) {
      case NotificationType.milestone:
        return '🎉';
      case NotificationType.deadline:
        return '⏰';
      case NotificationType.transaction:
        return '💰';
      case NotificationType.alert:
        return '⚠️';
      case NotificationType.info:
        return 'ℹ️';
    }
  }
}
```

---

### UserPreferences

User settings and preferences.

**Location**: `lib/models/user_preferences.dart`

```dart
class UserPreferences {
  final bool isDarkMode;
  final String language;
  final String currency;
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final int autoLockMinutes;

  UserPreferences({
    this.isDarkMode = false,
    this.language = 'en',
    this.currency = 'USD',
    this.notificationsEnabled = true,
    this.biometricEnabled = false,
    this.autoLockMinutes = 5,
  });

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'language': language,
      'currency': currency,
      'notificationsEnabled': notificationsEnabled,
      'biometricEnabled': biometricEnabled,
      'autoLockMinutes': autoLockMinutes,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      language: json['language'] as String? ?? 'en',
      currency: json['currency'] as String? ?? 'USD',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      autoLockMinutes: json['autoLockMinutes'] as int? ?? 5,
    );
  }

  UserPreferences copyWith({
    bool? isDarkMode,
    String? language,
    String? currency,
    bool? notificationsEnabled,
    bool? biometricEnabled,
    int? autoLockMinutes,
  }) {
    return UserPreferences(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
    );
  }
}
```

---

### WalletInfo

Wallet connection information.

**Location**: `lib/models/wallet_info.dart`

```dart
class WalletInfo {
  final String address;
  final String? name;
  final double balance;
  final String network;
  final DateTime connectedAt;
  final bool isConnected;

  WalletInfo({
    required this.address,
    this.name,
    required this.balance,
    required this.network,
    required this.connectedAt,
    this.isConnected = true,
  });

  String get shortAddress {
    if (address.length <= 10) return address;
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'name': name,
      'balance': balance,
      'network': network,
      'connectedAt': connectedAt.toIso8601String(),
      'isConnected': isConnected,
    };
  }

  factory WalletInfo.fromJson(Map<String, dynamic> json) {
    return WalletInfo(
      address: json['address'] as String,
      name: json['name'] as String?,
      balance: (json['balance'] as num).toDouble(),
      network: json['network'] as String,
      connectedAt: DateTime.parse(json['connectedAt'] as String),
      isConnected: json['isConnected'] as bool? ?? true,
    );
  }

  WalletInfo copyWith({
    String? address,
    String? name,
    double? balance,
    String? network,
    DateTime? connectedAt,
    bool? isConnected,
  }) {
    return WalletInfo(
      address: address ?? this.address,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      network: network ?? this.network,
      connectedAt: connectedAt ?? this.connectedAt,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
```

---

## Model Patterns

### Immutability

All models are immutable - use `copyWith` to create modified copies:

```dart
final goal = SavingsGoal(
  id: '1',
  name: 'Emergency Fund',
  targetAmount: 10000,
  createdAt: DateTime.now(),
);

// Create modified copy
final updatedGoal = goal.copyWith(
  currentAmount: 5000,
);

// Original remains unchanged
print(goal.currentAmount); // 0.0
print(updatedGoal.currentAmount); // 5000.0
```

### JSON Serialization

All models support JSON serialization for:
- API communication
- Local storage
- State persistence

```dart
// To JSON
final json = goal.toJson();
final jsonString = jsonEncode(json);

// From JSON
final decoded = jsonDecode(jsonString);
final goal = SavingsGoal.fromJson(decoded);
```

### Computed Properties

Use getters for derived values:

```dart
class SavingsGoal {
  final double targetAmount;
  final double currentAmount;

  // Computed property
  double get progress => currentAmount / targetAmount;
  bool get isCompleted => currentAmount >= targetAmount;
}
```

---

## Data Validation

### Model Validation

Add validation methods to models:

```dart
class SavingsGoal {
  // ... properties

  String? validate() {
    if (name.isEmpty) {
      return 'Goal name cannot be empty';
    }

    if (targetAmount <= 0) {
      return 'Target amount must be positive';
    }

    if (currentAmount < 0) {
      return 'Current amount cannot be negative';
    }

    if (currentAmount > targetAmount) {
      return 'Current amount exceeds target';
    }

    return null; // Valid
  }

  bool get isValid => validate() == null;
}
```

---

## Collections

### GoalsList

List of goals with helper methods:

```dart
class GoalsList {
  final List<SavingsGoal> goals;

  GoalsList(this.goals);

  double get totalSaved {
    return goals.fold(0.0, (sum, goal) => sum + goal.currentAmount);
  }

  double get totalTarget {
    return goals.fold(0.0, (sum, goal) => sum + goal.targetAmount);
  }

  double get overallProgress {
    if (totalTarget == 0) return 0;
    return totalSaved / totalTarget;
  }

  List<SavingsGoal> get activeGoals {
    return goals.where((goal) => goal.isActive).toList();
  }

  List<SavingsGoal> get completedGoals {
    return goals.where((goal) => goal.isCompleted).toList();
  }

  List<SavingsGoal> get overdueGoals {
    return goals.where((goal) => goal.isOverdue).toList();
  }

  List<SavingsGoal> getGoalsByCategory(GoalCategory category) {
    return goals.where((goal) => goal.category == category).toList();
  }

  SavingsGoal? getGoalById(String id) {
    try {
      return goals.firstWhere((goal) => goal.id == id);
    } catch (e) {
      return null;
    }
  }
}
```

---

## Best Practices

### 1. Use Final Fields

Make all fields `final` for immutability:

```dart
class SavingsGoal {
  final String id;      // ✅ Immutable
  final String name;    // ✅ Immutable

  // ❌ Don't use mutable fields
  String mutableName;
}
```

### 2. Provide Default Values

```dart
class SavingsGoal {
  final double currentAmount;

  SavingsGoal({
    this.currentAmount = 0.0, // ✅ Default value
  });
}
```

### 3. Implement Equality

For comparing models:

```dart
class SavingsGoal {
  final String id;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SavingsGoal && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
```

Or use `equatable` package:

```dart
import 'package:equatable/equatable.dart';

class SavingsGoal extends Equatable {
  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
```

### 4. Use Named Constructors

For special cases:

```dart
class SavingsGoal {
  SavingsGoal({required this.id, ...});

  // Named constructor for creating with defaults
  SavingsGoal.create({
    required String name,
    required double targetAmount,
  }) : this(
    id: Uuid().v4(),
    name: name,
    targetAmount: targetAmount,
    createdAt: DateTime.now(),
  );

  // Named constructor from blockchain data
  factory SavingsGoal.fromBlockchain(Map<String, dynamic> data) {
    return SavingsGoal(
      id: data['id'],
      // ... parse blockchain data
    );
  }
}
```

---

## Testing Models

### Unit Tests

```dart
import 'package:flutter_test/flutter_test.dart';

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

    test('detects completed goals', () {
      final goal = SavingsGoal(
        id: '1',
        name: 'Test',
        targetAmount: 100,
        currentAmount: 100,
        createdAt: DateTime.now(),
      );

      expect(goal.isCompleted, true);
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
      expect(restored.targetAmount, goal.targetAmount);
    });
  });
}
```

---

## Model Documentation

### Documenting Models

```dart
/// Represents a user's savings goal.
///
/// A [SavingsGoal] tracks the progress towards a specific
/// savings target with an optional deadline.
///
/// Example:
/// ```dart
/// final goal = SavingsGoal(
///   id: '1',
///   name: 'Emergency Fund',
///   targetAmount: 10000,
///   createdAt: DateTime.now(),
/// );
/// ```
class SavingsGoal {
  /// Unique identifier for this goal
  final String id;

  /// User-friendly name
  final String name;

  /// Target amount in USDC
  final double targetAmount;

  /// Current saved amount in USDC
  final double currentAmount;

  /// Optional deadline for reaching the goal
  final DateTime? deadline;

  // ...
}
```

---

## Next Steps

- [State Management](state-management.md) - How models are used with providers
- [Project Structure](project-structure.md) - Where models are located
- [API Reference](../api/models.md) - Complete API documentation

---

Need help? Check [Development Guide](../development/setup.md) or [FAQ](../resources/faq.md).
