# NotificationModel API

Complete reference for the NotificationModel provider and notification management.

## NotificationModel Class

Provider for managing in-app notifications.

**Location**: `lib/models/notification_model.dart`

**Extends**: `ChangeNotifier`

---

## Properties

### notifications

List of all notifications.

```dart
List<AppNotification> get notifications
```

**Returns**: List of notifications, newest first

---

### unreadCount

Number of unread notifications.

```dart
int get unreadCount
```

**Returns**: Count of unread notifications

---

### hasUnread

Whether there are any unread notifications.

```dart
bool get hasUnread => unreadCount > 0
```

---

## Methods

### addNotification()

Add a new notification.

```dart
void addNotification(AppNotification notification)
```

**Parameters**:
- `notification` - Notification to add

**Example**:
```dart
final notificationModel = Provider.of<NotificationModel>(context, listen: false);

notificationModel.addNotification(
  AppNotification(
    id: Uuid().v4(),
    title: 'Milestone Reached!',
    message: 'You\'ve saved 50% of your goal',
    type: NotificationType.milestone,
    timestamp: DateTime.now(),
  ),
);
```

---

### markAsRead()

Mark a notification as read.

```dart
void markAsRead(String notificationId)
```

**Parameters**:
- `notificationId` - ID of notification to mark as read

**Example**:
```dart
notificationModel.markAsRead('notif-123');
```

---

### markAllAsRead()

Mark all notifications as read.

```dart
void markAllAsRead()
```

**Example**:
```dart
notificationModel.markAllAsRead();
```

---

### deleteNotification()

Remove a specific notification.

```dart
void deleteNotification(String notificationId)
```

**Parameters**:
- `notificationId` - ID of notification to delete

**Example**:
```dart
notificationModel.deleteNotification('notif-123');
```

---

### clearAll()

Remove all notifications.

```dart
void clearAll()
```

**Example**:
```dart
notificationModel.clearAll();
```

---

### getNotificationById()

Retrieve a specific notification.

```dart
AppNotification? getNotificationById(String id)
```

**Parameters**:
- `id` - Notification ID

**Returns**: Notification if found, `null` otherwise

**Example**:
```dart
final notif = notificationModel.getNotificationById('notif-123');
if (notif != null) {
  print(notif.title);
}
```

---

### getUnreadNotifications()

Get only unread notifications.

```dart
List<AppNotification> getUnreadNotifications()
```

**Returns**: List of unread notifications

**Example**:
```dart
final unread = notificationModel.getUnreadNotifications();
print('${unread.length} unread notifications');
```

---

### getNotificationsByType()

Filter notifications by type.

```dart
List<AppNotification> getNotificationsByType(NotificationType type)
```

**Parameters**:
- `type` - Notification type to filter

**Returns**: List of matching notifications

**Example**:
```dart
final milestones = notificationModel.getNotificationsByType(
  NotificationType.milestone,
);
```

---

## Helper Methods

### createMilestoneNotification()

Create a milestone notification.

```dart
static AppNotification createMilestoneNotification({
  required String goalName,
  required int percentage,
}) {
  return AppNotification(
    id: Uuid().v4(),
    title: 'Milestone Reached! 🎉',
    message: 'You\'ve saved $percentage% of your $goalName goal',
    type: NotificationType.milestone,
    timestamp: DateTime.now(),
  );
}
```

**Example**:
```dart
final notif = NotificationModel.createMilestoneNotification(
  goalName: 'Emergency Fund',
  percentage: 50,
);

notificationModel.addNotification(notif);
```

---

### createDeadlineNotification()

Create a deadline reminder notification.

```dart
static AppNotification createDeadlineNotification({
  required String goalName,
  required int daysRemaining,
}) {
  return AppNotification(
    id: Uuid().v4(),
    title: 'Deadline Approaching ⏰',
    message: '$goalName deadline in $daysRemaining days',
    type: NotificationType.deadline,
    timestamp: DateTime.now(),
  );
}
```

---

### createTransactionNotification()

Create a transaction confirmation notification.

```dart
static AppNotification createTransactionNotification({
  required String type, // 'deposit' or 'withdrawal'
  required double amount,
  required String goalName,
  required bool success,
}) {
  return AppNotification(
    id: Uuid().v4(),
    title: success ? '${type.capitalize()} Successful ✅' : '${type.capitalize()} Failed ❌',
    message: success
        ? '\$$amount ${type}ed to $goalName'
        : '\$$amount ${type} to $goalName failed',
    type: NotificationType.transaction,
    timestamp: DateTime.now(),
  );
}
```

---

## Usage Examples

