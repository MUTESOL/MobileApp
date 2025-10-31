import 'package:flutter/material.dart';
import 'package:stacksave/constants/colors.dart';
import 'package:stacksave/screens/home_screen.dart';
import 'package:stacksave/screens/portfolio_screen.dart';
import 'package:stacksave/screens/add_saving_screen.dart';
import 'package:stacksave/screens/withdraw_screen.dart';
import 'package:stacksave/screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    const HomeScreen(showNavBar: false),
    const PortfolioScreen(showNavBar: false),
    const AddSavingScreen(showNavBar: false, fromNavBar: true),
    const WithdrawScreen(showNavBar: false),
    const ProfileScreen(showNavBar: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: const BoxDecoration(
          color: Color(0xFFD4F5E9),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 0),
            _buildNavItem(Icons.pie_chart_outline, 1),
            _buildNavItem(Icons.layers, 2),
            _buildNavItem(Icons.swap_horiz, 3),
            _buildNavItem(Icons.person_outline, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
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
}
