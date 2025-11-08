import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:stacksave/constants/colors.dart';
import 'package:stacksave/services/api_service.dart';
import 'package:stacksave/services/wallet_service.dart';

class AddSavingScreen extends StatefulWidget {
  final bool showNavBar;
  final bool fromNavBar;

  const AddSavingScreen({
    super.key,
    this.showNavBar = true,
    this.fromNavBar = false,
  });

  @override
  State<AddSavingScreen> createState() => _AddSavingScreenState();
}

class _AddSavingScreenState extends State<AddSavingScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _walletAddressController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();

  double _scrollOffset = 0.0;
  String _savingMode = 'Lite Mode'; // 'Lite Mode' or 'Pro Mode'
  int? _selectedGoalId; // Changed to int goalId
  String? _selectedPaymentMethod;

  // Real-time data from backend
  List<Map<String, dynamic>> _realGoals = [];
  bool _isLoadingGoals = true;

  // Get mode info
  Map<String, dynamic> get _modeInfo {
    if (_savingMode == 'Lite Mode') {
      return {
        'title': 'Lite Mode',
        'desc': 'Auto-stake in stablecoins',
        'risk': 'Low Risk',
        'apy': '5-8%',
        'color': const Color(0xFF4CAF50),
      };
    } else {
      return {
        'title': 'Pro Mode',
        'desc': 'High-yield staking instruments',
        'risk': 'High Risk',
        'apy': '15-30%',
        'color': const Color(0xFFFF9800),
      };
    }
  }

  // Calculate projected returns
  String _calculateProjectedReturns() {
    if (_amountController.text.isEmpty) return '\$0.00';

    try {
      final amount = double.parse(_amountController.text.replaceAll(',', ''));
      final apy = _savingMode == 'Lite Mode' ? 0.065 : 0.225; // Average APY
      final monthlyReturn = amount * (apy / 12);
      return '\$${monthlyReturn.toStringAsFixed(2)}';
    } catch (e) {
      return '\$0.00';
    }
  }

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'Wallet',
      'icon': Icons.account_balance_wallet,
      'description': 'Connect your crypto wallet',
    },
    {
      'name': 'Mastercard',
      'icon': Icons.credit_card,
      'description': 'Pay with your credit card',
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
    // Listen to amount changes for real-time calculation
    _amountController.addListener(() {
      setState(() {});
    });
    // Fetch real data from backend
    _loadUserGoals();
  }

  // Fetch user's goals from database
  Future<void> _loadUserGoals() async {
    final walletService = context.read<WalletService>();

    print('🔍 AddSaving: Loading goals...');
    print('🔍 AddSaving: Wallet address: ${walletService.walletAddress}');

    if (walletService.walletAddress == null) {
      print('❌ AddSaving: Wallet address is null');
      setState(() => _isLoadingGoals = false);
      return;
    }

    try {
      final apiService = ApiService();
      print('📡 AddSaving: Calling API with address: ${walletService.walletAddress}');
      final response = await apiService.getUserGoals(walletService.walletAddress!);

      print('✅ AddSaving: API Response: $response');

      if (response['success'] == true) {
        final data = response['data'];
        if (data != null && data['goals'] != null) {
          final goalsList = List<Map<String, dynamic>>.from(data['goals']);
          print('✅ AddSaving: Found ${goalsList.length} goals');
          setState(() {
            _realGoals = goalsList;
            _isLoadingGoals = false;
          });
        } else {
          print('⚠️ AddSaving: No goals data in response');
          setState(() => _isLoadingGoals = false);
        }
      } else {
        print('⚠️ AddSaving: API returned success=false');
        setState(() => _isLoadingGoals = false);
      }
    } catch (e) {
      print('❌ AddSaving Error loading goals: $e');
      setState(() => _isLoadingGoals = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _amountController.dispose();
    _walletAddressController.dispose();
    _cardNumberController.dispose();
    _cvcController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  Future<void> _proceed() async {
    // Validation
    if (_selectedGoalId == null ||
        _amountController.text.isEmpty ||
        _selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
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
      final apiService = ApiService();

      // Call deposit API with real goalId
      final result = await apiService.deposit(
        goalId: _selectedGoalId!,
        amount: _amountController.text.replaceAll(',', ''),
      );

      // Close loading dialog
      if (!mounted) return;
      Navigator.pop(context);

      // Show success dialog with transaction details
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          title: const Text('✅ Deposit Successful!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount: \$${_amountController.text}'),
              const SizedBox(height: 12),
              const Text(
                'Transaction Hash:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                result['data']['txHash'] ?? 'N/A',
                style: const TextStyle(fontSize: 10),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your funds are now staked in Morpho v2 and earning yield!',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                Navigator.of(context).pop(true); // Return to home with refresh signal
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
          content: Text('Deposit failed: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate scroll-based animations
    const double maxHeaderHeight = 72.0;
    final double headerOpacity = (1 - (_scrollOffset / 100)).clamp(0.0, 1.0);
    final double headerTranslateY = -(_scrollOffset * 0.5).clamp(0.0, maxHeaderHeight);
    final double borderRadius = (32.0 - (_scrollOffset / 8)).clamp(16.0, 32.0);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: VisibilityDetector(
        key: const Key('add-saving-screen'),
        onVisibilityChanged: (info) {
          // Reload goals when screen becomes visible (>50% visible)
          if (info.visibleFraction > 0.5 && mounted) {
            _loadUserGoals();
          }
        },
        child: SafeArea(
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
                      'Add Saving',
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
            RefreshIndicator(
              onRefresh: _loadUserGoals,
              child: CustomScrollView(
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
                          // Saving Mode Section
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Saving Mode',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildModeButton('Lite Mode'),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildModeButton('Pro Mode'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Mode Description
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _savingMode == 'Lite Mode'
                                          ? Icons.shield_outlined
                                          : Icons.trending_up,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _modeInfo['desc'],
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              '${_modeInfo['risk']} • APY ${_modeInfo['apy']}',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 10,
                                                color: Colors.white.withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Goals
                          const Text(
                            'Goals',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: _isLoadingGoals
                                  ? const Center(child: CircularProgressIndicator())
                                  : DropdownButton<int>(
                                      value: _selectedGoalId,
                                      hint: Text(
                                        _realGoals.isEmpty ? 'No goals available' : 'Select the goals',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          color: AppColors.grayText,
                                        ),
                                      ),
                                      isExpanded: true,
                                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        color: AppColors.black,
                                      ),
                                      items: _realGoals.map((goal) {
                                        return DropdownMenuItem<int>(
                                          value: goal['id'] as int,
                                          child: Text(goal['name'] as String),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        setState(() {
                                          _selectedGoalId = newValue;
                                        });
                                      },
                                    ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Amount
                          const Text(
                            'Amount',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: AppColors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: '\$30,00',
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

                          // Analysis Section
                          const Text(
                            'Analysis',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                // Projected Monthly Returns
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Projected Monthly Returns',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 11,
                                            color: AppColors.grayText,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _calculateProjectedReturns(),
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _modeInfo['color'],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _modeInfo['apy'],
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Info Cards
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoCard(
                                        'Risk Level',
                                        _modeInfo['risk'],
                                        _savingMode == 'Lite Mode'
                                          ? Icons.shield_outlined
                                          : Icons.warning_amber_outlined,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _buildInfoCard(
                                        'Strategy',
                                        _savingMode == 'Lite Mode' ? 'Stablecoin' : 'High Yield',
                                        Icons.analytics_outlined,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Payment Method
                          const Text(
                            'Payment Method',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Payment Method Options
                          ..._paymentMethods.map((method) {
                            final isSelected = _selectedPaymentMethod == method['name'];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedPaymentMethod = method['name'];
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isSelected
                                            ? AppColors.primary.withOpacity(0.2)
                                            : Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primary.withOpacity(0.1)
                                              : const Color(0xFFE8F5E9),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          method['icon'],
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.grayText,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              method['name'],
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: isSelected
                                                    ? AppColors.primary
                                                    : AppColors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              method['description'],
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: AppColors.grayText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          color: AppColors.primary,
                                          size: 24,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),

                          // Dynamic Payment Form Fields
                          if (_selectedPaymentMethod != null) ...[
                            const SizedBox(height: 16),
                            if (_selectedPaymentMethod == 'Wallet') ...[
                              const Text(
                                'Wallet Address',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _walletAddressController,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: AppColors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: '0x742d35Cc6634C0532925a3b...',
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
                            ] else if (_selectedPaymentMethod == 'Mastercard') ...[
                              const Text(
                                'Card Number',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _cardNumberController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: AppColors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: '1234 5678 9012 3456',
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
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Expiry Date',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller: _expiryController,
                                          keyboardType: TextInputType.datetime,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            color: AppColors.black,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'MM/YY',
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
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'CVC',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        TextField(
                                          controller: _cvcController,
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            color: AppColors.black,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: '123',
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],

                          const SizedBox(height: 24),

                          // Proceed Button
                          Center(
                            child: SizedBox(
                              width: 170,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _proceed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Proceed',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildModeButton(String mode) {
    final isSelected = _savingMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _savingMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            mode,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primary : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: AppColors.grayText,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: AppColors.grayText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
