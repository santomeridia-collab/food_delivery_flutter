class Address {
  final String id;
  final String label;
  final String street;
  final String area;
  final String city;
  final String pincode;
  final double latitude;
  final double longitude;
  bool isDefault; // Changed from 'final' to 'bool' (non-final)

  Address({
    required this.id,
    required this.label,
    required this.street,
    required this.area,
    required this.city,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });

  // Create a copy of the address with updated fields
  Address copyWith({
    String? id,
    String? label,
    String? street,
    String? area,
    String? city,
    String? pincode,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      label: label ?? this.label,
      street: street ?? this.street,
      area: area ?? this.area,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'street': street,
    'area': area,
    'city': city,
    'pincode': pincode,
    'latitude': latitude,
    'longitude': longitude,
    'isDefault': isDefault,
  };

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'],
    label: json['label'],
    street: json['street'],
    area: json['area'],
    city: json['city'],
    pincode: json['pincode'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    isDefault: json['isDefault'],
  );
}
