// WalletConnect V2 service for connecting external wallets

import 'package:flutter/foundation.dart';
import 'package:wallet_connect_v2/wallet_connect_v2.dart';

class WalletService extends ChangeNotifier {
  WalletConnectV2? _client;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  // Wallet address
  String? _walletAddress;
  String? get walletAddress => _walletAddress;

  // Error message for UI
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // WalletConnect pairing URI (for QR code or deep link)
  String? _pairingUri;
  String? get pairingUri => _pairingUri;

  // Shortened address for display (e.g., "0x1234...5678")
  String get shortenedAddress {
    if (_walletAddress == null || _walletAddress!.isEmpty) {
      return 'Not connected';
    }
    if (_walletAddress!.length <= 10) {
      return _walletAddress!;
    }
    return '${_walletAddress!.substring(0, 6)}...${_walletAddress!.substring(_walletAddress!.length - 4)}';
  }

  // Session data
  Session? session;

  // Callbacks you can set from UI if you prefer (optional)
  void Function(bool connected)? onConnectionStatus;
  void Function(dynamic proposal)? onSessionProposal;
  void Function(Session session)? onSessionSettle;
  void Function(dynamic topic)? onSessionUpdate;
  void Function(dynamic topic)? onSessionDelete;
  void Function(dynamic request)? onSessionRequest;
  void Function(dynamic topic)? onSessionRejection;
  void Function(dynamic topic)? onSessionResponse;

  /// Initialize the SDK client with your projectId and app metadata.
  Future<void> init({required String projectId, required dynamic appMetadata}) async {
    try {
      _client = WalletConnectV2();
      await _client!.init(projectId: projectId, appMetadata: appMetadata);

      // Map the SDK callbacks
      _client!.onConnectionStatus = (isConnected) {
        _isConnected = isConnected;
        onConnectionStatus?.call(isConnected);
        notifyListeners();
      };
    } catch (e) {
      if (kDebugMode) {
        print('WalletConnect init error: $e');
      }
      _errorMessage = 'Failed to initialize: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Connect to WalletConnect and generate pairing URI
  /// Returns true if connection initiated successfully (not yet approved by wallet)
  Future<bool> connectWallet() async {
    try {
      _errorMessage = null; // Clear previous errors
      _pairingUri = null;

      if (_client == null) {
        _errorMessage = 'WalletConnect not initialized';
        notifyListeners();
        return false;
      }

      // Connect to WalletConnect relay
      await _client!.connect();

      // Setup session proposal listener
      _client!.onSessionSettle = (Session settledSession) {
        if (kDebugMode) {
          print('Session settled: ${settledSession.topic}');
        }

        // Extract wallet address from session
        try {
          // Get accounts from session namespaces
          final namespaces = settledSession.namespaces;
          if (namespaces.isNotEmpty) {
            // Get accounts from eip155 namespace (Ethereum)
            final eip155 = namespaces['eip155'];
            if (eip155 != null && eip155.accounts.isNotEmpty) {
              final account = eip155.accounts[0];
              // Format: "eip155:1:0xAddress"
              final parts = account.split(':');
              if (parts.length >= 3) {
                _walletAddress = parts[2];
              } else {
                _walletAddress = account;
              }

              _isConnected = true;
              session = settledSession;
              onSessionSettle?.call(settledSession);
              notifyListeners();

              if (kDebugMode) {
                print('Wallet connected: $_walletAddress');
              }
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing session accounts: $e');
          }
          _errorMessage = 'Failed to get wallet address';
          notifyListeners();
        }
      };

      // Setup session rejection listener
      _client!.onSessionRejection = (topic) {
        if (kDebugMode) {
          print('Session rejected: $topic');
        }
        _errorMessage = 'Connection rejected by wallet';
        _isConnected = false;
        onSessionRejection?.call(topic);
        notifyListeners();
      };

      // Create session proposal with Ethereum namespace
      final namespaces = <String, ProposalNamespace>{
        'eip155': ProposalNamespace(
          methods: [
            'eth_sendTransaction',
            'eth_signTransaction',
            'eth_sign',
            'personal_sign',
            'eth_signTypedData',
          ],
          chains: ['eip155:1'], // Ethereum Mainnet (change as needed)
          events: ['chainChanged', 'accountsChanged'],
        ),
      };

      // Generate pairing URI and get connection info
      final connectionInfo = await _client!.createPair(namespaces: namespaces);

      // Store the pairing URI for QR code or deep link
      // The URI format should be like: wc:xxxxx@2?relay-protocol=...
      if (connectionInfo is String) {
        _pairingUri = connectionInfo;
      } else {
        // If connectionInfo is an object, try to get uri property
        _pairingUri = connectionInfo.toString();
      }

      if (kDebugMode) {
        print('WalletConnect pairing URI: $_pairingUri');
        print('Waiting for wallet approval...');
      }

      notifyListeners(); // Notify listeners so UI can access pairingUri

      // Return true to indicate connection initiated
      // Actual connection completion happens in onSessionSettle callback
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('WalletConnect error: $e');
      }
      _errorMessage = 'Failed to connect: ${e.toString()}';
      _isConnected = false;
      notifyListeners();
      return false;
    }
  }

  /// Disconnect from the wallet
  Future<void> disconnectWallet() async {
    try {
      if (_client != null && session != null) {
        await _client!.disconnectSession(topic: session!.topic);
      }

      _isConnected = false;
      _walletAddress = null;
      _errorMessage = null;
      _pairingUri = null;
      session = null;
      onConnectionStatus?.call(false);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to disconnect: ${e.toString()}';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // Optionally disconnect socket
    // await _client?.disconnect();
    super.dispose();
  }
}
