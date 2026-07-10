import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:food_delivery/api/api_client.dart';
import 'package:food_delivery/screens/app_basic/model/login_model.dart';

class LoginService {
  Future<LoginResponse?> loginUser({
    required String identifier,
    required String password,
    required String role,
  }) async {
    try {
      final body = {
        "identifier": identifier,
        "password": password,
        "role": role,
      };

      log("🚀 LOGIN API START");
      log("📤 BODY: $body");

      final response = await apiClient.dio.post(
        "/api/auth/login/password",
        data: body,
        options: Options(
          extra: {"RequireAuthInterceptor": false, "SkipRefresh": true},
        ),
      );

      log("📥 RESPONSE: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponse.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      log("❌ LOGIN ERROR");
      log("🔴 STATUS: ${e.response?.statusCode}");
      log("🔴 DATA: ${e.response?.data}");
      return null;
    }
  }
}
