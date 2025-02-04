import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:save/models/memo.dart';
import 'package:save/providers/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  static String ID = 'notifications';

  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Load notifications when screen is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          if (notificationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notificationProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${notificationProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () => notificationProvider.loadNotifications(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final notifications = notificationProvider.notifications;

          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                'No notifications set',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationItem(notification: notification);
            },
          );
        },
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final MemoNotification notification;

  const NotificationItem({
    super.key,
    required this.notification,
  });

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y • h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(notification.memo.title),
        subtitle: Text(_formatDateTime(notification.notificationTime)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check_circle_outline),
              onPressed: () {
                Provider.of<NotificationProvider>(context, listen: false)
                    .completeNotification(notification.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                Provider.of<NotificationProvider>(context, listen: false)
                    .deleteNotification(notification.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MemoNotification {
  final int id;
  final Memo memo;
  final DateTime notificationTime;
  final bool isCompleted;

  MemoNotification({
    required this.id,
    required this.memo,
    required this.notificationTime,
    this.isCompleted = false,
  });

  // Create from map (database)
  factory MemoNotification.fromMap(Map<String, dynamic> map) {
    return MemoNotification(
      id: map['id'] as int,
      memo: Memo.fromMap(map['memo'] as Map<String, dynamic>),
      notificationTime: DateTime.parse(map['notification_time'] as String),
      isCompleted: (map['is_completed'] as int) == 1,
    );
  }

  // Convert to map (database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memo_id': memo.id,
      'notification_time': notificationTime.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
    };
  }
}
