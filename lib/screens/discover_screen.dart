import 'package:flutter/material.dart';
import 'package:stacksave/constants/colors.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  // Hardcoded Octant-approved public goods projects
  static const List<Map<String, dynamic>> APPROVED_PROJECTS = [
    {
      'name': 'Octant General Pool',
      'address': '0x00d1e028A70ee8D422bFD1132B50464E2D21FBcD',
      'description': 'The Octant General Pool distributes funds to public goods projects through community governance. Your donations support the broader ecosystem of open-source and public benefit projects.',
      'category': 'Infrastructure',
      'donationPercentage': 5,
    },
    {
      'name': 'MetaMask',
      'address': '0x1234567890123456789012345678901234567890',
      'description': 'MetaMask is a leading crypto wallet and gateway to blockchain apps. It enables users to securely store, send, and receive cryptocurrencies while maintaining full control of their private keys.',
      'category': 'Open Source',
      'donationPercentage': 5,
    },
    {
      'name': 'ENS (Ethereum Name Service)',
      'address': '0x2345678901234567890123456789012345678901',
      'description': 'ENS provides decentralized naming for wallets, websites, and more. It makes crypto addresses human-readable and enables a more user-friendly Web3 experience.',
      'category': 'Infrastructure',
      'donationPercentage': 5,
    },
    {
      'name': 'Gitcoin',
      'address': '0x3456789012345678901234567890123456789012',
      'description': 'Gitcoin is the leading platform for funding open-source software development through quadratic funding and grants. It has distributed millions to developers building public goods.',
      'category': 'Open Source',
      'donationPercentage': 5,
    },
    {
      'name': 'Protocol Guild',
      'address': '0x4567890123456789012345678901234567890123',
      'description': 'Protocol Guild supports Ethereum core protocol contributors through a collective funding mechanism. Your donations directly support those maintaining and improving Ethereum.',
      'category': 'Infrastructure',
      'donationPercentage': 5,
    },
    {
      'name': 'Radicle',
      'address': '0x5678901234567890123456789012345678901234',
      'description': 'Radicle is a decentralized code collaboration network built on open protocols. It provides a peer-to-peer alternative to centralized platforms like GitHub.',
      'category': 'Open Source',
      'donationPercentage': 5,
    },
    {
      'name': 'Giveth',
      'address': '0x6789012345678901234567890123456789012345',
      'description': 'Giveth is building the future of giving through blockchain technology. It provides a free, open-source platform for communities to fund public goods projects transparently.',
      'category': 'Climate',
      'donationPercentage': 5,
    },
    {
      'name': 'Commons Stack',
      'address': '0x7890123456789012345678901234567890123456',
      'description': 'Commons Stack designs and builds sustainable funding mechanisms for public goods. They provide tools and frameworks for communities to manage shared resources.',
      'category': 'Infrastructure',
      'donationPercentage': 5,
    },
  ];

  List<Map<String, dynamic>> _filteredProjects = [];
  final List<String> _categories = ['All', 'Infrastructure', 'Open Source', 'Climate'];
  String? _selectedCategory;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
    // Initialize with all projects
    _filteredProjects = List.from(APPROVED_PROJECTS);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterProjects() {
    setState(() {
      _filteredProjects = APPROVED_PROJECTS.where((project) {
        final matchesCategory = _selectedCategory == null ||
                                _selectedCategory == 'All' ||
                                project['category'] == _selectedCategory;

        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
                             project['name'].toLowerCase().contains(searchQuery) ||
                             project['description'].toLowerCase().contains(searchQuery);

        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const double maxHeaderHeight = 160.0;
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Discover',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Support public goods projects',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
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
                          // Search Bar
                          TextField(
                            controller: _searchController,
                            onChanged: (value) => _filterProjects(),
                            decoration: InputDecoration(
                              hintText: 'Search projects...',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: AppColors.grayText,
                              ),
                              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Category Filter
                          if (_categories.isNotEmpty)
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _categories.length,
                                itemBuilder: (context, index) {
                                  final category = _categories[index];
                                  final isSelected = _selectedCategory == category ||
                                                    (category == 'All' && _selectedCategory == null);

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = category == 'All' ? null : category;
                                        });
                                        _filterProjects();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primary
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primary
                                                : Colors.grey[300]!,
                                          ),
                                        ),
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Projects Grid
                          if (_filteredProjects.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: AppColors.grayText,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No projects found',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        color: AppColors.grayText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ..._filteredProjects.map((project) =>
                              _buildProjectCard(project)
                            ).toList(),

                          const SizedBox(height: 80),
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

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  project['category'] ?? 'General',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              // Supporters Count
              Row(
                children: [
                  const Icon(Icons.favorite, size: 16, color: Colors.red),
                  const SizedBox(width: 4),
                  Text(
                    '${project['supportersCount'] ?? 0}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grayText,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Project Name
          Text(
            project['name'] ?? 'Unknown Project',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            project['description'] ?? '',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: AppColors.grayText,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                _showProjectDetails(project);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Learn More',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProjectDetails(Map<String, dynamic> project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 24),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        project['category'] ?? 'General',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Name
                    Text(
                      project['name'] ?? 'Unknown Project',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Description
                    Text(
                      project['description'] ?? '',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: AppColors.grayText,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Supporters',
                            '${project['supportersCount'] ?? 0}',
                            Icons.favorite,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Total Donated',
                            '\$${(double.parse(project['totalDonated'] ?? '0') / 1000).toStringAsFixed(1)}k',
                            Icons.attach_money,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Address
                    const Text(
                      'Contract Address',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grayText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        project['address'] ?? '',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: AppColors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(16),
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
                              'Set your global donation preferences in Settings to support projects like this with your yield earnings.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: AppColors.primary,
                                height: 1.4,
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
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              color: AppColors.grayText,
            ),
          ),
        ],
      ),
    );
  }
}
