# Connecting Your Wallet

Learn how to securely connect your crypto wallet to StackSave using WalletConnect V2.

## What is WalletConnect?

WalletConnect is an open-source protocol that allows your crypto wallet to securely communicate with dApps (decentralized applications) like StackSave. It's:
- **Secure**: End-to-end encrypted connection
- **Universal**: Works with 200+ wallets
- **Easy**: Simple QR code or deep-link connection

## Supported Wallets

StackSave works with any WalletConnect V2 compatible wallet, including:

### Popular Options
- **MetaMask** - Most widely used Ethereum wallet
- **Trust Wallet** - Mobile-first, multi-chain wallet
- **Rainbow** - Elegant interface, Ethereum-focused
- **Coinbase Wallet** - Integrated with Coinbase exchange
- **Argent** - Smart contract wallet with social recovery
- **Zerion** - Portfolio tracking + wallet

### Full Compatibility
Over 200 wallets support WalletConnect V2. If your wallet supports it, it works with StackSave!

## Connection Methods

### Method 1: Mobile to Mobile (Recommended)

If StackSave and your wallet are on the same device:

1. Open StackSave
2. Tap **"Connect Wallet"**
3. Tap **"Open in Wallet"** or the wallet app icon
4. Your wallet app opens automatically
5. Review the connection request
6. Tap **"Approve"** or **"Connect"**
7. Return to StackSave - you're connected! ✅

### Method 2: QR Code Scan

If using a wallet on a different device:

1. Open StackSave on one device
2. Tap **"Connect Wallet"**
3. A QR code appears on screen
4. Open your wallet app on another device
5. Tap the scan icon (usually top-right)
6. Scan the QR code from StackSave
7. Approve the connection in your wallet
8. StackSave updates to show connection success ✅

### Method 3: Copy URI

Alternative manual method:

1. Tap **"Copy Connection Link"** in StackSave
2. Paste it into your wallet's WalletConnect feature
3. Approve the connection
4. Return to StackSave

## Step-by-Step Guide

### Detailed Connection Process

#### 1. Launch Connection Flow

From the welcome screen or profile settings:
- Tap **"Connect Wallet"** button
- StackSave initializes WalletConnect

#### 2. Connection Screen

You'll see:
- **QR Code**: For scanning with mobile wallet
- **Connection URI**: Long string starting with "wc:"
- **Wallet Icons**: Quick links to popular wallets
- **Status**: "Waiting for wallet approval..."

#### 3. Approve in Wallet

Your wallet will show:
- **App Name**: StackSave
- **Permissions Requested**:
  - View wallet address
  - Request transaction approval
  - View account balance
- **Chain**: Ethereum Mainnet (or selected network)

**Important**: Review permissions carefully before approving.

#### 4. Connection Confirmed

After approval:
- StackSave shows success message
- Your wallet address appears (shortened)
- Home screen becomes accessible
- Connected status indicator appears

## Connection Details

### What StackSave Requests

When connecting, StackSave requests permission to:

#### View Permissions
- ✅ Read your wallet address
- ✅ Check your balance
- ✅ View transaction history

#### Action Permissions
- ✅ Request transaction signatures
- ✅ Request message signatures

#### What StackSave NEVER Can Do
- ❌ Access your private keys
- ❌ Move funds without your approval
- ❌ Change wallet settings
- ❌ Access other apps or data

### Supported Blockchains

Currently supported:
- **Ethereum Mainnet** (EIP-155:1)

Coming soon:
- Polygon
- Arbitrum
- Optimism
- Base

### Supported Methods

StackSave uses these blockchain methods:
- `eth_sendTransaction` - Send transactions
- `eth_signTransaction` - Sign transactions
- `personal_sign` - Sign messages
- `eth_sign` - General signing
- `eth_signTypedData` - Typed data signing

## Managing Your Connection

### Check Connection Status

To verify you're connected:
1. Look for wallet address in profile
2. Check for "Connected" status indicator
3. Try accessing portfolio or goals

### Disconnect Wallet

To safely disconnect:

1. Go to **Profile** tab
2. Tap **"Disconnect Wallet"**
3. Confirm disconnection
4. StackSave returns to welcome screen

Your data is saved locally and will be there when you reconnect.

### Reconnect Wallet

To reconnect after disconnecting:

1. Tap **"Connect Wallet"** from welcome screen
2. Follow connection steps again
3. Your previous goals and data reload

### Switch Wallets

To connect a different wallet:

1. Disconnect current wallet (see above)
2. Connect new wallet
3. Note: Goals are wallet-specific

## Troubleshooting Connection

### "Connection Timed Out"

**Cause**: Wallet didn't respond in time

**Solutions**:
- Ensure wallet app is running
- Check internet connection
- Try again with fresh QR code
- Restart both apps

### "Connection Rejected"

**Cause**: You declined the connection request

**Solutions**:
- Try connecting again
- Approve the request in wallet
- Check wallet is unlocked

### "Wallet Not Found"

**Cause**: Deep link couldn't find wallet app

**Solutions**:
- Ensure wallet app is installed
- Try QR code method instead
- Update wallet app to latest version

### "Wrong Network"

**Cause**: Wallet is on different blockchain network

**Solutions**:
- Switch wallet to Ethereum Mainnet
- Check network settings in wallet
- Some wallets auto-switch - approve the change

### QR Code Won't Scan

**Solutions**:
- Increase screen brightness
- Ensure QR code is fully visible
- Try copy-paste URI method instead
- Use different device/camera

### Connection Keeps Dropping

**Solutions**:
- Check internet stability
- Restart both apps
- Clear app cache
- Update to latest app versions

## Security Best Practices

### ✅ Do's

- ✓ Verify you're connecting to the real StackSave app
- ✓ Review connection permissions before approving
- ✓ Keep your wallet app updated
- ✓ Use a strong wallet password/PIN
- ✓ Enable biometric authentication if available
- ✓ Disconnect when not in use (optional)

### ❌ Don'ts

- ✗ Never share your seed phrase/private key
- ✗ Don't approve connections from unknown apps
- ✗ Don't use public WiFi for financial transactions
- ✗ Don't store seed phrase digitally
- ✗ Don't ignore wallet security warnings

## Advanced Topics

### Session Management

WalletConnect sessions:
- Last until manually disconnected
- Persist across app restarts
- Can be managed in wallet app
- Are encrypted end-to-end

### Multiple Sessions

You can have multiple WalletConnect sessions:
- Each app gets its own session
- Sessions are independent
- Disconnect each separately if needed
- Check active sessions in wallet settings

### Network Switching

To change blockchain networks:
1. Switch network in your wallet
2. StackSave will detect the change
3. Some features may be network-specific

## FAQ

**Q: Is WalletConnect safe?**
A: Yes! It's an industry-standard protocol used by thousands of dApps. Your private keys never leave your wallet.

**Q: Do I need a new wallet?**
A: Not if you already have a WalletConnect-compatible wallet. Most modern wallets support it.

**Q: Can I use multiple wallets?**
A: Yes, but one at a time. Disconnect current wallet first, then connect another.

**Q: Will disconnecting delete my goals?**
A: No! Goals are stored locally and tied to your wallet address. They'll be there when you reconnect.

**Q: Does connection use data/battery?**
A: Minimal. The connection is lightweight and only active when needed.

## Next Steps

- [Create Your First Goal](first-goal.md)
- [Make a Deposit](../features/savings-goals.md#making-deposits)
- [Explore Portfolio](../features/portfolio.md)

---

**Need help?** Visit [Troubleshooting](../resources/troubleshooting.md) or [FAQ](../resources/faq.md).
