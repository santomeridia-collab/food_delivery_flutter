// lib/screens/app_basic/controller/login_controller.dart
import 'package:flutter/material.dart';
import 'package:food_delivery/global_providers/session_provider.dart';
import 'package:food_delivery/utils/log.dart';
import '../service/login_service.dart';

class LoginController with ChangeNotifier {
  final LoginService _service = LoginService();

  bool isLoading = false;
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
        // Save tokens
        try {
          sessionProvider.setSession(
            // TODO: temporarily setting userId to empty string. BUG: this will break logout as it depends on userId
            "",
            identifier,
            response.data.accessToken,
            response.data.refreshToken,
            role,
          );

          logger.ok("Tokens saved successfully");
        } catch (e) {
          logger.error("SharedPreferences Error: $e");
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
      logger.error("Login Error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }
}
