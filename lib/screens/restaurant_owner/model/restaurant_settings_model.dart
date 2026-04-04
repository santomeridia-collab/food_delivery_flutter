import 'package:flutter/material.dart';

class RestaurantSettings {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String description;
  final String logoUrl;
  final String coverImageUrl;
  final String cuisine;
  final double rating;
  final int reviewCount;
  final double minOrder;
  final double deliveryFee;
  final bool isOpen;
  final List<WorkingHours> workingHours;
  final List<String> paymentMethods;
  final String? instagramHandle;
  final String? facebookHandle;

  RestaurantSettings({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.description,
    required this.logoUrl,
    required this.coverImageUrl,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.minOrder,
    required this.deliveryFee,
    required this.isOpen,
    required this.workingHours,
    required this.paymentMethods,
    this.instagramHandle,
    this.facebookHandle,
  });
}

class WorkingHours {
  final String day;
  bool isClosed; // Changed from final
  TimeOfDay? openTime; // Changed from final
  TimeOfDay? closeTime; // Changed from final

  WorkingHours({
    required this.day,
    this.isClosed = false,
    this.openTime,
    this.closeTime,
  });

  String get formattedHours {
    if (isClosed) return 'Closed';
    if (openTime == null || closeTime == null) return 'Not set';
    return '${_formatTime(openTime!)} - ${_formatTime(closeTime!)}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Helper method to create a copy with updated values
  WorkingHours copyWith({
    String? day,
    bool? isClosed,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
  }) {
    return WorkingHours(
      day: day ?? this.day,
      isClosed: isClosed ?? this.isClosed,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }
}

class EarningsSummary {
  final double todayEarnings;
  final double thisWeekEarnings;
  final double thisMonthEarnings;
  final double totalEarnings;
  final int totalOrders;
  final double averageOrderValue;
  final int pendingPayouts;
  final double availableForPayout;

  EarningsSummary({
    required this.todayEarnings,
    required this.thisWeekEarnings,
    required this.thisMonthEarnings,
    required this.totalEarnings,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.pendingPayouts,
    required this.availableForPayout,
  });
}

class Payout {
  final String id;
  final double amount;
  final DateTime date;
  final String status; // pending, processing, completed, failed
  final String? transactionId;
  final String paymentMethod;

  Payout({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
    this.transactionId,
    required this.paymentMethod,
  });

  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';
  String get formattedDate => '${date.day}/${date.month}/${date.year}';
}
