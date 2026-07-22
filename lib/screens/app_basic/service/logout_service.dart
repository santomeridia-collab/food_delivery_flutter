// lib/screens/app_basic/service/logout_service.dart
import 'package:dio/dio.dart';
import 'package:food_delivery/api/api_client.dart';
import 'package:food_delivery/global_providers/session_provider.dart';
import 'package:food_delivery/screens/app_basic/model/logout_model.dart';
import 'package:food_delivery/utils/json.dart';
import 'package:food_delivery/utils/log.dart';

class LogoutService {
  Future<ApiResponse<LogoutData>?> logout({
    String? refreshToken,
    String? userId,
  }) async {
    try {
      final accessToken = sessionProvider.session.accessToken;
      if (accessToken == null || accessToken.isEmpty) {
        logger.error("No access token found");
        return null;
      }

      // Prepare request body
      final LogoutRequest request = LogoutRequest(
        refreshToken: refreshToken,
        userId: userId,
      );

      logger.info("🚀 Logout API Call");
      logger.info("📤 Headers: Authorization: Bearer $accessToken");
      logger.info("📤 Body: ${prettyJson(request)}");

      final response = await apiClient.dio.post(
        "/api/auth/logout",
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: request.toJson(),
      );

      logger.info("📥 Response Status: ${response.statusCode}");
      logger.info("📥 Response Data: ${prettyJson(response.data)}");

      return ApiResponse<LogoutData>.fromJson(
        response.data,
        LogoutData.fromJson,
      );
    } on DioException catch (e) {
      logger.error("Dio Error: ${e.message}");
      logger.error("Status Code: ${e.response?.statusCode}");
      logger.error("Response Data: ${prettyJson(e.response?.data)}");

      return null;
    } catch (e) {
      logger.error("Unknown Error: $e");
      return null;
    }
  }

  // Helper method to clear local data
  Future<void> clearLocalData() async {
    sessionProvider.clear();
  }
}
