import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:solana/solana.dart';
import 'package:stacksave/services/wallet_service.dart';

/// Service for interacting with StackSave smart contract on Solana
class StackSaveService {
  // Smart Contract Addresses from deployment
  static const String programId = '4Ho2aKGXYt4ZyS6qpkxy2xpYpbWJGDQq4grrcnLpJnNR';
  static const String globalStatePDA = 'Bgrmt9k33JTLVG2cxs6iXmfrznjwDfZ2D6DfoNkFt8HN';
  static const String treasury = 'KoMsP3JY27Uk4Ufvuaoi8gggpbemGnYtxawPWDggepK';
  static const String rewardPool = 'HtbyQ8nqi8WZewdaj9kmEukJsTtZ4iEcnVojCu9QqCzs';

  // Token Mints
  static const String usdcMint = 'ATfRmV4crskH4kM8LWnRBbXUJvGYtmq21Aivyi2EeKVW';
  static const String idrxMint = 'H4eKxcnt1WMrWwMxSpusYsR79apGVnC26xD6VbCazsw4';
  static const String sUsdcMint = 'J6KPPT3bfT9EpWKQuk1y3aWv1UZ9mm9edjRmK32yv516';
  static const String sIdrxMint = '7YZdNVBAyszLzTgKrvFvr4AQf64DqqsN26upwasdE1yg';

  // Currency Configs
  static const String usdcConfig = 'CzaXXwPoUVuJV6EHvWYyHe2peN8UoTgektamy4YxKrKD';
  static const String idrxConfig = 'Df2oV1WVx5KNnN7SgGXpAsLsz5J93vHJ6LAKSJ18jpY9';

  // Faucets
  static const String usdcFaucet = '4XTmTehdh9gyQsypWcU29gcFbBebG2a2G9mou37fLirE';
  static const String idrxFaucet = 'DcpS6FqWFgw5LCmtMQdNQoKxj47KwSQ1qwPwEf833aTE';

  final WalletService walletService;
  final SolanaClient rpcClient;

  StackSaveService({
    required this.walletService,
    String? rpcUrl,
  }) : rpcClient = SolanaClient(
          rpcUrl: Uri.parse(rpcUrl ?? 'https://api.devnet.solana.com'),
          websocketUrl: Uri.parse('wss://api.devnet.solana.com'),
        );

  /// Claim tokens from faucet (USDC or IDRX)
  Future<String?> claimFromFaucet({required String tokenType}) async {
    if (!walletService.isConnected || walletService.publicKey == null) {
      if (kDebugMode) {
        print('Wallet not connected');
      }
      return null;
    }

    try {
      final faucetAddress = tokenType == 'USDC' ? usdcFaucet : idrxFaucet;

      if (kDebugMode) {
        print('Claiming $tokenType from faucet: $faucetAddress');
      }

      // For now, use mock transaction
      // TODO: Implement actual transaction building when solana package API is stable
      if (walletService.useMockWallet) {
        await Future.delayed(const Duration(milliseconds: 800));
        final mockSignature = 'mock_faucet_claim_${DateTime.now().millisecondsSinceEpoch}';
        if (kDebugMode) {
          print('Mock faucet claim successful! Signature: $mockSignature');
        }
        return mockSignature;
      }

      // Placeholder for real transaction
      // This will be implemented once we have the correct API usage
      if (kDebugMode) {
        print('Real faucet claim not yet implemented - using mock');
      }
      await Future.delayed(const Duration(milliseconds: 800));
      return 'placeholder_${DateTime.now().millisecondsSinceEpoch}';

    } catch (e) {
      if (kDebugMode) {
        print('Faucet claim error: $e');
      }
      return null;
    }
  }

  /// Get token balance for a specific mint
  Future<double> getTokenBalance(String mintAddress) async {
    if (!walletService.isConnected || walletService.publicKey == null) {
      return 0.0;
    }

    try {
      if (walletService.useMockWallet) {
        // Return mock balance
        return 100.0;
      }

      // TODO: Implement actual balance check when API is stable
      if (kDebugMode) {
        print('Real balance check not yet implemented - returning 0');
      }
      return 0.0;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting token balance: $e');
      }
      return 0.0;
    }
  }

  /// Stake tokens (Lite or Pro mode)
  Future<String?> stakeTokens({
    required String tokenMint,
    required double amount,
    required bool isProMode,
  }) async {
    if (!walletService.isConnected || walletService.publicKey == null) {
      if (kDebugMode) {
        print('Wallet not connected');
      }
      return null;
    }

    try {
      if (kDebugMode) {
        print('Staking $amount tokens in ${isProMode ? "Pro" : "Lite"} mode');
      }

      // For now, use mock transaction
      if (walletService.useMockWallet) {
        await Future.delayed(const Duration(milliseconds: 1000));
        final mockSignature = 'mock_stake_${DateTime.now().millisecondsSinceEpoch}';
        if (kDebugMode) {
          print('Mock stake successful! Signature: $mockSignature');
        }
        return mockSignature;
      }

      // Placeholder for real transaction
      if (kDebugMode) {
        print('Real stake not yet implemented - using mock');
      }
      await Future.delayed(const Duration(milliseconds: 1000));
      return 'placeholder_stake_${DateTime.now().millisecondsSinceEpoch}';

    } catch (e) {
      if (kDebugMode) {
        print('Stake error: $e');
      }
      return null;
    }
  }

  /// Unstake/Withdraw tokens
  Future<String?> unstakeTokens({
    required String tokenMint,
    required double amount,
  }) async {
    if (!walletService.isConnected || walletService.publicKey == null) {
      if (kDebugMode) {
        print('Wallet not connected');
      }
      return null;
    }

    try {
      if (kDebugMode) {
        print('Unstaking $amount tokens');
      }

      // For now, use mock transaction
      if (walletService.useMockWallet) {
        await Future.delayed(const Duration(milliseconds: 1000));
        final mockSignature = 'mock_unstake_${DateTime.now().millisecondsSinceEpoch}';
        if (kDebugMode) {
          print('Mock unstake successful! Signature: $mockSignature');
        }
        return mockSignature;
      }

      // Placeholder for real transaction
      if (kDebugMode) {
        print('Real unstake not yet implemented - using mock');
      }
      await Future.delayed(const Duration(milliseconds: 1000));
      return 'placeholder_unstake_${DateTime.now().millisecondsSinceEpoch}';

    } catch (e) {
      if (kDebugMode) {
        print('Unstake error: $e');
      }
      return null;
    }
  }

  void dispose() {
    // SolanaClient doesn't have a close() method in current API version
    // The connection will be cleaned up automatically
  }
}
