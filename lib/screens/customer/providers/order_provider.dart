import 'package:flutter/material.dart';
import '../models/address_model.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder({
    required double total,
    required Address address,
    required List<CartItem> items,
    required String paymentMethod,
    DateTime? scheduledDate,
    required String restaurantId,
    required String restaurantName,
    required String restaurantImage,
  }) {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      total: total,
      address: address,
      items: items,
      paymentMethod: paymentMethod,
      status: OrderStatus.confirmed,
      createdAt: DateTime.now(),
      scheduledDate: scheduledDate,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      restaurantImage: restaurantImage,
      deliveryPartnerName: 'Raj Kumar',
      deliveryPartnerPhone: '+91 98765 43210',
      deliveryPartnerImage: '',
    );
    _orders.insert(0, order);
    notifyListeners();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index].status = status;
      if (status == OrderStatus.delivered) {
        _orders[index].deliveredAt = DateTime.now();
      }
      notifyListeners();
    }
  }

  void updateCancellationInfo(
    String orderId,
    String reason,
    double refundAmount,
  ) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index].cancellationReason = reason;
      _orders[index].refundAmount = refundAmount;
      notifyListeners();
    }
  }
}
