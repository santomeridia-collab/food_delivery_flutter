import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => _notifications;

  NotificationProvider() {
    _loadSampleNotifications();
  }

  void _loadSampleNotifications() {
    _notifications = [
      AppNotification(
        id: '1',
        title: 'Order Delivered!',
        message: 'Your order #ORD12345678 has been delivered successfully.',
        type: NotificationType.order,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
        orderId: 'ORD12345678',
      ),
      AppNotification(
        id: '2',
        title: 'Special Offer!',
        message: 'Get 20% off on your next order above \$20. Use code: SAVE20',
        type: NotificationType.offer,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: false,
      ),
      AppNotification(
        id: '3',
        title: 'Payment Successful',
        message: 'Your payment of \$25.99 has been processed successfully.',
        type: NotificationType.payment,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      AppNotification(
        id: '4',
        title: 'Welcome to FoodieDash!',
        message:
            'Thank you for joining us. Enjoy your first order with free delivery!',
        type: NotificationType.system,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];
  }

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = AppNotification(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        type: _notifications[index].type,
        createdAt: _notifications[index].createdAt,
        isRead: true,
        orderId: _notifications[index].orderId,
        imageUrl: _notifications[index].imageUrl,
      );
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = AppNotification(
        id: _notifications[i].id,
        title: _notifications[i].title,
        message: _notifications[i].message,
        type: _notifications[i].type,
        createdAt: _notifications[i].createdAt,
        isRead: true,
        orderId: _notifications[i].orderId,
        imageUrl: _notifications[i].imageUrl,
      );
    }
    notifyListeners();
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}
