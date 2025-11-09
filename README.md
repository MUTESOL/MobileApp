# StackSave

> A decentralized savings application built with Flutter and Web3 technology

StackSave is a modern mobile application that combines traditional savings goals with blockchain technology, allowing users to manage their financial goals while leveraging the power of Web3 wallets and decentralized finance.

## Overview

StackSave empowers users to:
- Set and track multiple savings goals with visual progress indicators
- Connect external crypto wallets via WalletConnect V2
- Manage their portfolio with real-time updates
- Receive notifications about savings milestones and reminders
- Withdraw funds securely through blockchain transactions

## Key Features

### Savings Goals
Create custom savings goals with specific targets and deadlines. Track your progress with beautiful visual indicators and receive notifications when you hit milestones.

### Web3 Integration
Connect any WalletConnect-compatible wallet (MetaMask, Trust Wallet, Rainbow, etc.) to manage your crypto savings securely on-chain.

### Portfolio Dashboard
Monitor all your savings goals in one place with a clean, intuitive interface that shows your total savings, active goals, and recent activity.

### Notifications
Stay informed with smart notifications for:
- Savings reminders
- Goal milestones
- Transaction confirmations
- App updates

## Technology Stack

- **Framework**: Flutter 3.9.2
- **State Management**: Provider
- **Web3**: WalletConnect V2
- **UI**: Material Design 3 with custom theming
- **Font**: Poppins

## Quick Start

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK
- Android Studio / Xcode (for mobile development)
- A crypto wallet app (MetaMask, Trust Wallet, etc.)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/stacksave.git
cd stacksave
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
stacksave/
├── lib/
│   ├── constants/       # Color constants and theme
│   ├── models/          # Data models
│   ├── screens/         # UI screens
│   ├── services/        # Business logic and Web3 integration
│   ├── widgets/         # Reusable UI components
│   └── main.dart        # App entry point
├── design/              # Image assets and design files
├── fonts/               # Custom fonts (Poppins)
├── docs/                # GitBook documentation
└── test/                # Unit and widget tests
```

## Documentation

Comprehensive documentation is available in the [docs](./docs) folder and can be viewed as a GitBook:

- [Getting Started Guide](./docs/getting-started/quick-start.md)
- [Features Overview](./docs/features/overview.md)
- [Architecture](./docs/architecture/project-structure.md)
- [Web3 Integration](./docs/web3/wallet-connect.md)
- [API Reference](./docs/api/services.md)
- [Contributing Guide](./docs/contributing/how-to-contribute.md)

## Development

### Running Tests
```bash
flutter test
```

### Building for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## Contributing

We welcome contributions! Please see our [Contributing Guide](./docs/contributing/how-to-contribute.md) for details on:
- Code of conduct
- Development process
- Submitting pull requests
- Reporting issues

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

- Documentation: [GitBook Docs](./docs)
- Issues: [GitHub Issues](https://github.com/yourusername/stacksave/issues)
- Discussions: [GitHub Discussions](https://github.com/yourusername/stacksave/discussions)

## Acknowledgments

- Built with [Flutter](https://flutter.dev)
- Powered by [WalletConnect](https://walletconnect.com)
- Icons from [Material Design](https://material.io/icons)

---

Made with ❤️ by the StackSave Team
