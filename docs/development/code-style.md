# Code Style Guide

Coding standards and best practices for StackSave.

## Dart Style

Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines.

### Formatting

```bash
# Format all files
dart format .

# Check formatting
dart format --set-exit-if-changed .
```

### Linting

Configure in `analysis_options.yaml`:
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - avoid_print
    - prefer_single_quotes
    - require_trailing_commas
```

Run analyzer:
```bash
flutter analyze
```

---

## Naming Conventions

### Classes

```dart
// PascalCase for classes
class SavingsGoal {}
class WalletService {}
```

### Variables & Functions

```dart
// camelCase for variables and functions
final goalName = 'Emergency Fund';
double calculateProgress() {}
```

### Constants

```dart
// lowerCamelCase for constants
const double maxAmount = 1000000.0;
const int requiredConfirmations = 12;
```

### Private Members

```dart
// Prefix with underscore
class MyClass {
  String _privateField;
  void _privateMethod() {}
}
```

---

## Code Organization

### File Structure

```dart
// 1. Imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/savings_goal.dart';
import '../services/wallet_service.dart';

// 2. Class definition
class HomeScreen extends StatefulWidget {
  // 3. Constructor
  const HomeScreen({Key? key}) : super(key: key);

  // 4. Overrides
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 5. Fields
  final _goals = <SavingsGoal>[];
  bool _isLoading = false;

  // 6. Lifecycle methods
  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  // 7. Event handlers
  void _onGoalTap(SavingsGoal goal) {}

  // 8. Helper methods
  Future<void> _loadGoals() async {}

  // 9. Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
```

---

## Best Practices

### 1. Use const Constructors

```dart
// ✅ Good
const Text('Hello');
const SizedBox(height: 16);

// ❌ Bad
Text('Hello');
SizedBox(height: 16);
```

### 2. Prefer Final

```dart
// ✅ Good
final name = 'StackSave';
final goals = <SavingsGoal>[];

// ❌ Bad
var name = 'StackSave';
var goals = <SavingsGoal>[];
```

### 3. Null Safety

```dart
// ✅ Good
String? getNullableValue() => null;
String getValue() => 'value';

final value = getNullableValue();
if (value != null) {
  print(value);
}

// Using ??
final displayValue = value ?? 'default';

// ❌ Bad
String getNullableValue() => null!; // Don't use !
```

### 4. Async/Await

```dart
// ✅ Good
Future<void> loadData() async {
  try {
    final data = await fetchData();
    setState(() {
      _data = data;
    });
  } catch (e) {
    print('Error: $e');
  }
}

// ❌ Bad
Future<void> loadData() {
  fetchData().then((data) {
    setState(() {
      _data = data;
    });
  }).catchError((e) {
    print('Error: $e');
  });
}
```

### 5. Widget Composition

```dart
// ✅ Good
Widget buildHeader() {
  return Text('Header');
}

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      buildHeader(),
      buildContent(),
    ],
  );
}

// Even better: Extract to separate widget
class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Header');
  }
}
```

---

## Comments

### Documentation Comments

```dart
/// Represents a user's savings goal.
///
/// A [SavingsGoal] tracks progress towards a specific
/// target amount with an optional deadline.
///
/// Example:
/// ```dart
/// final goal = SavingsGoal(
///   name: 'Emergency Fund',
///   targetAmount: 10000,
/// );
/// ```
class SavingsGoal {
  /// The unique identifier for this goal.
  final String id;

  /// The user-friendly name of the goal.
  final String name;

  /// Creates a new [SavingsGoal].
  SavingsGoal({
    required this.id,
    required this.name,
  });
}
```

### Inline Comments

```dart
// Use sparingly, only when code isn't self-explanatory

// Calculate final amount including gas fees
final total = amount + gasFee;

// Retry transaction if nonce is too low
if (error.code == 'NONCE_TOO_LOW') {
  return _retryWithNewNonce();
}
```

---

## Error Handling

### Use Try-Catch

```dart
Future<void> deposit(double amount) async {
  try {
    await walletService.deposit(amount);
  } on InsufficientFundsException catch (e) {
    showError('Insufficient balance');
  } on NetworkException catch (e) {
    showError('Network error: ${e.message}');
  } catch (e) {
    showError('Unknown error: $e');
  }
}
```

---

## State Management

### Provider Pattern

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WalletService>(
      builder: (context, wallet, child) {
        if (!wallet.isConnected) {
          return ConnectWalletScreen();
        }
        return GoalsList();
      },
    );
  }
}
```

---

## File Naming

- **Dart files**: `snake_case.dart`
- **Screens**: `home_screen.dart`
- **Widgets**: `goal_card.dart`
- **Models**: `savings_goal.dart`
- **Services**: `wallet_service.dart`

---

## Git Commit Messages

### Format

```
type(scope): subject

body

footer
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Tests
- `chore`: Maintenance

### Examples

```
feat(goals): add goal creation screen

- Add form validation
- Integrate with blockchain service
- Update navigation

Closes #123
```

```
fix(wallet): handle disconnection edge case

Previously, the app would crash if wallet disconnected
during a transaction. Now it shows an error message
and recovers gracefully.
```

---

## Next Steps

- [Testing](testing.md)
- [Development Setup](setup.md)
- [Building](building.md)
