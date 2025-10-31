import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacksave/constants/colors.dart';
import 'package:stacksave/services/wallet_service.dart';
import 'package:stacksave/screens/add_goals_screen.dart';

class LaunchBScreen extends StatefulWidget {
  const LaunchBScreen({super.key});

  @override
  State<LaunchBScreen> createState() => _LaunchBScreenState();
}

class _LaunchBScreenState extends State<LaunchBScreen> {
  bool _isConnecting = false;

  Future<void> _handleConnectWallet() async {
    final walletService = context.read<WalletService>();

    setState(() {
      _isConnecting = true;
    });

    final success = await walletService.connectWallet();

    setState(() {
      _isConnecting = false;
    });

    if (!mounted) return;

    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            walletService.useMockWallet
              ? 'Connected to TEST wallet: ${walletService.shortenedAddress}'
              : 'Connected: ${walletService.shortenedAddress}'
          ),
          backgroundColor: walletService.useMockWallet ? Colors.orange : AppColors.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to Add Goals screen after short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const AddGoalsScreen(),
            ),
          );
        }
      });
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(walletService.errorMessage ?? 'Failed to connect wallet'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // App Name
              const Text(
                'StackSave',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              // Tagline
              const Text(
                'Save easily, grow effortlessly',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.black,
                ),
              ),
              const Spacer(flex: 1),

              // Wallet Status or Connect Button
              Consumer<WalletService>(
                builder: (context, walletService, child) {
                  if (walletService.isConnected) {
                    return Column(
                      children: [
                        // Connected status
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                                size: 48,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Wallet Connected',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                walletService.shortenedAddress ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.grayText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Disconnect button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: () async {
                              await walletService.disconnectWallet();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Wallet disconnected'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              'Disconnect Wallet',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  // Connect Wallet Button
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isConnecting ? null : _handleConnectWallet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: AppColors.grayText,
                      ),
                      child: _isConnecting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
                              ),
                            )
                          : const Text(
                              'Connect Wallet',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Email Login (Coming Soon)
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppColors.grayText.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Login using email (coming soon)',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColors.grayText,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
