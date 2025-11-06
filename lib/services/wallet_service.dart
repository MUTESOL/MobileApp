// WalletConnect service using Reown AppKit (official WalletConnect v2)

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';

class WalletService extends ChangeNotifier {
  ReownAppKitModal? _appKitModal;
  ReownAppKitModal? get appKitModal => _appKitModal;

  bool get isConnected => _appKitModal?.isConnected ?? false;

  String? get walletAddress {
    // Get address for the currently selected chain, or default to Ethereum mainnet (1)
    final chainId = _appKitModal?.selectedChain?.chainId ?? '1';
    return _appKitModal?.session?.getAddress(chainId);
  }

  String get shortenedAddress {
    final address = walletAddress;
    if (address == null || address.isEmpty) {
      return 'Not connected';
    }
    if (address.length <= 10) {
      return address;
    }
    return '${address.substring(0, 6)}...${address.substring(address.length - 4)}';
  }

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Callbacks for UI
  void Function()? onSessionConnect;
  void Function()? onSessionDelete;

  /// Initialize the Reown AppKit modal
  Future<void> init({
    required BuildContext context,
    required String projectId,
    required PairingMetadata metadata,
  }) async {
    try {
      _errorMessage = null;

      _appKitModal = ReownAppKitModal(
        context: context,
        projectId: projectId,
        metadata: metadata,
        enableAnalytics: true,
        disconnectOnDispose: false,
      );

      // Setup event listeners
      _appKitModal!.onModalConnect.subscribe(_onModalConnect);
      _appKitModal!.onModalDisconnect.subscribe(_onModalDisconnect);
      _appKitModal!.onModalError.subscribe(_onModalError);

      // Initialize the modal
      await _appKitModal!.init();

      notifyListeners();

      if (kDebugMode) {
        print('Reown AppKit initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Reown AppKit init error: $e');
      }
      _errorMessage = 'Failed to initialize: ${e.toString()}';
      notifyListeners();
    }
  }

  void _onModalConnect(ModalConnect? event) {
    if (kDebugMode) {
      final chainId = _appKitModal?.selectedChain?.chainId ?? '1';
      print('Modal connected: ${event?.session.getAddress(chainId)}');
    }
    onSessionConnect?.call();
    notifyListeners();
  }

  void _onModalDisconnect(ModalDisconnect? event) {
    if (kDebugMode) {
      print('Modal disconnected');
    }
    onSessionDelete?.call();
    notifyListeners();
  }

  void _onModalError(ModalError? event) {
    if (kDebugMode) {
      print('Modal error: ${event?.message}');
    }
    _errorMessage = event?.message ?? 'Unknown error';
    notifyListeners();
  }

  /// Open the wallet connection modal
  Future<void> openModal() async {
    if (_appKitModal == null) {
      _errorMessage = 'AppKit not initialized. Call init() first.';
      notifyListeners();
      return;
    }

    try {
      _errorMessage = null;
      await _appKitModal!.openModalView();
    } catch (e) {
      if (kDebugMode) {
        print('Error opening modal: $e');
      }
      _errorMessage = 'Failed to open modal: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Disconnect from the wallet
  Future<void> disconnect() async {
    if (_appKitModal == null) return;

    try {
      await _appKitModal!.disconnect();
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error disconnecting: $e');
      }
      _errorMessage = 'Failed to disconnect: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Get current chain/network info
  ReownAppKitModalNetworkInfo? get currentNetwork => _appKitModal?.selectedChain;

  /// Check if a specific chain is selected
  bool isChainSelected(String chainId) {
    return _appKitModal?.selectedChain?.chainId == chainId;
  }

  @override
  void dispose() {
    // Unsubscribe from events
    _appKitModal?.onModalConnect.unsubscribe(_onModalConnect);
    _appKitModal?.onModalDisconnect.unsubscribe(_onModalDisconnect);
    _appKitModal?.onModalError.unsubscribe(_onModalError);

    super.dispose();
  }
}
