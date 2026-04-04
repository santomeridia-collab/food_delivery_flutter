import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/providers/notification_provider.dart';
import 'package:food_delivery/screens/customer/widgets/notification_card.dart';
import 'package:provider/provider.dart';
import 'models/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final notifications = notificationProvider.notifications;
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () {
                notificationProvider.markAllAsRead();
              },
              child: const Text('Mark all as read'),
            ),
        ],
      ),
      body:
          notifications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return NotificationCard(
                    notification: notification,
                    onTap: () {
                      notificationProvider.markAsRead(notification.id);
                      // Handle navigation based on notification type
                      _handleNotificationTap(context, notification);
                    },
                  );
                },
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'We\'ll notify you when something arrives',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    AppNotification notification,
  ) {
    switch (notification.type) {
      case NotificationType.order:
        if (notification.orderId != null) {
          // Navigate to order details
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('View order ${notification.orderId}')),
          );
        }
        break;
      case NotificationType.payment:
        // Navigate to wallet
        Navigator.pushNamed(context, '/wallet');
        break;
      case NotificationType.offer:
      case NotificationType.promo:
        // Navigate to offers
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('View offers')));
        break;
      default:
        break;
    }
  }
}
