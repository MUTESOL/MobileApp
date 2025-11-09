# State Management

StackSave uses **Provider** (part of the Flutter ecosystem) for state management, offering a reactive and efficient way to manage application state.

## Overview

State management in StackSave handles:

- Wallet connection state
- Savings goals data
- User preferences
- Transaction status
- UI state and navigation
- Blockchain data synchronization

---

## Architecture Pattern

### Provider Pattern

StackSave implements the Provider pattern for state management:

```
┌─────────────────┐
│   Widget Tree   │
│                 │
│  ┌───────────┐  │
│  │ Consumer  │  │
│  └─────┬─────┘  │
│        │        │
└────────┼────────┘
         │
         ▼
  ┌─────────────┐
  │  Provider   │
  │   (Store)   │
  └──────┬──────┘
         │
         ▼
  ┌─────────────┐
  │   Model     │
  │ChangeNotifier│
  └─────────────┘
```

### Why Provider?

**Benefits**:
- ✅ Simple and intuitive API
- ✅ Efficient rebuilds (only affected widgets)
- ✅ Type-safe
- ✅ Recommended by Flutter team
- ✅ Good developer experience
- ✅ Testable

---

## Core Providers

### WalletService Provider

Manages wallet connection and blockchain interactions:

**Location**: `lib/services/wallet_service.dart`

```dart
class WalletService extends ChangeNotifier {
  // State
  bool _isConnected = false;
  String? _walletAddress;
  double _balance = 0.0;

  // Getters
  bool get isConnected => _isConnected;
  String? get walletAddress => _walletAddress;
  double get balance => _balance;

  // Methods
  Future<void> connectWallet() async {
    // Connect to wallet
    _isConnected = true;
    notifyListeners(); // Notify UI to rebuild
  }

  Future<void> disconnect() async {
    // Disconnect wallet
    _isConnected = false;
    _walletAddress = null;
    notifyListeners();
  }
}
```

**Provides**:
- Wallet connection status
- Connected address
- USDC balance
- Transaction methods
- WalletConnect session

**Usage**:
```dart
// In widget
final walletService = Provider.of<WalletService>(context);

if (walletService.isConnected) {
  Text('Connected: ${walletService.walletAddress}');
}
```

### GoalsProvider (Conceptual)

Manages savings goals:

```dart
class GoalsProvider extends ChangeNotifier {
  List<SavingsGoal> _goals = [];

  List<SavingsGoal> get goals => _goals;

  Future<void> fetchGoals() async {
    _goals = await _repository.getGoals();
    notifyListeners();
  }

  Future<void> addGoal(SavingsGoal goal) async {
    await _repository.saveGoal(goal);
    _goals.add(goal);
    notifyListeners();
  }

  Future<void> updateGoal(SavingsGoal goal) async {
    await _repository.updateGoal(goal);
    final index = _goals.indexWhere((g) => g.id == goal.id);
    _goals[index] = goal;
    notifyListeners();
  }

  Future<void> deleteGoal(String goalId) async {
    await _repository.deleteGoal(goalId);
    _goals.removeWhere((g) => g.id == goalId);
    notifyListeners();
  }
}
```

### NotificationProvider

Manages notifications:

**Location**: `lib/models/notification_model.dart`

```dart
class NotificationModel extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  int _unreadCount = 0;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    if (!notification.isRead) {
      _unreadCount++;
    }
    notifyListeners();
  }

  void markAsRead(String notificationId) {
    final notification = _notifications.firstWhere(
      (n) => n.id == notificationId
    );
    notification.isRead = true;
    _unreadCount = max(0, _unreadCount - 1);
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }
}
```

---

## Provider Setup

### App Initialization

**Location**: `lib/main.dart`

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        // Wallet Service
        ChangeNotifierProvider(
          create: (_) => WalletService(),
        ),

        // Goals Provider
        ChangeNotifierProvider(
          create: (_) => GoalsProvider(),
        ),

        // Notifications
        ChangeNotifierProvider(
          create: (_) => NotificationModel(),
        ),

        // User Preferences
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}
```

### Provider Hierarchy

```
MultiProvider
├── WalletService
│   └── Connection state, transactions
├── GoalsProvider
│   └── Savings goals, CRUD operations
├── NotificationModel
│   └── Notifications, unread count
└── PreferencesProvider
    └── User settings, theme, language
```

---

## Consuming State

### Consumer Widget

**Best for**: Specific widget rebuilds

```dart
Consumer<WalletService>(
  builder: (context, walletService, child) {
    if (walletService.isConnected) {
      return Text('Balance: ${walletService.balance} USDC');
    }
    return Text('Not connected');
  },
)
```

### Provider.of

**Best for**: One-time reads or method calls

```dart
// Watch for changes (rebuilds on change)
final walletService = Provider.of<WalletService>(context);

// Read only (no rebuild)
final walletService = Provider.of<WalletService>(
  context,
  listen: false
);

