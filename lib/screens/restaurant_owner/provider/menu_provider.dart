import 'package:flutter/material.dart';
import 'package:food_delivery/screens/restaurant_owner/model/menu_item_model.dart';

class MenuProvider extends ChangeNotifier {
  List<MenuItem> _menuItems = [];
  List<MenuCategory> _categories = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _showOnlyAvailable = false;

  List<MenuItem> get menuItems => _menuItems;
  List<MenuCategory> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get showOnlyAvailable => _showOnlyAvailable;

  List<MenuItem> get filteredItems {
    var filtered = List<MenuItem>.from(_menuItems);

    if (_selectedCategory != 'All') {
      filtered =
          filtered.where((item) => item.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (item) =>
                    item.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    item.description.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    if (_showOnlyAvailable) {
      filtered = filtered.where((item) => item.isAvailable).toList();
    }

    return filtered;
  }

  MenuProvider() {
    _loadSampleData();
  }

  void _loadSampleData() {
    _categories = [
      MenuCategory(id: '1', name: 'Pizza', imageUrl: '', itemCount: 8),
      MenuCategory(id: '2', name: 'Burgers', imageUrl: '', itemCount: 6),
      MenuCategory(id: '3', name: 'Sides', imageUrl: '', itemCount: 5),
      MenuCategory(id: '4', name: 'Beverages', imageUrl: '', itemCount: 4),
      MenuCategory(id: '5', name: 'Desserts', imageUrl: '', itemCount: 3),
    ];

    _menuItems = [
      MenuItem(
        id: '1',
        name: 'Margherita Pizza',
        description: 'Fresh mozzarella, tomato sauce, basil leaves',
        price: 12.99,
        discountedPrice: 9.99,
        category: 'Pizza',
        imageUrl: '',
        isVeg: true,
        preparationTime: 15,
        addons: ['Extra Cheese', 'Olives', 'Mushrooms'],
        sizes: ['Small', 'Medium', 'Large'],
        rating: 4,
        soldCount: 45,
        createdAt: DateTime.now(),
      ),
      MenuItem(
        id: '2',
        name: 'Pepperoni Pizza',
        description: 'Pepperoni, mozzarella, tomato sauce',
        price: 14.99,
        discountedPrice: null,
        category: 'Pizza',
        imageUrl: '',
        isVeg: false,
        preparationTime: 20,
        addons: ['Extra Pepperoni', 'Jalapenos'],
        sizes: ['Small', 'Medium', 'Large'],
        rating: 5,
        soldCount: 78,
        createdAt: DateTime.now(),
      ),
    ];
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleShowOnlyAvailable() {
    _showOnlyAvailable = !_showOnlyAvailable;
    notifyListeners();
  }

  void addMenuItem(MenuItem item) {
    _menuItems.insert(0, item);
    _updateCategoryItemCount(item.category);
    notifyListeners();
  }

  void updateMenuItem(MenuItem updatedItem) {
    final index = _menuItems.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      final oldCategory = _menuItems[index].category;
      _menuItems[index] = updatedItem;
      if (oldCategory != updatedItem.category) {
        _updateCategoryItemCount(oldCategory);
        _updateCategoryItemCount(updatedItem.category);
      }
      notifyListeners();
    }
  }

  void deleteMenuItem(String id) {
    final item = _menuItems.firstWhere((item) => item.id == id);
    _menuItems.removeWhere((item) => item.id == id);
    _updateCategoryItemCount(item.category);
    notifyListeners();
  }

  void toggleAvailability(String id) {
    final index = _menuItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _menuItems[index] = _menuItems[index].copyWith(
        isAvailable: !_menuItems[index].isAvailable,
      );
      notifyListeners();
    }
  }

  void _updateCategoryItemCount(String categoryName) {
    final count =
        _menuItems.where((item) => item.category == categoryName).length;
    final index = _categories.indexWhere((cat) => cat.name == categoryName);
    if (index != -1) {
      _categories[index] = _categories[index].copyWith(itemCount: count);
    }
  }

  void addCategory(MenuCategory category) {
    _categories.add(category);
    notifyListeners();
  }

  void updateCategory(MenuCategory updatedCategory) {
    final index = _categories.indexWhere((cat) => cat.id == updatedCategory.id);
    if (index != -1) {
      _categories[index] = updatedCategory;
      notifyListeners();
    }
  }

  void deleteCategory(String id) {
    final category = _categories.firstWhere((cat) => cat.id == id);
    _categories.removeWhere((cat) => cat.id == id);
    notifyListeners();
  }
}
