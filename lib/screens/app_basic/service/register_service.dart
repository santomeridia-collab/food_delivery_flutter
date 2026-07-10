import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:food_delivery/api/api_costants.dart';
import 'package:food_delivery/screens/app_basic/model/register_model.dart';
import 'package:food_delivery/utils/log.dart';

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
            logPrint: (obj) => logger.info(obj.toString()),
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

      logger.info("🚀 ===== REGISTER API START =====", tag: "Auth");
      logger.info("📡 URL: $url", tag: "Auth");
      logger.info("📤 BODY: $body", tag: "Auth");

      final response = await dio.post(url, data: body);

      logger.info("📥 STATUS CODE: ${response.statusCode}", tag: "Auth");
      logger.info("📥 RESPONSE DATA: ${response.data}", tag: "Auth");
      logger.info("✅ ===== REGISTER API END =====", tag: "Auth");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponse.fromJson(response.data);
      } else {
        logger.error("⚠️ Unexpected status code", tag: "Auth");
        return null;
      }
    } on DioException catch (e) {
      logger.error("===== DIO ERROR =====", tag: "Auth");

      logger.error("TYPE: ${e.type}", tag: "Auth");
      logger.error("MESSAGE: ${e.message}", tag: "Auth");

      if (e.response != null) {
        logger.error("STATUS CODE: ${e.response?.statusCode}", tag: "Auth");
        logger.error("RESPONSE DATA: ${e.response?.data}", tag: "Auth");
        logger.error("HEADERS: ${e.response?.headers}", tag: "Auth");
      } else {
        logger.error("NO RESPONSE FROM SERVER", tag: "Auth");
      }

      logger.error("===== END ERROR =====", tag: "Auth");
      return null;
    } catch (e) {
      logger.error("UNKNOWN ERROR: $e", tag: "Auth");
      return null;
    }
  }
}
