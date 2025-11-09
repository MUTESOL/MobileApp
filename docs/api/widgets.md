# Widgets API

Reusable widgets used throughout StackSave.

## GoalCard

Display a savings goal as a card.

**Location**: `lib/widgets/goal_card.dart`

### Constructor

```dart
GoalCard({
  required SavingsGoal goal,
  VoidCallback? onTap,
  VoidCallback? onDeposit,
  VoidCallback? onWithdraw,
})
```

### Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `goal` | `SavingsGoal` | Yes | Goal to display |
| `onTap` | `VoidCallback?` | No | Called when card tapped |
| `onDeposit` | `VoidCallback?` | No | Called when deposit button tapped |
| `onWithdraw` | `VoidCallback?` | No | Called when withdraw button tapped |

### Example

```dart
GoalCard(
  goal: myGoal,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GoalDetailsScreen(goalId: myGoal.id),
      ),
    );
  },
  onDeposit: () => _showDepositDialog(myGoal),
)
```

---

## ProgressBar

Custom progress bar with percentage display.

**Location**: `lib/widgets/progress_bar.dart`

### Constructor

```dart
ProgressBar({
  required double progress,
  double height = 20.0,
  Color? backgroundColor,
  Color? progressColor,
  bool showPercentage = true,
})
```

### Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `progress` | `double` | - | Progress (0.0 to 1.0) |
| `height` | `double` | `20.0` | Bar height |
| `backgroundColor` | `Color?` | `Colors.grey[300]` | Background color |
| `progressColor` | `Color?` | `Colors.green` | Progress color |
| `showPercentage` | `bool` | `true` | Show percentage text |

### Example

```dart
ProgressBar(
  progress: 0.65,
  height: 24,
  progressColor: Colors.blue,
)
```

---

## AmountInput

Input field for entering amounts.

**Location**: `lib/widgets/amount_input.dart`

### Constructor

```dart
AmountInput({
  TextEditingController? controller,
  String? label,
  String? hint,
  double? maxAmount,
  ValueChanged<double>? onChanged,
  VoidCallback? onMaxTap,
})
```

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `controller` | `TextEditingController?` | Text controller |
| `label` | `String?` | Label text |
| `hint` | `String?` | Hint text |
| `maxAmount` | `double?` | Maximum allowed |
| `onChanged` | `ValueChanged<double>?` | Called on value change |
| `onMaxTap` | `VoidCallback?` | Called when MAX tapped |

### Example

```dart
AmountInput(
  controller: amountController,
  label: 'Deposit Amount',
  hint: 'Enter amount in USDC',
  maxAmount: 1000.0,
  onMaxTap: () {
    amountController.text = '1000';
  },
)
```

---

## WalletButton

Button for wallet connection.

**Location**: `lib/widgets/wallet_button.dart`

### Constructor

```dart
WalletButton({
  VoidCallback? onConnect,
  VoidCallback? onDisconnect,
})
```

### Example

```dart
WalletButton(
  onConnect: () async {
    await walletService.connectWallet();
  },
  onDisconnect: () async {
    await walletService.disconnect();
  },
)
```

Automatically shows connect/disconnect based on wallet state.

---

## LoadingOverlay

Full-screen loading indicator.

**Location**: `lib/widgets/loading_overlay.dart`

### Constructor

```dart
LoadingOverlay({
  required bool isLoading,
  required Widget child,
  String? message,
})
```

### Properties

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `isLoading` | `bool` | Yes | Show loading indicator |
| `child` | `Widget` | Yes | Child widget |
| `message` | `String?` | No | Loading message |

### Example

```dart
LoadingOverlay(
  isLoading: _isProcessing,
  message: 'Processing transaction...',
  child: MyScreen(),
)
```

---

## ErrorDisplay

Display error messages.

**Location**: `lib/widgets/error_display.dart`

### Constructor

```dart
ErrorDisplay({
  required String message,
  VoidCallback? onRetry,
  bool showIcon = true,
})
```

### Example

```dart
ErrorDisplay(
  message: 'Failed to load goals',
  onRetry: () {
    _loadGoals();
  },
)
```

---

## EmptyState

Display when no data available.

**Location**: `lib/widgets/empty_state.dart`

### Constructor

```dart
EmptyState({
  required String message,
  IconData? icon,
  Widget? action,
})
```

### Example

```dart
EmptyState(
  message: 'No goals yet',
  icon: Icons.savings,
  action: ElevatedButton(
    onPressed: () => _createGoal(),
    child: Text('Create Your First Goal'),
  ),
)
```

---

## ConfirmationDialog

Confirmation dialog with actions.

**Location**: `lib/widgets/confirmation_dialog.dart`

