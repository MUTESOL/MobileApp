# Navigation Flow

StackSave uses Flutter's navigation system to provide smooth transitions between screens and maintain a clear user journey.

## Navigation Overview

### Navigation Stack

StackSave implements a stack-based navigation pattern:

```
┌─────────────────────┐
│   Current Screen    │ ← Top of stack
├─────────────────────┤
│   Previous Screen   │
├─────────────────────┤
│   Launch Screen     │
├─────────────────────┤
│   Splash Screen     │ ← Bottom of stack
└─────────────────────┘
```

### Navigation Methods

- **Push**: Add new screen to stack
- **Pop**: Remove current screen, go back
- **Replace**: Replace current screen
- **PopUntil**: Remove screens until condition met
- **PushReplacement**: Push new screen and remove current

---

## App Navigation Structure

### Screen Hierarchy

```
App Launch
    ↓
Splash Screen (SplashScreen)
    ↓
Launch B Screen (OnboardingScreen)
    ↓
    ├─→ Home Screen (HomeScreen) ← Main Hub
    │       ├─→ Add Saving Screen (AddGoalScreen)
    │       ├─→ Goal Details Screen
    │       ├─→ Portfolio Screen
    │       └─→ Notifications Screen
    │
    ├─→ Profile Screen
    │       ├─→ Settings Screen
    │       ├─→ Statistics Screen
    │       └─→ About Screen
    │
    └─→ Wallet Connection (WalletConnectScreen)
```

---

## Core Screens

### 1. Splash Screen

**Purpose**: App initialization and branding

**Location**: `lib/screens/splash_screen.dart`

```dart
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Initialize services
    await Future.delayed(Duration(seconds: 2));

    // Navigate to next screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LaunchBScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
```

**Navigation**:
- **To**: Launch B Screen (Onboarding)
- **Method**: `pushReplacement` (can't go back to splash)

---

### 2. Launch B Screen (Onboarding)

**Purpose**: Welcome and wallet connection

**Location**: `lib/screens/launch_b_screen.dart`

```dart
class LaunchBScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Onboarding content
          Text('Welcome to StackSave'),

          // Connect wallet button
          ElevatedButton(
            onPressed: () => _connectWallet(context),
            child: Text('Connect Wallet'),
          ),
        ],
      ),
    );
  }

  Future<void> _connectWallet(BuildContext context) async {
    final walletService = Provider.of<WalletService>(
      context,
      listen: false,
    );

    await walletService.connectWallet();

    if (walletService.isConnected) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  }
}
```

**Navigation**:
- **To**: Home Screen (after wallet connection)
- **Method**: `pushReplacement` (start fresh flow)

---

### 3. Home Screen

**Purpose**: Main dashboard showing all goals

**Location**: `lib/screens/home_screen.dart`

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Goals'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: GoalsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddSavingScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) => _onNavigationTap(context, index),
      ),
    );
  }

  void _onNavigationTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PortfolioScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProfileScreen()),
        );
        break;
    }
  }
}
```

**Navigation**:
- **To**: Add Saving Screen (FAB)
- **To**: Goal Details Screen (tap goal card)
- **To**: Portfolio Screen (bottom nav)
- **To**: Profile Screen (bottom nav)
- **To**: Notifications Screen (app bar)

---

### 4. Add Saving Screen

**Purpose**: Create new savings goal

**Location**: `lib/screens/add_saving_screen.dart`

```dart
class AddSavingScreen extends StatefulWidget {
  @override
  _AddSavingScreenState createState() => _AddSavingScreenState();
}

class _AddSavingScreenState extends State<AddSavingScreen> {
  final _formKey = GlobalKey<FormState>();
  String _goalName = '';
  double _targetAmount = 0;

  Future<void> _createGoal() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    // Create goal
    final goal = SavingsGoal(
      name: _goalName,
      targetAmount: _targetAmount,
    );

    // Save to blockchain
    await saveGoal(goal);

    // Navigate back with result
    Navigator.pop(context, goal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Goal'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Goal Name'),
              onSaved: (value) => _goalName = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Target Amount'),
              keyboardType: TextInputType.number,
              onSaved: (value) => _targetAmount = double.parse(value ?? '0'),
            ),
            ElevatedButton(
              onPressed: _createGoal,
              child: Text('Create Goal'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Navigation**:
- **From**: Home Screen
- **Back**: `Navigator.pop()` with created goal

---

## Navigation Patterns

### 1. Basic Navigation (Push/Pop)

```dart
// Navigate to new screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailsScreen(),
  ),
);

// Go back
Navigator.pop(context);

// Go back with data
Navigator.pop(context, resultData);
```

### 2. Replace Navigation

```dart
// Replace current screen
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => NewScreen(),
  ),
);

// Use case: After login, don't allow back to login screen
```

### 3. Named Routes

Define routes in main.dart:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/onboarding': (context) => LaunchBScreen(),
        '/home': (context) => HomeScreen(),
        '/add-goal': (context) => AddSavingScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
```

Navigate using names:

```dart
// Navigate to named route
Navigator.pushNamed(context, '/add-goal');

// With arguments
Navigator.pushNamed(
  context,
  '/goal-details',
  arguments: goalId,
);

// Extract arguments
final goalId = ModalRoute.of(context)!.settings.arguments as String;
```

### 4. Modal Navigation

```dart
// Show bottom sheet
showModalBottomSheet(
  context: context,
  builder: (context) {
    return DepositWidget();
  },
);

// Show dialog
showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: Text('Confirm'),
      content: Text('Are you sure?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Confirm'),
        ),
      ],
    );
  },
);
```

---

## Passing Data Between Screens

### Method 1: Constructor Arguments

```dart
// Pass data
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => GoalDetailsScreen(
      goalId: 'goal-123',
    ),
  ),
);

