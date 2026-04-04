import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';

class CustomerRestaurantProvider extends ChangeNotifier {
  List<Restaurant> _allRestaurants = [];
  List<Restaurant> _filteredRestaurants = [];

  List<Restaurant> get filteredRestaurants => _filteredRestaurants;

  RestaurantProvider() {
    _loadRestaurants();
  }

  void _loadRestaurants() {
    _allRestaurants = [
      // Add all restaurant data here
    ];
    _filteredRestaurants = List.from(_allRestaurants);
  }

  void sortRestaurants(String sortBy) {
    switch (sortBy) {
      case 'rating':
        _filteredRestaurants.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'deliveryTime':
        _filteredRestaurants.sort(
          (a, b) => a.deliveryTime.compareTo(b.deliveryTime),
        );
        break;
      case 'price':
        _filteredRestaurants.sort(
          (a, b) => a.deliveryFee.compareTo(b.deliveryFee),
        );
        break;
      case 'distance':
        _filteredRestaurants.sort((a, b) => a.distance.compareTo(b.distance));
        break;
    }
    notifyListeners();
  }

  void filterRestaurants(String filter) {
    switch (filter) {
      case 'open':
        _filteredRestaurants = _allRestaurants.where((r) => r.isOpen).toList();
        break;
      case 'veg':
        _filteredRestaurants = _allRestaurants.where((r) => r.isVeg).toList();
        break;
      case 'offers':
        _filteredRestaurants =
            _allRestaurants.where((r) => r.offers.isNotEmpty).toList();
        break;
      default:
        _filteredRestaurants = List.from(_allRestaurants);
    }
    notifyListeners();
  }
}
