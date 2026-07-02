import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/login_model.dart';
import '../service/login_service.dart';

class LoginController with ChangeNotifier {
  final LoginService _service = LoginService();

  bool isLoading = false;
  LoginResponse? loginResponse;
  String? errorMessage;

  Future<void> login({
    required String identifier,
    required String password,
    required String role,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.loginUser(
        identifier: identifier,
        password: password,
        role: role,
      );

      if (response != null && response.success) {
        loginResponse = response;

        /// ✅ SAFE STORAGE
        try {
          final prefs = await SharedPreferences.getInstance();

          await prefs.setString("accessToken", response.data.accessToken);
          await prefs.setString("refreshToken", response.data.refreshToken);
          await prefs.setString("role", role);
        } catch (e) {
          debugPrint("❌ SharedPreferences Error: $e");
        }
      } else {
        errorMessage = response?.message ?? "Invalid credentials";
      }
    } catch (e) {
      errorMessage = "Something went wrong";
      debugPrint("❌ Login Error: $e");
    }

    /// ✅ ALWAYS STOP LOADING (VERY IMPORTANT)
    isLoading = false;
    notifyListeners();
  }
}
