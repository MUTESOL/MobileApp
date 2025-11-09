# Testing

Comprehensive testing guide for StackSave.

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/savings_goal_test.dart

# Run tests matching pattern
flutter test --name="SavingsGoal"
```

---

## Test Types

### Unit Tests

Test individual functions and classes.

**Location**: `test/unit/`

```dart
// test/unit/models/savings_goal_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stacksave/models/savings_goal.dart';

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
  });
}
```

### Widget Tests

Test UI components.

**Location**: `test/widget/`

```dart
// test/widget/goal_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stacksave/widgets/goal_card.dart';

void main() {
  testWidgets('GoalCard displays goal information', (tester) async {
    final goal = SavingsGoal(
      id: '1',
      name: 'Emergency Fund',
      targetAmount: 10000,
      currentAmount: 5000,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GoalCard(goal: goal),
        ),
      ),
    );

    expect(find.text('Emergency Fund'), findsOneWidget);
    expect(find.text('\$5,000 / \$10,000'), findsOneWidget);
  });
}
```

### Integration Tests

Test complete user flows.

**Location**: `integration_test/`

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stacksave/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('complete goal creation flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Find and tap add goal button
    final addButton = find.byIcon(Icons.add);
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Fill in goal details
    await tester.enterText(
      find.byKey(Key('goalNameField')),
      'Emergency Fund',
    );
    await tester.enterText(
      find.byKey(Key('targetAmountField')),
      '10000',
    );

    // Submit
    await tester.tap(find.text('Create Goal'));
    await tester.pumpAndSettle();

    // Verify goal created
    expect(find.text('Emergency Fund'), findsOneWidget);
  });
}
```

---

## Mocking

### Mock Dependencies

```dart
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([WalletService, StorageService])
void main() {
  group('GoalService', () {
    late MockWalletService mockWallet;
    late MockStorageService mockStorage;
    late GoalService goalService;

    setUp(() {
      mockWallet = MockWalletService();
      mockStorage = MockStorageService();
      goalService = GoalService(
        walletService: mockWallet,
        storageService: mockStorage,
      );
    });

    test('creates goal successfully', () async {
      when(mockWallet.isConnected).thenReturn(true);
      when(mockStorage.saveGoal(any)).thenAnswer((_) async => {});

      final goal = await goalService.createGoal(
        name: 'Test',
        targetAmount: 1000,
      );

      expect(goal, isNotNull);
      verify(mockStorage.saveGoal(any)).called(1);
    });
  });
}
```

---

## Coverage

### Generate Coverage Report

```bash
# Run tests with coverage
flutter test --coverage

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open report
open coverage/html/index.html
```

### Coverage Goals

- **Unit Tests**: > 80%
- **Widget Tests**: > 60%
- **Integration Tests**: Critical flows

---

## Testing Best Practices

### 1. Test Structure (AAA)

```dart
test('descriptive test name', () {
  // Arrange: Setup
  final goal = SavingsGoal(...);

  // Act: Execute
  final result = goal.progress;

  // Assert: Verify
  expect(result, 0.5);
});
```

### 2. Use Descriptive Names

```dart
// ✅ Good
test('calculates progress correctly when halfway to target', () {});

// ❌ Bad
test('test1', () {});
```

### 3. Test One Thing

```dart
// ✅ Good
test('calculates progress', () {
  expect(goal.progress, 0.5);
});

test('detects completion', () {
  expect(goal.isCompleted, false);
});

// ❌ Bad
test('goal tests', () {
  expect(goal.progress, 0.5);
  expect(goal.isCompleted, false);
  expect(goal.daysRemaining, 30);
});
```

---

## Continuous Testing

### Watch Mode

```bash
# Re-run tests on file changes
flutter test --watch
```

### Pre-commit Hook

Create `.git/hooks/pre-commit`:
```bash
#!/bin/sh
flutter test
if [ $? -ne 0 ]; then
  echo "Tests failed! Commit aborted."
  exit 1
fi
```

---

## Next Steps

- [Code Style Guide](code-style.md)
- [Development Setup](setup.md)
- [Building](building.md)
