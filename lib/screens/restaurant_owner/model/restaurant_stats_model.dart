class RestaurantStats {
  final int todayOrders;
  final double todayEarnings;
  final int weeklyOrders;
  final double weeklyEarnings;
  final double averageOrderValue;
  final double completionRate;
  final int activeOrders;
  final int pendingOrders;

  RestaurantStats({
    required this.todayOrders,
    required this.todayEarnings,
    required this.weeklyOrders,
    required this.weeklyEarnings,
    required this.averageOrderValue,
    required this.completionRate,
    required this.activeOrders,
    required this.pendingOrders,
  });
}

class DailyEarning {
  final DateTime date;
  final double amount;
  final int orders;

  DailyEarning({
    required this.date,
    required this.amount,
    required this.orders,
  });
}
