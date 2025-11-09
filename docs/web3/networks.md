# Supported Networks

StackSave supports multiple blockchain networks to provide flexibility, lower costs, and broader accessibility.

## Currently Supported

### Ethereum Mainnet

**Status**: ✅ Fully Supported

**Network Details**:
```
Network Name:     Ethereum Mainnet
Chain ID:         1
Currency:         ETH
RPC URL:          https://mainnet.infura.io/v3/...
Block Explorer:   https://etherscan.io
```

**Characteristics**:
- 🔒 Most secure and decentralized
- 💰 Higher gas fees ($2-$50+ per transaction)
- ⏱ ~15 second block time
- 🌍 Largest user base and liquidity

**Contract Addresses**:
```
StackSave Contract:  0xABCD...EF01
USDC Token:          0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
```

**When to Use**:
- Large savings amounts (>$1,000)
- Maximum security priority
- Don't mind higher fees
- Long-term savings

---

## Coming Soon

### Polygon (Matic)

**Status**: 🚧 In Development

**Network Details**:
```
Network Name:     Polygon Mainnet
Chain ID:         137
Currency:         MATIC
RPC URL:          https://polygon-rpc.com
Block Explorer:   https://polygonscan.com
```

**Characteristics**:
- ⚡ Very low gas fees ($0.01-$0.10)
- 🚀 Fast transactions (~2 second blocks)
- 🌱 More environmentally friendly
- 🔗 Ethereum-compatible

**Advantages**:
- Perfect for small, frequent deposits
- Ideal for beginners
- Great for testing
- Low-cost withdrawals

**Expected Launch**: Q1 2025

---

### Binance Smart Chain (BSC)

**Status**: 🚧 Planned

**Network Details**:
```
Network Name:     BSC Mainnet
Chain ID:         56
Currency:         BNB
RPC URL:          https://bsc-dataseed.binance.org
Block Explorer:   https://bscscan.com
```

**Characteristics**:
- 💵 Low gas fees ($0.10-$0.50)
- ⚡ Fast block time (~3 seconds)
- 🌏 Popular in Asia
- 💱 High USDC liquidity

**Expected Launch**: Q2 2025

---

### Arbitrum

**Status**: 🚧 Planned

**Network Details**:
```
Network Name:     Arbitrum One
Chain ID:         42161
Currency:         ETH
RPC URL:          https://arb1.arbitrum.io/rpc
Block Explorer:   https://arbiscan.io
```

**Characteristics**:
- 💸 Low fees (90% cheaper than Ethereum)
- 🔒 Ethereum-level security (L2 rollup)
- ⚡ Fast finality
- 🔄 Easy bridging from Ethereum

**Expected Launch**: Q2 2025

---

### Optimism

**Status**: 📋 Under Consideration

**Network Details**:
```
Network Name:     Optimism
Chain ID:         10
Currency:         ETH
RPC URL:          https://mainnet.optimism.io
Block Explorer:   https://optimistic.etherscan.io
```

**Characteristics**:
- 💰 Low fees
- 🔐 Ethereum security
- 🔄 Optimistic rollup technology
- 🌐 Growing ecosystem

**Status**: Evaluating demand

---

## Network Comparison

| Feature | Ethereum | Polygon | BSC | Arbitrum |
|---------|----------|---------|-----|----------|
| **Status** | ✅ Live | 🚧 Soon | 🚧 Planned | 🚧 Planned |
| **Gas Fees** | $2-$50 | $0.01-$0.10 | $0.10-$0.50 | $0.10-$2 |
| **Block Time** | ~15s | ~2s | ~3s | ~13s |
| **Security** | Highest | High | Medium-High | Highest |
| **Decentralization** | Highest | High | Medium | High |
| **Best For** | Large amounts | Small deposits | Asia users | Balance of both |

---

## Network Selection

### In the App

**Auto-Detection**:

StackSave automatically detects your wallet's current network.

```dart
Future<int> detectNetwork() async {
  final chainId = await _client.getChainId();
  return chainId;
}

String getNetworkName(int chainId) {
  switch (chainId) {
    case 1:
      return 'Ethereum Mainnet';
    case 137:
      return 'Polygon';
    case 56:
      return 'BSC';
    case 42161:
      return 'Arbitrum';
    default:
      return 'Unknown Network';
  }
}
```

**Manual Selection**:

Users can switch networks in their wallet app (MetaMask, Trust Wallet, etc.)

**Network Indicator**:
```
┌─────────────────────────┐
│ 🟢 Ethereum Mainnet     │
│ Connected               │
└─────────────────────────┘
```

---

## Adding Custom Networks

### In MetaMask

**Ethereum Mainnet** (pre-configured):
- Already available in MetaMask

**Polygon**:
1. Open MetaMask
2. Click network dropdown
3. Click "Add Network"
4. Fill in details:
```
Network Name: Polygon Mainnet
RPC URL: https://polygon-rpc.com
Chain ID: 137
Currency Symbol: MATIC
Block Explorer: https://polygonscan.com
```

