class RegisterResponse {
  final bool success;
  final String message;
  final UserData data;

  RegisterResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'],
      message: json['message'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  final String id;
  final String email;
  final String phone;
  final String role;

  UserData({
    required this.id,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
    );
  }
}
