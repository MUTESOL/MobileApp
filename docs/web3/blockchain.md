# Blockchain Interaction

Learn how StackSave interacts with the blockchain for secure, decentralized savings management.

## Overview

StackSave uses blockchain technology to:

- Store savings goals on-chain
- Execute deposits and withdrawals
- Maintain transparent transaction history
- Ensure non-custodial fund management
- Provide cryptographic security

---

## Smart Contract Architecture

### StackSave Contract

The main smart contract managing savings goals.

**Contract Address**: `0xABCD...EF01` (Ethereum Mainnet)
**Status**: ✅ Verified on Etherscan

**Core Functions**:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StackSavings {
    struct SavingsGoal {
        string name;
        uint256 targetAmount;
        uint256 currentAmount;
        uint256 deadline;
        address owner;
        bool active;
    }

    mapping(address => mapping(uint256 => SavingsGoal)) public goals;
    mapping(address => uint256) public goalCount;

    event GoalCreated(address indexed owner, uint256 goalId, string name);
    event Deposit(address indexed owner, uint256 goalId, uint256 amount);
    event Withdrawal(address indexed owner, uint256 goalId, uint256 amount);

    function createGoal(
        string memory _name,
        uint256 _targetAmount,
        uint256 _deadline
    ) external returns (uint256) {
        uint256 goalId = goalCount[msg.sender]++;

        goals[msg.sender][goalId] = SavingsGoal({
            name: _name,
            targetAmount: _targetAmount,
            currentAmount: 0,
            deadline: _deadline,
            owner: msg.sender,
            active: true
        });

        emit GoalCreated(msg.sender, goalId, _name);
        return goalId;
    }

    function deposit(uint256 _goalId, uint256 _amount) external {
        require(goals[msg.sender][_goalId].active, "Goal not active");
        require(_amount > 0, "Amount must be positive");

        // Transfer USDC from user to contract
        IERC20(usdcAddress).transferFrom(msg.sender, address(this), _amount);

        goals[msg.sender][_goalId].currentAmount += _amount;

        emit Deposit(msg.sender, _goalId, _amount);
    }

    function withdraw(uint256 _goalId, uint256 _amount) external {
        SavingsGoal storage goal = goals[msg.sender][_goalId];

        require(goal.active, "Goal not active");
        require(_amount > 0, "Amount must be positive");
        require(goal.currentAmount >= _amount, "Insufficient balance");

        goal.currentAmount -= _amount;

        // Transfer USDC from contract to user
        IERC20(usdcAddress).transfer(msg.sender, _amount);

        emit Withdrawal(msg.sender, _goalId, _amount);
    }

    function getGoal(uint256 _goalId)
        external
        view
        returns (SavingsGoal memory)
    {
        return goals[msg.sender][_goalId];
    }
}
```

---

## Reading from Blockchain

### Query Goal Data

Fetch goal information from the blockchain:

**Dart Implementation**:

```dart
import 'package:web3dart/web3dart.dart';

class BlockchainService {
  final Web3Client _client;
  final DeployedContract _contract;

  Future<SavingsGoal> getGoal(String userAddress, int goalId) async {
    final function = _contract.function('getGoal');

    final result = await _client.call(
      contract: _contract,
      function: function,
      params: [BigInt.from(goalId)],
      sender: EthereumAddress.fromHex(userAddress),
    );

    return SavingsGoal(
      id: goalId.toString(),
      name: result[0] as String,
      targetAmount: _weiToUsdc(result[1] as BigInt),
      currentAmount: _weiToUsdc(result[2] as BigInt),
      deadline: DateTime.fromMillisecondsSinceEpoch(
        (result[3] as BigInt).toInt() * 1000,
      ),
      createdAt: DateTime.now(), // From events
    );
  }

  double _weiToUsdc(BigInt wei) {
    // USDC has 6 decimals
    return wei.toDouble() / 1000000;
  }
}
```

### Listen to Events

Subscribe to blockchain events for real-time updates:

```dart
Stream<GoalCreatedEvent> listenToGoalCreated(String userAddress) {
  final event = _contract.event('GoalCreated');

  final filter = FilterOptions.events(
    contract: _contract,
    event: event,
    fromBlock: BlockNum.current(),
  );

  return _client
      .events(filter)
      .map((event) => GoalCreatedEvent.fromLog(event));
}

class GoalCreatedEvent {
  final String owner;
  final int goalId;
  final String name;

  GoalCreatedEvent({
    required this.owner,
    required this.goalId,
    required this.name,
  });

  factory GoalCreatedEvent.fromLog(FilterEvent log) {
    final decoded = log.topics;
    return GoalCreatedEvent(
      owner: '0x${decoded[1]!.substring(26)}',
      goalId: BigInt.parse(decoded[2]!.substring(2), radix: 16).toInt(),
      name: log.data ?? '',
    );
  }
}
```

---

## Writing to Blockchain

### Create Transaction

Send transactions to the blockchain:

```dart
Future<String> createGoal({
  required String name,
  required double targetAmount,
  required DateTime? deadline,
}) async {
  final function = _contract.function('createGoal');

  final params = [
    name,
    _usdcToWei(targetAmount),
    deadline != null
        ? BigInt.from(deadline.millisecondsSinceEpoch ~/ 1000)
        : BigInt.zero,
  ];

  // Estimate gas
  final gasLimit = await _client.estimateGas(
    sender: _userAddress,
    to: _contract.address,
    data: function.encodeCall(params),
  );

  // Send transaction via WalletConnect
  final txHash = await _walletService.sendTransaction(
    to: _contract.address.hex,
    data: function.encodeCall(params).toHexString(),
    gasLimit: gasLimit.toInt(),
  );

  return txHash;
}

