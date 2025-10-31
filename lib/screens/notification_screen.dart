import 'package:flutter/material.dart';
import 'package:stacksave/constants/colors.dart';
import 'package:stacksave/models/notification_model.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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

  // Sample notification data
  final List<NotificationModel> notifications = [
    // Today
    NotificationModel(
      type: NotificationType.reminder,
      title: 'Reminder!',
      description: 'Set up your automatic savings to meet your savings goal...',
      dateTime: DateTime.now().subtract(const Duration(hours: 7, minutes: 0)),
    ),
    NotificationModel(
      type: NotificationType.newUpdate,
      title: 'New Update',
      description: 'Set up your automatic savings to meet your savings goal...',
      dateTime: DateTime.now().subtract(const Duration(hours: 7, minutes: 0)),
    ),
    // Yesterday
    NotificationModel(
      type: NotificationType.saving,
      title: 'Saving',
      description: 'A new transaction has been registered',
      amount: '\$100,00',
      goal: 'Buy Flat',
      dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 7)),
    ),
    NotificationModel(
      type: NotificationType.reminder,
      title: 'Reminder!',
      description: 'Set up your automatic savings to meet your savings goal...',
      dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 7)),
    ),
    // This Weekend
    NotificationModel(
      type: NotificationType.expenseRecord,
      title: 'Expense Record',
      description: 'We recommend that you be more attentive to your finances.',
      dateTime: DateTime.now().subtract(const Duration(days: 3, hours: 7)),
    ),
    NotificationModel(
      type: NotificationType.saving,
      title: 'Saving',
      description: 'A new transaction has been registered',
      amount: '\$70,40',
      goal: 'Buy Car',
      dateTime: DateTime.now().subtract(const Duration(days: 3, hours: 7)),
    ),
  ];

  Map<String, List<NotificationModel>> _groupNotificationsByDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    Map<String, List<NotificationModel>> grouped = {
      'Today': [],
      'Yesterday': [],
      'This Weekend': [],
    };

    for (var notification in notifications) {
      final notificationDate = DateTime(
        notification.dateTime.year,
        notification.dateTime.month,
        notification.dateTime.day,
      );

      if (notificationDate == today) {
        grouped['Today']!.add(notification);
      } else if (notificationDate == yesterday) {
        grouped['Yesterday']!.add(notification);
      } else {
        grouped['This Weekend']!.add(notification);
      }
    }

    // Remove empty sections
    grouped.removeWhere((key, value) => value.isEmpty);

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotifications = _groupNotificationsByDate();

    // Calculate header opacity and position based on scroll
    final double headerOpacity = (_scrollOffset / 100).clamp(0.0, 1.0);
    final double headerHeight = 64.0 - (_scrollOffset / 5).clamp(0.0, 24.0);
    final double borderRadius = 32.0 - (_scrollOffset / 3).clamp(0.0, 32.0);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Stack(
          children: [
            // Scrollable Content
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Header Space
                SliverToBoxAdapter(
                  child: SizedBox(height: headerHeight + 16),
                ),

                // Notification List
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(24.0),
                      itemCount: groupedNotifications.length,
                      itemBuilder: (context, index) {
                        final section = groupedNotifications.keys.elementAt(index);
                        final sectionNotifications = groupedNotifications[section]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section Header
                            Padding(
                              padding: EdgeInsets.only(
                                left: 8,
                                bottom: 16,
                                top: index == 0 ? 8 : 24,
                              ),
                              child: Text(
                                section,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grayText,
                                ),
                              ),
                            ),

                            // Notification Items
                            ...sectionNotifications.asMap().entries.map((entry) {
                              final notificationIndex = entry.key;
                              final notification = entry.value;
                              final isLast = notificationIndex == sectionNotifications.length - 1;

                              return Column(
                                children: [
                                  _buildNotificationItem(notification),
                                  if (!isLast)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Divider(
                                        color: AppColors.primary.withOpacity(0.3),
                                        thickness: 1,
                                        height: 1,
                                      ),
                                    ),
                                ],
                              );
                            }).toList(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Fixed Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppColors.primary.withOpacity(1 - headerOpacity),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white.withOpacity(1 - headerOpacity),
                          size: 24,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Notification',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(1 - headerOpacity),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40), // Balance the back button
                  ],
                ),
              ),
            ),

            // White header overlay (appears on scroll)
            if (headerOpacity > 0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  ignoring: headerOpacity < 0.5, // Allow clicks through when mostly transparent
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightBackground.withOpacity(headerOpacity),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular((1 - headerOpacity) * 32),
                        bottomRight: Radius.circular((1 - headerOpacity) * 32),
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColors.black.withOpacity(headerOpacity),
                              size: 24,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Notification',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black.withOpacity(headerOpacity),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40), // Balance the back button
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: notification.iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              notification.icon,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.black.withOpacity(0.6),
                    height: 1.4,
                  ),
                ),
                if (notification.goal != null && notification.amount != null) ...[
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${notification.goal} | ',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        TextSpan(
                          text: notification.amount,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0066FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Time
          Text(
            DateFormat('HH:mm - MMM dd').format(notification.dateTime),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
