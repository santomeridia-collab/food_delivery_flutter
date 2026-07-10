// lib/screens/app_basic/controller/logout_controller.dart
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/app_basic/model/logout_model.dart';
import 'package:food_delivery/screens/app_basic/service/logout_service.dart';
import 'package:food_delivery/utils/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutController with ChangeNotifier {
  final LogoutService _logoutService = LogoutService();

  bool isLoading = false;
  LogoutResponse? logoutResponse;
  String? errorMessage;

  Future<bool> performLogout() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Get refreshToken and userId from SharedPreferences
      final prefs = SharedPreferencesAsync();
      final refreshToken = await prefs.getString('refreshToken');
      final userId = await prefs.getString('userId');

      // Call logout API
      final response = await _logoutService.logout(
        refreshToken: refreshToken,
        userId: userId,
      );

      if (response != null && response.success) {
        logoutResponse = response;

        // Clear local data after successful logout
        await _logoutService.clearLocalData();

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = response?.message ?? 'Logout failed';

        // Even if API fails, clear local data
        await _logoutService.clearLocalData();

        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = "An error occurred: $e";
      logger.error("Logout Controller Error: $e");

      // Clear local data on error
      await _logoutService.clearLocalData();

      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset controller state
  void reset() {
    isLoading = false;
    logoutResponse = null;
    errorMessage = null;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
