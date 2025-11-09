# WalletService API Reference

Complete API documentation for the WalletService class.

## Overview

**File**: `lib/services/wallet_service.dart`

**Purpose**: Manages WalletConnect V2 integration, wallet connections, and session state.

**Pattern**: ChangeNotifier (Provider pattern)

## Class Definition

```dart
class WalletService extends ChangeNotifier
```

## Properties

### Public Getters

#### `isConnected`
```dart
bool get isConnected
```
**Returns**: Current wallet connection status

**Usage**:
```dart
if (walletService.isConnected) {
  // Show connected UI
}
```

---

#### `walletAddress`
```dart
String? get walletAddress
```
**Returns**: Full wallet address or `null` if not connected

**Format**: `"0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb0"`

**Usage**:
```dart
final address = walletService.walletAddress;
print('Connected wallet: $address');
```

---

#### `shortenedAddress`
```dart
String get shortenedAddress
```
**Returns**: Shortened wallet address for display

**Format**: `"0x742d...bEb0"` or `"Not connected"`

**Implementation**: lib/services/wallet_service.dart:25-33

**Usage**:
```dart
Text('Wallet: ${walletService.shortenedAddress}')
```

---

#### `errorMessage`
```dart
String? get errorMessage
```
**Returns**: Latest error message or `null` if no error

**Usage**:
```dart
if (walletService.errorMessage != null) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Error'),
      content: Text(walletService.errorMessage!),
    ),
  );
}
```

---

#### `pairingUri`
```dart
String? get pairingUri
```
**Returns**: WalletConnect pairing URI for connection

**Format**: `"wc:TOPIC@2?relay-protocol=irn&symKey=KEY"`

**Usage**:
```dart
// Display as QR code
QrImage(data: walletService.pairingUri!)

// Or as deep link
launchUrl(Uri.parse(walletService.pairingUri!))
```

---

#### `session`
```dart
Session? session
```
**Returns**: Current WalletConnect session object or `null`

**Contains**:
- `topic`: Session identifier
- `namespaces`: Blockchain permissions
- `expiry`: Session expiration timestamp

---

### Public Callbacks

Optional callbacks you can set to receive events:

#### `onConnectionStatus`
```dart
void Function(bool connected)? onConnectionStatus
```
**Called**: When connection status changes

**Usage**:
```dart
walletService.onConnectionStatus = (isConnected) {
  print('Connection status: $isConnected');
};
```

---

#### `onSessionSettle`
```dart
void Function(Session session)? onSessionSettle
```
**Called**: When wallet connection is successfully established

**Usage**:
```dart
walletService.onSessionSettle = (session) {
  print('Session established: ${session.topic}');
  Navigator.pushReplacement(/*...*/);
};
```

---

#### `onSessionRejection`
```dart
void Function(dynamic topic)? onSessionRejection
```
**Called**: When user rejects connection in wallet

**Usage**:
```dart
walletService.onSessionRejection = (topic) {
  showSnackBar('Connection rejected');
};
```

---

Other callbacks: `onSessionProposal`, `onSessionUpdate`, `onSessionDelete`, `onSessionRequest`, `onSessionResponse`

## Methods

### `init()`

Initialize WalletConnect client.

```dart
Future<void> init({
  required String projectId,
  required dynamic appMetadata,
}) async
```

**Parameters**:
- `projectId` (String): WalletConnect Cloud project ID
- `appMetadata` (dynamic): App information object

**Returns**: `Future<void>`

**Throws**: May throw on initialization failure

**Example**:
```dart
await walletService.init(
  projectId: 'your-project-id',
  appMetadata: {
    'name': 'StackSave',
    'description': 'Decentralized savings app',
    'url': 'https://stacksave.app',
    'icons': ['https://stacksave.app/icon.png'],
  },
);
```

**Implementation**: lib/services/wallet_service.dart:49-67

**Side effects**:
- Initializes WalletConnect client
- Sets up connection status callback
- Updates `_client` property

---

### `connectWallet()`

Initiate wallet connection flow.

```dart
Future<bool> connectWallet() async
```

**Parameters**: None

**Returns**: `Future<bool>`
- `true`: Connection initiated successfully
- `false`: Failed to initiate connection

**Example**:
```dart
final success = await walletService.connectWallet();
if (success) {
  print('Waiting for wallet approval...');
  print('URI: ${walletService.pairingUri}');
} else {
  print('Error: ${walletService.errorMessage}');
}
```

**Implementation**: lib/services/wallet_service.dart:71-184

**Process**:
1. Clears previous errors
2. Validates client initialization
3. Connects to WalletConnect relay
4. Sets up session callbacks
5. Creates session proposal
6. Generates pairing URI
7. Returns success status

**Side effects**:
- Updates `_pairingUri`
- Sets up `onSessionSettle` callback
- Sets up `onSessionRejection` callback
- Calls `notifyListeners()`

**Errors**:
Sets `_errorMessage` and returns `false` on:
- Client not initialized
- Network errors
- Session creation failure

---

### `disconnectWallet()`

Disconnect from wallet and clear session.

```dart
Future<void> disconnectWallet() async
```

**Parameters**: None

**Returns**: `Future<void>`

**Example**:
```dart
await walletService.disconnectWallet();
print('Wallet disconnected');
```

**Implementation**: lib/services/wallet_service.dart:187-204

**Process**:
1. Sends disconnect to wallet (if session exists)
2. Clears all state variables
3. Notifies listeners

