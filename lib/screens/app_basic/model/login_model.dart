class LoginData {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String role;
  final String identifier;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.role,
    required this.identifier,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
      userId: json["userId"],
      role: json["role"],
      identifier: json["identifier"],
    );
  }
}
