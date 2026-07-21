import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:food_delivery/screens/delivery_partener/model/delivery_dashboard_response.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:food_delivery/api/api_client.dart";
import "package:food_delivery/utils/log.dart";
import "package:food_delivery/screens/delivery_partener/model/delivery_order_model.dart";

class DeliveryProvider extends ChangeNotifier {
  List<DeliveryOrder> _allOrders = [];
  List<DeliveryOrder> _newOrders = [];
  List<DeliveryOrder> _activeOrders = [];
  bool _isOnline = true;
  DeliveryStats _stats = DeliveryStats(
    todayDeliveries: 0,
    todayEarnings: 0,
    totalDeliveries: 0,
    totalEarnings: 0,
    onlineHours: 0.0,

    // we are not recieving rating and acceptanceRate from the backend
    rating: 0,
    acceptanceRate: 0,
  );

  List<DeliveryOrder> get newOrders => _newOrders;
  List<DeliveryOrder> get activeOrders => _activeOrders;
  bool get isOnline => _isOnline;
  DeliveryStats get stats => _stats;

  DeliveryProvider() {
    _init();
  }

  Future<void> _init() async {
    try {
      logger.info("Fetching and loading delivery dashboard data");
      await _fetchAndLoadData();
      logger.ok("Successfully fetched and loading delivery dashboard data");

      notifyListeners();
    } catch (e) {
      logger.error("Failed to fetch and load dashboard data:\n\n$e");
    }
  }

  /// This method fetch's the dashboard data from {api_url}/api/delivery/dashboard route and update the values for this DeliveryProvider instance
  ///
  /// NOTE: This function does not call notifyListeners(), you have explicitly call notify_listeners()
  Future<void> _fetchAndLoadData() async {
    Response response;
    response = await apiClient.dio.get("/api/delivery/dashboard");
    logger.info("/api/delivery/dashboard response:\n\n$response");

    try {
      final responseData = DeliveryDashboardResponse.fromJson(response.data);

      setOnlineStatus(responseData.data.isOnline);
      _updateStats(responseData);
    } catch (e) {
      logger.error(e.toString());
      throw Error;
    }
  }

  /// This method takes in the response of /api/delivery/dashboard i.e. DeliveryDashboardResponse and
  /// updates this DeliveryProvider instance's Delivery stats variable
  ///
  /// NOTE: This function does not call notifyListeners(), you have explicitly call notify_listeners()
  void _updateStats(DeliveryDashboardResponse response) {
    _stats = DeliveryStats(
      todayDeliveries: response.data.deliveries.today,
      todayEarnings: response.data.earnings.today,

      // ================= TODO: get these values from backend (backend does send these values right now) =================
      rating: 0,
      acceptanceRate: 0,

      totalDeliveries: response.data.totalDeliveries,
      totalEarnings: response.data.earnings.total,
      onlineHours: response.data.onlineHours.todayHours,
    );
  }

  // =========== TESTING FUNCTIONS ===========
  //
  // In _loadDataTest method, ensure IDs have sufficient length
  void _loadDataTest() {
    _newOrders = [
      DeliveryOrder(
        id: 'DEL001',
        restaurantId: 'R1',
        restaurantName: 'Pizza Hut',
        restaurantAddress: '123 Main St, Downtown',
        restaurantLocation: const LatLng(28.6139, 77.2090), // Use const
        customerId: 'C1',
        customerName: 'John Doe',
        customerPhone: '+1 234 567 8901',
        customerAddress: '456 Oak Ave, Midtown',
        customerLocation: const LatLng(28.6200, 77.2200), // Use const
        items: [
          OrderItem(
            id: '1',
            name: 'Margherita Pizza',
            quantity: 2,
            price: 12.99,
          ),
        ],
        subtotal: 25.98,
        deliveryFee: 3.99,
        total: 29.97,
        paymentMethod: 'card',
        createdAt: DateTime.now(),
        status: DeliveryOrderStatus.newOrder,
        distance: 2.5,
        estimatedTime: 15,
      ),
    ];

    _activeOrders = [
      DeliveryOrder(
        id: 'DEL002',
        restaurantId: 'R2',
        restaurantName: 'Burger King',
        restaurantAddress: '789 Pine St',
        restaurantLocation: const LatLng(28.6000, 77.2000),
        customerId: 'C2',
        customerName: 'Jane Smith',
        customerPhone: '+1 234 567 8902',
        customerAddress: '321 Elm St',
        customerLocation: const LatLng(28.6300, 77.2300),
        items: [OrderItem(id: '2', name: 'Whopper', quantity: 1, price: 8.99)],
        subtotal: 8.99,
        deliveryFee: 2.99,
        total: 11.98,
        paymentMethod: 'cod',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        acceptedAt: DateTime.now().subtract(const Duration(minutes: 8)),
        status: DeliveryOrderStatus.accepted,
        distance: 3.2,
        estimatedTime: 20,
      ),
    ];

    _allOrders = [..._newOrders, ..._activeOrders];
    _updateStatsTest();
  }

