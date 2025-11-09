# Transaction Handling

Learn how StackSave manages blockchain transactions from creation to confirmation.

## Transaction Lifecycle

### Overview

```
User Action
    ↓
Transaction Creation
    ↓
Transaction Signing (WalletConnect)
    ↓
Transaction Broadcast
    ↓
Pending State
    ↓
Block Inclusion
    ↓
Confirmation (12 blocks)
    ↓
Finalized
```

---

## Creating Transactions

### Transaction Builder

**Basic Structure**:

```dart
class TransactionBuilder {
  final Web3Client client;
  final EthereumAddress from;
  final EthereumAddress to;
  final BigInt? value;
  final Uint8List? data;
  BigInt? gasLimit;
  EtherAmount? gasPrice;
  int? nonce;

  TransactionBuilder({
    required this.client,
    required this.from,
    required this.to,
    this.value,
    this.data,
  });

  Future<Transaction> build() async {
    // Auto-fill missing values
    gasLimit ??= await estimateGas();
    gasPrice ??= await client.getGasPrice();
    nonce ??= await client.getTransactionCount(from);

    return Transaction(
      from: from,
      to: to,
      value: value != null ? EtherAmount.inWei(value!) : null,
      data: data,
      gasPrice: gasPrice,
      maxGas: gasLimit!.toInt(),
      nonce: nonce,
    );
  }

  Future<BigInt> estimateGas() async {
    return await client.estimateGas(
      sender: from,
      to: to,
      value: value != null ? EtherAmount.inWei(value!) : null,
      data: data,
    );
  }
}
```

### Creating a Deposit Transaction

```dart
Future<String> createDepositTransaction({
  required int goalId,
  required double amount,
}) async {
  final function = _contract.function('deposit');

  final data = function.encodeCall([
    BigInt.from(goalId),
    _usdcToWei(amount),
  ]);

  final txBuilder = TransactionBuilder(
    client: _client,
    from: _userAddress,
    to: _contract.address,
    data: data,
  );

  final transaction = await txBuilder.build();

  // Send via WalletConnect
  return await _sendViaWalletConnect(transaction);
}
```

---

## Signing Transactions

### WalletConnect Signing

```dart
Future<String> _sendViaWalletConnect(Transaction transaction) async {
  final txHash = await _walletConnector.sendTransaction(
    from: transaction.from!.hex,
    to: transaction.to!.hex,
    data: bytesToHex(transaction.data ?? Uint8List(0), include0x: true),
    gasLimit: '0x${transaction.maxGas!.toRadixString(16)}',
    gasPrice: '0x${transaction.gasPrice!.getInWei.toRadixString(16)}',
    value: transaction.value != null
        ? '0x${transaction.value!.getInWei.toRadixString(16)}'
        : '0x0',
    nonce: '0x${transaction.nonce!.toRadixString(16)}',
  );

  return txHash;
}
```

### User Confirmation

```dart
class TransactionConfirmationDialog extends StatelessWidget {
  final Transaction transaction;
  final Function(bool) onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Transaction'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('To: ${transaction.to!.hex}'),
          SizedBox(height: 8),
          Text('Amount: ${_formatAmount(transaction.value)}'),
          SizedBox(height: 8),
          Text('Gas Fee: ~${_formatGasFee(transaction)}'),
          SizedBox(height: 8),
          Text('Total: ${_formatTotal(transaction)}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => onConfirm(false),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => onConfirm(true),
          child: Text('Confirm'),
        ),
      ],
    );
  }

  String _formatAmount(EtherAmount? value) {
    if (value == null) return '0 USDC';
    return '${value.getInWei / BigInt.from(1000000)} USDC';
  }

  String _formatGasFee(Transaction tx) {
    final gasCost = tx.gasPrice!.getInWei * BigInt.from(tx.maxGas!);
    final ethCost = gasCost.toDouble() / 1e18;
    return '${ethCost.toStringAsFixed(4)} ETH';
  }

  String _formatTotal(Transaction tx) {
    // Calculate total including gas
    return '...'; // Implementation
  }
}
```

---

## Broadcasting Transactions

### Send to Network

```dart
Future<String> broadcastTransaction(Transaction transaction) async {
  try {
    final txHash = await _client.sendTransaction(
      transaction,
      chainId: _chainId,
    );

    // Store pending transaction
    await _storePendingTransaction(txHash, transaction);

    return txHash;
  } catch (e) {
    throw TransactionBroadcastException('Failed to broadcast: $e');
  }
}
```

