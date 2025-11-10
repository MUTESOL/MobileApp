# How to Contribute

Thank you for your interest in contributing to StackSave! This guide will help you get started.

## Ways to Contribute

### 🐛 Report Bugs
Found a bug? Help us fix it!
- Check if it's already reported in [Issues](https://github.com/yourusername/stacksave/issues)
- Create a new issue with detailed steps to reproduce
- Include screenshots, error logs, device info

### ✨ Suggest Features
Have an idea for improvement?
- Check [existing feature requests](https://github.com/yourusername/stacksave/issues?q=label%3Aenhancement)
- Open a new issue with the `enhancement` label
- Describe the feature, use case, and benefits

### 📝 Improve Documentation
Documentation is always appreciated!
- Fix typos or unclear explanations
- Add examples or tutorials
- Translate to other languages (future)

### 💻 Write Code
Ready to code?
- Pick an issue labeled `good first issue` or `help wanted`
- Fix bugs or implement features
- Follow our coding standards (below)

### 🧪 Write Tests
Help improve code quality!
- Add unit tests
- Write widget tests
- Create integration tests

### 🎨 Design
Creative skills welcome!
- UI/UX improvements
- Icons and graphics
- Marketing materials

## Getting Started

### 1. Fork the Repository

```bash
# Fork on GitHub, then clone your fork
git clone https://github.com/MUT-TANT/MobileApp.git
cd stacksave
```

### 2. Set Up Development Environment

See [Development Setup](../development/setup.md) for detailed instructions.

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

### 3. Create a Branch

```bash
# Create a branch for your work
git checkout -b feature/my-awesome-feature

# Or for bug fixes
git checkout -b fix/bug-description
```

**Branch naming**:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Test additions

### 4. Make Your Changes

- Write clean, readable code
- Follow Flutter best practices
- Add comments for complex logic
- Test your changes thoroughly

### 5. Test Your Changes

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/widget_test.dart

# Check code analysis
flutter analyze
```

### 6. Commit Your Changes

Use clear, descriptive commit messages:

```bash
git add .
git commit -m "feat: add dark mode toggle to settings"
```

**Commit message format**:
```
<type>: <description>

[optional body]

[optional footer]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting, no code change
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples**:
```bash
git commit -m "feat: implement multi-currency support"
git commit -m "fix: resolve wallet disconnect issue on iOS"
git commit -m "docs: update WalletConnect setup guide"
git commit -m "test: add tests for WalletService"
```

### 7. Push to Your Fork

```bash
git push origin feature/my-awesome-feature
```

### 8. Create Pull Request

1. Go to [StackSave repository](https://github.com/MUT-TANT/MobileApp.git)
2. Click "New Pull Request"
3. Select your fork and branch
4. Fill in the PR template (see below)
5. Submit for review

## Pull Request Guidelines

### PR Title Format

```
<type>: <description>
```

Example: `feat: add support for Polygon network`

### PR Description Template

```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Changes Made
- Change 1
- Change 2
- Change 3

## Screenshots (if applicable)
Add screenshots here

## Testing
- [ ] Tested on Android
- [ ] Tested on iOS
- [ ] Added/updated tests
- [ ] All tests passing

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Code commented where needed
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests added/updated
- [ ] Tests pass locally
```

### Review Process

1. **Automated Checks**: CI runs tests and linting
2. **Code Review**: Maintainer reviews your code
3. **Feedback**: Address any requested changes
4. **Approval**: Once approved, PR will be merged
5. **Thank You!**: Your contribution is live! 🎉

## Coding Standards

### Dart/Flutter Style

Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style):

```dart
// ✅ Good
class MyClass {
  final String userName;

  MyClass({required this.userName});

  void doSomething() {
    // Implementation
  }
}

// ❌ Bad
class myclass {
  String username;
  void DoSomething() {}
}
```

### File Organization

```dart
// 1. Imports (grouped)
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:stacksave/models/user.dart';

// 2. Class definition
class MyWidget extends StatelessWidget {
  // 3. Properties
  final String title;

  // 4. Constructor
  const MyWidget({Key? key, required this.title}) : super(key: key);

  // 5. Methods
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  // 6. Helper methods
  void _helper() {}
}
```

### Code Quality

#### Use Descriptive Names

```dart
// ✅ Good
final walletAddress = '0x123...';
void connectToWallet() {}

// ❌ Bad
final addr = '0x123...';
void connect() {}
```

#### Add Comments for Complex Logic

```dart
// ✅ Good
// Extract wallet address from WalletConnect session account format
// Format: "eip155:1:0xAddress" -> "0xAddress"
final parts = account.split(':');
final address = parts[2];

// ❌ Bad (no context)
final address = account.split(':')[2];
```

#### Handle Errors Properly

```dart
// ✅ Good
try {
  await walletService.connect();
} catch (e) {
  if (kDebugMode) {
    print('Connection error: $e');
  }
  showError('Failed to connect wallet');
}

// ❌ Bad
try {
  await walletService.connect();
} catch (e) {
  // Silent failure
}
```

#### Use Const Where Possible

```dart
// ✅ Good
const Text('Hello')
const EdgeInsets.all(16)

// ❌ Bad (when value is constant)
Text('Hello')
EdgeInsets.all(16)
```

### Widget Best Practices

#### Extract Widgets

```dart
// ✅ Good - Reusable and testable
class GoalCard extends StatelessWidget {
  final Goal goal;
  const GoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Card(/*...*/);
  }
}

// ❌ Bad - Monolithic build method
Widget build(BuildContext context) {
  return Column(
    children: [
      Card(/* 50 lines of widget tree */),
      Card(/* 50 lines of widget tree */),
    ],
  );
}
```

#### Use Keys Appropriately

```dart
ListView.builder(
  itemCount: goals.length,
  itemBuilder: (context, index) {
    final goal = goals[index];
    return GoalCard(
      key: ValueKey(goal.id), // Helps Flutter optimize rebuilds
      goal: goal,
    );
  },
)
```

## Testing Guidelines

### Write Tests for New Features

```dart
// test/services/wallet_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stacksave/services/wallet_service.dart';

void main() {
  group('WalletService', () {
    test('initializes successfully', () async {
      final service = WalletService();
      await service.init(projectId: 'test', appMetadata: {});
      expect(service, isNotNull);
    });

    test('shortens address correctly', () {
      final service = WalletService();
      // Test implementation
    });
  });
}
```

### Test Coverage

Aim for:
- **Unit tests**: Business logic, services, models
- **Widget tests**: UI components
- **Integration tests**: User flows

Run with coverage:
```bash
flutter test --coverage
```

## Documentation Standards

### Code Documentation

Use dartdoc comments for public APIs:

```dart
/// Connects to user's crypto wallet via WalletConnect V2.
///
/// Returns `true` if connection initiated successfully.
/// The actual connection completion happens in [onSessionSettle] callback.
///
/// Example:
/// ```dart
/// final success = await walletService.connectWallet();
/// if (success) {
///   print('Waiting for approval...');
/// }
/// ```
Future<bool> connectWallet() async {
  // Implementation
}
```

### Update Documentation

When making changes:
- Update relevant docs in `/docs`
- Add examples for new features
- Update API reference if needed
- Keep CHANGELOG.md current

## Community Guidelines

### Code of Conduct

Be respectful and constructive:
- ✅ Be welcoming and inclusive
- ✅ Respect differing viewpoints
- ✅ Accept constructive criticism gracefully
- ✅ Focus on what's best for the community
- ❌ No harassment or trolling
- ❌ No inflammatory comments
- ❌ No spam or self-promotion

### Communication

- **Issues**: Bug reports and feature requests
- **Pull Requests**: Code contributions
- **Discussions**: General questions and ideas
- **Discord** (coming soon): Real-time chat

### Getting Help

Stuck? We're here to help!
- Comment on your PR/issue
- Ask in Discussions
- Check [Troubleshooting](../resources/troubleshooting.md)

## Recognition

Contributors are recognized:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Featured on project website (future)

## Legal

By contributing, you agree that:
- Your contributions are your own work
- You grant us rights to use your contribution
- Your contribution is under the same license (MIT)

## Next Steps

Ready to contribute?

1. **Find an issue**: [Good first issues]
2. **Set up dev environment**: [Development Setup](../development/setup.md)
3. **Learn the codebase**: [Architecture](../architecture/project-structure.md)
4. **Ask questions**: Don't hesitate!

---

**Thank you for contributing to StackSave! Every contribution, no matter how small, helps make the project better.** 🙏