// Call method
walletService.connectWallet();
```

### Selector

**Best for**: Optimized rebuilds on specific properties

```dart
Selector<WalletService, bool>(
  selector: (context, service) => service.isConnected,
  builder: (context, isConnected, child) {
    return Icon(
      isConnected ? Icons.check_circle : Icons.error,
    );
  },
)
```

Only rebuilds when `isConnected` changes, not on balance updates!

---

## State Flow

### Data Flow Diagram

```
User Action
    ↓
Widget Event
    ↓
Provider Method Call
    ↓
Update Internal State
    ↓
notifyListeners()
    ↓
Provider Notifies Consumers
    ↓
Widget Rebuild
    ↓
UI Update
```

### Example: Making a Deposit

```dart
// 1. User taps deposit button
onPressed: () async {
  // 2. Get provider (no rebuild)
  final walletService = Provider.of<WalletService>(
    context,
    listen: false
  );

  // 3. Call async method
  await walletService.deposit(goalId, amount);

  // 4. WalletService internally:
  // - Executes blockchain transaction
  // - Updates _balance
  // - Calls notifyListeners()

  // 5. All Consumer<WalletService> widgets rebuild
  // 6. UI shows updated balance
}
```

---

## Advanced Patterns

### ProxyProvider

Combine multiple providers:

```dart
ProxyProvider2<WalletService, GoalsProvider, AnalyticsProvider>(
  update: (context, wallet, goals, previous) {
    return AnalyticsProvider(
      walletService: wallet,
      goalsProvider: goals,
    );
  },
)
```

### FutureProvider

Handle async data:

```dart
FutureProvider<List<SavingsGoal>>(
  initialData: [],
  create: (_) => fetchGoalsFromBlockchain(),
  child: MyApp(),
)
```

### StreamProvider

Handle real-time updates:

```dart
StreamProvider<BlockchainEvent>(
  initialData: null,
  create: (_) => blockchainEventStream,
  child: MyApp(),
)
```

---

## State Persistence

### SharedPreferences

Persist user preferences:

```dart
class PreferencesProvider extends ChangeNotifier {
  final SharedPreferences _prefs;

  bool get isDarkMode => _prefs.getBool('darkMode') ?? false;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool('darkMode', value);
    notifyListeners();
  }
}
```

### Secure Storage

Store sensitive data:

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageProvider extends ChangeNotifier {
  final _storage = FlutterSecureStorage();

  Future<void> saveWalletSession(String session) async {
    await _storage.write(key: 'wallet_session', value: session);
  }

  Future<String?> getWalletSession() async {
    return await _storage.read(key: 'wallet_session');
  }
}
```

---

## Optimization

### Rebuild Optimization

**Problem**: Entire screen rebuilds on small state change

**Solution 1**: Use Selector
```dart
// ❌ Rebuilds on any WalletService change
Consumer<WalletService>(
  builder: (context, service, _) => Text(service.address),
)

// ✅ Only rebuilds when address changes
Selector<WalletService, String?>(
  selector: (_, service) => service.address,
  builder: (context, address, _) => Text(address ?? 'N/A'),
)
```

**Solution 2**: Split providers
```dart
// ❌ One large provider
class AppState extends ChangeNotifier {
  bool isConnected;
  List<Goal> goals;
  UserSettings settings;
  // Changes to any trigger full rebuild
}

// ✅ Separate concerns
WalletProvider  // Only wallet state
GoalsProvider   // Only goals state
SettingsProvider // Only settings
```

### Lazy Loading

Load providers only when needed:

```dart
// ❌ All providers loaded at startup
providers: [
  ChangeNotifierProvider(create: (_) => HeavyProvider()),
]

// ✅ Load on demand
providers: [
  ChangeNotifierProxyProvider<AuthProvider, HeavyProvider?>(
    create: (_) => null,
    update: (_, auth, __) {
      if (auth.isAuthenticated) {
        return HeavyProvider();
      }
      return null;
    },
  ),
]
```

---

## Testing

### Unit Testing Providers

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WalletService', () {
    late WalletService walletService;

    setUp(() {
      walletService = WalletService();
    });

    test('initial state is disconnected', () {
      expect(walletService.isConnected, false);
      expect(walletService.walletAddress, null);
    });

    test('connectWallet updates state', () async {
      await walletService.connectWallet();
      expect(walletService.isConnected, true);
      expect(walletService.walletAddress, isNotNull);
    });

    test('notifies listeners on state change', () {
      var notified = false;
      walletService.addListener(() {
        notified = true;
      });

      walletService.connectWallet();
      expect(notified, true);
    });
  });
}
```

### Widget Testing with Providers

```dart
testWidgets('shows wallet address when connected', (tester) async {
  final mockWalletService = MockWalletService();
  when(mockWalletService.isConnected).thenReturn(true);
  when(mockWalletService.walletAddress).thenReturn('0x123');

  await tester.pumpWidget(
    ChangeNotifierProvider<WalletService>.value(
      value: mockWalletService,
      child: MaterialApp(
        home: WalletWidget(),
      ),
    ),
  );

  expect(find.text('0x123'), findsOneWidget);
});
```

---

## Best Practices

### Do's ✅

1. **Keep providers focused**:
```dart
// ✅ Single responsibility
class WalletProvider extends ChangeNotifier {
  // Only wallet-related state
}

