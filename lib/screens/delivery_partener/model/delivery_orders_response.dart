class DeliveryOrdersResponse {
  final bool success;
  final String message;
  final dynamic data;

  DeliveryOrdersResponse._({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DeliveryOrdersResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryOrdersResponse._(
      success: json["success"],
      message: json["message"],
      data: json["data"], // TODO parse this
    );
  }
}

class DeliveryOrderData {
  // final orders;
}
