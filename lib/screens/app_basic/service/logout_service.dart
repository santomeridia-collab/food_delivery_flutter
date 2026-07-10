// lib/screens/app_basic/service/logout_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:food_delivery/api/api_costants.dart';
import 'package:food_delivery/screens/app_basic/model/logout_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutService {
  final Dio dio = Dio();

  Future<LogoutResponse?> logout({String? refreshToken, String? userId}) async {
    try {
      // Get access token from SharedPreferences
      final prefs = SharedPreferencesAsync();
      final accessToken = await prefs.getString('accessToken');

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('❌ No access token found');
        return LogoutResponse(success: false, message: 'No access token found');
      }

      const baseUrl = ApiConstants.baseUrl;
      final url = "$baseUrl/api/auth/logout";

      // Prepare request body
      final LogoutRequest request = LogoutRequest(
        refreshToken: refreshToken,
        userId: userId,
      );

      debugPrint('🚀 Logout API Call');
      debugPrint('📡 URL: $url');
      debugPrint('📤 Headers: Authorization: Bearer $accessToken');
      debugPrint('📤 Body: ${request.toJson()}');

      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
        data: request.toJson(),
      );

      debugPrint('📥 Response Status: ${response.statusCode}');
      debugPrint('📥 Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LogoutResponse.fromJson(response.data);
      } else {
        return LogoutResponse(
          success: false,
          message: 'Logout failed with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      debugPrint('❌ Dio Error: ${e.message}');
      debugPrint('❌ Status Code: ${e.response?.statusCode}');
      debugPrint('❌ Response Data: ${e.response?.data}');

      String errorMessage = 'Network error occurred';
      if (e.response?.data != null) {
        try {
          final errorData = e.response?.data as Map<String, dynamic>;
          errorMessage = errorData['message'] ?? 'Logout failed';
        } catch (_) {}
      }

      return LogoutResponse(success: false, message: errorMessage);
    } catch (e) {
      debugPrint('❌ Unknown Error: $e');
      return LogoutResponse(
        success: false,
        message: 'An unexpected error occurred',
      );
    }
  }

  // Helper method to clear local data
  Future<void> clearLocalData() async {
    try {
      final prefs = SharedPreferencesAsync();
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      await prefs.remove('role');
      await prefs.remove('identifier');
      await prefs.remove('userId');
      await prefs.remove('isLoggedIn');
      debugPrint('✅ Local data cleared successfully');
    } catch (e) {
      debugPrint('❌ Error clearing local data: $e');
    }
  }
}