**BSC**:
```
Network Name: Binance Smart Chain
RPC URL: https://bsc-dataseed.binance.org
Chain ID: 56
Currency Symbol: BNB
Block Explorer: https://bscscan.com
```

**Arbitrum**:
```
Network Name: Arbitrum One
RPC URL: https://arb1.arbitrum.io/rpc
Chain ID: 42161
Currency Symbol: ETH
Block Explorer: https://arbiscan.io
```

### In Trust Wallet

1. Open Trust Wallet
2. Go to Settings > Networks
3. Tap "+"
4. Enter network details
5. Save

---

## Network Switching

### Programmatic Switching

Request network switch via WalletConnect:

```dart
Future<void> switchNetwork(int chainId) async {
  try {
    await _walletConnector.request(
      WCRequestMethod.switchEthereumChain,
      params: [
        {'chainId': '0x${chainId.toRadixString(16)}'}
      ],
    );
  } on WalletConnectException catch (e) {
    if (e.code == 4902) {
      // Network not added, try adding it
      await _addNetwork(chainId);
    } else {
      rethrow;
    }
  }
}

Future<void> _addNetwork(int chainId) async {
  final networkConfig = _getNetworkConfig(chainId);

  await _walletConnector.request(
    WCRequestMethod.addEthereumChain,
    params: [networkConfig],
  );
}

Map<String, dynamic> _getNetworkConfig(int chainId) {
  switch (chainId) {
    case 137: // Polygon
      return {
        'chainId': '0x89',
        'chainName': 'Polygon Mainnet',
        'nativeCurrency': {
          'name': 'MATIC',
          'symbol': 'MATIC',
          'decimals': 18,
        },
        'rpcUrls': ['https://polygon-rpc.com'],
        'blockExplorerUrls': ['https://polygonscan.com'],
      };

    // ... other networks
    default:
      throw UnsupportedError('Network not supported');
  }
}
```

### UI for Network Switching

```dart
class NetworkSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: currentChainId,
      items: [
        DropdownMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.blue),
              SizedBox(width: 8),
              Text('Ethereum'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 137,
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.purple),
              SizedBox(width: 8),
              Text('Polygon'),
            ],
          ),
        ),
        // ... more networks
      ],
      onChanged: (chainId) {
        if (chainId != null) {
          switchNetwork(chainId);
        }
      },
    );
  }
}
```

---

## Cross-Chain Compatibility

### Same Contract Address

StackSave uses the same contract address across all networks (when possible):

```
Ethereum:  0xABCD...EF01
Polygon:   0xABCD...EF01
BSC:       0xABCD...EF01
Arbitrum:  0xABCD...EF01
```

This is achieved using CREATE2 deployment.

### Separate Goal Storage

**Important**: Goals are stored per-network and do NOT automatically sync across chains.

```
Ethereum Goals:  Stored on Ethereum contract
Polygon Goals:   Stored on Polygon contract (separate)
```

To move funds between networks, you must:
1. Withdraw from Goal on Network A
2. Bridge tokens to Network B
3. Deposit to Goal on Network B

---

## Bridging Assets

### Ethereum ↔ Polygon

**Using Polygon Bridge**:

