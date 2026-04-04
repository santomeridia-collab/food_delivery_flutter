import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  double _ratingFilter = 0;
  double _distanceFilter = 5;
  double _priceFilter = 50;
  String _dietaryFilter = 'all';

  List<Map<String, dynamic>> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  double get ratingFilter => _ratingFilter;
  double get distanceFilter => _distanceFilter;
  double get priceFilter => _priceFilter;
  String get dietaryFilter => _dietaryFilter;

  void search(String query) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock search results
    _searchResults = [
      {
        'type': 'restaurant',
        'data': {
          'id': '1',
          'name': 'Pizza Hut',
          'imageUrl': 'https://via.placeholder.com/400x200',
          'cuisine': 'Italian',
          'rating': 4.5,
          'reviewCount': 1234,
          'deliveryTime': '25-30 min',
          'deliveryFee': 2.99,
          'minOrder': 10,
          'isVeg': false,
          'isOpen': true,
          'distance': '1.2 km',
          'offers': ['50% OFF'],
        },
      },
      {
        'type': 'dish',
        'data': {
          'id': '1',
          'name': 'Margherita Pizza',
          'imageUrl': 'https://via.placeholder.com/400x200',
          'description': 'Classic cheese pizza',
          'price': 12.99,
          'isVeg': true,
          'rating': 4,
          'reviewCount': 123,
          'restaurantId': '1',
          'restaurantName': 'Pizza Hut',
        },
      },
    ];

    _isLoading = false;
    notifyListeners();
  }

  void setRatingFilter(double value) {
    _ratingFilter = value;
    notifyListeners();
  }

  void setDistanceFilter(double value) {
    _distanceFilter = value;
    notifyListeners();
  }

  void setPriceFilter(double value) {
    _priceFilter = value;
    notifyListeners();
  }

  void setDietaryFilter(String value) {
    _dietaryFilter = value;
    notifyListeners();
  }

  void clearFilters() {
    _ratingFilter = 0;
    _distanceFilter = 5;
    _priceFilter = 50;
    _dietaryFilter = 'all';
    notifyListeners();
  }

  void clearSearch() {
    _searchResults.clear();
    notifyListeners();
  }
}