### Constructor

```dart
ConfirmationDialog({
  required String title,
  required String message,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
})
```

### Example

```dart
showDialog(
  context: context,
  builder: (_) => ConfirmationDialog(
    title: 'Confirm Withdrawal',
    message: 'Withdraw \$500 from Emergency Fund?',
    confirmText: 'Withdraw',
    onConfirm: () {
      Navigator.pop(context, true);
    },
    onCancel: () {
      Navigator.pop(context, false);
    },
  ),
);
```

---

## TransactionStatusIndicator

Show transaction status with icon.

**Location**: `lib/widgets/transaction_status_indicator.dart`

### Constructor

```dart
TransactionStatusIndicator({
  required TransactionStatus status,
  bool showLabel = true,
})
```

### Example

```dart
TransactionStatusIndicator(
  status: TransactionStatus.pending,
  showLabel: true,
)
```

Shows:
- ⏳ Pending (yellow)
- ✅ Completed (green)
- ❌ Failed (red)

---

## CategoryIcon

Display category icon.

**Location**: `lib/widgets/category_icon.dart`

### Constructor

```dart
CategoryIcon({
  required GoalCategory category,
  double size = 40.0,
})
```

### Example

```dart
CategoryIcon(
  category: GoalCategory.emergency,
  size: 48,
)
```

---

## CurrencyText

Format and display currency values.

**Location**: `lib/widgets/currency_text.dart`

### Constructor

```dart
CurrencyText({
  required double amount,
  String currency = 'USDC',
  TextStyle? style,
  bool showSymbol = true,
})
```

### Example

```dart
CurrencyText(
  amount: 1234.56,
  currency: 'USDC',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
)
```

Output: `$1,234.56 USDC`

---

## DatePicker

Custom date picker for deadlines.

**Location**: `lib/widgets/date_picker.dart`

### Constructor

```dart
DatePicker({
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  ValueChanged<DateTime>? onDateSelected,
})
```

### Example

```dart
DatePicker(
  initialDate: DateTime.now(),
  firstDate: DateTime.now(),
  lastDate: DateTime.now().add(Duration(days: 365)),
  onDateSelected: (date) {
    print('Selected: $date');
  },
)
```

---

## NetworkBadge

Show current blockchain network.

**Location**: `lib/widgets/network_badge.dart`

### Constructor

```dart
NetworkBadge({
  required String networkName,
  bool isConnected = true,
})
```

### Example

```dart
NetworkBadge(
  networkName: 'Ethereum Mainnet',
  isConnected: true,
)
```

---

## Common Patterns

### Conditional Rendering

```dart
// Using builder pattern
Widget build(BuildContext context) {
  final walletService = Provider.of<WalletService>(context);

  if (!walletService.isConnected) {
    return EmptyState(
      message: 'Connect your wallet to continue',
      action: WalletButton(),
    );
  }

  if (_isLoading) {
    return LoadingOverlay(
      isLoading: true,
      message: 'Loading goals...',
      child: Container(),
    );
  }

  if (_error != null) {
    return ErrorDisplay(
      message: _error!,
      onRetry: _loadGoals,
    );
  }

  return _buildGoalsList();
}
```

### Dialog Usage

```dart
Future<bool?> showConfirmation(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (_) => ConfirmationDialog(
      title: 'Delete Goal',
      message: 'Are you sure?',
      onConfirm: () => Navigator.pop(context, true),
      onCancel: () => Navigator.pop(context, false),
    ),
  );
}

// Usage
final confirmed = await showConfirmation(context);
if (confirmed == true) {
  _deleteGoal();
}
```

---

## Widget Testing

```dart
void main() {
  testWidgets('GoalCard displays goal information', (tester) async {
    final goal = SavingsGoal(
      id: '1',
      name: 'Test Goal',
      targetAmount: 1000,
      currentAmount: 500,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GoalCard(goal: goal),
        ),
      ),
    );

    expect(find.text('Test Goal'), findsOneWidget);
    expect(find.text('\$500 / \$1,000'), findsOneWidget);
  });
}
```

---

## Custom Widgets

### Creating Custom Widgets

```dart
class CustomGoalCard extends StatelessWidget {
  final SavingsGoal goal;

  const CustomGoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(goal.name, style: Theme.of(context).textTheme.headline6),
          ProgressBar(progress: goal.progress),
          CurrencyText(amount: goal.currentAmount),
        ],
      ),
    );
  }
}
```

---

## Next Steps

- [Services API](services.md) - Backend services
- [Models API](models.md) - Data models
- [Constants](constants.md) - App constants

---

Need help? Check [Development Guide](../development/setup.md) or [FAQ](../resources/faq.md).
