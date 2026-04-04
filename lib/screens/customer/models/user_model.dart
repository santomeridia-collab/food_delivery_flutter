class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final DateTime createdAt;
  final double walletBalance;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    required this.createdAt,
    this.walletBalance = 0,
  });

  String get initials {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }
}
