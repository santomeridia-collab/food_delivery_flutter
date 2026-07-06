import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:food_delivery/api/api_costants.dart';
import 'package:food_delivery/screens/app_basic/model/register_model.dart';

class RegisterService {
  final Dio dio =
      Dio()
        ..interceptors.add(
          LogInterceptor(
            request: true,
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            error: true,
            logPrint: (obj) => log(obj.toString()),
          ),
        );

  Future<RegisterResponse?> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      const baseUrl = ApiConstants.baseUrl;
      final url = "$baseUrl/api/auth/register";

      final body = {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "role": role,
      };

      log("🚀 ===== REGISTER API START =====");
      log("📡 URL: $url");
      log("📤 BODY: $body");

      final response = await dio.post(url, data: body);

      log("📥 STATUS CODE: ${response.statusCode}");
      log("📥 RESPONSE DATA: ${response.data}");
      log("✅ ===== REGISTER API END =====");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponse.fromJson(response.data);
      } else {
        log("⚠️ Unexpected status code");
        return null;
      }
    } on DioException catch (e) {
      log("❌ ===== DIO ERROR =====");

      log("🔴 TYPE: ${e.type}");
      log("🔴 MESSAGE: ${e.message}");

      if (e.response != null) {
        log("🔴 STATUS CODE: ${e.response?.statusCode}");
        log("🔴 RESPONSE DATA: ${e.response?.data}");
        log("🔴 HEADERS: ${e.response?.headers}");
      } else {
        log("🔴 NO RESPONSE FROM SERVER");
      }

      log("❌ ===== END ERROR =====");
      return null;
    } catch (e) {
      log("❌ UNKNOWN ERROR: $e");
      return null;
    }
  }
}
