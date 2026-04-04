import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/restaurant_owner/active_orders_screen.dart';
import 'package:food_delivery/screens/restaurant_owner/completed_orders_screen.dart';
import 'package:food_delivery/screens/restaurant_owner/earnings_screen.dart';
import 'package:food_delivery/screens/restaurant_owner/incoming_orders_screen.dart';
import 'package:food_delivery/screens/restaurant_owner/menu_management_screen.dart';
import 'package:food_delivery/screens/restaurant_owner/model/restaurant_order_model.dart';
import 'package:food_delivery/screens/restaurant_owner/provider/restaurant_provider.dart';
import 'package:food_delivery/screens/restaurant_owner/restaurant_chat_screen.dart';
import 'package:food_delivery/screens/restaurant_owner/restaurant_profile_screen.dart';
import 'package:food_delivery/screens/restaurant_owner/widget/earnings_chart.dart';
import 'package:food_delivery/screens/restaurant_owner/widget/stat_card.dart';
import 'package:provider/provider.dart';

class RestaurantDashboardScreen extends StatefulWidget {
  const RestaurantDashboardScreen({super.key});

  @override
  State<RestaurantDashboardScreen> createState() =>
      _RestaurantDashboardScreenState();
}

class _RestaurantDashboardScreenState extends State<RestaurantDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _DashboardContent(),
    const IncomingOrdersScreen(),
    const ActiveOrdersScreen(),
    const CompletedOrdersScreen(),
    const MenuManagementScreen(),
    const RestaurantProfileScreen(),
    const EarningsScreen(),
    const RestaurantChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final pendingCount = restaurantProvider.pendingOrders.length;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_active_outlined),
                if (pendingCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        pendingCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_active),
                if (pendingCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        pendingCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Incoming',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_outlined),
            activeIcon: Icon(Icons.restaurant),
            label: 'Active',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            activeIcon: Icon(Icons.history),
            label: 'Completed',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Menu',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final stats = restaurantProvider.stats;

    return RefreshIndicator(
      onRefresh: () async {
        await restaurantProvider.refreshData();
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Restaurant Dashboard'),
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  restaurantProvider.refreshData();
                },
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Stats Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 1.2,
                    children: [
                      StatCard(
                        title: 'Today\'s Orders',
                        value: stats.todayOrders.toString(),
                        icon: Icons.shopping_bag,
                        color: Colors.blue,
                        onTap: () {},
                      ),
                      StatCard(
                        title: 'Today\'s Earnings',
                        value: '\$${stats.todayEarnings.toStringAsFixed(2)}',
                        icon: Icons.attach_money,
                        color: Colors.green,
                        onTap: () {},
                      ),
                      StatCard(
                        title: 'Active Orders',
                        value: stats.activeOrders.toString(),
                        icon: Icons.restaurant,
                        color: Colors.orange,
                        onTap: () {},
                      ),
                      StatCard(
                        title: 'Completion Rate',
                        value: '${stats.completionRate.toStringAsFixed(0)}%',
                        icon: Icons.verified,
                        color: Colors.purple,
                        onTap: () {},
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Earnings Chart
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Weekly Earnings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          height: 200.h,
                          child: EarningsChart(
                            earnings: restaurantProvider.weeklyEarnings,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Recent Orders
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recent Orders',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        ...restaurantProvider.recentOrders.take(3).map((order) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getStatusColor(
                                order.status,
                              ).withOpacity(0.1),
                              child: Icon(
                                _getStatusIcon(order.status),
                                color: _getStatusColor(order.status),
                                size: 20,
                              ),
                            ),
                            title: Text('Order #${order.orderNumber}'),
                            subtitle: Text(
                              '\$${order.total.toStringAsFixed(2)} • ${_formatTime(order.createdAt)}',
                            ),
                            trailing: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  order.status,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                _getStatusText(order.status),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: _getStatusColor(order.status),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            onTap: () {},
                          );
                        }),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(RestaurantOrderStatus status) {
    switch (status) {
      case RestaurantOrderStatus.pending:
        return Colors.orange;
      case RestaurantOrderStatus.accepted:
        return Colors.blue;
      case RestaurantOrderStatus.preparing:
        return Colors.purple;
      case RestaurantOrderStatus.ready:
        return Colors.green;
      case RestaurantOrderStatus.pickedUp:
        return Colors.teal;
      case RestaurantOrderStatus.delivered:
        return Colors.green;
      case RestaurantOrderStatus.rejected:
        return Colors.red;
      case RestaurantOrderStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(RestaurantOrderStatus status) {
    switch (status) {
      case RestaurantOrderStatus.pending:
        return Icons.access_time;
      case RestaurantOrderStatus.accepted:
        return Icons.check_circle;
      case RestaurantOrderStatus.preparing:
        return Icons.restaurant;
      case RestaurantOrderStatus.ready:
        return Icons.notifications_active;
      case RestaurantOrderStatus.pickedUp:
        return Icons.delivery_dining;
      case RestaurantOrderStatus.delivered:
        return Icons.home;
      case RestaurantOrderStatus.rejected:
        return Icons.cancel;
      case RestaurantOrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getStatusText(RestaurantOrderStatus status) {
    switch (status) {
      case RestaurantOrderStatus.pending:
        return 'Pending';
      case RestaurantOrderStatus.accepted:
        return 'Accepted';
      case RestaurantOrderStatus.preparing:
        return 'Preparing';
      case RestaurantOrderStatus.ready:
        return 'Ready';
      case RestaurantOrderStatus.pickedUp:
        return 'Picked Up';
      case RestaurantOrderStatus.delivered:
        return 'Delivered';
      case RestaurantOrderStatus.rejected:
        return 'Rejected';
      case RestaurantOrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
