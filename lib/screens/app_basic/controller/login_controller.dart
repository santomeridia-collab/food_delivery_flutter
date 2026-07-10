// lib/screens/app_basic/controller/login_controller.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/login_model.dart';
import '../service/login_service.dart';

class LoginController with ChangeNotifier {
  final LoginService _service = LoginService();

  bool isLoading = false;
  LoginResponse? loginResponse;
  String? errorMessage;

  Future<bool> login({
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

        // Save tokens
        try {
          final prefs = SharedPreferencesAsync();
          await prefs.setString("accessToken", response.data.accessToken);
          await prefs.setString("refreshToken", response.data.refreshToken);
          await prefs.setString("role", role);
          await prefs.setString("identifier", identifier);

          debugPrint("✅ Tokens saved successfully");
        } catch (e) {
          debugPrint("❌ SharedPreferences Error: $e");
        }

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = response?.message ?? "Invalid credentials";
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = "Something went wrong: $e";
      debugPrint("❌ Login Error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    isLoading = false;
    loginResponse = null;
    errorMessage = null;
    notifyListeners();
  }
}
