import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _cartItems = {};
  String? _currentRestaurantId;

  Map<String, CartItem> get cartItems => _cartItems;

  int get totalQuantity {
    return _cartItems.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalAmount {
    return _cartItems.values.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  String? get currentRestaurantId => _currentRestaurantId;

  bool get hasItems => _cartItems.isNotEmpty;

  void addItem(
    String dishId,
    String dishName,
    double price,
    String restaurantId,
    String restaurantName, { // Add restaurantName parameter
    int quantity = 1,
    String? size,
    List<String>? addons,
    String? customization,
    String? imageUrl,
  }) {
    // Clear cart if adding from different restaurant
    if (_currentRestaurantId != null && _currentRestaurantId != restaurantId) {
      _cartItems.clear();
      _currentRestaurantId = null;
    }

    _currentRestaurantId = restaurantId;

    // Create a unique key that includes customization
    final itemKey = _generateItemKey(dishId, size, addons, customization);

    if (_cartItems.containsKey(itemKey)) {
      _cartItems[itemKey]!.quantity += quantity;
    } else {
      _cartItems[itemKey] = CartItem(
        dishId: dishId,
        dishName: dishName,
        price: price,
        quantity: quantity,
        restaurantId: restaurantId,
        restaurantName: restaurantName, // Pass restaurantName
        size: size,
        addons: addons,
        customization: customization,
        imageUrl: imageUrl,
      );
    }
    notifyListeners();
  }

  void updateQuantity(String itemKey, int quantity) {
    if (quantity <= 0) {
      _cartItems.remove(itemKey);
      if (_cartItems.isEmpty) {
        _currentRestaurantId = null;
      }
    } else {
      if (_cartItems.containsKey(itemKey)) {
        _cartItems[itemKey]!.quantity = quantity;
      }
    }
    notifyListeners();
  }

  void updateQuantityByDishId(String dishId, int quantity) {
    final itemKey = _cartItems.keys.firstWhere(
      (key) => key.startsWith(dishId),
      orElse: () => '',
    );
    if (itemKey.isNotEmpty) {
      updateQuantity(itemKey, quantity);
    }
  }

  void removeItem(String itemKey) {
    _cartItems.remove(itemKey);
    if (_cartItems.isEmpty) {
      _currentRestaurantId = null;
    }
    notifyListeners();
  }

  void removeItemByDishId(String dishId) {
    final itemKey = _cartItems.keys.firstWhere(
      (key) => key.startsWith(dishId),
      orElse: () => '',
    );
    if (itemKey.isNotEmpty) {
      removeItem(itemKey);
    }
  }

  void clearCart() {
    _cartItems.clear();
    _currentRestaurantId = null;
    notifyListeners();
  }

  String _generateItemKey(
    String dishId,
    String? size,
    List<String>? addons,
    String? customization,
  ) {
    final buffer = StringBuffer(dishId);
    if (size != null) buffer.write('_size:$size');
    if (addons != null && addons.isNotEmpty)
      buffer.write('_addons:${addons.join(",")}');
    if (customization != null && customization.isNotEmpty)
      buffer.write('_custom:$customization');
    return buffer.toString();
  }

  List<CartItem> getCartItemsList() {
    return _cartItems.values.toList();
  }

  List<CartItem> getItemsByRestaurant(String restaurantId) {
    return _cartItems.values
        .where((item) => item.restaurantId == restaurantId)
        .toList();
  }
}
