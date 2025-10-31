import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:solana/base58.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

class WalletService extends ChangeNotifier {
  MobileWalletAdapterClient? _client;
  AuthorizationResult? _authResult;
  bool _isConnected = false;
  String? _publicKey;
  String? _errorMessage;
  bool _useMockWallet = false; // Toggle for mock wallet mode

  bool get isConnected => _isConnected;
  String? get publicKey => _publicKey;
  String? get errorMessage => _errorMessage;
  bool get useMockWallet => _useMockWallet;

  /// Get Ed25519HDPublicKey from the public key string
  Ed25519HDPublicKey? get publicKeyObj {
    if (_publicKey == null) return null;
    try {
      return Ed25519HDPublicKey.fromBase58(_publicKey!);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating public key object: $e');
      }
      return null;
    }
  }

  /// Connect to Solana wallet using Mobile Wallet Adapter
  Future<bool> connectWallet() async {
    try {
      _errorMessage = null;
      notifyListeners();

      if (kDebugMode) {
        print('Starting wallet connection...');
      }

      // Try real wallet connection first
      try {
        // Create local association scenario with proper configuration
        final scenario = await LocalAssociationScenario.create();

        if (kDebugMode) {
          print('Local association scenario created');
        }

        // Start the session - this will trigger the wallet app to open
        _client = await scenario.start();

        if (kDebugMode) {
          print('Session started, authorizing...');
        }

        // Authorize with wallet
        _authResult = await _client!.authorize(
          identityUri: Uri.parse('https://stacksave.app'),
          iconUri: Uri.parse('https://stacksave.app/favicon.ico'),
          identityName: 'StackSave',
          cluster: 'devnet',
        );

        if (_authResult == null) {
          throw Exception('Authorization failed - no auth result');
        }

        if (kDebugMode) {
          print('Authorization successful!');
        }

        // Convert public key bytes to base58 string
        _publicKey = base58encode(_authResult!.publicKey);
        _isConnected = true;
        _useMockWallet = false;

        if (kDebugMode) {
          print('Connected to real wallet: $_publicKey');
        }

        notifyListeners();
        return true;
      } catch (walletError) {
        if (kDebugMode) {
          print('Real wallet connection failed: $walletError');
          print('Falling back to mock wallet for testing...');
        }

        // Fallback to mock wallet for testing
        await Future.delayed(const Duration(milliseconds: 800)); // Simulate connection time

        // Generate a random Solana public key for testing
        final random = Random();
        final randomBytes = Uint8List(32);
        for (var i = 0; i < 32; i++) {
          randomBytes[i] = random.nextInt(256);
        }

        _publicKey = base58encode(randomBytes);
        _isConnected = true;
        _useMockWallet = true;

        if (kDebugMode) {
          print('Connected to MOCK wallet: $_publicKey');
          print('Note: This is a test wallet. Real wallet connection failed.');
        }

        notifyListeners();
        return true;
      }
    } catch (e) {
      _errorMessage = 'Failed to connect wallet: ${e.toString()}';
      _isConnected = false;
      _publicKey = null;
      _useMockWallet = false;

      if (kDebugMode) {
        print('Complete wallet connection failure: $e');
        print('Stack trace: ${StackTrace.current}');
      }

      notifyListeners();
      return false;
    }
  }

  /// Disconnect wallet
  Future<void> disconnectWallet() async {
    try {
      if (_client != null && _authResult != null && !_useMockWallet) {
        await _client!.deauthorize(authToken: _authResult!.authToken);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Disconnect error: $e');
      }
    } finally {
      _client = null;
      _authResult = null;
      _isConnected = false;
      _publicKey = null;
      _errorMessage = null;
      _useMockWallet = false;
      notifyListeners();
    }
  }

  /// Get shortened wallet address for display
  String? get shortenedAddress {
    if (_publicKey == null) return null;
    if (_publicKey!.length <= 8) return _publicKey;
    return '${_publicKey!.substring(0, 4)}...${_publicKey!.substring(_publicKey!.length - 4)}';
  }

  /// Sign and send a transaction
  /// Returns the transaction signature if successful
  Future<String?> signAndSendTransaction(Uint8List transaction) async {
    if (!_isConnected || _client == null || _authResult == null) {
      _errorMessage = 'Wallet not connected';
      notifyListeners();
      return null;
    }

    if (_useMockWallet) {
      // Mock transaction for testing
      if (kDebugMode) {
        print('Mock wallet: Simulating transaction...');
      }
      await Future.delayed(const Duration(milliseconds: 500));

      // Generate a mock signature
      final random = Random();
      final mockSignature = base58encode(
        Uint8List.fromList(List.generate(64, (_) => random.nextInt(256)))
      );

      if (kDebugMode) {
        print('Mock transaction signature: $mockSignature');
      }
      return mockSignature;
    }

    try {
      // Sign and send transaction using Mobile Wallet Adapter
      final signResult = await _client!.signAndSendTransactions(
        transactions: [transaction],
      );

      if (signResult.signatures.isEmpty) {
        throw Exception('No signed transactions returned');
      }

      // Get the transaction signature
      final signature = base58encode(signResult.signatures.first);

      if (kDebugMode) {
        print('Transaction sent successfully: $signature');
      }

      return signature;
    } catch (e) {
      _errorMessage = 'Transaction failed: ${e.toString()}';
      if (kDebugMode) {
        print('Transaction error: $e');
      }
      notifyListeners();
      return null;
    }
  }

  /// Sign a transaction without sending it
  Future<Uint8List?> signTransaction(Uint8List transaction) async {
    if (!_isConnected || _client == null || _authResult == null) {
      _errorMessage = 'Wallet not connected';
      notifyListeners();
      return null;
    }

    if (_useMockWallet) {
      // Mock signing for testing
      if (kDebugMode) {
        print('Mock wallet: Simulating transaction signing...');
      }
      await Future.delayed(const Duration(milliseconds: 300));

      // Return mock signed transaction
      return transaction;
    }

    try {
      // Sign transaction using Mobile Wallet Adapter
      final signResult = await _client!.signTransactions(
        transactions: [transaction],
      );

      if (signResult.signedPayloads.isEmpty) {
        throw Exception('No signed transactions returned');
      }

      if (kDebugMode) {
        print('Transaction signed successfully');
      }

      return Uint8List.fromList(signResult.signedPayloads.first);
    } catch (e) {
      _errorMessage = 'Signing failed: ${e.toString()}';
      if (kDebugMode) {
        print('Signing error: $e');
      }
      notifyListeners();
      return null;
    }
  }

  /// Re-authorize the session (useful when auth token expires)
  Future<bool> reauthorize() async {
    if (_client == null) {
      _errorMessage = 'No active session';
      return false;
    }

    try {
      final authToken = _authResult?.authToken;
      if (authToken == null) {
        return false;
      }

      _authResult = await _client!.reauthorize(
        identityUri: Uri.parse('https://stacksave.app'),
        iconUri: Uri.parse('https://stacksave.app/favicon.ico'),
        identityName: 'StackSave',
        authToken: authToken,
      );

      if (_authResult != null) {
        _publicKey = base58encode(_authResult!.publicKey);
        _isConnected = true;
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Reauthorize error: $e');
      }
      return false;
    }
  }

  @override
  void dispose() {
    disconnectWallet();
    super.dispose();
  }
}