BigInt _usdcToWei(double usdc) {
  return BigInt.from((usdc * 1000000).round());
}
```

### Deposit Funds

```dart
Future<String> deposit({
  required int goalId,
  required double amount,
}) async {
  // Step 1: Approve USDC spending
  await _approveUsdc(amount);

  // Step 2: Call deposit function
  final function = _contract.function('deposit');

  final params = [
    BigInt.from(goalId),
    _usdcToWei(amount),
  ];

  final txHash = await _walletService.sendTransaction(
    to: _contract.address.hex,
    data: function.encodeCall(params).toHexString(),
  );

  return txHash;
}

Future<void> _approveUsdc(double amount) async {
  final usdcContract = _getUsdcContract();
  final approveFunction = usdcContract.function('approve');

  final params = [
    _contract.address,
    _usdcToWei(amount),
  ];

  await _walletService.sendTransaction(
    to: usdcContract.address.hex,
    data: approveFunction.encodeCall(params).toHexString(),
  );
}
```

### Withdraw Funds

```dart
Future<String> withdraw({
  required int goalId,
  required double amount,
}) async {
  final function = _contract.function('withdraw');

  final params = [
    BigInt.from(goalId),
    _usdcToWei(amount),
  ];

  final txHash = await _walletService.sendTransaction(
    to: _contract.address.hex,
    data: function.encodeCall(params).toHexString(),
  );

  return txHash;
}
```

---

## Transaction Lifecycle

### 1. Transaction Creation

```dart
// User initiates deposit
final txHash = await deposit(goalId: 1, amount: 100.0);
```

### 2. Transaction Submission

```
User App → WalletConnect → User Wallet → Blockchain Network
```

### 3. Transaction Confirmation

```dart
Future<void> waitForConfirmation(String txHash) async {
  while (true) {
    final receipt = await _client.getTransactionReceipt(txHash);

    if (receipt != null) {
      if (receipt.status!) {
        print('Transaction successful!');
        return;
      } else {
        throw Exception('Transaction failed');
      }
    }

    await Future.delayed(Duration(seconds: 2));
  }
}
```

### 4. Event Emission

Smart contract emits event → App listens → UI updates

---

## Gas Management

### Estimate Gas

```dart
Future<BigInt> estimateGas({
  required String to,
  required String data,
  BigInt? value,
}) async {
  return await _client.estimateGas(
    sender: _userAddress,
    to: EthereumAddress.fromHex(to),
    data: hexToBytes(data),
    value: value != null ? EtherAmount.inWei(value) : null,
  );
}
```

### Gas Price

```dart
Future<EtherAmount> getGasPrice() async {
  return await _client.getGasPrice();
}

Future<double> estimateTransactionCost({
  required String to,
  required String data,
}) async {
  final gasLimit = await estimateGas(to: to, data: data);
  final gasPrice = await getGasPrice();

  final cost = gasLimit * gasPrice.getInWei;
  return cost.toDouble() / 1e18; // Convert to ETH
}
```

### Gas Optimization

**Tips**:

1. **Batch Operations**: Combine multiple operations when possible
2. **Off-Peak Times**: Execute during low network activity
3. **Gas Price Selection**: Use appropriate gas price for urgency
4. **Efficient Contracts**: Optimize smart contract code

---

## Error Handling

### Common Errors

```dart
Future<String> executeTransaction(Function transaction) async {
  try {
    return await transaction();
  } on RPCError catch (e) {
    if (e.message.contains('insufficient funds')) {
      throw InsufficientFundsError();
    } else if (e.message.contains('gas too low')) {
      throw InsufficientGasError();
    } else if (e.message.contains('nonce too low')) {
      throw NonceError();
    } else {
      throw BlockchainError(e.message);
    }
  } catch (e) {
    throw BlockchainError('Unknown error: $e');
  }
}

class InsufficientFundsError implements Exception {
  @override
  String toString() => 'Insufficient USDC balance';
}

class InsufficientGasError implements Exception {
  @override
  String toString() => 'Insufficient gas for transaction';
}

class NonceError implements Exception {
  @override
  String toString() => 'Transaction nonce error. Please try again.';
}

class BlockchainError implements Exception {
  final String message;
  BlockchainError(this.message);

