import 'dart:developer';
import 'package:dio/dio.dart';
import '../model/login_model.dart';

class LoginService {
  final Dio dio = Dio();

  Future<LoginResponse?> loginUser({
    required String identifier,
    required String password,
    required String role,
  }) async {
    try {
      final url =
          'https://food-delievery-backend-frdj.onrender.com/api/auth/login/password';

      final body = {
        "identifier": identifier,
        "password": password,
        "role": role,
      };

      log("🚀 LOGIN API START");
      log("📤 BODY: $body");

      final response = await dio.post(url, data: body);

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
