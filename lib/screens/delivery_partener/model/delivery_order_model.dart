import 'package:google_maps_flutter/google_maps_flutter.dart';

enum DeliveryOrderStatus {
  newOrder, // Just received
  accepted, // Accepted by delivery partner
  pickedUp, // Picked up from restaurant
  onTheWay, // En route to customer
  delivered, // Successfully delivered
  rejected, // Rejected by delivery partner
}

class DeliveryOrder {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String restaurantAddress;
  final LatLng restaurantLocation; // Now using Google Maps LatLng
  final String customerId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final LatLng customerLocation; // Now using Google Maps LatLng
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  DeliveryOrderStatus status;
  final double distance; // in km
  final int estimatedTime; // in minutes

  DeliveryOrder({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.restaurantLocation,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.customerLocation,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
    this.acceptedAt,
    this.pickedUpAt,
    this.deliveredAt,
    required this.status,
    required this.distance,
    required this.estimatedTime,
  });

  String get formattedTotal => '\$${total.toStringAsFixed(2)}';

  String get orderNumber {
    if (id.length >= 8) {
      return 'DEL${id.substring(0, 8)}';
    } else {
      return 'DEL${id.padLeft(8, '0')}';
    }
  }

  String get formattedDistance => '${distance.toStringAsFixed(1)} km';

  bool get isNew => status == DeliveryOrderStatus.newOrder;
  bool get isActive =>
      status == DeliveryOrderStatus.accepted ||
      status == DeliveryOrderStatus.pickedUp ||
      status == DeliveryOrderStatus.onTheWay;
}

class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String? size;
  final List<String>? addons;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.size,
    this.addons,
  });

  double get total => price * quantity;
}

// Remove the custom LatLng class - it's now imported from google_maps_flutter

class DeliveryStats {
  final int todayDeliveries;
  final double todayEarnings;
  final int totalDeliveries;
  final double totalEarnings;
  final double rating;
  final double onlineHours;
  final double acceptanceRate;

  DeliveryStats({
    required this.todayDeliveries,
    required this.todayEarnings,
    required this.totalDeliveries,
    required this.totalEarnings,
    required this.rating,
    required this.onlineHours,
    required this.acceptanceRate,
  });
}