  @override
  String toString() => 'Blockchain error: $message';
}
```

---

## Security Considerations

### Input Validation

```dart
void validateDeposit(double amount) {
  if (amount <= 0) {
    throw ArgumentError('Amount must be positive');
  }

  if (amount > 1000000) {
    throw ArgumentError('Amount exceeds maximum');
  }

  // Check for decimal precision (USDC has 6 decimals)
  if ((amount * 1000000) % 1 != 0) {
    throw ArgumentError('Amount has too many decimal places');
  }
}
```

### Address Validation

```dart
bool isValidEthereumAddress(String address) {
  if (!address.startsWith('0x')) return false;
  if (address.length != 42) return false;

  try {
    EthereumAddress.fromHex(address);
    return true;
  } catch (e) {
    return false;
  }
}
```

### Reentrancy Protection

Smart contract includes reentrancy guards:

```solidity
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract StackSavings is ReentrancyGuard {
    function withdraw(uint256 _goalId, uint256 _amount)
        external
        nonReentrant // Prevents reentrancy attacks
    {
        // ... withdrawal logic
    }
}
```

---

## Blockchain Data Indexing

### Using The Graph

Index blockchain data for efficient queries:

**GraphQL Schema**:
```graphql
type SavingsGoal @entity {
  id: ID!
  owner: Bytes!
  name: String!
  targetAmount: BigInt!
  currentAmount: BigInt!
  deadline: BigInt!
  active: Boolean!
  createdAt: BigInt!
}

type Deposit @entity {
  id: ID!
  goal: SavingsGoal!
  amount: BigInt!
  timestamp: BigInt!
  txHash: Bytes!
}
```

**Query Goals**:
```dart
Future<List<SavingsGoal>> queryGoals(String owner) async {
  const query = '''
    query GetGoals(\$owner: Bytes!) {
      savingsGoals(where: { owner: \$owner, active: true }) {
        id
        name
        targetAmount
        currentAmount
        deadline
      }
    }
  ''';

  final response = await _graphqlClient.query(
    QueryOptions(
      document: gql(query),
      variables: {'owner': owner},
    ),
  );

  return response.data['savingsGoals']
      .map((json) => SavingsGoal.fromJson(json))
      .toList();
}
```

---

## Testing

### Mock Blockchain

For testing without real transactions:

```dart
class MockBlockchainService implements BlockchainService {
  final Map<String, SavingsGoal> _mockGoals = {};

  @override
  Future<String> createGoal({
    required String name,
    required double targetAmount,
    DateTime? deadline,
  }) async {
    final goalId = DateTime.now().millisecondsSinceEpoch.toString();

    _mockGoals[goalId] = SavingsGoal(
      id: goalId,
      name: name,
      targetAmount: targetAmount,
      deadline: deadline,
      currentAmount: 0,
      createdAt: DateTime.now(),
    );

    return '0xMOCK_TX_HASH_$goalId';
  }

  @override
  Future<SavingsGoal> getGoal(String goalId) async {
    return _mockGoals[goalId]!;
  }
}
```

### Testnet Testing

Use test networks before mainnet:

```dart
class BlockchainConfig {
  static const String mainnetRpc = 'https://mainnet.infura.io/v3/...';
  static const String goerliRpc = 'https://goerli.infura.io/v3/...';

  static String getRpcUrl(bool isTestnet) {
    return isTestnet ? goerliRpc : mainnetRpc;
  }
}
```

---

## Best Practices

### 1. Always Estimate Gas

```dart
// ✅ Estimate before sending
final gasLimit = await estimateGas(...);
await sendTransaction(..., gasLimit: gasLimit);

// ❌ Don't use fixed gas limit
await sendTransaction(..., gasLimit: 100000); // May fail or waste gas
```

### 2. Handle Pending Transactions

```dart
// ✅ Track pending state
setState(() {
  _isPending = true;
});

try {
  final txHash = await deposit(...);
  await waitForConfirmation(txHash);
} finally {
  setState(() {
    _isPending = false;
  });
}
```

### 3. Cache Blockchain Data

```dart
// ✅ Cache to reduce RPC calls
class CachedBlockchainService {
  final _cache = <String, SavingsGoal>{};

  Future<SavingsGoal> getGoal(String goalId) async {
    if (_cache.containsKey(goalId)) {
      return _cache[goalId]!;
    }

    final goal = await _fetchFromBlockchain(goalId);
    _cache[goalId] = goal;
    return goal;
  }
}
```

### 4. Retry Failed Transactions

```dart
Future<String> sendTransactionWithRetry(
  Function transaction, {
  int maxRetries = 3,
}) async {
  for (int i = 0; i < maxRetries; i++) {
    try {
      return await transaction();
    } catch (e) {
      if (i == maxRetries - 1) rethrow;
      await Future.delayed(Duration(seconds: 2));
    }
  }
  throw Exception('Max retries exceeded');
}
```

---

## Resources

- [web3dart Package](https://pub.dev/packages/web3dart)
- [Ethereum JSON-RPC](https://ethereum.org/en/developers/docs/apis/json-rpc/)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [The Graph](https://thegraph.com/docs/)

---

## Next Steps

- [Supported Networks](networks.md) - Available blockchain networks
- [Transaction Handling](transactions.md) - Transaction management
- [WalletConnect](wallet-connect.md) - Wallet integration

---

Need help? Check [Troubleshooting](../resources/troubleshooting.md) or [FAQ](../resources/faq.md).
