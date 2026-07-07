// lib/screens/app_basic/model/logout_model.dart
class LogoutResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  LogoutResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }
}

class LogoutRequest {
  final String? refreshToken;
  final String? userId;

  LogoutRequest({
    this.refreshToken,
    this.userId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (refreshToken != null) data['refreshToken'] = refreshToken;
    if (userId != null) data['userId'] = userId;
    return data;
  }
}   