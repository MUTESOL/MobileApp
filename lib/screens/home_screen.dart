import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacksave/constants/colors.dart';
import 'package:stacksave/screens/add_goals_screen.dart';
import 'package:stacksave/screens/add_saving_screen.dart';
import 'package:stacksave/screens/notification_screen.dart';
import 'package:stacksave/screens/portfolio_screen.dart';
import 'package:stacksave/screens/profile_screen.dart';
import 'package:stacksave/screens/withdraw_screen.dart';
import 'package:stacksave/services/wallet_service.dart';
import 'package:stacksave/services/stacksave_service.dart';

class HomeScreen extends StatefulWidget {
  final bool showNavBar;

  const HomeScreen({super.key, this.showNavBar = true});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fireAnimationController;
  final ScrollController _scrollController = ScrollController();
  bool _showSpeedDial = false;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    // Animation controller for fire icon
    _fireAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Scroll listener
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _fireAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSpeedDial() {
    setState(() {
      _showSpeedDial = !_showSpeedDial;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate scroll-based animations
    const double maxHeaderHeight = 220.0; // Header + Streak section height
    final double headerOpacity = (1 - (_scrollOffset / 150)).clamp(0.0, 1.0);
    final double headerTranslateY = -(_scrollOffset * 0.5).clamp(0.0, maxHeaderHeight);
    final double borderRadius = (32.0 - (_scrollOffset / 8)).clamp(16.0, 32.0); // Min 16px radius

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            // Header and Streak Section (will fade out on scroll)
            Positioned(
              top: headerTranslateY,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: headerOpacity,
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'design/logo-white.png',
                            height: 48,
                            color: Colors.white,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NotificationScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Streak Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Animated Fire Icon
                              AnimatedBuilder(
                                animation: _fireAnimationController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      0,
                                      -5 * _fireAnimationController.value,
                                    ),
                                    child: Transform.scale(
                                      scale: 1.0 + (0.1 * _fireAnimationController.value),
                                      child: Image.asset(
                                        'design/fire.png',
                                        height: 40,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                '20 Days Streak',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Week Days
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildDayIndicator('Su', true),
                              _buildDayIndicator('M', true),
                              _buildDayIndicator('Tu', false),
                              _buildDayIndicator('W', false),
                              _buildDayIndicator('Th', false),
                              _buildDayIndicator('F', false),
                              _buildDayIndicator('Sa', false),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Main Content Area (scrollable white card)
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
                          // Main Goal Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Car Icon with Progress
                                    Column(
                                      children: [
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            // Progress Circle
                                            SizedBox(
                                              width: 90,
                                              height: 90,
                                              child: CircularProgressIndicator(
                                                value: 0.4, // 40% progress (4000/10000)
                                                strokeWidth: 6,
                                                backgroundColor: Colors.white.withOpacity(0.2),
                                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            ),
                                            // Car Icon
                                            Container(
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Image.asset(
                                                  'design/Car.png',
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Buying car',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    // Divider
                                    Container(
                                      width: 1,
                                      height: 100,
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                    const SizedBox(width: 16),
                                    // Savings Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.account_balance_wallet,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'Total saving',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            '\$4,000.00',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.flag_outlined,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'Target',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            '\$10,000.00',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Other Goals
                          const Text(
                            'Other Goals',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Goal Items
                          _buildGoalItem(
                            icon: 'design/Group.png',
                            title: 'Buy Stock',
                            progress: 0.8, // 80% complete
                            saved: '\$8,000.00',
                            target: '\$10,000.00',
                          ),
                          const SizedBox(height: 12),
                          _buildGoalItem(
                            icon: 'design/Salary.png',
                            title: 'Buy Flat',
                            progress: 0.5, // 50% complete
                            saved: '\$50,000.00',
                            target: '\$100,000.00',
                          ),
                          const SizedBox(height: 12),
                          _buildGoalItem(
                            icon: 'design/Group.png',
                            title: 'Buy House',
                            progress: 0.2, // 20% complete
                            saved: '\$40,000.00',
                            target: '\$200,000.00',
                          ),

                          const SizedBox(height: 32),

                          // Faucet Section
                          const Text(
                            'Faucet',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Faucet Cards
                          _buildFaucetCard(
                            title: 'IDRX Faucet',
                            description: 'Get free IDRX tokens for testing',
                            amount: '100 IDRX',
                            color: const Color(0xFF5B9CFF),
                            icon: Icons.water_drop,
                            tokenType: 'IDRX',
                          ),
                          const SizedBox(height: 12),
                          _buildFaucetCard(
                            title: 'USDC Faucet',
                            description: 'Get free USDC tokens for testing',
                            amount: '10 USDC',
                            color: const Color(0xFF0052CC),
                            icon: Icons.account_balance_wallet,
                            tokenType: 'USDC',
                          ),

                          const SizedBox(height: 100), // Space for bottom nav
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Floating Action Button with Speed Dial
            Positioned(
              bottom: 100,
              right: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Speed Dial Options
                  if (_showSpeedDial) ...[
                    _buildSpeedDialOption(
                      label: 'Add Goals',
                      icon: Icons.flag,
                      onTap: () {
                        setState(() {
                          _showSpeedDial = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddGoalsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSpeedDialOption(
                      label: 'Add Saving',
                      icon: Icons.account_balance_wallet,
                      onTap: () {
                        setState(() {
                          _showSpeedDial = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddSavingScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Main FAB
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _toggleSpeedDial,
                        borderRadius: BorderRadius.circular(32),
                        child: Center(
                          child: AnimatedRotation(
                            duration: const Duration(milliseconds: 200),
                            turns: _showSpeedDial ? 0.125 : 0,
                            child: Icon(
                              _showSpeedDial ? Icons.close : Icons.add,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation Bar
            if (widget.showNavBar)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4F5E9),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.home, true, null),
                      _buildNavItem(Icons.pie_chart_outline, false, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PortfolioScreen(),
                          ),
                        );
                      }),
                      _buildNavItem(Icons.layers, false, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddSavingScreen(),
                          ),
                        );
                      }),
                      _buildNavItem(Icons.swap_horiz, false, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WithdrawScreen(),
                          ),
                        );
                      }),
                      _buildNavItem(Icons.person_outline, false, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayIndicator(String day, bool isCompleted) {
    return Column(
      children: [
        Text(
          day,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.white.withOpacity(0.3) : Colors.white,
            shape: BoxShape.circle,
          ),
          child: isCompleted
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                )
              : null,
        ),
      ],
    );
  }

  Widget _buildGoalItem({
    required String icon,
    required String title,
    required double progress,
    required String saved,
    required String target,
  }) {
    // Determine color based on progress (darker blue = closer to goal)
    Color getProgressColor() {
      if (progress >= 0.7) {
        return const Color(0xFF0052CC); // Dark blue - close to goal
      } else if (progress >= 0.4) {
        return const Color(0xFF5B9CFF); // Medium blue
      } else {
        return const Color(0xFF99C2FF); // Light blue - far from goal
      }
    }

    final color = getProgressColor();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                icon,
                width: 32,
                height: 32,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      saved,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    Text(
                      ' / $target',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: AppColors.grayText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Progress percentage
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedDialOption({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : AppColors.black.withOpacity(0.5),
          size: 28,
        ),
      ),
    );
  }

  Widget _buildFaucetCard({
    required String title,
    required String description,
    required String amount,
    required Color color,
    required IconData icon,
    required String tokenType,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.grayText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () async {
              // Get wallet service
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

              // Claim from faucet
              final stackSaveService = StackSaveService(
                walletService: walletService,
              );

              final signature = await stackSaveService.claimFromFaucet(
                tokenType: tokenType,
              );

              // Close loading dialog
              if (context.mounted) {
                Navigator.pop(context);
              }

              // Show result
              if (context.mounted) {
                if (signature != null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Success!'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('You received $amount!'),
                          const SizedBox(height: 8),
                          const Text(
                            'Transaction Signature:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            signature,
                            style: const TextStyle(
                              fontSize: 10,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        walletService.useMockWallet
                            ? 'Mock faucet claim simulated!'
                            : 'Failed to claim from faucet',
                      ),
                      backgroundColor:
                          walletService.useMockWallet ? Colors.orange : Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }

              stackSaveService.dispose();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Claim',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
