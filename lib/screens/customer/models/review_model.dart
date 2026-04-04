class Review {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final List<String> images;
  final DateTime createdAt;
  final int likes;
  final bool isVerified;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.images,
    required this.createdAt,
    required this.likes,
    this.isVerified = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'userAvatar': userAvatar,
    'rating': rating,
    'comment': comment,
    'images': images,
    'createdAt': createdAt.toIso8601String(),
    'likes': likes,
    'isVerified': isVerified,
  };

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'],
    userId: json['userId'],
    userName: json['userName'],
    userAvatar: json['userAvatar'],
    rating: json['rating'],
    comment: json['comment'],
    images: List<String>.from(json['images']),
    createdAt: DateTime.parse(json['createdAt']),
    likes: json['likes'],
    isVerified: json['isVerified'],
  );
}
