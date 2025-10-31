import 'package:flutter/material.dart';
import 'package:stacksave/constants/colors.dart';

class WithdrawScreen extends StatefulWidget {
  final bool showNavBar;

  const WithdrawScreen({super.key, this.showNavBar = true});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _walletAddressController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  double _scrollOffset = 0.0;
  String _withdrawMethod = 'Crypto Wallet'; // 'Crypto Wallet' or 'Bank'
  String? _selectedCurrency;

  final double availableBalance = 7783.00;

  final List<String> _currencies = [
    'SOL',
    'USDC',
    'USD',
    'IDR',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
    // Listen to amount changes for validation
    _amountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _amountController.dispose();
    _walletAddressController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  double get _withdrawAmount {
    try {
      return double.parse(_amountController.text.replaceAll(',', ''));
    } catch (e) {
      return 0.0;
    }
  }

  bool get _canWithdraw {
    if (_amountController.text.isEmpty || _selectedCurrency == null) {
      return false;
    }
    if (_withdrawAmount <= 0 || _withdrawAmount > availableBalance) {
      return false;
    }
    if (_withdrawMethod == 'Crypto Wallet' && _walletAddressController.text.isEmpty) {
      return false;
    }
    if (_withdrawMethod == 'Bank' &&
        (_bankNameController.text.isEmpty || _accountNumberController.text.isEmpty)) {
      return false;
    }
    return true;
  }

  void _confirm() {
    if (!_canWithdraw) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Confirm Withdrawal',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Amount: \$${_withdrawAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            Text(
              'Currency: $_selectedCurrency',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            Text(
              'Method: $_withdrawMethod',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            if (_withdrawMethod == 'Crypto Wallet')
              Text(
                'To: ${_walletAddressController.text.substring(0, 10)}...',
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
            if (_withdrawMethod == 'Bank')
              Text(
                'To: ${_bankNameController.text} - ${_accountNumberController.text}',
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processWithdrawal();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _processWithdrawal() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Withdrawal of \$${_withdrawAmount.toStringAsFixed(2)} processing!'),
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
                      'Withdraw',
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
                          // Available Balance Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Total Amount Available',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${availableBalance.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Withdrawal Method Section
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Withdraw To',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildMethodButton('Crypto Wallet', Icons.account_balance_wallet),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildMethodButton('Bank', Icons.account_balance),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Conditional Fields based on method
                          if (_withdrawMethod == 'Crypto Wallet') ...[
                            // Wallet Address
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
                                hintText: 'Enter wallet address',
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
                          ] else ...[
                            // Bank Name
                            const Text(
                              'Bank Name',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _bankNameController,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: AppColors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: 'e.g., Bank Mandiri',
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
                            const SizedBox(height: 20),

                            // Account Number
                            const Text(
                              'Account Number',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _accountNumberController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: AppColors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter account number',
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
                          ],

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

                          // Withdrawal Amount
                          const Text(
                            'Withdrawal Amount',
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
                              hintText: '\$100.00',
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
                              suffixIcon: _amountController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      _amountController.clear();
                                    },
                                  )
                                : null,
                            ),
                          ),

                          // Amount validation message
                          if (_amountController.text.isNotEmpty && _withdrawAmount > availableBalance)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Insufficient balance',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),

                          const SizedBox(height: 8),

                          // Quick amount buttons
                          Row(
                            children: [
                              _buildQuickAmountButton('25%'),
                              const SizedBox(width: 8),
                              _buildQuickAmountButton('50%'),
                              const SizedBox(width: 8),
                              _buildQuickAmountButton('75%'),
                              const SizedBox(width: 8),
                              _buildQuickAmountButton('Max'),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Summary Card
                          if (_amountController.text.isNotEmpty && _withdrawAmount > 0 && _withdrawAmount <= availableBalance)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Withdrawal Amount',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: AppColors.grayText,
                                        ),
                                      ),
                                      Text(
                                        '\$${_withdrawAmount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Remaining Balance',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: AppColors.grayText,
                                        ),
                                      ),
                                      Text(
                                        '\$${(availableBalance - _withdrawAmount).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 32),

                          // Confirm Button
                          Center(
                            child: SizedBox(
                              width: 170,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _canWithdraw ? _confirm : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: AppColors.grayText,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Confirm',
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

  Widget _buildMethodButton(String method, IconData icon) {
    final isSelected = _withdrawMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _withdrawMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.black,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              method,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmountButton(String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          double amount;
          if (label == 'Max') {
            amount = availableBalance;
          } else {
            final percentage = int.parse(label.replaceAll('%', '')) / 100;
            amount = availableBalance * percentage;
          }
          _amountController.text = amount.toStringAsFixed(2);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