// Receive data
class GoalDetailsScreen extends StatelessWidget {
  final String goalId;

  GoalDetailsScreen({required this.goalId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Goal: $goalId')),
    );
  }
}
```

### Method 2: Route Arguments

```dart
// Send
Navigator.pushNamed(
  context,
  '/goal-details',
  arguments: GoalArguments(
    goalId: 'goal-123',
    goalName: 'Emergency Fund',
  ),
);

// Receive
class GoalDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as GoalArguments;

    return Scaffold(
      appBar: AppBar(title: Text(args.goalName)),
    );
  }
}

class GoalArguments {
  final String goalId;
  final String goalName;

  GoalArguments({required this.goalId, required this.goalName});
}
```

### Method 3: Return Data

```dart
// Wait for result
final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AddSavingScreen(),
  ),
);

if (result != null) {
  print('Goal created: $result');
}

// Return data from screen
Navigator.pop(context, newGoal);
```

---

## Navigation Guards

### Check Wallet Connection

```dart
void navigateToGoalDetails(BuildContext context) {
  final walletService = Provider.of<WalletService>(
    context,
    listen: false,
  );

  if (!walletService.isConnected) {
    // Show connection dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Wallet Required'),
          content: Text('Please connect your wallet first'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }

  // Proceed with navigation
  Navigator.pushNamed(context, '/goal-details');
}
```

---

## Bottom Navigation Bar

### Implementation

```dart
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    PortfolioScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

---

## Deep Linking

### Setup (Conceptual)

Handle external links to app:

```dart
// Handle deep link
void handleDeepLink(Uri uri) {
  if (uri.path == '/goal') {
    final goalId = uri.queryParameters['id'];
    Navigator.pushNamed(
      context,
      '/goal-details',
      arguments: goalId,
    );
  }
}

// Example deep link:
// stacksave://goal?id=goal-123
```

---

## Navigation Transitions

### Custom Transitions

```dart
// Slide transition
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return GoalDetailsScreen();
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  ),
);
```

### Fade Transition

```dart
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (_, __, ___) => NewScreen(),
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  ),
);
```

---

## Navigation Best Practices

### Do's ✅

1. **Use named routes for complex apps**:
```dart
// ✅ Centralized route management
routes: {
  '/home': (_) => HomeScreen(),
  '/add-goal': (_) => AddGoalScreen(),
}

// ❌ Scattered MaterialPageRoute calls
Navigator.push(context, MaterialPageRoute(...));
```

2. **Handle navigation errors**:
```dart
Navigator.pushNamed(context, '/unknown').catchError((error) {
  // Show 404 screen
  Navigator.pushReplacementNamed(context, '/404');
});
```

3. **Clean up on pop**:
```dart
@override
void dispose() {
  // Cancel subscriptions, close streams
  _subscription.cancel();
  super.dispose();
}
```

4. **Use WillPopScope for confirmation**:
```dart
WillPopScope(
  onWillPop: () async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Discard changes?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
    return shouldPop ?? false;
  },
  child: FormScreen(),
)
```

### Don'ts ❌

1. **Don't use context after async gap**:
```dart
// ❌ Context might be invalid
Future<void> doSomething() async {
  await someAsyncOperation();
  Navigator.push(context, ...); // Dangerous!
}

// ✅ Check mounted
Future<void> doSomething() async {
  await someAsyncOperation();
  if (!mounted) return;
  Navigator.push(context, ...);
}
```

2. **Don't build deep navigation stacks**:
```dart
// ❌ Screen -> Screen -> Screen -> Screen -> Screen
// User must tap back 5 times

// ✅ Use pushReplacement or popAndPushNamed
Navigator.pushReplacement(context, ...);
```

---

## Troubleshooting

### Navigator Not Found

**Error**: `Navigator operation requested with a context that does not include a Navigator`

**Solution**: Ensure MaterialApp is in widget tree:
```dart
void main() {
  runApp(
    MaterialApp(
      home: MyScreen(),
    ),
  );
}
```

### Context Issues

**Problem**: Using context after async operation

**Solution**:
```dart
Future<void> myFunction(BuildContext context) async {
  await asyncOperation();

  // Check widget still mounted
  if (!mounted) return;

  Navigator.push(context, ...);
}
```

---

## User Flows

### First Time User

```
Splash → Onboarding → Connect Wallet → Home
```

### Returning User

```
Splash → Home (auto-connect wallet)
```

### Create Goal Flow

```
Home → Add Goal → [Form] → Submit → Home (with new goal)
```

### Deposit Flow

```
Home → Goal Details → Deposit Sheet → Wallet Confirm → Goal Details (updated)
```

### Withdrawal Flow

```
Home → Goal Details → Withdraw Sheet → Confirm Dialog → Wallet Confirm → Goal Details (updated)
```

---

## Next Steps

- [State Management](state-management.md) - How data flows
- [Data Models](data-models.md) - Application data structures
- [Project Structure](project-structure.md) - Code organization

---

Need help? Check [Development Setup](../development/setup.md) or [FAQ](../resources/faq.md).
