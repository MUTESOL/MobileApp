import 'package:flutter/material.dart';
import 'package:stacksave/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  final bool showNavBar;

  const ProfileScreen({super.key, this.showNavBar = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double headerOpacity = (_scrollOffset / 100).clamp(0.0, 1.0);
    final double borderRadius = (32.0 - (_scrollOffset / 8)).clamp(16.0, 32.0);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Green background
            Container(
              color: AppColors.primary,
            ),
            // White card that pulls up
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    height: 200,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Profile photo
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E3),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        // User name
                        const Text(
                          'John Smith',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Menu items
                        _buildMenuItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          onTap: () {
                            // Navigate to edit profile
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.shield_outlined,
                          title: 'History',
                          onTap: () {
                            // Navigate to history
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.settings_outlined,
                          title: 'Setting',
                          onTap: () {
                            // Navigate to settings
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help',
                          onTap: () {
                            // Navigate to help
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.logout,
                          title: 'Logout',
                          onTap: () {
                            _showLogoutDialog();
                          },
                        ),
                        const SizedBox(height: 100), // Space for bottom navbar
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // White header overlay
            IgnorePointer(
              ignoring: headerOpacity < 0.5,
              child: Opacity(
                opacity: headerOpacity,
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E3),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(borderRadius),
                      bottomRight: Radius.circular(borderRadius),
                    ),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF5B9CFF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout logic
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
