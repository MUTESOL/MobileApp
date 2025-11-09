# WalletConnect V2 Integration

StackSave uses WalletConnect V2 to provide secure, decentralized wallet connectivity. This guide explains how it works and how it's implemented.

## What is WalletConnect V2?

WalletConnect is an open protocol for connecting decentralized applications (dApps) to mobile wallets using end-to-end encryption. Version 2 brings significant improvements:

### Key Features
- **Multi-chain support**: Connect to multiple blockchains simultaneously
- **Improved performance**: Faster connection and message relay
- **Better UX**: Streamlined connection flow
- **Enhanced security**: Updated encryption standards
- **Session persistence**: Connections survive app restarts

### Why WalletConnect?

**For Users**:
- One wallet works with many apps
- Secure, encrypted communication
- Full control over permissions
- Easy QR code or deep link connection

**For Developers**:
- No private key handling needed
- Broad wallet compatibility (200+ wallets)
- Simple integration
- Active development and support

## Architecture Overview

### Components

```
┌─────────────┐          ┌──────────────┐          ┌──────────────┐
│  StackSave  │◄────────►│ WalletConnect│◄────────►│ User Wallet  │
│    (dApp)   │  Encrypted│    Relay     │  Encrypted│   (Mobile)   │
└─────────────┘   Bridge  └──────────────┘   Bridge  └──────────────┘
```

1. **StackSave (dApp)**: Initiates connection, requests signatures
2. **WalletConnect Relay**: Encrypted message relay server
3. **User Wallet**: Approves requests, signs transactions

### Connection Flow

```
1. User taps "Connect Wallet"
2. StackSave generates pairing URI
3. URI displayed as QR code / deep link
4. User scans QR or taps deep link
5. Wallet receives session proposal
6. User approves connection
7. Session established
8. Both apps can now communicate
```

## Implementation in StackSave

### Service Architecture

StackSave's Web3 integration is centralized in `WalletService`:

**Location**: `lib/services/wallet_service.dart`

```dart
class WalletService extends ChangeNotifier {
  WalletConnectV2? _client;
  bool _isConnected = false;
  String? _walletAddress;
  Session? session;
  // ... more state
}
```

### Key Methods

#### 1. Initialize WalletConnect

```dart
Future<void> init({
  required String projectId,
  required dynamic appMetadata
}) async
```

**Purpose**: Set up WalletConnect client with project configuration

**Parameters**:
- `projectId`: Your WalletConnect Cloud project ID
- `appMetadata`: App information (name, description, URL, icons)

**When called**: Before first connection attempt (lazy initialization)

#### 2. Connect Wallet

```dart
Future<bool> connectWallet() async
```

**Purpose**: Initiate wallet connection

**Returns**: `true` if connection initiated successfully

**Process**:
1. Generates pairing URI
2. Creates session proposal
3. Sets up event listeners
4. Waits for wallet approval

**Implementation details** (lib/services/wallet_service.dart:71-184):
- Configures Ethereum namespace (`eip155`)
- Requests standard Ethereum methods
- Handles session settlement
- Extracts wallet address from session

#### 3. Disconnect Wallet

```dart
Future<void> disconnectWallet() async
```

**Purpose**: Safely terminate wallet connection

**Process**:
1. Sends disconnect message to wallet
2. Clears session data
3. Resets connection state
4. Notifies listeners

### State Management

WalletConnect state is managed through Provider:

```dart
// In main.dart
ChangeNotifierProvider(create: (_) => WalletService())

// In widgets
final walletService = Provider.of<WalletService>(context);
```

**Reactive updates**: When wallet state changes, all listening widgets rebuild automatically.

### Session Management

#### Session Data Structure

```dart
Session {
  topic: String           // Unique session identifier
  namespaces: Map         // Blockchain namespaces and permissions
  expiry: int            // Session expiration timestamp
  // ... more fields
}
```

#### Session Lifecycle

1. **Creation**: User approves connection
2. **Active**: Session persists, survives app restarts
3. **Expiry**: Sessions auto-expire (default: 7 days)
4. **Termination**: User disconnects or session expires

### Namespace Configuration

StackSave configures the Ethereum namespace (`eip155`):

```dart
'eip155': ProposalNamespace(
  methods: [
    'eth_sendTransaction',      // Send transactions
    'eth_signTransaction',      // Sign transactions
    'eth_sign',                 // Generic signing
    'personal_sign',            // Message signing
    'eth_signTypedData',        // Typed data signing
  ],
  chains: ['eip155:1'],        // Ethereum Mainnet
  events: [
    'chainChanged',             // Network changes
    'accountsChanged'           // Account switches
  ],
)
```

**See**: lib/services/wallet_service.dart:139-151

## Connection Process Details

### Pairing URI Generation

When user taps "Connect Wallet":

1. **Create pairing proposal**:
   ```dart
   final connectionInfo = await _client!.createPair(
     namespaces: namespaces
   );
   ```

2. **URI format**:
   ```
   wc:TOPIC@2?relay-protocol=irn&symKey=KEY
   ```

3. **Display options**:
   - QR code for scanning
   - Deep link button for mobile
   - Copy-paste URI

### Session Establishment

When wallet approves:

1. **Session settlement callback**:
   ```dart
   _client!.onSessionSettle = (Session settledSession) {
     // Extract wallet address
     // Update connection state
     // Notify listeners
   }
   ```

