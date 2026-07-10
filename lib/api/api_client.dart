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
          final authRequired = options.extra["RequireAuth"] ?? true;
          if (!authRequired) {
            return handler.next(options);
          }

          String? accessToken = await _prefs.getString("accessToken");
          logger.ok("Access Token found attaching:\n $accessToken");
          if (accessToken != null) {
            options.headers["Authorization"] = "Bearer $accessToken";
          }

          handler.next(options);
        },

        onError: (DioException e, handler) async {
          logger.error("Request Failed with following error:\n $e");

          // // Unauthorized error the access token is either expired or invalid
          // if (e.response?.statusCode == HttpStatus.unauthorized) {
          //   logger.error("Unauthorized access status code, recieved");
          //   final skipRefresh = e.requestOptions.extra["SkipRefresh"] ?? false;
          //   if (skipRefresh) {
          //     logger.info(
          //       "SkipRefresh enabled, skipping the attemp to get new access token",
          //     );
          //     return handler.next(e);
          //   }

          //   logger.warn(
          //     "Attempting to refresh expired/invalid accessToken via refreshToken",
          //   );
          //   final String? newAccessToken = await _refreshAccessToken();
          //   if (newAccessToken == null) {
          //     logger.error("Failed to get new access token");
          //     return handler.next(e);
          //   }

          //   logger.ok("Succesfully fetched new access token: $newAccessToken");
          //   _prefs.setString("accessToken", newAccessToken);
          //   // call retry
          // }

          return handler.next(e);
        },
      ),
    );
  }

  // ================================ THIS FUNCTION DOESN'T BELONG HERE, MOVE IT TO THE AUTH LAYER ================================
  /// This method uses "refreshToken" from SharedPreferencesAsync (if exists) and  fetches a new accessToken from api and returns it
  /// if refreshToken request fails returns null
  // Future<String?> _refreshAccessToken() async {
  //   try {
  //     final refreshToken = await _prefs.getString("refreshToken");
  //     if (refreshToken == null) {
  //       logger.error("Refresh token not found");
  //       return null;
  //     }
  //     final response = await dio.post(
  //       "/api/auth/refresh",
  //       data: {"refreshToken": refreshToken},
  //       options: Options(extra: {"RequireAuth": false, "SkipRefresh": true}),
  //     );
  //     logger.info("/api/auth/refresh: ${response.data}");

  //     // TODO: Fix this is quite hacky, we don't know the response data structure yet,
  //     // Create a model for refreshAccessTokenResponse
  //     return response.data.data.accessToken;
  //   } on DioException catch (e) {
  //     logger.error(
  //       "Refresh token invalid or expired, response:\n${e.response}",
  //     );
  //     return null;
  //   }
  // }
}

final apiClient = ApiClient._();
