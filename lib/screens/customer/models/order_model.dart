import 'cart_model.dart';
import 'address_model.dart';

enum OrderStatus {
  confirmed,
  preparing,
  ready,
  pickedUp,
  onTheWay,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final double total;
  final Address address;
  final List<CartItem> items;
  final String paymentMethod;
  OrderStatus status;
  final DateTime createdAt;
  final DateTime? scheduledDate;
  DateTime? deliveredAt;
  String? cancellationReason;
  double? refundAmount;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImage;
  final String deliveryPartnerName;
  final String deliveryPartnerPhone;
  final String deliveryPartnerImage;

  Order({
    required this.id,
    required this.total,
    required this.address,
    required this.items,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.scheduledDate,
    this.deliveredAt,
    this.cancellationReason,
    this.refundAmount,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.deliveryPartnerName,
    required this.deliveryPartnerPhone,
    required this.deliveryPartnerImage,
  });

  String get formattedTotal => '\$${total.toStringAsFixed(2)}';
  String get orderNumber => 'ORD${id.substring(0, 8)}';

  // Add subtotal getter
  double get subtotal {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)}';

  bool get isActive =>
      status != OrderStatus.delivered && status != OrderStatus.cancelled;
  bool get canCancel =>
      status == OrderStatus.confirmed || status == OrderStatus.preparing;

  Order copyWith({
    String? id,
    double? total,
    Address? address,
    List<CartItem>? items,
    String? paymentMethod,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? scheduledDate,
    DateTime? deliveredAt,
    String? cancellationReason,
    double? refundAmount,
    String? restaurantId,
    String? restaurantName,
    String? restaurantImage,
    String? deliveryPartnerName,
    String? deliveryPartnerPhone,
    String? deliveryPartnerImage,
  }) {
    return Order(
      id: id ?? this.id,
      total: total ?? this.total,
      address: address ?? this.address,
      items: items ?? this.items,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      refundAmount: refundAmount ?? this.refundAmount,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantImage: restaurantImage ?? this.restaurantImage,
      deliveryPartnerName: deliveryPartnerName ?? this.deliveryPartnerName,
      deliveryPartnerPhone: deliveryPartnerPhone ?? this.deliveryPartnerPhone,
      deliveryPartnerImage: deliveryPartnerImage ?? this.deliveryPartnerImage,
    );
  }
}

class OrderStatusUpdate {
  final OrderStatus status;
  final DateTime timestamp;
  final String message;
  final String? location;

  OrderStatusUpdate({
    required this.status,
    required this.timestamp,
    required this.message,
    this.location,
  });
}
