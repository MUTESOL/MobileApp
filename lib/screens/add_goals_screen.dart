import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacksave/constants/colors.dart';
import 'package:stacksave/screens/main_navigation.dart';
import 'package:stacksave/services/api_service.dart';
import 'package:stacksave/services/wallet_service.dart';

class AddGoalsScreen extends StatefulWidget {
  const AddGoalsScreen({super.key});

  @override
  State<AddGoalsScreen> createState() => _AddGoalsScreenState();
}

class _AddGoalsScreenState extends State<AddGoalsScreen> {
  final TextEditingController _goalNameController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _timeFrameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _goalNameController.dispose();
    _targetAmountController.dispose();
    _timeFrameController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _saveGoal() async {
    // Validation
    if (_goalNameController.text.isEmpty ||
        _targetAmountController.text.isEmpty ||
        _timeFrameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final walletService = context.read<WalletService>();
    if (!walletService.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please connect your wallet first'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final walletService = context.read<WalletService>();
      final apiService = ApiService();

      // Use default currency (USDC)
      const defaultCurrencyAddress = '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48'; // USDC

      // Parse timeframe to days
      final durationInDays = int.tryParse(_timeFrameController.text) ?? 90;

      // Validate and convert target amount to wei format
      double targetAmountDouble;
      try {
        targetAmountDouble = double.parse(_targetAmountController.text);
        if (targetAmountDouble <= 0) {
          throw Exception('Amount must be greater than 0');
        }
      } catch (e) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid target amount'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Convert to wei format (USDC uses 6 decimals)
      final targetAmountWei = (targetAmountDouble * 1e6).toStringAsFixed(0);

      print('📝 DEBUG: Target amount: $targetAmountDouble USDC = $targetAmountWei wei');

      // Create goal via API
      print('📝 DEBUG: Creating goal with address: ${walletService.walletAddress}');
      final result = await apiService.createGoal(
        name: _goalNameController.text,
        owner: walletService.walletAddress ?? '0x0000000000000000000000000000000000000000',
        currency: defaultCurrencyAddress,
        mode: 0, // 0 = Lite Mode, 1 = Pro Mode
        targetAmount: targetAmountWei,
        durationInDays: durationInDays,
        donationPercentage: 500, // 5% donation
      );
      print('✅ DEBUG: Goal created: $result');

      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      // Show success dialog
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false, // Force user to click OK button
        builder: (dialogContext) => AlertDialog(
          title: const Text('🎉 Goal Created!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Goal "${_goalNameController.text}" has been created successfully!'),
              const SizedBox(height: 12),
              Text(
                'Goal ID: ${result['data']?['goalId'] ?? 'N/A'}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Target: \$${_targetAmountController.text}',
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                'Duration: ${_timeFrameController.text} days',
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close dialog using dialog's context
                Navigator.of(dialogContext).pop();
                // Navigate back and signal success to refresh goals
                Navigator.of(context).pop(true); // Return true to indicate success
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      // Show error
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create goal: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _oldSaveGoal() {
    // Navigate to Main Navigation (Home screen)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainNavigation(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate scroll-based animations
    const double maxHeaderHeight = 72.0; // Header height
    final double headerOpacity = (1 - (_scrollOffset / 100)).clamp(0.0, 1.0);
    final double headerTranslateY = -(_scrollOffset * 0.5).clamp(0.0, maxHeaderHeight);
    final double borderRadius = (32.0 - (_scrollOffset / 8)).clamp(16.0, 32.0);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            // Header (will fade out on scroll)
            Positioned(
              top: headerTranslateY,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: headerOpacity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: const Text(
                      'Add Saving Goals',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Form Container (scrollable white card)
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Space for header
                SliverToBoxAdapter(
                  child: SizedBox(height: maxHeaderHeight),
                ),

                // White Card Content
                SliverToBoxAdapter(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 80,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      // Goal Name
                      const Text(
                        'Goal Name',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _goalNameController,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: AppColors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Buying Honda Civic Hybrid',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: AppColors.black.withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFE8F5E9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Target Amount (in USDC)
                      const Text(
                        'Target Amount',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _targetAmountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: AppColors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: '\$100',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: AppColors.black.withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFE8F5E9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Time Frame
                      const Text(
                        'Time Frame (Days)',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _timeFrameController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: AppColors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: '90',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: AppColors.black.withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFE8F5E9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 5,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: AppColors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter Description',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: AppColors.grayText,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFE8F5E9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Save Button
                      Center(
                        child: SizedBox(
                          width: 170,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _saveGoal,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'SOL':
        return 'SOL ';
      case 'USDC':
        return '\$ ';
      case 'USD':
        return '\$ ';
      case 'IDR':
        return 'Rp ';
      default:
        return '\$ ';
    }
  }
}
