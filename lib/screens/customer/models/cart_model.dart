class CartItem {
  final String dishId;
  final String dishName;
  final double price;
  int quantity;
  final String restaurantId;
  final String restaurantName; // Add this property
  final String? size;
  final List<String>? addons;
  final String? customization;
  final String? imageUrl;

  CartItem({
    required this.dishId,
    required this.dishName,
    required this.price,
    this.quantity = 1,
    required this.restaurantId,
    required this.restaurantName, // Add this parameter
    this.size,
    this.addons,
    this.customization,
    this.imageUrl,
  });

  double get totalPrice => price * quantity;

  String getDescription() {
    final desc = StringBuffer();
    if (size != null) desc.write('Size: $size');
    if (addons != null && addons!.isNotEmpty) {
      if (desc.isNotEmpty) desc.write(', ');
      desc.write('Add-ons: ${addons!.join(", ")}');
    }
    if (customization != null && customization!.isNotEmpty) {
      if (desc.isNotEmpty) desc.write('\n');
      desc.write('Note: $customization');
    }
    return desc.toString();
  }

  Map<String, dynamic> toJson() => {
    'dishId': dishId,
    'dishName': dishName,
    'price': price,
    'quantity': quantity,
    'restaurantId': restaurantId,
    'restaurantName': restaurantName,
    'size': size,
    'addons': addons,
    'customization': customization,
    'imageUrl': imageUrl,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    dishId: json['dishId'],
    dishName: json['dishName'],
    price: json['price'],
    quantity: json['quantity'],
    restaurantId: json['restaurantId'],
    restaurantName: json['restaurantName'],
    size: json['size'],
    addons: json['addons'] != null ? List<String>.from(json['addons']) : null,
    customization: json['customization'],
    imageUrl: json['imageUrl'],
  );
}
