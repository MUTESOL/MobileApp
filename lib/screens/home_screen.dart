import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:stacksave/constants/colors.dart';
import 'package:stacksave/screens/add_goals_screen.dart';
import 'package:stacksave/screens/add_saving_screen.dart';
import 'package:stacksave/screens/discover_screen.dart';
import 'package:stacksave/screens/notification_screen.dart';
import 'package:stacksave/screens/portfolio_screen.dart';
import 'package:stacksave/screens/profile_screen.dart';
import 'package:stacksave/screens/withdraw_screen.dart';
import 'package:stacksave/services/wallet_service.dart';
import 'package:stacksave/services/api_service.dart';
import 'package:stacksave/models/goal_model.dart';

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

  // Goals data
  List<GoalModel> _goals = [];
  bool _isLoadingGoals = true;

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

    // Load goals from API - defer until after first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGoals();
    });
  }

  // Public method to refresh goals (can be called externally)
  Future<void> refreshGoals() async {
    await _loadGoals();
  }

  Future<void> _loadGoals() async {
    final walletService = context.read<WalletService>();

    // DEBUG: Print wallet info
    print('🔍 DEBUG: Loading goals...');
    print('🔍 DEBUG: Wallet connected: ${walletService.isConnected}');
    print('🔍 DEBUG: Wallet address: ${walletService.walletAddress}');

    if (!walletService.isConnected || walletService.walletAddress == null) {
      print('❌ DEBUG: Skipping API call - wallet not connected or address is null');
      setState(() {
        _isLoadingGoals = false;
      });
      return;
    }

    try {
      final apiService = ApiService();
      print('📡 DEBUG: Calling API with address: ${walletService.walletAddress}');
      final response = await apiService.getUserGoals(walletService.walletAddress!);

      print('✅ DEBUG: API Response: $response');

      if (response['success'] == true) {
        final data = response['data'];
        if (data != null && data['goals'] != null) {
          final goalsData = data['goals'] as List;
          final goals = goalsData.map((json) => GoalModel.fromJson(json)).toList();

          print('DEBUG: Loaded ${goals.length} goals');

          setState(() {
            _goals = goals;
            _isLoadingGoals = false;
          });
        } else {
          print('DEBUG: No goals data in response');
          setState(() {
            _goals = [];
            _isLoadingGoals = false;
          });
        }
      } else {
        print('DEBUG: Response success is false');
        setState(() {
          _goals = [];
          _isLoadingGoals = false;
        });
      }
    } catch (e) {
      print('ERROR loading goals: $e');
      setState(() {
        _goals = [];
        _isLoadingGoals = false;
      });
    }
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
      body: VisibilityDetector(
        key: const Key('home-screen'),
        onVisibilityChanged: (info) {
          // Reload goals when screen becomes visible (>50% visible)
          if (info.visibleFraction > 0.5 && mounted) {
            _loadGoals();
          }
        },
        child: SafeArea(
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
                    // Header (logo only)
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
                          // Spacer for notification button (positioned separately)
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),

                    // Streak Section
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 8, bottom: 4),
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
                              Text(
                                '${(_goals.isNotEmpty && !_isLoadingGoals) ? _goals[0].currentStreak : 0} Days Streak',
                                style: const TextStyle(
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
                            children: _buildWeekDayIndicators(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Main Content Area (scrollable white card)
            RefreshIndicator(
              onRefresh: _loadGoals,
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
                          // Main Goal Card or Empty State
                          if (_isLoadingGoals)
                            Container(
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                            )
                          else if (_goals.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                children: const [
                                  Icon(Icons.flag_outlined, color: Colors.white, size: 48),
                                  SizedBox(height: 16),
                                  Text(
                                    'No Goals Yet',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Create your first savings goal!',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
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
                                      // Icon with Progress
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
                                                  value: _goals[0].progress,
                                                  strokeWidth: 6,
                                                  backgroundColor: Colors.white.withOpacity(0.2),
                                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              ),
                                              // Icon
                                              Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.2),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.savings_outlined,
                                                    color: Colors.white,
                                                    size: 32,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            _goals[0].name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
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
                                              children: const [
                                                Icon(
                                                  Icons.account_balance_wallet,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
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
                                            Text(
                                              '\$${_goals[0].depositedAmountDouble.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: const [
                                                Icon(
                                                  Icons.flag_outlined,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
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
                                            Text(
                                              '\$${_goals[0].targetAmountDouble.toStringAsFixed(2)}',
                                              style: const TextStyle(
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

                          // Donation Banner
                          _buildDonationBanner(),

                          const SizedBox(height: 24),

                          // Other Goals - Show if there are more than 1 goal
                          if (_goals.length > 1) const Text(
                            'Other Goals',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          if (_goals.length > 1) const SizedBox(height: 16),

                          // Display remaining goals using List.generate instead of nested spreads
                          ...List.generate(_goals.length > 1 ? _goals.length - 1 : 0, (index) {
                            final i = index + 1;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                key: ValueKey('goal_${_goals[i].id}'),
                                child: _buildGoalItem(
                                  emoji: 'design/Group.png',
                                  title: _goals[i].name,
                                  progress: _goals[i].progress,
                                  saved: '\$${_goals[i].depositedAmountDouble.toStringAsFixed(2)}',
                                  target: '\$${_goals[i].targetAmountDouble.toStringAsFixed(2)}',
                                ),
                              ),
                            );
                          }),

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

                          // USDC Faucet Card
                          _buildFaucetCard(
                            title: 'USDC Faucet',
                            description: 'Get free USDC tokens for testing',
                            amount: '100 USDC',
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
            ),

            // Notification Button (fades with header but always clickable)
            Positioned(
              top: 16,
              right: 16,
              child: Opacity(
                opacity: headerOpacity,
                child: GestureDetector(
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
              ),
            ),

            // Floating Action Button with Speed Dial
            Positioned(
              bottom: 20,
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
                      onTap: () async {
                        setState(() {
                          _showSpeedDial = false;
                        });
                        // Navigate and wait for result
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddGoalsScreen(),
                          ),
                        );
                        // If goal was created successfully, refresh the list
                        if (result == true) {
                          setState(() {
                            _goals = []; // Clear stale data to prevent accessing old goals
                            _isLoadingGoals = true;
                          });
                          // Add delay to allow database transaction to commit
                          await Future.delayed(const Duration(milliseconds: 500));
                          await _loadGoals();
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSpeedDialOption(
                      label: 'Add Saving',
                      icon: Icons.account_balance_wallet,
                      onTap: () async {
                        setState(() {
                          _showSpeedDial = false;
                        });
                        // Navigate and wait for result
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddSavingScreen(),
                          ),
                        );
                        // Refresh goals if deposit was successful
                        if (result == true) {
                          setState(() {
                            _goals = [];
                            _isLoadingGoals = true;
                          });
                          await Future.delayed(const Duration(milliseconds: 500));
                          await _loadGoals();
                        }
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
                      _buildNavItem(Icons.layers, false, () async {
                        // Navigate and wait for result
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddSavingScreen(),
                          ),
                        );
                        // Refresh goals if deposit was successful
                        if (result == true) {
                          setState(() {
                            _goals = [];
                            _isLoadingGoals = true;
                          });
                          await Future.delayed(const Duration(milliseconds: 500));
                          await _loadGoals();
                        }
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

  List<Widget> _buildWeekDayIndicators() {
    const weekDays = ['Su', 'M', 'Tu', 'W', 'Th', 'F', 'Sa'];

    // Show all unchecked if no goals OR currently loading
    if (_goals.isEmpty || _isLoadingGoals) {
      return weekDays.map((day) => _buildDayIndicator(day, false)).toList();
    }

    final now = DateTime.now();
    final today = now.weekday % 7; // Sunday = 0

    return List.generate(7, (index) {
      // Calculate the date for this day of the week
      final dayOffset = index - today;
      final dayDate = now.add(Duration(days: dayOffset));
      final dayDateMidnight = DateTime(dayDate.year, dayDate.month, dayDate.day);

      // Check if there's a save for this day
      final hasSaved = _goals[0].dailySaves.any((save) {
        final saveDate = DateTime.fromMillisecondsSinceEpoch(save.date);
        final saveDateMidnight = DateTime(saveDate.year, saveDate.month, saveDate.day);
        return saveDateMidnight.isAtSameMomentAs(dayDateMidnight);
      });

      return _buildDayIndicator(weekDays[index], hasSaved);
    });
  }

  Widget _buildGoalItem({
    required String emoji,
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
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 32),
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
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      ' / $target',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: AppColors.grayText,
                      ),
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildDonationBanner() {
    // Default donation settings
    final donationPercentage = _goals.isNotEmpty
        ? (_goals[0].donationPercentage / 100).toStringAsFixed(0)
        : '5';
    final projectCount = 1; // Default: Octant General Pool

    return GestureDetector(
      onTap: () {
        // Navigate to Discover screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DiscoverScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'You\'re donating $donationPercentage% of yield to $projectCount public goods project${projectCount > 1 ? 's' : ''}.',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Manage',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.primary,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
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

              try {
                // Call backend API to claim faucet tokens
                final apiService = ApiService();

                // USDC token address on mainnet
                const usdcAddress = '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';

                final result = await apiService.claimFaucet(
                  tokenAddress: usdcAddress,
                );

                // Close loading dialog
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                Navigator.pop(context);

                // Show success with real transaction data
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('🎉 Success!'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('You claimed $amount USDC!'),
                        const SizedBox(height: 8),
                        Text(
                          'Wallet: ${walletService.shortenedAddress}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Transaction Hash:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          result['txHash'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (result['explorer'] != null)
                          TextButton.icon(
                            onPressed: () {
                              // TODO: Open explorer link in browser
                              print('Open: ${result['explorer']}');
                            },
                            icon: const Icon(Icons.open_in_new, size: 16),
                            label: const Text('View on Explorer'),
                          ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } catch (e) {
                // Close loading dialog
                if (!context.mounted) return;
                // ignore: use_build_context_synchronously
                Navigator.pop(context);

                // Show error
                if (!context.mounted) return;
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to claim: ${e.toString()}'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
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
