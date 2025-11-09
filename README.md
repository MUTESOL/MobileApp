# StackSave 💰

<div align="center">

![StackSave Logo](design/logo.png)

**A Decentralized Savings Application Built with Flutter & Web3**

*Empowering users to save smarter with blockchain technology*

[![Flutter Version](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Documentation](#-documentation) • [Contributing](#-contributing)

</div>

---

## 📖 About

StackSave is a modern mobile application that combines traditional savings goals with blockchain technology, allowing users to manage their financial goals while leveraging the power of Web3 wallets and decentralized finance.

### ✨ Key Highlights

- 🎯 **Goal-Based Savings**: Create and track multiple savings goals with custom targets
- 🔗 **Web3 Integration**: Connect crypto wallets via WalletConnect V2
- 💸 **Daily Savings**: Track your daily saving habits
- 🤝 **Social Impact**: Allocate donations to causes you care about
- 📊 **Portfolio Dashboard**: Monitor all your savings in one place
- 🔔 **Smart Notifications**: Get reminders and milestone alerts
- 🔒 **Secure**: Non-custodial, your keys your crypto

---

## 🚀 Installation

You can run StackSave in **two ways**:

### Option 1: Using APK File (Easiest) 📱

**For quick testing and usage**:

1. **Download APK**
   - Download the latest `stacksave.apk` from [Releases](https://github.com/MUTESOL/MobileApp/releases)
   - Or get it from the hackathon submission folder

2. **Install on Android**
   - Transfer APK to your Android device
   - Enable "Install from Unknown Sources" in Settings
   - Tap the APK file and install

3. **Open StackSave**
   - Launch the app from your app drawer
   - You're ready to go! 🎉

---

### Option 2: Using GitHub Repository (For Developers) 👨‍💻

**For development and customization**:

#### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK (comes with Flutter)
- Android Studio / VS Code
- Android device or emulator
- Git

#### Steps

1. **Clone the Repository**

   ```bash
   git clone https://github.com/MUTESOL/MobileApp.git
   cd MobileApp
   git checkout import/stacksave
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Connect Your Device**

   **For Physical Device**:
   - Enable Developer Mode on your Android phone:
     - Go to `Settings` > `About Phone`
     - Tap `Build Number` 7 times
     - Go back to `Settings` > `Developer Options`
     - Enable `USB Debugging`
   - Connect via USB cable
   - Trust the computer on your device

   **For Emulator**:
   - Open Android Studio
   - AVD Manager > Create Virtual Device
   - Select device and download system image
   - Start emulator

4. **Verify Device Connection**

   ```bash
   flutter devices
   ```

   You should see your device listed.

5. **Run the App**

   ```bash
   flutter run
   ```

   The app will install and launch on your device! 🚀

---

## 🔧 Setup & Configuration

### 1️⃣ Install Wallet (Required)

StackSave requires a Web3 wallet to function. **We recommend OKX Wallet** for easier custom network setup.

**Download OKX Wallet**:
- [OKX Wallet - Google Play](https://play.google.com/store/apps/details?id=com.okinc.okex.gp)
- [OKX Wallet - iOS App Store](https://apps.apple.com/app/okx-wallet/id1327268470)

**Alternative Wallets** (also supported):
- MetaMask
- Trust Wallet
- Rainbow Wallet
- Any WalletConnect V2 compatible wallet

---

### 2️⃣ Add Custom Network (Tenderly Fork)

StackSave uses a custom EVM network for this hackathon.

#### Network Details

```
Network Name:     StackSave Network
RPC URL:          https://rpc.tenderly.co/fork/82c86106-662e-4d7f-a974-c311987358ff
Chain ID:         1 (or as specified)
Currency Symbol:  ETH
Block Explorer:   https://dashboard.tenderly.co/explorer/vnet/82c86106-662e-4d7f-a974-c311987358ff/transactions
```

#### Setup in OKX Wallet (Recommended)

1. **Open OKX Wallet**
2. **Tap** on the network dropdown (top of screen)
3. **Tap** "Add Custom Network" or ➕ icon
4. **Fill in the details**:
   ```
   Network Name: StackSave Network
   RPC URL: https://rpc.tenderly.co/fork/82c86106-662e-4d7f-a974-c311987358ff
   Chain ID: 1
   Symbol: ETH
   ```
5. **Save**
6. **Switch** to StackSave Network

#### Setup in MetaMask

1. **Open MetaMask**
2. **Tap** network dropdown
3. **"Add Network"** > **"Add a network manually"**
4. **Enter details** (same as above)
5. **Save** and **switch** to the network

---

### 3️⃣ Get Test Tokens

You'll need tokens to test the app.

**Option A: Request from Hackathon Organizers** (Recommended)
- Contact hackathon organizers
- Provide your wallet address
- They will send test tokens

**Option B: Tenderly Faucet** (if available)
- Visit the Tenderly dashboard
- Use built-in faucet if available

**Your Wallet Address**:
- Open your wallet
- Copy your address (starts with `0x...`)
- Share with organizers

---

## 📱 How to Use StackSave

### First Time Setup

#### 1. Launch the App
- Open StackSave on your device
- You'll see the welcome/onboarding screen

#### 2. Connect Your Wallet

1. **Tap** "Connect Wallet" button
2. **Select** your wallet (OKX recommended)
3. **Approve** the connection in your wallet app
4. **Verify** you're on StackSave Network
5. **Success!** Your wallet is connected ✅

#### 3. Create Your First Goal 🎯

1. **Tap** the ➕ button on home screen
2. **Fill in goal details**:
   ```
   Goal Name:       Emergency Fund
   Target Amount:   1000 USDC (or any amount)
   Deadline:        Optional (e.g., 3 months from now)
   Category:        Emergency
   ```
3. **Tap** "Create Goal"
4. **Approve** transaction in your wallet
5. **Wait** for confirmation (~5 seconds)
6. **Done!** Your goal is created 🎉

---

### Daily Usage

#### Save Money 💰

1. **Tap** on a goal from home screen
2. **Tap** "Deposit" button
3. **Enter amount** to save (e.g., 10 USDC)
4. **Confirm** in your wallet
5. **Track** your progress bar grow! 📈

**Pro Tip**: Save a little every day for best results!

#### Allocate Donations 🤝

StackSave allows you to set aside a portion for charitable causes:

1. **Go to** goal details
2. **Find** "Donation Allocation" section
3. **Set percentage** (e.g., 5% of savings)
4. **Choose cause** (if available)
5. **Save** settings

Your donations will be tracked separately and can be distributed to causes you care about!

#### Track Your Portfolio 📊

1. **Tap** "Portfolio" tab
2. **View**:
   - Total savings across all goals
   - Individual goal progress
   - Recent transactions
   - Savings rate and analytics

#### Withdraw Funds 💸

When you reach your goal or need funds:

1. **Tap** on the goal
2. **Tap** "Withdraw"
3. **Enter amount** (or tap MAX)
4. **Confirm** withdrawal
5. **Approve** in wallet
6. **Funds** sent to your wallet! ✅

---

## 🏗️ Repository Structure

StackSave is part of the **MUT-TANT Organization** ecosystem.

### Organization: [MUT-TANT](https://github.com/orgs/MUT-TANT/repositories)

Our organization consists of multiple repositories for different components:

```
MUT-TANT/
├── 📱 MobileApp (StackSave Flutter App)
│   ├── Main mobile application
│   ├── Web3 wallet integration
│   ├── UI/UX implementation
│   └── Client-side logic
│
├── 🔧 SmartContract (Blockchain Backend)
│   ├── Solidity smart contracts
│   ├── Savings goal management
│   ├── Donation allocation logic
│   └── Testing & deployment scripts
│
├── 🌐 Frontend (Web Dashboard - Optional)
│   ├── Next.js web application
│   ├── Portfolio analytics
│   └── Admin dashboard
│
└── 📚 Documentation
    ├── Technical specifications
    ├── API documentation
    └── Architecture diagrams
```

### Main Repository: MobileApp

```
MobileApp/
├── lib/
│   ├── constants/          # App constants and theme
│   ├── models/             # Data models
│   │   ├── savings_goal.dart
│   │   ├── transaction.dart
│   │   └── notification_model.dart
│   ├── screens/            # UI screens
│   │   ├── launch_b_screen.dart    # Onboarding
│   │   ├── home_screen.dart        # Main dashboard
│   │   ├── add_saving_screen.dart  # Create goal
│   │   └── profile_screen.dart     # User profile
│   ├── services/           # Business logic
│   │   ├── wallet_service.dart     # WalletConnect integration
│   │   └── blockchain_service.dart # Smart contract calls
│   ├── widgets/            # Reusable components
│   └── main.dart           # App entry point
│
├── docs/                   # GitBook documentation (41 files)
│   ├── features/           # Feature guides
│   ├── architecture/       # Technical architecture
│   ├── web3/              # Web3 integration docs
│   ├── api/               # API reference
│   ├── development/       # Dev guides
│   ├── contributing/      # Contribution guidelines
│   └── resources/         # FAQ, troubleshooting, etc.
│
├── design/                # Image assets
├── fonts/                 # Poppins font family
├── android/              # Android specific config
├── ios/                  # iOS specific config
├── test/                 # Unit & widget tests
│
├── pubspec.yaml          # Flutter dependencies
├── .gitbook.yaml         # GitBook configuration
├── book.json             # GitBook CLI config
└── README.md             # This file
```

---

## 🎨 Features

### ✅ Implemented Features

- [x] WalletConnect V2 integration
- [x] Multiple savings goals
- [x] Goal creation and management
- [x] Deposit functionality
- [x] Withdrawal functionality
- [x] Portfolio dashboard
- [x] Transaction history
- [x] Progress tracking
- [x] Notifications
- [x] Donation allocation
- [x] Beautiful UI/UX
- [x] Dark mode support

### 🚧 Coming Soon

- [ ] Recurring deposits (auto-save)
- [ ] Multiple network support (Polygon, BSC)
- [ ] Social features (share goals)
- [ ] Interest earning on deposits
- [ ] Advanced analytics
- [ ] Goal templates
- [ ] Multi-currency support

---

## 📚 Documentation

Comprehensive documentation is available:

### 📖 GitBook Documentation

**View Online**: [StackSave Docs](https://mutesol.gitbook.io/stacksave-documentation) _(coming soon)_

**Browse Locally**:
- [Getting Started Guide](./docs/getting-started/quick-start.md)
- [Features Overview](./docs/features/overview.md)
- [Savings Goals Guide](./docs/features/savings-goals.md)
- [Architecture Overview](./docs/architecture/project-structure.md)
- [Web3 Integration](./docs/web3/wallet-connect.md)
- [API Reference](./docs/api/services.md)
- [Development Setup](./docs/development/setup.md)
- [Contributing Guide](./docs/contributing/how-to-contribute.md)
- [FAQ](./docs/resources/faq.md)
- [Troubleshooting](./docs/resources/troubleshooting.md)

---

## 🛠️ Technology Stack

### Frontend (Mobile)
- **Flutter** 3.9.2 - Cross-platform framework
- **Dart** - Programming language
- **Provider** - State management
- **Material Design 3** - UI framework

### Web3 & Blockchain
- **WalletConnect V2** - Wallet connection protocol
- **web3dart** - Ethereum library for Dart
- **Tenderly** - Custom EVM network (fork)
- **Solidity** - Smart contract language

### Design
- **Figma** - UI/UX design
- **Poppins** - Custom font
- **Material Icons** - Icon set

---

## 🔧 Development

### Prerequisites

- Flutter SDK 3.9.2+
- Dart SDK 3.0.0+
- Android Studio / Xcode
- Git

### Setup Development Environment

1. **Clone Repository**
   ```bash
   git clone https://github.com/MUTESOL/MobileApp.git
   cd MobileApp
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run Tests**
   ```bash
   flutter test
   ```

4. **Run App**
   ```bash
   flutter run
   ```

### Building

**Android APK**:
```bash
flutter build apk --release
```

**Android App Bundle** (for Play Store):
```bash
flutter build appbundle --release
```

**iOS** (macOS only):
```bash
flutter build ios --release
```

---

## 🧪 Testing

### Run All Tests
```bash
flutter test
```

### Run with Coverage
```bash
flutter test --coverage
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

---

## 🤝 Contributing

We welcome contributions from the community!

### Quick Start

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Guidelines

- Follow the [Code Style Guide](./docs/development/code-style.md)
- Write tests for new features
- Update documentation
- Follow [Contribution Guidelines](./docs/contributing/how-to-contribute.md)

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](./docs/resources/license.md) file for details.

---

## 🆘 Support & Help

### Documentation
- 📖 [Full Documentation](./docs)
- 🚀 [Quick Start Guide](./docs/getting-started/quick-start.md)
- ❓ [FAQ](./docs/resources/faq.md)
- 🔧 [Troubleshooting](./docs/resources/troubleshooting.md)

### Community
- 💬 [GitHub Discussions](https://github.com/MUTESOL/MobileApp/discussions)
- 🐛 [Report Issues](https://github.com/MUTESOL/MobileApp/issues)
- 📧 Email: support@stacksave.io

### Hackathon Support
- Contact hackathon organizers for:
  - Test tokens
  - Network access issues
  - Technical questions

---

## 🙏 Acknowledgments

### Built With
- [Flutter](https://flutter.dev) - Beautiful native apps
- [WalletConnect](https://walletconnect.com) - Wallet connection protocol
- [Tenderly](https://tenderly.co) - EVM network infrastructure
- [Material Design](https://material.io) - Design system

### Special Thanks
- Hackathon organizers for the opportunity
- Open source community for amazing tools
- All contributors and testers

---

## 👥 Team

**MUT-TANT Organization**

- Lead Developer: [Your Name]
- Smart Contract Developer: [Team Member]
- UI/UX Designer: [Team Member]
- Documentation: [Team Member]

---

## 📞 Contact

- **Website**: [stacksave.io](https://stacksave.io) _(coming soon)_
- **Email**: team@stacksave.io
- **GitHub Org**: [MUT-TANT](https://github.com/MUT-TANT)
- **Twitter**: [@StackSaveApp](https://twitter.com/StackSaveApp) _(coming soon)_

---

## 🗺️ Roadmap

### Phase 1 - MVP ✅ (Current)
- [x] Basic savings goals
- [x] WalletConnect integration
- [x] Deposit/Withdrawal
- [x] Portfolio dashboard

### Phase 2 - Enhancement 🚧 (Q2 2025)
- [ ] Automated savings
- [ ] Multiple networks
- [ ] Advanced analytics
- [ ] Social features

### Phase 3 - DeFi Integration 📋 (Q3 2025)
- [ ] Interest earning
- [ ] Staking integration
- [ ] Yield optimization
- [ ] NFT rewards

---

<div align="center">

## ⭐ Star this repo if you find it useful!

**Made with ❤️ by the MUT-TANT Team**

[⬆ Back to top](#stacksave-)

</div>