### Transaction Pool

```dart
class TransactionPool {
  final Map<String, PendingTransaction> _pending = {};

  void add(String txHash, Transaction transaction) {
    _pending[txHash] = PendingTransaction(
      hash: txHash,
      transaction: transaction,
      timestamp: DateTime.now(),
      status: TransactionStatus.pending,
    );
  }

  void updateStatus(String txHash, TransactionStatus status) {
    _pending[txHash]?.status = status;
  }

  List<PendingTransaction> getPending() {
    return _pending.values
        .where((tx) => tx.status == TransactionStatus.pending)
        .toList();
  }

  void remove(String txHash) {
    _pending.remove(txHash);
  }
}

class PendingTransaction {
  final String hash;
  final Transaction transaction;
  final DateTime timestamp;
  TransactionStatus status;

  PendingTransaction({
    required this.hash,
    required this.transaction,
    required this.timestamp,
    required this.status,
  });
}
```

---

## Monitoring Transactions

### Watch Transaction Status

```dart
Stream<TransactionReceipt?> watchTransaction(String txHash) async* {
  while (true) {
    try {
      final receipt = await _client.getTransactionReceipt(txHash);

      yield receipt;

      if (receipt != null) {
        // Transaction mined
        break;
      }

      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      yield null;
    }
  }
}
```

### Wait for Confirmation

```dart
Future<TransactionReceipt> waitForConfirmation(
  String txHash, {
  int requiredConfirmations = 12,
  Duration timeout = const Duration(minutes: 5),
}) async {
  final startTime = DateTime.now();

  while (true) {
    if (DateTime.now().difference(startTime) > timeout) {
      throw TimeoutException('Transaction confirmation timeout');
    }

    final receipt = await _client.getTransactionReceipt(txHash);

    if (receipt != null) {
      final currentBlock = await _client.getBlockNumber();
      final confirmations = currentBlock - receipt.blockNumber.blockNum;

      if (confirmations >= requiredConfirmations) {
        if (!receipt.status!) {
          throw TransactionFailedException('Transaction failed');
        }
        return receipt;
      }
    }

    await Future.delayed(Duration(seconds: 2));
  }
}
```

### Progress Indicator

```dart
class TransactionProgressWidget extends StatelessWidget {
  final String txHash;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TransactionReceipt?>(
      stream: watchTransaction(txHash),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('⏳ Waiting for confirmation...'),
            ],
          );
        }

        final receipt = snapshot.data!;
        final confirmations = _getConfirmations(receipt);

        return Column(
          children: [
            LinearProgressIndicator(
              value: confirmations / 12,
            ),
            SizedBox(height: 8),
            Text('$confirmations / 12 confirmations'),
          ],
        );
      },
    );
  }

  int _getConfirmations(TransactionReceipt receipt) {
    // Calculate confirmations
    return 0; // Implementation
  }
}
```

---

## Transaction States

### State Machine

```dart
enum TransactionStatus {
  draft,      // Created but not sent
  pending,    // Sent, waiting for inclusion
  included,   // In a block, waiting for confirmations
  confirmed,  // Confirmed (12+ blocks)
  failed,     // Transaction reverted
  cancelled,  // User cancelled
}

class TransactionStateMachine {
  TransactionStatus _status = TransactionStatus.draft;

  TransactionStatus get status => _status;

  void transitionTo(TransactionStatus newStatus) {
    if (_isValidTransition(_status, newStatus)) {
      _status = newStatus;
    } else {
      throw StateError('Invalid transition: $_status -> $newStatus');
    }
  }

  bool _isValidTransition(
    TransactionStatus from,
    TransactionStatus to,
  ) {
    const validTransitions = {
      TransactionStatus.draft: [
        TransactionStatus.pending,
        TransactionStatus.cancelled,
      ],
      TransactionStatus.pending: [
        TransactionStatus.included,
        TransactionStatus.failed,
      ],
      TransactionStatus.included: [
        TransactionStatus.confirmed,
        TransactionStatus.failed,
      ],
    };

    return validTransitions[from]?.contains(to) ?? false;
  }
}
```

---

## Error Handling

### Common Transaction Errors

