import 'package:flutter/material.dart';
import '../model/restaurant_settings_model.dart';

class RestaurantSettingsProvider extends ChangeNotifier {
  RestaurantSettings _settings = RestaurantSettings(
    id: '1',
    name: 'Pizza Palace',
    email: 'contact@pizzapalace.com',
    phone: '+1 234 567 8900',
    address: '123 Main St, Downtown, New York, NY 10001',
    description:
        'Best pizza in town! Fresh ingredients, wood-fired pizzas, and fast delivery.',
    logoUrl: '',
    coverImageUrl: '',
    cuisine: 'Italian, Pizza, Fast Food',
    rating: 4.5,
    reviewCount: 1234,
    minOrder: 10,
    deliveryFee: 2.99,
    isOpen: true,
    workingHours: [
      WorkingHours(
        day: 'Monday',
        openTime: TimeOfDay(hour: 9, minute: 0),
        closeTime: TimeOfDay(hour: 22, minute: 0),
      ),
      WorkingHours(
        day: 'Tuesday',
        openTime: TimeOfDay(hour: 9, minute: 0),
        closeTime: TimeOfDay(hour: 22, minute: 0),
      ),
      WorkingHours(
        day: 'Wednesday',
        openTime: TimeOfDay(hour: 9, minute: 0),
        closeTime: TimeOfDay(hour: 22, minute: 0),
      ),
      WorkingHours(
        day: 'Thursday',
        openTime: TimeOfDay(hour: 9, minute: 0),
        closeTime: TimeOfDay(hour: 22, minute: 0),
      ),
      WorkingHours(
        day: 'Friday',
        openTime: TimeOfDay(hour: 9, minute: 0),
        closeTime: TimeOfDay(hour: 23, minute: 0),
      ),
      WorkingHours(
        day: 'Saturday',
        openTime: TimeOfDay(hour: 10, minute: 0),
        closeTime: TimeOfDay(hour: 23, minute: 0),
      ),
      WorkingHours(
        day: 'Sunday',
        openTime: TimeOfDay(hour: 10, minute: 0),
        closeTime: TimeOfDay(hour: 21, minute: 0),
      ),
    ],
    paymentMethods: ['Credit Card', 'Cash', 'UPI'],
  );

  EarningsSummary _earnings = EarningsSummary(
    todayEarnings: 245.50,
    thisWeekEarnings: 1850.75,
    thisMonthEarnings: 7250.00,
    totalEarnings: 45680.50,
    totalOrders: 1245,
    averageOrderValue: 36.70,
    pendingPayouts: 2,
    availableForPayout: 1250.00,
  );

  List<Payout> _payouts = [
    Payout(
      id: '1',
      amount: 500.00,
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'completed',
      transactionId: 'TXN123456',
      paymentMethod: 'Bank Transfer',
    ),
    Payout(
      id: '2',
      amount: 750.00,
      date: DateTime.now().subtract(const Duration(days: 12)),
      status: 'completed',
      transactionId: 'TXN123457',
      paymentMethod: 'Bank Transfer',
    ),
  ];

  RestaurantSettings get settings => _settings;
  EarningsSummary get earnings => _earnings;
  List<Payout> get payouts => _payouts;

  void updateSettings({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String description,
    required String cuisine,
    required double minOrder,
    required double deliveryFee,
    required bool isOpen,
  }) {
    _settings = RestaurantSettings(
      id: _settings.id,
      name: name,
      email: email,
      phone: phone,
      address: address,
      description: description,
      logoUrl: _settings.logoUrl,
      coverImageUrl: _settings.coverImageUrl,
      cuisine: cuisine,
      rating: _settings.rating,
      reviewCount: _settings.reviewCount,
      minOrder: minOrder,
      deliveryFee: deliveryFee,
      isOpen: isOpen,
      workingHours: _settings.workingHours,
      paymentMethods: _settings.paymentMethods,
      instagramHandle: _settings.instagramHandle,
      facebookHandle: _settings.facebookHandle,
    );
    notifyListeners();
  }

  void updateWorkingHours(List<WorkingHours> workingHours) {
    _settings = RestaurantSettings(
      id: _settings.id,
      name: _settings.name,
      email: _settings.email,
      phone: _settings.phone,
      address: _settings.address,
      description: _settings.description,
      logoUrl: _settings.logoUrl,
      coverImageUrl: _settings.coverImageUrl,
      cuisine: _settings.cuisine,
      rating: _settings.rating,
      reviewCount: _settings.reviewCount,
      minOrder: _settings.minOrder,
      deliveryFee: _settings.deliveryFee,
      isOpen: _settings.isOpen,
      workingHours: workingHours,
      paymentMethods: _settings.paymentMethods,
      instagramHandle: _settings.instagramHandle,
      facebookHandle: _settings.facebookHandle,
    );
    notifyListeners();
  }

  void toggleRestaurantStatus() {
    _settings = RestaurantSettings(
      id: _settings.id,
      name: _settings.name,
      email: _settings.email,
      phone: _settings.phone,
      address: _settings.address,
      description: _settings.description,
      logoUrl: _settings.logoUrl,
      coverImageUrl: _settings.coverImageUrl,
      cuisine: _settings.cuisine,
      rating: _settings.rating,
      reviewCount: _settings.reviewCount,
      minOrder: _settings.minOrder,
      deliveryFee: _settings.deliveryFee,
      isOpen: !_settings.isOpen,
      workingHours: _settings.workingHours,
      paymentMethods: _settings.paymentMethods,
      instagramHandle: _settings.instagramHandle,
      facebookHandle: _settings.facebookHandle,
    );
    notifyListeners();
  }
}
