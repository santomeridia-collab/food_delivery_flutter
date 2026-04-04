import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/order_details_screen.dart';
import 'package:food_delivery/screens/customer/widgets/order_card.dart';
import 'package:provider/provider.dart';
import 'models/order_model.dart';
import 'providers/order_provider.dart';
import 'utils/app_theme.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final activeOrders = orderProvider.orders.where((o) => o.isActive).toList();
    final pastOrders = orderProvider.orders.where((o) => !o.isActive).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          tabs: [
            Tab(text: 'Active (${activeOrders.length})'),
            Tab(text: 'Past (${pastOrders.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildOrderList(activeOrders), _buildOrderList(pastOrders)],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80.sp, color: Colors.grey.shade400),
            SizedBox(height: 16.h),
            Text(
              'No orders found',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your order history will appear here',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderCard(
          order: orders[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderDetailsScreen(order: orders[index]),
              ),
            );
          },
          onReorder:
              orders[index].status == OrderStatus.delivered
                  ? () => _reorder(orders[index])
                  : null,
        );
      },
    );
  }

  void _reorder(Order order) {
    // Add all items from previous order to cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${order.items.length} items added to cart'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
