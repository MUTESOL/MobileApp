# Frequently Asked Questions

Common questions about StackSave, answered.

## General

### What is StackSave?

StackSave is a decentralized mobile application that helps you set and track savings goals using cryptocurrency. It combines traditional savings goal management with Web3 wallet integration.

### Is StackSave free?

Yes! StackSave is completely free to use. You only pay standard blockchain gas fees when making deposits or withdrawals (same fees you'd pay for any blockchain transaction).

### Which platforms does StackSave support?

Currently:
- ✅ iOS (iPhone and iPad)
- ✅ Android (phones and tablets)

Coming soon: Web version

### Do I need cryptocurrency to use StackSave?

Yes. StackSave works with crypto wallets, so you'll need:
- A compatible crypto wallet (MetaMask, Trust Wallet, etc.)
- Some cryptocurrency to save (ETH, USDC, etc.)

## Wallet & Security

### Which wallets are supported?

Any wallet that supports WalletConnect V2, including:
- MetaMask
- Trust Wallet
- Rainbow
- Coinbase Wallet
- Argent
- 200+ other wallets

See the full list at [WalletConnect Explorer](https://explorer.walletconnect.com/).

### Is my money safe?

Yes! StackSave is **non-custodial**, meaning:
- We never hold your funds
- Your money stays in your wallet
- Only you control your private keys
- Transactions require your approval

**Important**: Keep your wallet's recovery phrase safe - we can't recover it if lost.

### Can StackSave access my wallet without permission?

No! Every transaction requires your explicit approval in your wallet app. StackSave can only:
- ✅ View your wallet address
- ✅ Request transaction signatures
- ❌ Cannot move funds without your approval
- ❌ Cannot access your private keys

### What if I lose my phone?

Your savings goals are tied to your wallet address:
1. Install StackSave on new device
2. Connect same wallet
3. Your goals will sync

**Critical**: Keep your wallet's recovery phrase safe in a secure location.

## Savings Goals

### How many goals can I create?

Unlimited! Create as many savings goals as you need.

### Can I change my goal after creating it?

Yes! You can edit:
- Goal name
- Target amount (increase or decrease)
- Deadline
- Category/icon

### What happens if I don't reach my goal by the deadline?

Nothing bad! Deadlines are just motivational targets:
- You can extend the deadline
- Keep saving at your own pace
- Withdraw anytime, even if incomplete
- No penalties

### Can I delete a goal?

Yes, but only if the balance is zero. If you have funds in a goal:
1. Withdraw all funds first
2. Then delete the goal

### Can I have multiple goals with the same name?

Yes, but we recommend unique names to avoid confusion.

## Deposits & Withdrawals

### Is there a minimum deposit amount?

Only what's needed to cover blockchain gas fees. Even small amounts work!

### How long do deposits take?

Deposits are blockchain transactions:
- **Initiation**: Instant (approve in wallet)
- **Confirmation**: 30-60 seconds typically
- **Finality**: Depends on network (1-5 minutes)

### Can I withdraw anytime?

Yes! Your funds are in your wallet, so you have complete control. Withdraw whenever you need to.

### Are there withdrawal fees?

Only standard blockchain gas fees (same as any transaction). StackSave doesn't charge withdrawal fees.

### Can I withdraw partial amounts?

Yes! Withdraw as much or as little as you want from any goal.

### What if a transaction fails?

Common causes and solutions:
- **Insufficient gas**: Add more ETH to wallet
- **Network congestion**: Wait and retry or increase gas
- **Rejected in wallet**: Approve the transaction
- **Timeout**: Generate new transaction

## Technical

### Which blockchains are supported?

Currently:
- ✅ Ethereum Mainnet

Coming soon:
- Polygon
- Arbitrum
- Optimism
- Base

### What cryptocurrencies can I save?

Currently:
- ✅ ETH (Ethereum)
- ✅ ERC-20 tokens (USDC, DAI, etc.)

More chains and tokens coming soon!

### Do I need to pay gas fees?

Yes, like any blockchain transaction, you pay network gas fees for:
- Making deposits
- Making withdrawals
- (StackSave doesn't charge additional fees)

**Tip**: Save gas by depositing larger amounts less frequently.

### Why is my transaction pending?

Transactions wait for blockchain confirmation:
- **Low gas**: Increase gas price to speed up
- **Network congestion**: Wait or increase gas
- **Usually takes**: 30-60 seconds

Check status on [Etherscan](https://etherscan.io).

### Can I cancel a pending transaction?

Once submitted to blockchain: No. You can:
- Wait for confirmation
- Speed up with higher gas (in wallet)
- Transaction will eventually confirm or fail

## Privacy & Data

### What data does StackSave collect?

Minimal data:
- Wallet address (public blockchain data)
- Goals and progress (stored locally on device)
- Connection session data (temporary)

We do NOT collect:
- ❌ Email or personal information
- ❌ Private keys or seed phrases
- ❌ Transaction details (beyond what's on public blockchain)

### Where is my data stored?

- **Goals**: Locally on your device
- **Transactions**: Public blockchain (Ethereum)
- **Session**: WalletConnect encrypted relay (temporary)

### Can others see my goals?

No! Goals are stored locally on your device. Only you can see them.

### Can others see my transactions?

Blockchain transactions are public by nature. Anyone can see:
- Your wallet address
- Transaction amounts
- Transaction history

They CANNOT see:
- Your identity (unless you link it publicly)
- Your savings goals
- Your personal information

## Troubleshooting

### Connection keeps failing

Try:
1. Ensure wallet app is installed and updated
2. Check internet connection
3. Restart both apps
4. Try QR code method instead of deep link
5. Check wallet is on correct network (Ethereum Mainnet)

### QR code won't scan

Solutions:
1. Increase screen brightness
2. Ensure QR code is fully visible
3. Try different device/camera
4. Use "Copy URI" method instead

### Address shows "Not connected"

You're not connected to a wallet:
1. Tap "Connect Wallet"
2. Approve connection in wallet
3. Verify wallet is unlocked

### Goals not loading

Try:
1. Check internet connection
2. Reconnect wallet
3. Restart app
4. Clear app cache

See [Troubleshooting Guide](troubleshooting.md) for more solutions.

## Features

### Can I set up automatic deposits?

Not yet, but it's on our roadmap! For now:
- Set reminders in your calendar
- Enable StackSave notifications
- Manually deposit regularly

### Can I share goals with friends?

Not yet, but coming soon! Planned features:
- Shared/group goals
- Social features
- Progress sharing

### Is there a desktop version?

Not yet. StackSave is mobile-first, but desktop version is being considered for the future.

### Can I export my data?

Currently you can:
- View all transactions on blockchain
- Take screenshots of goals

Coming soon:
- CSV export
- PDF reports
- Transaction history export

## Contributing

### How can I contribute?

Many ways to help:
- Report bugs
- Suggest features
- Write code
- Improve documentation
- Translate (future)

See [Contributing Guide](../contributing/how-to-contribute.md).

### I found a bug. Where do I report it?

1. Check if already reported: [GitHub Issues](https://github.com/yourusername/stacksave/issues)
2. Create new issue with:
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots
   - Device info

### Can I request a feature?

Absolutely! Open a feature request:
1. Check existing requests first
2. Create new issue with `enhancement` label
3. Describe the feature and why it's useful

### Is StackSave open source?

Yes! StackSave is open source under MIT License. You can:
- View the code
- Fork the repository
- Contribute improvements
- Use it in your own projects

## Still Have Questions?

- **Documentation**: Browse the full [docs](../README.md)
- **Troubleshooting**: Check [troubleshooting guide](troubleshooting.md)
- **Support**: Open an [issue on GitHub](https://github.com/yourusername/stacksave/issues)
- **Discussions**: Ask in [GitHub Discussions](https://github.com/yourusername/stacksave/discussions)

---

**Question not answered?** Ask in [GitHub Discussions](https://github.com/yourusername/stacksave/discussions) - we're here to help!
