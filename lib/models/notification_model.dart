import 'package:flutter/material.dart';

enum NotificationType {
  reminder,
  newUpdate,
  saving,
  expenseRecord,
}

class NotificationModel {
  final NotificationType type;
  final String title;
  final String description;
  final String? amount;
  final String? goal;
  final DateTime dateTime;

  NotificationModel({
    required this.type,
    required this.title,
    required this.description,
    this.amount,
    this.goal,
    required this.dateTime,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.reminder:
        return Icons.notifications;
      case NotificationType.newUpdate:
        return Icons.star;
      case NotificationType.saving:
        return Icons.account_balance_wallet;
      case NotificationType.expenseRecord:
        return Icons.article;
    }
  }

  Color get iconColor {
    return const Color(0xFF00D09E);
  }
}
