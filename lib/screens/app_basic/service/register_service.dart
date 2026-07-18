import 'package:dio/dio.dart';
import 'package:food_delivery/api/api_client.dart';
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
      final body = {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "role": role,
      };

      logger.info("🚀 ===== REGISTER API START =====");
      logger.info("📡 URL: ${ApiConstants.baseUrl}");
      logger.info("📤 BODY: $body");

      final response = await apiClient.dio.post(
        "/api/auth/register",
        data: body,
        options: Options(extra: {"RequireAuth": false, "SkipRefresh": true}),
      );

      logger.ok("REGISTER RESPONSE: $response\n\n");
      logger.info("===== REGISTER API END =====");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponse.fromJson(response.data);
      } else {
        logger.error("Unexpected status code");
        return null;
      }
    } on DioException catch (e) {
      logger.error("===== DIO ERROR =====");

      logger.error("TYPE: ${e.type}");
      logger.error("MESSAGE: ${e.message}");

      if (e.response != null) {
        logger.error("STATUS CODE: ${e.response?.statusCode}");
        logger.error("RESPONSE DATA: ${e.response?.data}");
        logger.error("HEADERS: ${e.response?.headers}");
      } else {
        logger.error("NO RESPONSE FROM SERVER");
      }

      logger.error("===== END ERROR =====");
      return null;
    } catch (e) {
      logger.error("UNKNOWN ERROR: $e");
      return null;
    }
  }
}
