import 'package:dio/dio.dart';
import 'package:food_delivery/api/api_client.dart';
import 'package:food_delivery/screens/app_basic/model/login_model.dart';
import 'package:food_delivery/utils/json.dart';
import 'package:food_delivery/utils/log.dart';

class LoginService {
  Future<ApiResponse<LoginData>?> loginUser({
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

      logger.info("LOGIN API START\n\nBody:\n${prettyJson(body)}");

      final response = await apiClient.dio.post(
        "/api/auth/login/password",
        data: body,
        options: Options(extra: {"RequireAuth": false, "SkipRefresh": true}),
      );

      logger.ok("📥 RESPONSE:\n${prettyJson(response)}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<LoginData>.fromJson(
          response.data,
          LoginData.fromJson,
        );
      } else {
        return null;
      }
    } on DioException catch (e) {
      logger.error("LOGIN ERROR RESPONSE: \n\n${prettyJson(e.response?.data)}");
      return null;
    }
  }
}
