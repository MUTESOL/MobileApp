# Troubleshooting

Common issues and solutions for StackSave.

## Wallet Connection Issues

### Wallet Won't Connect

**Symptoms**: Connection fails or hangs

**Solutions**:
1. **Check internet connection**
2. **Restart wallet app** (MetaMask, Trust Wallet, etc.)
3. **Clear app cache**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
4. **Reinstall WalletConnect**
5. **Try different wallet app**

### Connection Drops Frequently

**Cause**: Session timeout or network issues

**Solutions**:
- Enable "Keep alive" in wallet settings
- Stay on same WiFi network
- Check firewall settings
- Use mobile data instead of WiFi

### Wrong Network Connected

**Error**: "Please switch to Ethereum Mainnet"

**Solution**:
1. Open your wallet app
2. Tap network dropdown
3. Select "Ethereum Mainnet"
4. Return to StackSave

---

## Transaction Issues

### Transaction Stuck/Pending

**Symptoms**: Transaction pending for >30 minutes

**Causes**:
- Gas price too low
- Network congestion

**Solutions**:

**Option 1: Speed Up**
1. Open wallet app
2. Find pending transaction
3. Tap "Speed Up"
4. Increase gas price
5. Confirm

**Option 2: Cancel and Retry**
1. Cancel transaction in wallet
2. Wait for confirmation
3. Retry with higher gas price

### Transaction Failed

**Common Error Messages**:

**"Insufficient funds"**:
- Check USDC balance
- Ensure you have enough for amount + gas

**"Insufficient gas"**:
- Add ETH to your wallet for gas fees
- Even USDC transactions need ETH for gas

**"Transaction underpriced"**:
- Increase gas price
- Try again during off-peak hours

**"Nonce too low"**:
- Clear pending transactions
- Restart app
- Try again

### Gas Fees Too High

**Solutions**:
1. **Wait for off-peak hours**:
   - Evenings (UTC)
   - Weekends
   - Early mornings

2. **Use gas tracker**:
   - [Etherscan Gas Tracker](https://etherscan.io/gastracker)
   - Wait for "Low" gas prices

3. **Adjust gas settings**:
   - Use "Slow" option if not urgent
   - Save 30-50% on fees

---

## App Issues

### App Crashes on Startup

**Solutions**:
1. **Update to latest version**
2. **Clear app data**:
   - Android: Settings > Apps > StackSave > Clear Data
   - iOS: Delete and reinstall
3. **Check device storage** (need at least 500MB free)
4. **Restart device**

### App Freezes/Hangs

**Causes**:
- Poor internet connection
- Large data sync
- Device memory low

**Solutions**:
- Force close and reopen app
- Clear cache
- Free up device memory
- Check internet connection

### Goals Not Loading

**Solutions**:
1. Pull to refresh
2. Check wallet connection
3. Verify correct network
4. Clear app cache
5. Check blockchain explorer for your transactions

### Balance Shows Wrong Amount

**Causes**:
- Pending transactions
- Cache not updated
- Network sync delay

**Solutions**:
- Pull to refresh
- Wait 1-2 minutes
- Check on [Etherscan](https://etherscan.io)
- Reconnect wallet

---

## Blockchain Issues

### "Could not connect to blockchain"

**Solutions**:
1. Check internet connection
2. Try different network (WiFi vs mobile data)
3. Restart app
4. Check if Ethereum network is operational:
   - [Etherscan](https://etherscan.io)
   - [Ethereum Status](https://ethstats.net)

### Smart Contract Error

**Error**: "Execution reverted"

**Common Causes**:
- Insufficient balance
- Goal doesn't exist
- Amount exceeds available
- Contract is paused (rare)

**Solutions**:
- Verify goal ID is correct
- Check balance is sufficient
- Try smaller amount
- Contact support if persists

---

## Data Issues

### Lost Goals After Reinstall

**Don't worry!** Goals are stored on blockchain.

**Recovery**:
1. Reinstall app
2. Connect same wallet
3. Goals will automatically sync

**Note**: Local notes/preferences may be lost

### Transaction History Missing

**Causes**:
- App cache cleared
- New device

**Solutions**:
- Pull to refresh
- View on [Etherscan](https://etherscan.io) with your wallet address
- Transactions are permanently on blockchain

---

## Platform-Specific Issues

### Android

**App won't install**:
- Enable "Unknown Sources" in settings
- Check storage space
- Update Android OS

**Google Play Protect warning**:
- App is safe, proceed with installation
- Or download from official source

### iOS

**"Untrusted Developer"**:
- Settings > General > Device Management
- Trust the developer certificate

**App won't open**:
- Restart device
- Reinstall app
- Update iOS

### Web

**Browser compatibility**:
- Use Chrome or Brave
- Enable cookies
- Disable ad blockers for StackSave

---

## Error Messages

### "Network request failed"

**Cause**: Internet connectivity issue

**Solution**:
- Check WiFi/mobile data
- Try different network
- Disable VPN temporarily

### "Session expired"

**Cause**: WalletConnect session timed out

**Solution**:
- Reconnect wallet
- Session will refresh

### "Invalid address"

**Cause**: Wallet address format incorrect

**Solution**:
- Verify address starts with `0x`
- Check for typos
- Ensure it's an Ethereum address

---

## Performance Issues

### Slow App Performance

**Solutions**:
1. Close other apps
2. Restart device
3. Clear app cache
4. Free up storage
5. Update to latest version

### High Battery Drain

**Causes**:
- Constant network requests
- Location services (if enabled)

**Solutions**:
- Close app when not in use
- Disable background app refresh
- Reduce sync frequency

---

## Getting Help

### Still Having Issues?

1. **Check FAQ**: [Frequently Asked Questions](faq.md)
2. **Search Issues**: [GitHub Issues](https://github.com/yourusername/stacksave/issues)
3. **Ask Community**: [Discussions](https://github.com/yourusername/stacksave/discussions)
4. **Report Bug**: [Report an Issue](../contributing/reporting-issues.md)

### Providing Information

When reporting issues, include:
- Device model and OS version
- App version
- Network (Ethereum Mainnet, etc.)
- Error messages
- Screenshots
- Steps to reproduce

---

## Emergency Procedures

### Funds Stuck

**Don't panic!** Your funds are safe on the blockchain.

**Steps**:
1. Verify transaction on [Etherscan](https://etherscan.io)
2. Check transaction status
3. If pending >1 hour, try speeding up in wallet
4. Contact support with transaction hash

### Lost Private Keys

**Unfortunately, we cannot recover lost private keys.**

**Prevention**:
- Backup recovery phrase
- Store securely offline
- Never share with anyone

### Suspected Hack

**Immediate Actions**:
1. Disconnect wallet from all apps
2. Transfer remaining funds to new wallet
3. Change passwords
4. Report to wallet provider
5. Contact security@stacksave.io

---

## Useful Links

- [Etherscan](https://etherscan.io) - Blockchain explorer
- [Ethereum Gas Tracker](https://etherscan.io/gastracker) - Current gas prices
- [Ethereum Status](https://ethstats.net) - Network status
- [MetaMask Support](https://metamask.io/support) - Wallet help

---

## Next Steps

- [FAQ](faq.md) - Frequently asked questions
- [Report Issue](../contributing/reporting-issues.md) - Submit bug reports
- [Contact Support](mailto:support@stacksave.io) - Get direct help
