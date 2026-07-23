import 'package:dio/dio.dart';
import 'package:food_delivery/api/api_costants.dart';
import 'package:food_delivery/global_providers/session_provider.dart';
import 'package:food_delivery/utils/json.dart';
import 'package:food_delivery/utils/log.dart';

class RefreshData {
  String accessToken;
  String refreshToken;

  RefreshData({required this.accessToken, required this.refreshToken});

  factory RefreshData.fromJson(Map<String, dynamic> json) {
    return RefreshData(
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
    );
  }
}

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse._({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    return ApiResponse._(
      success: json["success"],
      message: json["message"],
      data: fromJsonT(json["data"]),
    );
  }
}

class ApiClient {
  final Dio dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  ApiClient._() {
    dio.interceptors.add(
      // Auth interceptor
      InterceptorsWrapper(
        onRequest: (RequestOptions options, handler) async {
          // don't add auth headers if authenticator is not required
          final authRequired = options.extra["RequireAuth"] ?? true;
          if (!authRequired) return handler.next(options);

          final accessToken = sessionProvider.session.accessToken;
          // stop the request if access token not found
          if (accessToken == null) {
            logger.warn(
              "Access token not found Rejecting.\nIf you do not wish to attach access token to the request header, set options.extra[\"RequireAuth\"] to true",
            );
            return handler.reject(
              DioException(
                requestOptions: options,
                message: "Access token not found. check logs",
                type: DioExceptionType.cancel,
              ),
            );
          }

          logger.info("Access Token found attaching:\n\n$accessToken");
          options.headers["Authorization"] = "Bearer $accessToken";

          return handler.next(options);
        },

        onError: (DioException e, handler) async {
          // Unauthorized error the access token is either expired or invalid
          if (e.response?.statusCode == 401) {
            logger.error(
              "401 Unauthorized access status code, recieved \n${prettyJson(e.response)}",
            );
            final skipRefresh = e.requestOptions.extra["SkipRefresh"] ?? false;
            if (skipRefresh) {
              logger.warn(
                "SkipRefresh enabled, skipping attempt to get new access token",
              );
              return handler.next(e);
            }

            logger.warn("Attempting to refresh expired/invalid accessToken");
            final refreshToken = sessionProvider.session.refreshToken;
            if (refreshToken == null) {
              logger.error("Refresh token not found");
              return handler.next(e);
            }

            String? newAccessToken;
            newAccessToken = await _refreshAccessToken(refreshToken);
            if (newAccessToken == null) {
              logger.error(
                "Failed Attempt to refresh access token. Cleaning sessionProvider data...",
              );
              sessionProvider.clear();
              return handler.next(e);
            }

            logger.ok("Success fetched new access token:\n\n$newAccessToken");
            sessionProvider.updateAccessToken(newAccessToken);

            // call retry
            logger.warn("Retrying failed request...");
            final retryRequestOptions = e.requestOptions;
            retryRequestOptions.extra = {
              "RequireAuth": false,
              "SkipRefresh": true,
            };

            final retryResponse = await _retry(
              retryRequestOptions,
              newAccessToken,
            );
            if (retryResponse == null) return handler.next(e);

            return handler.resolve(retryResponse);
          }

          return handler.next(e);
        },
      ),
    );
  }

  /// This method uses "refreshToken" from SharedPreferencesAsync (if exists) and fetches a new accessToken from api and returns it
  /// if refreshToken request fails returns null
  Future<String?> _refreshAccessToken(String refreshToken) async {
    try {
      final tempDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
      final response = await tempDio.post(
        "/api/auth/refresh",
        data: {"refreshToken": refreshToken},
      );
      final parsedResponse = ApiResponse<RefreshData>.fromJson(
        response.data,
        RefreshData.fromJson,
      );
      assert(
        parsedResponse.data != null,
      ); // on successful response data shouldn't be null
      final newAccessToken = parsedResponse.data!.accessToken;

      return newAccessToken;
    } catch (e) {
      logger.error("catch exception in refreshAccessToken: $e");
      return null;
    }
  }

  /// This method queues a retry request with provided request options and attaches the newAccessToken provided
  /// If the request fails returns null
  Future<Response?> _retry(RequestOptions req, String newAccessToken) async {
    try {
      req.headers["Authorization"] = "Bearer $newAccessToken";
      final response = await dio.fetch(req);

      return response;
    } catch (e) {
      logger.error("Retry request failed with following error\n\n$e");

      return null;
    }
  }
}

/// the dio instance i.e. apiClient.dio has the baseURL set to the backend api url.
///
/// WARNING: **DO NOT** use this to make request to external url, or fetching data from other sites.
/// To make requests to external url use: dio = Dio()
final apiClient = ApiClient._();
