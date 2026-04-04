import 'package:flutter/material.dart';
import 'package:food_delivery/screens/restaurant_owner/model/restaurant_order_model.dart';
import 'package:food_delivery/screens/restaurant_owner/model/restaurant_stats_model.dart';

// Global navigator key - add this to your main.dart
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class RestaurantProvider extends ChangeNotifier {
  List<RestaurantOrder> _allOrders = [];
  List<RestaurantOrder> _pendingOrders = [];
  List<RestaurantOrder> _activeOrders = [];
  List<RestaurantOrder> _completedOrders = [];

  RestaurantStats _stats = RestaurantStats(
    todayOrders: 0,
    todayEarnings: 0,
    weeklyOrders: 0,
    weeklyEarnings: 0,
    averageOrderValue: 0,
    completionRate: 0,
    activeOrders: 0,
    pendingOrders: 0,
  );

  List<DailyEarning> _weeklyEarnings = [];

  // Getters
  List<RestaurantOrder> get allOrders => _allOrders;
  List<RestaurantOrder> get pendingOrders => _pendingOrders;
  List<RestaurantOrder> get activeOrders => _activeOrders;
  List<RestaurantOrder> get completedOrders => _completedOrders;
  RestaurantStats get stats => _stats;
  List<DailyEarning> get weeklyEarnings => _weeklyEarnings;
  List<RestaurantOrder> get recentOrders => _allOrders.take(5).toList();

  RestaurantProvider() {
    _loadSampleData();
  }

  void _loadSampleData() {
    // Sample pending orders
    _pendingOrders = [
      RestaurantOrder(
        id: 'P001',
        customerName: 'John Doe',
        customerPhone: '+1 234 567 8901',
        customerAddress: '123 Main St, New York, NY 10001',
        items: [
          OrderItem(
            id: '1',
            name: 'Margherita Pizza',
            quantity: 2,
            price: 12.99,
          ),
          OrderItem(id: '2', name: 'Garlic Bread', quantity: 1, price: 4.99),
        ],
        subtotal: 30.97,
        deliveryFee: 2.99,
        tax: 2.48,
        total: 36.44,
        paymentMethod: 'card',
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        status: RestaurantOrderStatus.pending,
      ),
      RestaurantOrder(
        id: 'P002',
        customerName: 'Jane Smith',
        customerPhone: '+1 234 567 8902',
        customerAddress: '456 Oak Ave, New York, NY 10002',
        items: [
          OrderItem(
            id: '3',
            name: 'Pepperoni Pizza',
            quantity: 1,
            price: 14.99,
          ),
          OrderItem(id: '4', name: 'Coca Cola', quantity: 2, price: 2.49),
        ],
        subtotal: 19.97,
        deliveryFee: 2.99,
        tax: 1.60,
        total: 24.56,
        paymentMethod: 'cod',
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
        status: RestaurantOrderStatus.pending,
      ),
    ];

    // Sample active orders
    _activeOrders = [
      RestaurantOrder(
        id: 'A001',
        customerName: 'Mike Johnson',
        customerPhone: '+1 234 567 8903',
        customerAddress: '789 Pine St, New York, NY 10003',
        items: [
          OrderItem(
            id: '1',
            name: 'Margherita Pizza',
            quantity: 1,
            price: 12.99,
          ),
        ],
        subtotal: 12.99,
        deliveryFee: 2.99,
        tax: 1.04,
        total: 17.02,
        paymentMethod: 'card',
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
        acceptedAt: DateTime.now().subtract(const Duration(minutes: 23)),
        status: RestaurantOrderStatus.preparing,
      ),
    ];

    // Sample completed orders
    _completedOrders = [
      RestaurantOrder(
        id: 'C001',
        customerName: 'Sarah Wilson',
        customerPhone: '+1 234 567 8904',
        customerAddress: '321 Elm St, New York, NY 10004',
        items: [
          OrderItem(
            id: '3',
            name: 'Pepperoni Pizza',
            quantity: 1,
            price: 14.99,
          ),
          OrderItem(id: '2', name: 'Garlic Bread', quantity: 1, price: 4.99),
        ],
        subtotal: 19.98,
        deliveryFee: 2.99,
        tax: 1.60,
        total: 24.57,
        paymentMethod: 'card',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        acceptedAt: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 55),
        ),
        readyAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        completedAt: DateTime.now().subtract(const Duration(hours: 1)),
        status: RestaurantOrderStatus.delivered,
      ),
    ];

    _allOrders = [..._pendingOrders, ..._activeOrders, ..._completedOrders];
    _updateStats();
  }

  // Accept a single order
  void acceptOrder(String orderId) {
    final index = _pendingOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = _pendingOrders[index];
      final updatedOrder = RestaurantOrder(
        id: order.id,
        customerName: order.customerName,
        customerPhone: order.customerPhone,
        customerAddress: order.customerAddress,
        items: order.items,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        tax: order.tax,
        total: order.total,
        paymentMethod: order.paymentMethod,
        createdAt: order.createdAt,
        acceptedAt: DateTime.now(),
        readyAt: order.readyAt,
        completedAt: order.completedAt,
        status: RestaurantOrderStatus.accepted,
        rejectionReason: order.rejectionReason,
        preparationTime: order.preparationTime,
      );

      _pendingOrders.removeAt(index);
      _activeOrders.insert(0, updatedOrder);
      _allOrders = [..._pendingOrders, ..._activeOrders, ..._completedOrders];
      _updateStats();
      notifyListeners();
    }
  }

  // Accept all pending orders
  void acceptAllOrders() {
    for (var order in _pendingOrders.toList()) {
      final updatedOrder = RestaurantOrder(
        id: order.id,
        customerName: order.customerName,
        customerPhone: order.customerPhone,
        customerAddress: order.customerAddress,
        items: order.items,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        tax: order.tax,
        total: order.total,
        paymentMethod: order.paymentMethod,
        createdAt: order.createdAt,
        acceptedAt: DateTime.now(),
        readyAt: order.readyAt,
        completedAt: order.completedAt,
        status: RestaurantOrderStatus.accepted,
        rejectionReason: order.rejectionReason,
        preparationTime: order.preparationTime,
      );

      _activeOrders.insert(0, updatedOrder);
    }
    _pendingOrders.clear();
    _allOrders = [..._pendingOrders, ..._activeOrders, ..._completedOrders];
    _updateStats();
    notifyListeners();
  }

  // Reject an order with reason
  void rejectOrder(String orderId, String reason) {
    final index = _pendingOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = _pendingOrders[index];
      final rejectedOrder = RestaurantOrder(
        id: order.id,
        customerName: order.customerName,
        customerPhone: order.customerPhone,
        customerAddress: order.customerAddress,
        items: order.items,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        tax: order.tax,
        total: order.total,
        paymentMethod: order.paymentMethod,
        createdAt: order.createdAt,
        acceptedAt: order.acceptedAt,
        readyAt: order.readyAt,
        completedAt: order.completedAt,
        status: RestaurantOrderStatus.rejected,
        rejectionReason: reason,
        preparationTime: order.preparationTime,
      );

      _pendingOrders.removeAt(index);
      _completedOrders.insert(0, rejectedOrder);
      _allOrders = [..._pendingOrders, ..._activeOrders, ..._completedOrders];
      _updateStats();
      notifyListeners();
    }
  }

  // Update order status (Preparing, Ready, etc.)
  void updateOrderStatus(String orderId, RestaurantOrderStatus newStatus) {
    // Check in active orders
    int index = _activeOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = _activeOrders[index];
      final updatedOrder = RestaurantOrder(
        id: order.id,
        customerName: order.customerName,
        customerPhone: order.customerPhone,
        customerAddress: order.customerAddress,
        items: order.items,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        tax: order.tax,
        total: order.total,
        paymentMethod: order.paymentMethod,
        createdAt: order.createdAt,
        acceptedAt: order.acceptedAt,
        readyAt:
            newStatus == RestaurantOrderStatus.ready
                ? DateTime.now()
                : order.readyAt,
        completedAt:
            newStatus == RestaurantOrderStatus.delivered
                ? DateTime.now()
                : order.completedAt,
        status: newStatus,
        rejectionReason: order.rejectionReason,
        preparationTime: order.preparationTime,
      );

      _activeOrders[index] = updatedOrder;

      // If order is delivered or picked up, move to completed
      if (newStatus == RestaurantOrderStatus.delivered ||
          newStatus == RestaurantOrderStatus.pickedUp) {
        _activeOrders.removeAt(index);
        _completedOrders.insert(0, updatedOrder);
      }

      _allOrders = [..._pendingOrders, ..._activeOrders, ..._completedOrders];
      _updateStats();
      notifyListeners();
      return;
    }

    // Check in pending orders (if accepting)
    index = _pendingOrders.indexWhere((o) => o.id == orderId);
    if (index != -1 && newStatus == RestaurantOrderStatus.accepted) {
      acceptOrder(orderId);
    }
  }

  // Delay an order
  void delayOrder(String orderId, int minutes) {
    final index = _activeOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = _activeOrders[index];
      final updatedOrder = RestaurantOrder(
        id: order.id,
        customerName: order.customerName,
        customerPhone: order.customerPhone,
        customerAddress: order.customerAddress,
        items: order.items,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        tax: order.tax,
        total: order.total,
        paymentMethod: order.paymentMethod,
        createdAt: order.createdAt,
        acceptedAt: order.acceptedAt,
        readyAt: order.readyAt,
        completedAt: order.completedAt,
        status: order.status,
        rejectionReason: order.rejectionReason,
        preparationTime: order.preparationTime + minutes,
      );

      _activeOrders[index] = updatedOrder;
      notifyListeners();

      // Show snackbar if context is available
      if (navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text('Order delayed by $minutes minutes'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  // Refresh all data
  Future<void> refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    _loadSampleData();
    _updateStats();
    notifyListeners();
  }

  // Update statistics
  void _updateStats() {
    final today = DateTime.now();
    final todayOrdersList = _completedOrders.where(
      (o) =>
          o.createdAt.day == today.day &&
          o.createdAt.month == today.month &&
          o.createdAt.year == today.year,
    );

    final weeklyOrdersList = _completedOrders.where(
      (o) =>
          o.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 7))),
    );

    final totalOrders = _allOrders.length;
    final completedCount = _completedOrders.length;

    _stats = RestaurantStats(
      todayOrders: todayOrdersList.length,
      todayEarnings: todayOrdersList.fold(0.0, (sum, o) => sum + o.total),
      weeklyOrders: weeklyOrdersList.length,
      weeklyEarnings: weeklyOrdersList.fold(0.0, (sum, o) => sum + o.total),
      averageOrderValue:
          _completedOrders.isNotEmpty
              ? _completedOrders.fold(0.0, (sum, o) => sum + o.total) /
                  _completedOrders.length
              : 0.0,
      completionRate:
          totalOrders > 0 ? (completedCount / totalOrders) * 100 : 100.0,
      activeOrders: _activeOrders.length,
      pendingOrders: _pendingOrders.length,
    );

    _generateWeeklyEarnings();
  }

  // Generate weekly earnings data for chart
  void _generateWeeklyEarnings() {
    _weeklyEarnings = [];
    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dailyOrders = _completedOrders.where(
        (o) =>
            o.createdAt.day == date.day &&
            o.createdAt.month == date.month &&
            o.createdAt.year == date.year,
      );

      _weeklyEarnings.add(
        DailyEarning(
          date: date,
          amount: dailyOrders.fold(0.0, (sum, o) => sum + o.total),
          orders: dailyOrders.length,
        ),
      );
    }
  }

  // Add a new incoming order (for Socket.io simulation)
  void addIncomingOrder(RestaurantOrder order) {
    _pendingOrders.insert(0, order);
    _allOrders = [..._pendingOrders, ..._activeOrders, ..._completedOrders];
    _updateStats();
    notifyListeners();
  }

  // Get order by ID
  RestaurantOrder? getOrderById(String orderId) {
    try {
      return _allOrders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }
}
