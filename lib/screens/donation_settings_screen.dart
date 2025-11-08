import 'package:flutter/material.dart';
import 'package:stacksave/constants/colors.dart';

class DonationSettingsScreen extends StatefulWidget {
  const DonationSettingsScreen({super.key});

  @override
  State<DonationSettingsScreen> createState() => _DonationSettingsScreenState();
}

class _DonationSettingsScreenState extends State<DonationSettingsScreen> {
  final ScrollController _scrollController = ScrollController();

  // Default donation percentage (in basis points: 500 = 5%)
  int _donationPercentage = 500;
  double _scrollOffset = 0.0;

  // Hardcoded Octant-approved public goods projects (same as Discover screen)
  static const List<Map<String, dynamic>> APPROVED_PROJECTS = [
    {
      'name': 'Octant General Pool',
      'address': '0x00d1e028A70ee8D422bFD1132B50464E2D21FBcD',
      'description': 'The Octant General Pool distributes funds to public goods projects through community governance.',
      'category': 'Infrastructure',
    },
    {
      'name': 'MetaMask',
      'address': '0x1234567890123456789012345678901234567890',
      'description': 'MetaMask is a leading crypto wallet and gateway to blockchain apps.',
      'category': 'Open Source',
    },
    {
      'name': 'ENS (Ethereum Name Service)',
      'address': '0x2345678901234567890123456789012345678901',
      'description': 'ENS provides decentralized naming for wallets, websites, and more.',
      'category': 'Infrastructure',
    },
    {
      'name': 'Gitcoin',
      'address': '0x3456789012345678901234567890123456789012',
      'description': 'Gitcoin is the leading platform for funding open-source software development.',
      'category': 'Open Source',
    },
    {
      'name': 'Protocol Guild',
      'address': '0x4567890123456789012345678901234567890123',
      'description': 'Protocol Guild supports Ethereum core protocol contributors.',
      'category': 'Infrastructure',
    },
    {
      'name': 'Radicle',
      'address': '0x5678901234567890123456789012345678901234',
      'description': 'Radicle is a decentralized code collaboration network.',
      'category': 'Open Source',
    },
    {
      'name': 'Giveth',
      'address': '0x6789012345678901234567890123456789012345',
      'description': 'Giveth is building the future of giving through blockchain technology.',
      'category': 'Climate',
    },
    {
      'name': 'Commons Stack',
      'address': '0x7890123456789012345678901234567890123456',
      'description': 'Commons Stack designs and builds sustainable funding mechanisms for public goods.',
      'category': 'Infrastructure',
    },
  ];

  // Selected projects (addresses)
  final Set<String> _selectedProjects = {
    '0x00d1e028A70ee8D422bFD1132B50464E2D21FBcD', // Default: Octant General Pool
  };

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

  void _saveSettings() {
    // TODO: Save to local storage or global state
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Donation settings saved! ${_donationPercentage / 100}% of yield will support ${_selectedProjects.length} project(s)',
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const double maxHeaderHeight = 120.0;
    final double headerOpacity = (1 - (_scrollOffset / 100)).clamp(0.0, 1.0);
    final double headerTranslateY = -(_scrollOffset * 0.5).clamp(0.0, maxHeaderHeight);
    final double borderRadius = (32.0 - (_scrollOffset / 8)).clamp(16.0, 32.0);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            // Header
            Positioned(
              top: headerTranslateY,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: headerOpacity,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Donation Settings',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Configure your impact',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content
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
                      minHeight: MediaQuery.of(context).size.height - maxHeaderHeight,
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
                          // Info Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
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
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'These settings apply to yield earnings from all your savings goals.',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: AppColors.primary,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Donation Percentage Section
                          const Text(
                            'Donation Percentage',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Choose what percentage of your yield to donate',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: AppColors.grayText,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Percentage Slider Card
                          Container(
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
                            child: Column(
                              children: [
                                // Current percentage display
                                Text(
                                  '${_donationPercentage / 100}%',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'of your yield earnings',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: AppColors.grayText,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Slider
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: AppColors.primary,
                                    inactiveTrackColor: AppColors.primary.withOpacity(0.2),
                                    thumbColor: AppColors.primary,
                                    overlayColor: AppColors.primary.withOpacity(0.2),
                                    trackHeight: 8,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 14,
                                    ),
                                  ),
                                  child: Slider(
                                    value: _donationPercentage.toDouble(),
                                    min: 0,
                                    max: 10000, // 100% in basis points
                                    divisions: 100,
                                    label: '${_donationPercentage / 100}%',
                                    onChanged: (value) {
                                      setState(() {
                                        _donationPercentage = value.toInt();
                                      });
                                    },
                                  ),
                                ),

                                // Min/Max labels
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '0%',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: AppColors.grayText,
                                      ),
                                    ),
                                    Text(
                                      '100%',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: AppColors.grayText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Select Projects Section
                          const Text(
                            'Select Projects to Support',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your donations will be split equally among selected projects',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: AppColors.grayText,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Projects List
                          ...APPROVED_PROJECTS.map((project) {
                            final isSelected = _selectedProjects.contains(project['address']);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedProjects.remove(project['address']);
                                    } else {
                                      _selectedProjects.add(project['address'] as String);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.withOpacity(0.1)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.grey[300]!,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      if (!isSelected)
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Checkbox
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primary
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primary
                                                : Colors.grey[400]!,
                                            width: 2,
                                          ),
                                        ),
                                        child: isSelected
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(width: 16),

                                      // Project Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              project['name'] as String,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: isSelected
                                                    ? AppColors.primary
                                                    : AppColors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              project['description'] as String,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: AppColors.grayText,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Category Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          project['category'] as String,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),

                          const SizedBox(height: 32),

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _selectedProjects.isEmpty ? null : _saveSettings,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                                disabledBackgroundColor: Colors.grey[300],
                              ),
                              child: const Text(
                                'Save Settings',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 100),
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
}
