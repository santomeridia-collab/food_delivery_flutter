class DeliveryLocation {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  DeliveryLocation({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}

class DeliveryPartner {
  final String id;
  final String name;
  final String phone;
  final String imageUrl;
  final double rating;
  final double currentLatitude;
  final double currentLongitude;
  final double eta; // in minutes

  DeliveryPartner({
    required this.id,
    required this.name,
    required this.phone,
    required this.imageUrl,
    required this.rating,
    required this.currentLatitude,
    required this.currentLongitude,
    required this.eta,
  });
}
