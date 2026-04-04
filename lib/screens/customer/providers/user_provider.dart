import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  User _currentUser = User(
    id: '1',
    name: 'John Doe',
    email: 'john.doe@example.com',
    phone: '+1 234 567 8900',
    createdAt: DateTime.now(),
    walletBalance: 25.50,
  );

  User get currentUser => _currentUser;

  void updateUser({
    required String name,
    required String email,
    required String phone,
  }) {
    _currentUser = User(
      id: _currentUser.id,
      name: name,
      email: email,
      phone: phone,
      avatarUrl: _currentUser.avatarUrl,
      createdAt: _currentUser.createdAt,
      walletBalance: _currentUser.walletBalance,
    );
    notifyListeners();
  }

  void addWalletBalance(double amount) {
    _currentUser = User(
      id: _currentUser.id,
      name: _currentUser.name,
      email: _currentUser.email,
      phone: _currentUser.phone,
      avatarUrl: _currentUser.avatarUrl,
      createdAt: _currentUser.createdAt,
      walletBalance: _currentUser.walletBalance + amount,
    );
    notifyListeners();
  }

  void deductWalletBalance(double amount) {
    _currentUser = User(
      id: _currentUser.id,
      name: _currentUser.name,
      email: _currentUser.email,
      phone: _currentUser.phone,
      avatarUrl: _currentUser.avatarUrl,
      createdAt: _currentUser.createdAt,
      walletBalance: _currentUser.walletBalance - amount,
    );
    notifyListeners();
  }
}
