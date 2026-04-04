import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/order_model.dart';
import '../models/tracking_model.dart';

class TrackingProvider extends ChangeNotifier {
  DeliveryPartner? _deliveryPartner;
  LatLng? _restaurantLocation;
  List<OrderStatusUpdate> _statusUpdates = [];
  double _deliveryProgress = 0.0;
  Timer? _timer;

  DeliveryPartner? get deliveryPartner => _deliveryPartner;
  LatLng? get restaurantLocation => _restaurantLocation;
  List<OrderStatusUpdate> get statusUpdates => _statusUpdates;
  double get deliveryProgress => _deliveryProgress;

  void startTracking(String orderId) {
    _restaurantLocation = const LatLng(28.6139, 77.2090);
    _deliveryPartner = DeliveryPartner(
      id: 'dp1',
      name: 'Raj Kumar',
      phone: '+91 98765 43210',
      imageUrl: '',
      rating: 4.8,
      currentLatitude: 28.6200,
      currentLongitude: 77.2200,
      eta: 15,
    );

    _startSimulation();
  }

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_deliveryProgress >= 1.0) {
        timer.cancel();
        return;
      }

      _deliveryProgress += 0.02;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
