class Dish {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final double price;
  final double? discountedPrice;
  final bool isVeg;
  final int rating;
  final int reviewCount;
  final String restaurantId;
  final String restaurantName;
  final List<String> addons;
  final List<String>? sizes; // Added sizes with custom class
  final Map<String, double>? sizePrices; // Alternative: Map for size to price

  Dish({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    this.discountedPrice,
    required this.isVeg,
    required this.rating,
    required this.reviewCount,
    required this.restaurantId,
    required this.restaurantName,
    required this.addons,
    this.sizes,
    this.sizePrices,
  });

  double get finalPrice => discountedPrice ?? price;

  // Get price for a specific size
  double getPriceForSize(String sizeName) {
    if (sizePrices != null && sizePrices!.containsKey(sizeName)) {
      return sizePrices![sizeName]!;
    }
    return price;
  }

  // Check if dish has sizes
  bool get hasSizes => sizes != null && sizes!.isNotEmpty;
}

// Dish Size Model
class DishSize {
  final String name;
  final double price;
  final double? discountedPrice;

  DishSize({required this.name, required this.price, this.discountedPrice});

  double get finalPrice => discountedPrice ?? price;

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'discountedPrice': discountedPrice,
  };

  factory DishSize.fromJson(Map<String, dynamic> json) => DishSize(
    name: json['name'],
    price: json['price'],
    discountedPrice: json['discountedPrice'],
  );
}

// Extended Dish model with more features
class DishExtended {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final double basePrice;
  final double? discountedPrice;
  final bool isVeg;
  final int rating;
  final int reviewCount;
  final String restaurantId;
  final String restaurantName;
  final List<AddonCategory> addonCategories;
  final List<DishSize> sizes;
  final bool isAvailable;
  final int preparationTime; // in minutes
  final int maxQuantityPerOrder;
  final List<String> dietaryInfo;
  final List<String> ingredients;
  final String? spicyLevel;
  final bool isRecommended;
  final bool isPopular;
  final int soldCount;

  DishExtended({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.basePrice,
    this.discountedPrice,
    required this.isVeg,
    required this.rating,
    required this.reviewCount,
    required this.restaurantId,
    required this.restaurantName,
    required this.addonCategories,
    required this.sizes,
    this.isAvailable = true,
    this.preparationTime = 15,
    this.maxQuantityPerOrder = 10,
    this.dietaryInfo = const [],
    this.ingredients = const [],
    this.spicyLevel,
    this.isRecommended = false,
    this.isPopular = false,
    this.soldCount = 0,
  });

  double get finalPrice => discountedPrice ?? basePrice;

  double getPriceForSize(String sizeName) {
    final size = sizes.firstWhere(
      (s) => s.name == sizeName,
      orElse: () => sizes.first,
    );
    return size.finalPrice;
  }

  bool get hasSizes => sizes.isNotEmpty;
  bool get hasAddons => addonCategories.isNotEmpty;
}

// Addon Category Model
class AddonCategory {
  final String id;
  final String name;
  final bool isRequired;
  final int minSelection;
  final int maxSelection;
  final List<Addon> addons;

  AddonCategory({
    required this.id,
    required this.name,
    this.isRequired = false,
    this.minSelection = 0,
    this.maxSelection = 10,
    required this.addons,
  });
}

// Addon Model
class Addon {
  final String id;
  final String name;
  final double price;
  final bool isDefault;

  Addon({
    required this.id,
    required this.name,
    required this.price,
    this.isDefault = false,
  });
}
