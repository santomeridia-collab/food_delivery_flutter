class LogoutData {
  LogoutData._();

  factory LogoutData.fromJson(Map<String, dynamic> json) {
    return LogoutData._();
  }
}

class LogoutRequest {
  final String? refreshToken;
  final String? userId;

  LogoutRequest({this.refreshToken, this.userId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (refreshToken != null) data['refreshToken'] = refreshToken;
    if (userId != null) data['userId'] = userId;
    return data;
  }
}
