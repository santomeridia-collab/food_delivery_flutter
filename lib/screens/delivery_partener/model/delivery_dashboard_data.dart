class DeliveryDashboardData {
  final bool isOnline;
  final int totalDeliveries;
  final DeliveryDashboardDeliveries deliveries;
  final DeliveryDashboardEarnings earnings;
  final DeliveryDashboardOnlineHours onlineHours;
  final DeliveryDashboardActiveDelivery? activeDelivery;

  DeliveryDashboardData._({
    required this.isOnline,
    required this.totalDeliveries,
    required this.deliveries,
    required this.earnings,
    required this.onlineHours,
    required this.activeDelivery,
  });

  factory DeliveryDashboardData.fromJson(Map<String, dynamic> json) {
    return DeliveryDashboardData._(
      isOnline: json["isOnline"],
      totalDeliveries: json["totalDeliveries"],
      deliveries: DeliveryDashboardDeliveries._fromJson(json["deliveries"]),
      earnings: DeliveryDashboardEarnings._fromJson(json["earnings"]),
      onlineHours: DeliveryDashboardOnlineHours._fromJson(json["onlineHours"]),
      activeDelivery:
          json["activeDelivery"] != null
              ? DeliveryDashboardActiveDelivery._fromJson(
                json["activeDelivery"],
              )
              : null,
    );
  }
}

class DeliveryDashboardDeliveries {
  final int today;
  final int thisWeek;
  final int thisMonth;

  DeliveryDashboardDeliveries._({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
  });

  factory DeliveryDashboardDeliveries._fromJson(Map<String, dynamic> json) {
    return DeliveryDashboardDeliveries._(
      today: json["today"],
      thisWeek: json["thisWeek"],
      thisMonth: json["thisMonth"],
    );
  }
}

class DeliveryDashboardEarnings {
  final double total;
  final double today;
  final double thisWeek;
  final double thisMonth;
  final double avgPerDelivery;

  DeliveryDashboardEarnings._({
    required this.total,
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.avgPerDelivery,
  });

  factory DeliveryDashboardEarnings._fromJson(Map<String, dynamic> json) {
    return DeliveryDashboardEarnings._(
      total: (json["total"] as num).toDouble(),
      today: (json["today"] as num).toDouble(),
      thisWeek: (json["thisWeek"] as num).toDouble(),
      thisMonth: (json["thisMonth"] as num).toDouble(),
      avgPerDelivery: (json["avgPerDelivery"] as num).toDouble(),
    );
  }
}

class DeliveryDashboardOnlineHours {
  final int totalMinutes;
  final double totalHours;
  final int todayMinutes;
  final double todayHours;
  final int thisWeekMinutes;
  final int thisMonthMinutes;

  DeliveryDashboardOnlineHours._({
    required this.totalMinutes,
    required this.totalHours,
    required this.todayMinutes,
    required this.todayHours,
    required this.thisWeekMinutes,
    required this.thisMonthMinutes,
  });

  factory DeliveryDashboardOnlineHours._fromJson(Map<String, dynamic> json) {
    return DeliveryDashboardOnlineHours._(
      totalMinutes: json["totalMinutes"],
      totalHours: (json["totalHours"] as num).toDouble(),
      todayMinutes: json["todayMinutes"],
      todayHours: (json["todayHours"] as num).toDouble(),
      thisWeekMinutes: json["thisWeekMinutes"],
      thisMonthMinutes: json["thisMonthMinutes"],
    );
  }
}

class DeliveryDashboardActiveDelivery {
  DeliveryDashboardActiveDelivery._();

  factory DeliveryDashboardActiveDelivery._fromJson(Map<String, dynamic> json) {
    return DeliveryDashboardActiveDelivery._();
  }
}