2. **Address extraction** (lib/services/wallet_service.dart:92-106):
   ```dart
   final account = eip155.accounts[0];
   // Format: "eip155:1:0xAddress"
   final parts = account.split(':');
   _walletAddress = parts[2];
   ```

3. **State update**:
   - `_isConnected = true`
   - `session` stored
   - `notifyListeners()` called

### Error Handling

Common errors and handling:

#### Connection Timeout
```dart
// User didn't approve in time
_errorMessage = 'Connection timed out';
```

#### Session Rejection
```dart
_client!.onSessionRejection = (topic) {
  _errorMessage = 'Connection rejected by wallet';
  _isConnected = false;
};
```

#### Initialization Failure
```dart
catch (e) {
  _errorMessage = 'Failed to initialize: ${e.toString()}';
}
```

**See**: lib/services/wallet_service.dart:128-136

## Wallet Address Handling

### Address Formats

**Full address**:
```
0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb0
```

**Shortened display** (lib/services/wallet_service.dart:25-33):
```dart
String get shortenedAddress {
  if (_walletAddress == null || _walletAddress!.isEmpty) {
    return 'Not connected';
  }
  return '${_walletAddress!.substring(0, 6)}...${_walletAddress!.substring(_walletAddress!.length - 4)}';
}
// Result: "0x742d...bEb0"
```

### Address Validation

Addresses are validated by:
1. WalletConnect protocol (format)
2. Blockchain RPC (checksum)
3. Length and prefix checks

## Event Handling

### Available Callbacks

WalletService exposes optional callbacks:

```dart
void Function(bool connected)? onConnectionStatus;
void Function(dynamic proposal)? onSessionProposal;
void Function(Session session)? onSessionSettle;
void Function(dynamic topic)? onSessionUpdate;
void Function(dynamic topic)? onSessionDelete;
```

### Usage Example

```dart
walletService.onSessionSettle = (session) {
  print('Wallet connected successfully!');
  // Navigate to home screen
  // Show success message
};
```

## Transaction Signing

### Preparing Transaction

```dart
final transaction = {
  'from': walletAddress,
  'to': recipientAddress,
  'value': amountInWei,
  'data': '0x',  // Contract call data if needed
};
```

### Requesting Signature

```dart
final signature = await _client!.request(
  topic: session!.topic,
  chainId: 'eip155:1',
  request: {
    'method': 'eth_sendTransaction',
    'params': [transaction],
  },
);
```

### User Approval Flow

1. Transaction request sent to wallet
2. Wallet displays transaction details
3. User reviews and approves/rejects
4. Result returned to StackSave
5. Transaction broadcast to network

## Security Considerations

### Best Practices

✅ **Do's**:
- Always use HTTPS for relay connections
- Validate session data before use
- Handle errors gracefully
- Implement connection timeouts
- Never log sensitive data
- Clear session on logout

❌ **Don'ts**:
- Never access private keys
- Don't trust client-side data
- Don't skip signature verification
- Don't hardcode credentials
- Never auto-approve transactions

### Encryption

- **End-to-end encrypted**: Messages encrypted between dApp and wallet
- **Symmetric encryption**: Shared keys established during pairing
- **Relay can't decrypt**: Server only routes encrypted messages

### Session Security

Sessions include:
- Unique topic IDs
- Expiration timestamps
- Permission scopes
- Chain restrictions

## Debugging

### Enable Debug Logging

```dart
if (kDebugMode) {
  print('WalletConnect pairing URI: $_pairingUri');
  print('Session settled: ${settledSession.topic}');
  print('Wallet connected: $_walletAddress');
}
```

**See**: lib/services/wallet_service.dart:61-168

### Common Issues

**Connection hangs**:
- Check internet connectivity
- Verify project ID is valid
- Ensure relay server is accessible

**Address extraction fails**:
- Verify namespace configuration
- Check account format in session
- Log session data for inspection

**Session doesn't persist**:
- Ensure session is stored
- Check session expiry
- Verify client initialization

## Testing

### Manual Testing

1. **Connection flow**:
   - Connect with multiple wallets
   - Test QR and deep link methods
   - Verify address display

2. **Session management**:
   - Disconnect and reconnect
   - Test session persistence
   - Verify expiry handling

3. **Error scenarios**:
   - Reject connection
   - Timeout connection
   - Switch accounts mid-session

### Test Wallets

Recommended for testing:
- **MetaMask**: Most common wallet
- **Rainbow**: Good UX reference
- **WalletConnect example wallet**: Official test wallet

## Future Enhancements

Planned improvements:
- Multi-chain support (Polygon, Arbitrum, etc.)
- Account switching detection
- Network switching prompts
- Batch transaction support
- Message signing features
- Session recovery mechanisms

## Resources

### Documentation
- [WalletConnect Docs](https://docs.walletconnect.com/)
- [WalletConnect V2 Specs](https://specs.walletconnect.com/)
- [Flutter Package](https://pub.dev/packages/wallet_connect_v2)

### Tools
- [WalletConnect Cloud](https://cloud.walletconnect.com/) - Get project ID
- [WalletConnect Explorer](https://explorer.walletconnect.com/) - Find compatible wallets
- [Test Dapp](https://react-app.walletconnect.com/) - Reference implementation

### Support
- [GitHub Issues](https://github.com/WalletConnect/WalletConnectFlutterV2/issues)
- [Discord Community](https://discord.walletconnect.com/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/walletconnect)

---

**Next**: [Blockchain Interaction](blockchain.md) | [Supported Networks](networks.md)
