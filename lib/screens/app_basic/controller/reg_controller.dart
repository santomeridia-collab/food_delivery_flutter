import 'package:flutter/material.dart';
import 'package:food_delivery/screens/app_basic/model/reg_model.dart';
import 'package:food_delivery/screens/app_basic/service/reg_Service.dart';

class RegisterController with ChangeNotifier {
  final RegisterService _service = RegisterService();

  bool isLoading = false;
  RegisterResponse? registerResponse;

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.registerUser(
      name: name,
      email: email,
      phone: phone,
      password: password,
      role: role,
    );

    if (response != null && response.success) {
      registerResponse = response;
    }

    isLoading = false;
    notifyListeners();
  }
}
