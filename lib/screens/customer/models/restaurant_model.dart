class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final String cuisine;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final double deliveryFee;
  final double minOrder;
  final bool isVeg;
  final bool isOpen;
  final String distance;
  final List<String> offers;

  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minOrder,
    required this.isVeg,
    required this.isOpen,
    required this.distance,
    required this.offers,
  });
}