1. Visit [wallet.polygon.technology](https://wallet.polygon.technology)
2. Connect wallet
3. Select "Bridge"
4. Choose USDC
5. Enter amount
6. Confirm (takes ~7-8 minutes)

**Cost**: ~$10-20 in gas fees

### Cross-Chain in StackSave (Future)

**Planned Feature**: Built-in bridge integration

```
[Withdraw from Ethereum]
       ↓
[Bridge to Polygon] (automatic)
       ↓
[Deposit to Polygon Goal]
```

---

## Testnet Support

### For Development

**Goerli Testnet** (Ethereum):
```
Chain ID: 5
RPC: https://goerli.infura.io/v3/...
Faucet: https://goerlifaucet.com
```

**Mumbai Testnet** (Polygon):
```
Chain ID: 80001
RPC: https://rpc-mumbai.maticvigil.com
Faucet: https://faucet.polygon.technology
```

### Enable Testnet Mode

```dart
class AppConfig {
  static bool isTestnet = false; // Toggle for testnet

  static String getRpcUrl() {
    if (isTestnet) {
      return 'https://goerli.infura.io/v3/...';
    }
    return 'https://mainnet.infura.io/v3/...';
  }

  static String getContractAddress() {
    if (isTestnet) {
      return '0xTEST...CONTRACT';
    }
    return '0xABCD...EF01';
  }
}
```

---

## Network-Specific Features

### Gas Tokens

Each network uses different gas tokens:

| Network | Gas Token | How to Get |
|---------|-----------|------------|
| Ethereum | ETH | Exchange, swap |
| Polygon | MATIC | Exchange, faucet, bridge |
| BSC | BNB | Exchange, swap |
| Arbitrum | ETH | Bridge from Ethereum |

**Important**: Always keep some gas tokens for transactions!

### Transaction Speed

**Priority Levels**:

```dart
enum TransactionSpeed {
  slow,    // Cheapest, slower confirmation
  standard, // Balanced
  fast,     // More expensive, faster confirmation
}

Future<BigInt> getGasPrice(TransactionSpeed speed) async {
  final baseGasPrice = await _client.getGasPrice();

  switch (speed) {
    case TransactionSpeed.slow:
      return baseGasPrice.getInWei * BigInt.from(8) ~/ BigInt.from(10); // 80%
    case TransactionSpeed.standard:
      return baseGasPrice.getInWei;
    case TransactionSpeed.fast:
      return baseGasPrice.getInWei * BigInt.from(12) ~/ BigInt.from(10); // 120%
  }
}
```

---

## Network Health Monitoring

### RPC Status

Check if network RPC is reachable:

```dart
Future<bool> isNetworkHealthy() async {
  try {
    await _client.getBlockNumber();
    return true;
  } catch (e) {
    return false;
  }
}
```

### Fallback RPCs

Use backup RPC endpoints:

```dart
class NetworkConfig {
  static const Map<int, List<String>> rpcEndpoints = {
    1: [
      'https://mainnet.infura.io/v3/...',
      'https://eth-mainnet.alchemyapi.io/v2/...',
      'https://cloudflare-eth.com',
    ],
    137: [
      'https://polygon-rpc.com',
      'https://rpc-mainnet.matic.network',
      'https://rpc-mainnet.maticvigil.com',
    ],
  };

  static Future<Web3Client> getClient(int chainId) async {
    final rpcs = rpcEndpoints[chainId]!;

    for (final rpc in rpcs) {
      try {
        final client = Web3Client(rpc, Client());
        await client.getBlockNumber(); // Test connection
        return client;
      } catch (e) {
        continue; // Try next RPC
      }
    }

    throw Exception('No healthy RPC endpoint found');
  }
}
```

---

## Best Practices

### 1. Network Validation

Always validate network before transactions:

```dart
Future<void> deposit() async {
  final chainId = await _client.getChainId();

  if (chainId != expectedChainId) {
    throw WrongNetworkException(
      'Please switch to ${getNetworkName(expectedChainId)}',
    );
  }

  // Proceed with deposit
}
```

### 2. Gas Token Balance Check

```dart
Future<void> checkGasBalance() async {
  final balance = await _client.getBalance(_userAddress);

  if (balance.getInWei < requiredGas) {
    throw InsufficientGasException(
      'You need ${getNetworkName(chainId)} native tokens for gas',
    );
  }
}
```

### 3. Network-Specific UI

Show network-specific information:

```dart
String getMinimumDepositMessage(int chainId) {
  switch (chainId) {
    case 1: // Ethereum
      return 'Minimum $50 recommended (gas fees are high)';
    case 137: // Polygon
      return 'Any amount welcome (gas fees are very low)';
    default:
      return 'Any amount';
  }
}
```

---

## Troubleshooting

### Wrong Network Error

**Error**: "Wrong network, please switch to Ethereum Mainnet"

**Solution**:
1. Open your wallet app
2. Tap network dropdown
3. Select correct network
4. Return to StackSave

### Network Not Found

**Error**: "Network with Chain ID 137 not found"

**Solution**:
1. Add the network to your wallet (see [Adding Custom Networks](#adding-custom-networks))
2. Retry connection

### RPC Connection Failed

**Error**: "Unable to connect to network"

**Solution**:
1. Check internet connection
2. Try again in a few seconds
3. If persists, network RPC may be down
4. StackSave will try backup RPCs automatically

---

## FAQ

**Q: Can I use the same goals on different networks?**
A: No, goals are network-specific. Each network has separate goals.

**Q: Which network should I use?**
A: For large amounts (>$1,000), use Ethereum. For small, frequent deposits, use Polygon (when available).

**Q: Can I move my goals to a different network?**
A: You must withdraw, bridge tokens, and create new goals on the target network.

**Q: Do I need different tokens on each network?**
A: For savings, you need USDC on each network. For gas, you need the network's native token (ETH, MATIC, BNB, etc.)

**Q: Are my funds safe on all networks?**
A: All supported networks use audited smart contracts. Ethereum is the most secure, but all are safe for most use cases.

**Q: Can I switch networks mid-transaction?**
A: No, complete or cancel the transaction first, then switch networks.

---

## Coming Network Features

- ✨ Automatic network recommendations based on deposit amount
- 🔄 Built-in cross-chain bridges
- 📊 Network fee comparison tool
- 🎯 Multi-network portfolio view
- ⚡ Gas fee alerts and optimization

---

## Next Steps

- [Blockchain Interaction](blockchain.md) - How to interact with smart contracts
- [Transaction Handling](transactions.md) - Managing transactions
- [WalletConnect](wallet-connect.md) - Connecting your wallet

---

Need help? Visit [Troubleshooting](../resources/troubleshooting.md) or [FAQ](../resources/faq.md).
