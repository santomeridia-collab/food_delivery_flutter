enum RestaurantOrderStatus {
  pending, // Incoming - waiting for acceptance
  accepted, // Order accepted
  preparing, // Being prepared
  ready, // Ready for pickup
  pickedUp, // Picked up by delivery
  delivered, // Delivered
  rejected, // Rejected by restaurant
  cancelled, // Cancelled by customer
}

class RestaurantOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? readyAt;
  final DateTime? completedAt;
  final RestaurantOrderStatus status;
  final String? rejectionReason;
  final int preparationTime; // in minutes

  RestaurantOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
    this.acceptedAt,
    this.readyAt,
    this.completedAt,
    required this.status,
    this.rejectionReason,
    this.preparationTime = 25,
  });

  String get formattedTotal => '\$${total.toStringAsFixed(2)}';
  String get orderNumber =>
      'ORD${id.substring(0, 3)}${id.substring(id.length - 3)}';

  bool get isIncoming => status == RestaurantOrderStatus.pending;
  bool get isActive =>
      status == RestaurantOrderStatus.accepted ||
      status == RestaurantOrderStatus.preparing ||
      status == RestaurantOrderStatus.ready;
  bool get isCompleted =>
      status == RestaurantOrderStatus.delivered ||
      status == RestaurantOrderStatus.rejected ||
      status == RestaurantOrderStatus.cancelled;
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