```dart
Future<String> sendTransactionWithErrorHandling(
  Transaction transaction,
) async {
  try {
    return await broadcastTransaction(transaction);
  } on InsufficientFundsException {
    throw UserFriendlyException(
      'Insufficient USDC balance',
      'Please add more USDC to your wallet',
    );
  } on InsufficientGasException {
    throw UserFriendlyException(
      'Insufficient gas',
      'You need ETH to pay for transaction fees',
    );
  } on UserRejectedTransactionException {
    throw UserFriendlyException(
      'Transaction cancelled',
      'You rejected the transaction in your wallet',
    );
  } on NonceException {
    // Retry with correct nonce
    return await _retryWithCorrectNonce(transaction);
  } on RpcException catch (e) {
    throw UserFriendlyException(
      'Network error',
      'Failed to connect to blockchain: ${e.message}',
    );
  } catch (e) {
    throw UserFriendlyException(
      'Transaction failed',
      'An unexpected error occurred: $e',
    );
  }
}

class UserFriendlyException implements Exception {
  final String title;
  final String message;

  UserFriendlyException(this.title, this.message);
}
```

### Retry Logic

```dart
Future<String> sendTransactionWithRetry(
  Transaction transaction, {
  int maxRetries = 3,
  Duration retryDelay = const Duration(seconds: 2),
}) async {
  int attempts = 0;

  while (attempts < maxRetries) {
    try {
      return await broadcastTransaction(transaction);
    } catch (e) {
      attempts++;

      if (attempts >= maxRetries) {
        rethrow;
      }

      // Wait before retry
      await Future.delayed(retryDelay);

      // Update nonce for retry
      transaction = await _updateNonce(transaction);
    }
  }

  throw Exception('Max retries exceeded');
}
```

---

## Gas Optimization

### Dynamic Gas Pricing

```dart
class GasPriceOracle {
  final Web3Client client;

  Future<GasPrices> getGasPrices() async {
    final baseGasPrice = await client.getGasPrice();
    final baseWei = baseGasPrice.getInWei;

    return GasPrices(
      slow: EtherAmount.inWei(baseWei * BigInt.from(80) ~/ BigInt.from(100)),
      standard: baseGasPrice,
      fast: EtherAmount.inWei(baseWei * BigInt.from(120) ~/ BigInt.from(100)),
      instant: EtherAmount.inWei(baseWei * BigInt.from(150) ~/ BigInt.from(100)),
    );
  }
}

class GasPrices {
  final EtherAmount slow;
  final EtherAmount standard;
  final EtherAmount fast;
  final EtherAmount instant;

  GasPrices({
    required this.slow,
    required this.standard,
    required this.fast,
    required this.instant,
  });
}
```

### Gas Limit Estimation

```dart
Future<BigInt> estimateGasWithBuffer({
  required EthereumAddress from,
  required EthereumAddress to,
  Uint8List? data,
  EtherAmount? value,
  double bufferMultiplier = 1.2,
}) async {
  final estimated = await client.estimateGas(
    sender: from,
    to: to,
    data: data,
    value: value,
  );

  // Add 20% buffer
  return BigInt.from((estimated.toDouble() * bufferMultiplier).ceil());
}
```

---

## Transaction History

### Fetch User Transactions

```dart
Future<List<TransactionInfo>> getUserTransactions(
  String userAddress, {
  int limit = 100,
}) async {
  // Using Etherscan API or The Graph
  final url = 'https://api.etherscan.io/api'
      '?module=account'
      '&action=txlist'
      '&address=$userAddress'
      '&startblock=0'
      '&endblock=99999999'
      '&sort=desc'
      '&apikey=$apiKey';

  final response = await http.get(Uri.parse(url));
  final data = jsonDecode(response.body);

  return (data['result'] as List)
      .map((json) => TransactionInfo.fromJson(json))
      .take(limit)
      .toList();
}

class TransactionInfo {
  final String hash;
  final String from;
  final String to;
  final BigInt value;
  final DateTime timestamp;
  final bool isError;

  TransactionInfo({
    required this.hash,
    required this.from,
    required this.to,
    required this.value,
    required this.timestamp,
    required this.isError,
  });

  factory TransactionInfo.fromJson(Map<String, dynamic> json) {
    return TransactionInfo(
      hash: json['hash'],
      from: json['from'],
      to: json['to'],
      value: BigInt.parse(json['value']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        int.parse(json['timeStamp']) * 1000,
      ),
      isError: json['isError'] == '1',
    );
  }
}
```

