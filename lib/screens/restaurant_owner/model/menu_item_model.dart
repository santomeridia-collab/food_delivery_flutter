class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountedPrice;
  final String category;
  final String imageUrl;
  final bool isAvailable;
  final bool isVeg;
  final int preparationTime;
  final List<String> addons;
  final List<String> sizes;
  final int rating;
  final int soldCount;
  final DateTime createdAt;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountedPrice,
    required this.category,
    required this.imageUrl,
    this.isAvailable = true,
    required this.isVeg,
    this.preparationTime = 15,
    this.addons = const [],
    this.sizes = const [],
    this.rating = 0,
    this.soldCount = 0,
    required this.createdAt,
  });

  double get finalPrice => discountedPrice ?? price;
  String get formattedPrice => '\$${finalPrice.toStringAsFixed(2)}';
  String get formattedOriginalPrice => '\$${price.toStringAsFixed(2)}';
  bool get hasDiscount => discountedPrice != null && discountedPrice! < price;
  double get discountPercentage =>
      hasDiscount
          ? ((price - discountedPrice!) / price * 100).roundToDouble()
          : 0;

  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? discountedPrice,
    String? category,
    String? imageUrl,
    bool? isAvailable,
    bool? isVeg,
    int? preparationTime,
    List<String>? addons,
    List<String>? sizes,
    int? rating,
    int? soldCount,
    DateTime? createdAt,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      isVeg: isVeg ?? this.isVeg,
      preparationTime: preparationTime ?? this.preparationTime,
      addons: addons ?? this.addons,
      sizes: sizes ?? this.sizes,
      rating: rating ?? this.rating,
      soldCount: soldCount ?? this.soldCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'discountedPrice': discountedPrice,
    'category': category,
    'imageUrl': imageUrl,
    'isAvailable': isAvailable,
    'isVeg': isVeg,
    'preparationTime': preparationTime,
    'addons': addons,
    'sizes': sizes,
    'rating': rating,
    'soldCount': soldCount,
    'createdAt': createdAt.toIso8601String(),
  };

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    price: json['price'],
    discountedPrice: json['discountedPrice'],
    category: json['category'],
    imageUrl: json['imageUrl'],
    isAvailable: json['isAvailable'],
    isVeg: json['isVeg'],
    preparationTime: json['preparationTime'],
    addons: List<String>.from(json['addons']),
    sizes: List<String>.from(json['sizes']),
    rating: json['rating'],
    soldCount: json['soldCount'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class MenuCategory {
  final String id;
  final String name;
  final String? imageUrl;
  final int itemCount;
  final bool isActive;

  MenuCategory({
    required this.id,
    required this.name,
    this.imageUrl,
    this.itemCount = 0,
    this.isActive = true,
  });

  MenuCategory copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? itemCount,
    bool? isActive,
  }) {
    return MenuCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      itemCount: itemCount ?? this.itemCount,
      isActive: isActive ?? this.isActive,
    );
  }
}
