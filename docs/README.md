# StackSave Documentation

Welcome to the StackSave documentation! This GitBook contains comprehensive guides, tutorials, and API references for StackSave.

## 📚 What's Inside

### [Introduction](introduction/what-is-stacksave.md)
Learn about StackSave, its philosophy, and key features.

### [Getting Started](getting-started/quick-start.md)
Quick start guide to get you up and running in minutes.

### [Features](features/overview.md)
Detailed documentation of all StackSave features.

### [Architecture](architecture/project-structure.md)
Deep dive into the codebase structure and design patterns.

### [Web3 Integration](web3/wallet-connect.md)
Learn how WalletConnect V2 powers StackSave's Web3 features.

### [API Reference](api/wallet-service.md)
Complete API documentation for developers.

### [Development](development/setup.md)
Setup guides and development workflows.

### [Contributing](contributing/how-to-contribute.md)
Help make StackSave better - contribution guidelines and processes.

## 🚀 Quick Links

**New Users**:
- [What is StackSave?](introduction/what-is-stacksave.md)
- [Quick Start Guide](getting-started/quick-start.md)
- [Connecting Your Wallet](getting-started/connecting-wallet.md)

**Developers**:
- [Project Structure](architecture/project-structure.md)
- [WalletConnect Integration](web3/wallet-connect.md)
- [API Reference](api/wallet-service.md)

**Contributors**:
- [How to Contribute](contributing/how-to-contribute.md)
- [Development Setup](development/setup.md)
- [Code Style Guide](development/code-style.md)

## 📖 Using This Documentation

### Navigation
Use the sidebar to browse all documentation sections, or use the search bar to find specific topics.

### Code Examples
Code examples are provided throughout. They're syntax-highlighted and can be copied directly:

```dart
final walletService = Provider.of<WalletService>(context);
if (walletService.isConnected) {
  print('Connected: ${walletService.walletAddress}');
}
```

### Conventions

**File References**:
- References to code files include path from project root
- Example: `lib/services/wallet_service.dart`

**Line References**:
- Specific code locations include line numbers
- Example: `lib/services/wallet_service.dart:25-33`

**API Signatures**:
```dart
Future<bool> connectWallet() async
```

**Icons**:
- ✅ Do this
- ❌ Don't do this
- 💡 Tip or best practice
- ⚠️ Warning or important note

## 🔧 Building the Docs Locally

### With GitBook CLI

```bash
# Install GitBook CLI
npm install -g gitbook-cli

# Navigate to project root
cd stacksave

# Install GitBook plugins
gitbook install

# Serve documentation locally
gitbook serve

# Visit http://localhost:4000
```

### With GitBook.com

1. Create account at [GitBook.com](https://www.gitbook.com)
2. Import repository
3. Point to `/docs` folder
4. Publish!

## 📝 Contributing to Docs

Found an error or want to improve the docs?

1. **Minor edits**: Click "Edit on GitHub" (if available)
2. **Major changes**: Follow [contribution guide](contributing/how-to-contribute.md)

Documentation improvements are always welcome!

## 🆘 Getting Help

- **Troubleshooting**: Check [troubleshooting guide](resources/troubleshooting.md)
- **FAQ**: See [frequently asked questions](resources/faq.md)
- **Issues**: Report issues on [GitHub](https://github.com/yourusername/stacksave/issues)
- **Discussions**: Ask questions in [GitHub Discussions](https://github.com/yourusername/stacksave/discussions)

## 📜 License

This documentation is part of StackSave and is licensed under the MIT License.

---

**Ready to dive in?** Start with the [Quick Start Guide](getting-started/quick-start.md)!
