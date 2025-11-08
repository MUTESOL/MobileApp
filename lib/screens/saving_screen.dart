import 'package:flutter/material.dart';
import 'package:stacksave/constants/colors.dart';
import 'package:stacksave/screens/add_saving_screen.dart';
import 'package:stacksave/screens/withdraw_screen.dart';

class SavingScreen extends StatefulWidget {
  const SavingScreen({super.key});

  @override
  State<SavingScreen> createState() => _SavingScreenState();
}

class _SavingScreenState extends State<SavingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Header with tabs
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Title
                  const Text(
                    'Savings',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tab Bar
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Colors.white,
                      labelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: const [
                        Tab(text: 'Add Saving'),
                        Tab(text: 'Withdraw'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  AddSavingScreen(showNavBar: false),
                  WithdrawScreen(showNavBar: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
