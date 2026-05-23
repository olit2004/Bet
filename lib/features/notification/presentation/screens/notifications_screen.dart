import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/notification_provider.dart';
import '../../data/models/notification_model.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(notificationProvider.notifier).fetchNotifications();
            },
          ),
        ],
      ),
      body: notificationState.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return const Center(
              child: Text('No notifications yet.'),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _NotificationTile(notification: notification);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Failed to load notifications: $error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(notificationProvider.notifier).fetchNotifications(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  final NotificationModel notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUnread = !notification.isRead;

    return ListTile(
      tileColor: isUnread ? Colors.blue.withOpacity(0.1) : null,
      leading: Icon(
        _getIconForType(notification.type),
        color: isUnread ? Colors.blue : Colors.grey,
      ),
      title: Text(
        notification.message,
        style: TextStyle(
          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        DateFormat.yMMMd().add_jm().format(notification.createdAt),
        style: const TextStyle(fontSize: 12),
      ),
      onTap: () {
        if (isUnread) {
          ref.read(notificationProvider.notifier).markAsRead(notification.id);
        }
      },
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'NEW_BID':
        return Icons.gavel;
      case 'NEW_PROPOSAL':
        return Icons.local_offer;
      case 'BID_ACCEPTED':
      case 'PROPOSAL_ACCEPTED':
        return Icons.check_circle;
      case 'PROPOSAL_REJECTED':
        return Icons.cancel;
      default:
        return Icons.notifications;
    }
  }
}
