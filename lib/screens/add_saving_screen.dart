import 'package:flutter/material.dart';
import 'package:stacksave/constants/colors.dart';

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

  double _scrollOffset = 0.0;
  String _savingMode = 'Lite Mode'; // 'Lite Mode' or 'Pro Mode'
  String? _selectedGoal;
  String? _selectedCurrency;
  String? _selectedPaymentMethod;

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

  final List<String> _goals = [
    'Buying car',
    'Buy Stock',
    'Buy Flat',
    'Buy House',
  ];

  final List<String> _currencies = [
    'SOL',
    'USDC',
    'USD',
    'IDR',
  ];

  final List<String> _paymentMethods = [
    'Via Wallet',
    'Via Bank Transfer',
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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _proceed() {
    if (_selectedGoal == null ||
        _selectedCurrency == null ||
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

    // TODO: Process saving transaction
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saving \$${_amountController.text} to $_selectedGoal!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
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
                              child: DropdownButton<String>(
                                value: _selectedGoal,
                                hint: Text(
                                  'Select the goals',
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
                                items: _goals.map((goal) {
                                  return DropdownMenuItem<String>(
                                    value: goal,
                                    child: Text(goal),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGoal = newValue;
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Currency
                          const Text(
                            'Currency',
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
                              child: DropdownButton<String>(
                                value: _selectedCurrency,
                                hint: Text(
                                  'Select currency',
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
                                items: _currencies.map((currency) {
                                  return DropdownMenuItem<String>(
                                    value: currency,
                                    child: Text(currency),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCurrency = newValue;
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
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedPaymentMethod = method;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: _selectedPaymentMethod == method
                                        ? AppColors.primary.withOpacity(0.1)
                                        : const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _selectedPaymentMethod == method
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    method,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: _selectedPaymentMethod == method
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: _selectedPaymentMethod == method
                                          ? AppColors.primary
                                          : AppColors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),

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
          ],
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
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    color: AppColors.grayText,
                  ),
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