**Side effects**:
- Sets `_isConnected = false`
- Clears `_walletAddress`
- Clears `_errorMessage`
- Clears `_pairingUri`
- Clears `session`
- Calls `onConnectionStatus(false)`
- Calls `notifyListeners()`

**Errors**:
Sets `_errorMessage` on disconnect failure but continues cleanup

## Usage Examples

### Basic Setup

```dart
// 1. Add provider in main.dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletService()),
      ],
      child: MyApp(),
    ),
  );
}

// 2. Access in widgets
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final walletService = Provider.of<WalletService>(context);

    return Text(
      walletService.isConnected
        ? 'Connected: ${walletService.shortenedAddress}'
        : 'Not connected'
    );
  }
}
```

### Connection Flow

```dart
class ConnectButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final walletService = Provider.of<WalletService>(context, listen: false);

    return ElevatedButton(
      onPressed: () async {
        // Initialize if needed
        await walletService.init(
          projectId: 'your-project-id',
          appMetadata: {...},
        );

        // Connect wallet
        final success = await walletService.connectWallet();

        if (success) {
          // Show QR code with walletService.pairingUri
          showQRDialog(context, walletService.pairingUri!);
        } else {
          // Show error
          showError(context, walletService.errorMessage);
        }
      },
      child: Text('Connect Wallet'),
    );
  }
}
```

### Listening to Changes

```dart
class WalletStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Rebuilds when walletService notifies listeners
    return Consumer<WalletService>(
      builder: (context, walletService, child) {
        if (walletService.isConnected) {
          return Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              Text('Connected'),
              Text(walletService.shortenedAddress),
            ],
          );
        } else if (walletService.errorMessage != null) {
          return Column(
            children: [
              Icon(Icons.error, color: Colors.red),
              Text('Error: ${walletService.errorMessage}'),
            ],
          );
        } else {
          return Column(
            children: [
              Icon(Icons.account_balance_wallet),
              Text('Not connected'),
            ],
          );
        }
      },
    );
  }
}
```

### Advanced: Session Management

```dart
class WalletManager {
  final WalletService walletService;

  WalletManager(this.walletService) {
    _setupCallbacks();
  }

  void _setupCallbacks() {
    walletService.onSessionSettle = (session) {
      print('Session established');
      print('Topic: ${session.topic}');
      print('Expiry: ${session.expiry}');
      // Navigate to home screen
    };

    walletService.onSessionRejection = (topic) {
      print('User rejected connection');
      // Show user feedback
    };
  }

  Future<void> connect() async {
    await walletService.init(
      projectId: 'your-project-id',
      appMetadata: {...},
    );

    await walletService.connectWallet();
  }

  Future<void> disconnect() async {
    await walletService.disconnectWallet();
  }

  String getDisplayAddress() {
    return walletService.shortenedAddress;
  }
}
```

## State Diagram

```
┌──────────────┐
│ Uninitialized│
└──────┬───────┘
       │ init()
       ▼
┌──────────────┐
│ Initialized  │
└──────┬───────┘
       │ connectWallet()
       ▼
┌──────────────┐
│   Pairing    │ ← pairingUri available
└──────┬───────┘
       │ User approves in wallet
       ▼
┌──────────────┐
│  Connected   │ ← isConnected = true, walletAddress set
└──────┬───────┘
       │ disconnectWallet()
       ▼
┌──────────────┐
│ Disconnected │ ← Back to Initialized state
└──────────────┘
```

## Error Handling

### Common Errors

| Error Message | Cause | Solution |
|--------------|-------|----------|
| "WalletConnect not initialized" | Called `connectWallet()` before `init()` | Call `init()` first |
| "Failed to initialize" | Network or config issue | Check project ID and internet |
| "Connection rejected by wallet" | User declined in wallet | Try again, user needs to approve |
| "Failed to connect" | Various connection issues | Check logs, retry |
| "Failed to disconnect" | Disconnect failed but cleanup continues | Usually safe to ignore |

### Error Handling Pattern

```dart
try {
  await walletService.connectWallet();
  if (walletService.errorMessage != null) {
    // Handle error
    showError(walletService.errorMessage!);
  }
} catch (e) {
  // Unexpected errors
  showError('Unexpected error: $e');
}
```

## Best Practices

### ✅ Do's

- Initialize before first use
- Check `isConnected` before wallet operations
- Handle errors gracefully
- Use `Consumer` or `selector` for efficient rebuilds
- Clear errors when retrying
- Disconnect on logout

### ❌ Don'ts

- Don't call methods without initializing
- Don't ignore error messages
- Don't assume connection persists forever
- Don't access `walletAddress` without null check
- Don't initialize multiple times unnecessarily

## Testing

### Unit Test Example

```dart
testWidgets('WalletService connects successfully', (tester) async {
  final walletService = WalletService();

  // Initialize
  await walletService.init(
    projectId: 'test-project-id',
    appMetadata: {},
  );

  // Connect
  final success = await walletService.connectWallet();

  expect(success, true);
  expect(walletService.pairingUri, isNotNull);
});
```

## See Also

- [WalletConnect Integration Guide](../web3/wallet-connect.md)
- [State Management](../architecture/state-management.md)
- [Blockchain Interaction](../web3/blockchain.md)

---

**File Location**: [lib/services/wallet_service.dart](../../lib/services/wallet_service.dart)
