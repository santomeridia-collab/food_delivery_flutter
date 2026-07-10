import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:food_delivery/api/api_costants.dart';
import 'package:food_delivery/utils/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
  final _prefs = SharedPreferencesAsync();

  // private contructor i.e. cannot be called outside this file
  ApiClient._() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, handler) async {
          // don't add auth headers if interceptor not required
          if (!options.extra["RequireAuthInterceptor"]) {
            return handler.next(options);
          }

          String? accessToken = await _prefs.getString("accessToken");
          logger.ok("ACCESS TOKEN: $accessToken");
          if (accessToken != null) {
            options.headers["Authorization"] = "Bearer $accessToken";
          }

          handler.next(options);
        },

        onError: (DioException e, handler) async {
          // if (e.requestOptions.extra["SkipRefresh"]) {
          //   return handler.next(e);
          // }

          // Unauthorized error the token is either expired or invalid
          if (e.response?.statusCode == 401) {
            final String? newAccessToken = await _refreshAccessToken();
            if (newAccessToken == null || newAccessToken.isEmpty) {
              logger.error(
                "Couldn't get new access token, redirecting to login",
                tag: "Error",
              );
              // TODO: redirect user to login page

              return;
            }

            // TODO: add new access token to sharedprefrences
            _prefs.setString("accessToken", newAccessToken);
          }

          logger.error(
            "Exception caught in ApiClient Interceptor: ${e.response}",
            tag: "Error",
          );
        },
      ),
    );
  }

  /// This method uses "refreshToken" from SharedPreferencesAsync (if exists) and  fetches a new accessToken from api and returns it
  /// if refreshToken request fails returns null
  Future<String?> _refreshAccessToken() async {
    try {
      final refreshToken = await _prefs.getString("refreshToken");
      if (refreshToken == null || refreshToken.isEmpty) {
        logger.error("Refresh token not found", tag: "Error");
        return null;
      }
      final response = await dio.post(
        "/api/auth/refresh",
        data: {"refreshToken": refreshToken},
        options: Options(
          extra: {"RequireAuthInterceptor": false, "SkipRefresh": true},
        ),
      );
      logger.info("/api/auth/refresh: ${response.data}");

      return response.data.data.accessToken;
    } on DioException catch (e) {
      logger.info("Error refresh token invalid or expired ${e.response?.data}");
      return null;
    }
  }
}

final apiClient = ApiClient._();