// ❌ God object
class AppProvider extends ChangeNotifier {
  // Everything in one provider
}
```

2. **Use meaningful names**:
```dart
// ✅ Clear and descriptive
class GoalsProvider extends ChangeNotifier {}

// ❌ Generic
class DataProvider extends ChangeNotifier {}
```

3. **Dispose resources**:
```dart
class MyProvider extends ChangeNotifier {
  final StreamController _controller = StreamController();

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
```

4. **Make state immutable when possible**:
```dart
// ✅ Return copy
List<Goal> get goals => List.unmodifiable(_goals);

// ❌ Return mutable reference
List<Goal> get goals => _goals;
```

### Don'ts ❌

1. **Don't put UI logic in providers**:
```dart
// ❌ Provider handles navigation
class MyProvider extends ChangeNotifier {
  void doSomething(BuildContext context) {
    Navigator.push(context, ...);
  }
}

// ✅ Provider only manages state
class MyProvider extends ChangeNotifier {
  void doSomething() {
    // Business logic only
  }
}
```

2. **Don't forget to call notifyListeners()**:
```dart
// ❌ UI won't update
void updateName(String name) {
  _name = name;
  // Missing notifyListeners()!
}

// ✅ UI updates
void updateName(String name) {
  _name = name;
  notifyListeners();
}
```

3. **Don't use Provider.of in initState** without listen: false:
```dart
// ❌ May cause issues
@override
void initState() {
  super.initState();
  final service = Provider.of<MyService>(context);
}

// ✅ Correct usage
@override
void initState() {
  super.initState();
  final service = Provider.of<MyService>(context, listen: false);
}
```

---

## Common Patterns

### Loading States

```dart
class DataProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Item> _items = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Item> get items => _items;

  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await fetchData();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

**UI**:
```dart
Consumer<DataProvider>(
  builder: (context, provider, _) {
    if (provider.isLoading) {
      return CircularProgressIndicator();
    }

    if (provider.error != null) {
      return Text('Error: ${provider.error}');
    }

    return ListView.builder(
      itemCount: provider.items.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(provider.items[index].name));
      },
    );
  },
)
```

### Computed Properties

```dart
class GoalsProvider extends ChangeNotifier {
  List<SavingsGoal> _goals = [];

  List<SavingsGoal> get goals => _goals;

  // Computed: total saved across all goals
  double get totalSaved {
    return _goals.fold(0.0, (sum, goal) => sum + goal.currentAmount);
  }

  // Computed: total target
  double get totalTarget {
    return _goals.fold(0.0, (sum, goal) => sum + goal.targetAmount);
  }

  // Computed: overall progress
  double get overallProgress {
    if (totalTarget == 0) return 0;
    return totalSaved / totalTarget;
  }

  // Computed: active goals only
  List<SavingsGoal> get activeGoals {
    return _goals.where((goal) => goal.isActive).toList();
  }
}
```

---

## Troubleshooting

### Provider Not Found Error

**Error**: `ProviderNotFoundException`

**Cause**: Provider not in widget tree above consumer

**Solution**:
```dart
// ✅ Wrap with MultiProvider at app root
void main() {
  runApp(
    MultiProvider(
      providers: [...],
      child: MyApp(),
    ),
  );
}
```

### Listeners Not Rebuilding

**Cause**: Not calling `notifyListeners()`

**Solution**:
```dart
void updateData() {
  _data = newData;
  notifyListeners(); // Don't forget!
}
```

### Performance Issues

**Symptom**: Laggy UI, frequent rebuilds

**Diagnosis**:
```dart
// Add logging to track rebuilds
Consumer<MyProvider>(
  builder: (context, provider, _) {
    print('Rebuilding!'); // See how often this prints
    return MyWidget();
  },
)
```

**Solutions**:
- Use Selector for specific properties
- Split large providers into smaller ones
- Use const widgets where possible
- Implement shouldNotify if extending ChangeNotifier

---

## Further Reading

- [Provider Documentation](https://pub.dev/packages/provider)
- [Flutter State Management](https://docs.flutter.dev/development/data-and-backend/state-mgmt)
- [Provider Architecture](https://github.com/rrousselGit/provider)

---

## Next Steps

- [Navigation Flow](navigation.md) - How screens connect
- [Data Models](data-models.md) - Application data structures
- [Project Structure](project-structure.md) - Code organization

---

Need help? Check [Development Guide](../development/setup.md) or [FAQ](../resources/faq.md).