### Setup Provider

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationModel()),
        // ... other providers
      ],
      child: MyApp(),
    ),
  );
}
```

---

### Listening to Notifications

```dart
class NotificationBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationModel>(
      builder: (context, notificationModel, child) {
        return Badge(
          label: Text('${notificationModel.unreadCount}'),
          isLabelVisible: notificationModel.hasUnread,
          child: IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationsScreen(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
```

---

### Displaying Notifications

```dart
class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationModel = Provider.of<NotificationModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          if (notificationModel.hasUnread)
            TextButton(
              onPressed: () {
                notificationModel.markAllAsRead();
              },
              child: Text('Mark All Read'),
            ),
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              notificationModel.clearAll();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notificationModel.notifications.length,
        itemBuilder: (context, index) {
          final notification = notificationModel.notifications[index];

          return NotificationTile(
            notification: notification,
            onTap: () {
              notificationModel.markAsRead(notification.id);
              // Handle notification tap
            },
            onDismiss: () {
              notificationModel.deleteNotification(notification.id);
            },
          );
        },
      ),
    );
  }
}
```

---

### Notification Tile Widget

```dart
class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      onDismissed: (_) => onDismiss(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(notification.type.icon),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Text(notification.message),
        trailing: Text(
          _formatTimestamp(notification.timestamp),
          style: TextStyle(fontSize: 12),
        ),
        tileColor: notification.isRead ? null : Colors.blue.shade50,
        onTap: onTap,
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${timestamp.month}/${timestamp.day}';
  }
}
```

---

### Creating Notifications from Events

```dart
class GoalService {
  final NotificationModel notificationModel;

  Future<void> depositToGoal(String goalId, double amount) async {
    try {
      // Execute deposit
      await blockchain.deposit(goalId: goalId, amount: amount);

      // Success notification
      notificationModel.addNotification(
        NotificationModel.createTransactionNotification(
          type: 'deposit',
          amount: amount,
          goalName: goal.name,
          success: true,
        ),
      );

      // Check for milestone
      if (_isMilestone(goal)) {
        notificationModel.addNotification(
          NotificationModel.createMilestoneNotification(
            goalName: goal.name,
            percentage: (goal.progress * 100).round(),
          ),
        );
      }
    } catch (e) {
      // Failure notification
      notificationModel.addNotification(
        NotificationModel.createTransactionNotification(
          type: 'deposit',
          amount: amount,
          goalName: goal.name,
          success: false,
        ),
      );
    }
  }

  bool _isMilestone(SavingsGoal goal) {
    final percentage = goal.percentageComplete;
    return percentage == 25 ||
           percentage == 50 ||
           percentage == 75 ||
           percentage == 100;
  }
}
```

---

### Scheduled Notifications

```dart
class NotificationScheduler {
  final NotificationModel notificationModel;

  void scheduleDeadlineReminders(List<SavingsGoal> goals) {
    for (final goal in goals) {
      if (goal.deadline == null) continue;

      final daysRemaining = goal.daysRemaining;

      if (daysRemaining == 7 || daysRemaining == 1) {
        notificationModel.addNotification(
          NotificationModel.createDeadlineNotification(
            goalName: goal.name,
            daysRemaining: daysRemaining!,
          ),
        );
      }
    }
  }
}
```

---

## Persistence

### Save to Storage

```dart
class NotificationModel extends ChangeNotifier {
  final StorageService storage;

  Future<void> _saveToStorage() async {
    final json = notifications.map((n) => n.toJson()).toList();
    await storage.saveNotifications(json);
  }

  @override
  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    _saveToStorage();
    notifyListeners();
  }

  Future<void> loadFromStorage() async {
    final json = await storage.getNotifications();
    _notifications = json
        .map((j) => AppNotification.fromJson(j))
        .toList();
    notifyListeners();
  }
}
```

---

## Testing

```dart
void main() {
  group('NotificationModel', () {
    late NotificationModel notificationModel;

    setUp(() {
      notificationModel = NotificationModel();
    });

    test('adds notification', () {
      final notification = AppNotification(
        id: '1',
        title: 'Test',
        message: 'Test message',
        type: NotificationType.info,
        timestamp: DateTime.now(),
      );

      notificationModel.addNotification(notification);

      expect(notificationModel.notifications.length, 1);
      expect(notificationModel.unreadCount, 1);
    });

    test('marks as read', () {
      final notification = AppNotification(
        id: '1',
        title: 'Test',
        message: 'Test',
        type: NotificationType.info,
        timestamp: DateTime.now(),
      );

      notificationModel.addNotification(notification);
      notificationModel.markAsRead('1');

      expect(notificationModel.unreadCount, 0);
    });

    test('filters by type', () {
      notificationModel.addNotification(
        AppNotification(
          id: '1',
          title: 'Milestone',
          message: 'Test',
          type: NotificationType.milestone,
          timestamp: DateTime.now(),
        ),
      );

      notificationModel.addNotification(
        AppNotification(
          id: '2',
          title: 'Transaction',
          message: 'Test',
          type: NotificationType.transaction,
          timestamp: DateTime.now(),
        ),
      );

      final milestones = notificationModel.getNotificationsByType(
        NotificationType.milestone,
      );

      expect(milestones.length, 1);
      expect(milestones[0].id, '1');
    });
  });
}
```

---

## Next Steps

- [Services API](services.md) - Related services
- [Models API](models.md) - Other models
- [Notifications Feature](../features/notifications.md) - User guide

---

Need help? Visit [FAQ](../resources/faq.md) or [Troubleshooting](../resources/troubleshooting.md).