  void _updateStatsTest() {
    final today = DateTime.now();
    final todayOrders = _allOrders.where(
      (o) =>
          o.status == DeliveryOrderStatus.delivered &&
          o.deliveredAt != null &&
          o.deliveredAt!.day == today.day &&
          o.deliveredAt!.month == today.month,
    );

    _stats = DeliveryStats(
      todayDeliveries: todayOrders.length,
      todayEarnings: todayOrders.fold(0.0, (sum, o) => sum + o.deliveryFee),
      totalDeliveries:
          _allOrders
              .where((o) => o.status == DeliveryOrderStatus.delivered)
              .length,
      totalEarnings: _allOrders
          .where((o) => o.status == DeliveryOrderStatus.delivered)
          .fold(0.0, (sum, o) => sum + o.deliveryFee),
      rating: 4.8,
      onlineHours: 5,
      acceptanceRate: 95,
    );
  }
  //
  // =========================================

  void setOnlineStatus(bool value) {
    _isOnline = value;
    notifyListeners();
  }

  void acceptOrder(String orderId) {
    final index = _newOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = _newOrders[index];
      final updatedOrder = DeliveryOrder(
        id: order.id,
        restaurantId: order.restaurantId,
        restaurantName: order.restaurantName,
        restaurantAddress: order.restaurantAddress,
        restaurantLocation: order.restaurantLocation,
        customerId: order.customerId,
        customerName: order.customerName,
        customerPhone: order.customerPhone,
        customerAddress: order.customerAddress,
        customerLocation: order.customerLocation,
        items: order.items,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        total: order.total,
        paymentMethod: order.paymentMethod,
        createdAt: order.createdAt,
        acceptedAt: DateTime.now(),
        status: DeliveryOrderStatus.accepted,
        distance: order.distance,
        estimatedTime: order.estimatedTime,
      );

      _newOrders.removeAt(index);
      _activeOrders.insert(0, updatedOrder);
      _allOrders = [..._newOrders, ..._activeOrders];
      _updateStatsTest();

      notifyListeners();
    }
  }

  void acceptAllOrders() {
    for (var order in _newOrders.toList()) {
      acceptOrder(order.id);
    }
  }

  void rejectOrder(String orderId) {
    _newOrders.removeWhere((o) => o.id == orderId);
    _allOrders = [..._newOrders, ..._activeOrders];

    notifyListeners();
  }

  void updateOrderStatus(String orderId, DeliveryOrderStatus newStatus) {
    final index = _activeOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final order = _activeOrders[index];
      final updatedOrder = DeliveryOrder(
        id: order.id,
        restaurantId: order.restaurantId,
        restaurantName: order.restaurantName,
        restaurantAddress: order.restaurantAddress,
        restaurantLocation: order.restaurantLocation,
        customerId: order.customerId,
        customerName: order.customerName,
        customerPhone: order.customerPhone,
        customerAddress: order.customerAddress,
        customerLocation: order.customerLocation,
        items: order.items,
        subtotal: order.subtotal,
        deliveryFee: order.deliveryFee,
        total: order.total,
        paymentMethod: order.paymentMethod,
        createdAt: order.createdAt,
        acceptedAt: order.acceptedAt,
        pickedUpAt:
            newStatus == DeliveryOrderStatus.pickedUp
                ? DateTime.now()
                : order.pickedUpAt,
        deliveredAt:
            newStatus == DeliveryOrderStatus.delivered
                ? DateTime.now()
                : order.deliveredAt,
        status: newStatus,
        distance: order.distance,
        estimatedTime: order.estimatedTime,
      );

      _activeOrders[index] = updatedOrder;

      if (newStatus == DeliveryOrderStatus.delivered) {
        _activeOrders.removeAt(index);
      }

      _allOrders = [..._newOrders, ..._activeOrders];
      _updateStatsTest();

      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    try {
      logger.info("Refreshing... delivery provider data");
      await _fetchAndLoadData();
      logger.ok("finished refreshData successfully");

      notifyListeners();
    } on DioException catch (e) {
      logger.error("Couldn't fetching dashboard data:\n\n${e.response}");
    }
  }
}