---

## Transaction Batching

### Batch Multiple Operations

```dart
class TransactionBatcher {
  final List<Transaction> _batch = [];

  void add(Transaction transaction) {
    _batch.add(transaction);
  }

  Future<List<String>> executeAll() async {
    final txHashes = <String>[];

    for (final tx in _batch) {
      final hash = await _sendTransaction(tx);
      txHashes.add(hash);

      // Wait a bit between transactions to avoid nonce conflicts
      await Future.delayed(Duration(milliseconds: 500));
    }

    _batch.clear();
    return txHashes;
  }

  void clear() {
    _batch.clear();
  }
}
```

---

## Transaction Receipts

### Parse Receipt Data

```dart
class ReceiptParser {
  static TransactionResult parseReceipt(TransactionReceipt receipt) {
    return TransactionResult(
      hash: receipt.transactionHash,
      blockNumber: receipt.blockNumber.blockNum,
      gasUsed: receipt.gasUsed!,
      status: receipt.status!,
      logs: receipt.logs.map((log) => _parseLog(log)).toList(),
    );
  }

  static LogEvent _parseLog(FilterEvent log) {
    // Parse event logs
    return LogEvent(
      address: log.address!.hex,
      topics: log.topics!.map((t) => t!).toList(),
      data: log.data ?? '',
    );
  }
}

class TransactionResult {
  final String hash;
  final int blockNumber;
  final BigInt gasUsed;
  final bool status;
  final List<LogEvent> logs;

  TransactionResult({
    required this.hash,
    required this.blockNumber,
    required this.gasUsed,
    required this.status,
    required this.logs,
  });
}

class LogEvent {
  final String address;
  final List<String> topics;
  final String data;

  LogEvent({
    required this.address,
    required this.topics,
    required this.data,
  });
}
```

---

## Best Practices

### 1. Always Estimate Gas

```dart
// ✅ Estimate before sending
final gasLimit = await estimateGas();

// ❌ Don't use fixed values
final gasLimit = BigInt.from(100000); // May fail or waste gas
```

### 2. Handle Pending State

```dart
// ✅ Show pending indicator
setState(() {
  _isPending = true;
});

try {
  await sendTransaction();
} finally {
  setState(() {
    _isPending = false;
  });
}
```

### 3. Validate Before Sending

```dart
// ✅ Pre-flight checks
await checkSufficientBalance();
await checkSufficientGas();
await checkNetworkConnection();

// Then send
await sendTransaction();
```

### 4. Store Transaction History

```dart
// ✅ Save for later reference
await _database.saveTransaction(
  hash: txHash,
  type: 'deposit',
  amount: amount,
  timestamp: DateTime.now(),
);
```

---

## Testing Transactions

### Mock Transactions

```dart
class MockTransactionService implements TransactionService {
  @override
  Future<String> sendTransaction(Transaction tx) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Return mock tx hash
    return '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}';
  }

  @override
  Future<TransactionReceipt> getReceipt(String hash) async {
    await Future.delayed(Duration(seconds: 2));

    return TransactionReceipt(
      transactionHash: hash,
      status: true,
      blockNumber: BlockNum.exact(12345678),
      gasUsed: BigInt.from(50000),
    );
  }
}
```

---

## Troubleshooting

### Transaction Stuck

**Symptoms**: Transaction pending for >1 hour

**Solutions**:
1. Check gas price - may be too low
2. Speed up transaction (increase gas price)
3. Cancel and resubmit with higher gas

### Nonce Too Low

**Error**: "nonce too low"

**Solution**:
```dart
// Get current nonce from network
final nonce = await client.getTransactionCount(address);

// Retry with correct nonce
transaction = transaction.copyWith(nonce: nonce);
```

### Out of Gas

**Error**: "out of gas"

**Solution**:
```dart
// Increase gas limit
final estimatedGas = await estimateGas();
final gasLimit = estimatedGas * BigInt.from(15) ~/ BigInt.from(10); // +50%
```

---

## Next Steps

- [Blockchain Interaction](blockchain.md) - Smart contract integration
- [Supported Networks](networks.md) - Available networks
- [WalletConnect](wallet-connect.md) - Wallet integration

---

Need help? Visit [Troubleshooting](../resources/troubleshooting.md) or [FAQ](../resources/faq.md).
