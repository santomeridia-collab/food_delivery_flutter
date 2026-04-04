import 'package:flutter/material.dart';

enum NotificationType { order, payment, offer, promo, system }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String? orderId;
  final String? imageUrl;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.orderId,
    this.imageUrl,
  });

  IconData get icon {
    switch (type) {
      case NotificationType.order:
        return Icons.shopping_bag;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.offer:
        return Icons.local_offer;
      case NotificationType.promo:
        return Icons.card_giftcard;
      case NotificationType.system:
        return Icons.notifications;
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.order:
        return Colors.blue;
      case NotificationType.payment:
        return Colors.green;
      case NotificationType.offer:
        return Colors.orange;
      case NotificationType.promo:
        return Colors.purple;
      case NotificationType.system:
        return Colors.grey;
    }
  }
}
