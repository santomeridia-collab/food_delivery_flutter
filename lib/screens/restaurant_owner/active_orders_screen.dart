import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/restaurant_owner/model/restaurant_order_model.dart';
import 'package:food_delivery/screens/restaurant_owner/provider/restaurant_provider.dart';
import 'package:provider/provider.dart';
import 'order_detail_screen.dart';

class ActiveOrdersScreen extends StatelessWidget {
  const ActiveOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final activeOrders = restaurantProvider.activeOrders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Orders'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          activeOrders.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant,
                      size: 80.sp,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No active orders',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Orders in progress will appear here',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: () async {
                  await restaurantProvider.refreshData();
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: activeOrders.length,
                  itemBuilder: (context, index) {
                    final order = activeOrders[index];
                    return _buildActiveOrderCard(
                      context,
                      order,
                      restaurantProvider,
                    );
                  },
                ),
              ),
    );
  }

  Widget _buildActiveOrderCard(
    BuildContext context,
    RestaurantOrder order,
    RestaurantProvider provider,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
          // Order Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: _getStatusColor(order.status).withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.orderNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.1),
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
                  ],
                ),
                Text(
                  order.formattedTotal,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Order Body
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Info
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        order.customerName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Items Summary
                const Text(
                  'Items:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                ...order.items.map((item) {
                  return Padding(
                    padding: EdgeInsets.only(left: 8.w, top: 4.h),
                    child: Text(
                      '${item.quantity}x ${item.name}',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  );
                }),

                SizedBox(height: 16.h),

                // Action Buttons based on status
                if (order.status == RestaurantOrderStatus.accepted)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        provider.updateOrderStatus(
                          order.id,
                          RestaurantOrderStatus.preparing,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: const Text('Start Preparing'),
                    ),
                  ),

                if (order.status == RestaurantOrderStatus.preparing)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _showDelayDialog(context, order, provider);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.orange),
                            foregroundColor: Colors.orange,
                          ),
                          child: const Text('Delay'),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            provider.updateOrderStatus(
                              order.id,
                              RestaurantOrderStatus.ready,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Mark Ready'),
                        ),
                      ),
                    ],
                  ),

                if (order.status == RestaurantOrderStatus.ready)
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.delivery_dining, color: Colors.green),
                        SizedBox(width: 12.w),
                        const Expanded(
                          child: Text(
                            'Order ready for pickup. Delivery partner will arrive soon.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                // View Details Button
                SizedBox(height: 12.h),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailScreen(order: order),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primaryColor),
                  ),
                  child: const Text('View Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDelayDialog(
    BuildContext context,
    RestaurantOrder order,
    RestaurantProvider provider,
  ) {
    int delayMinutes = 10;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Delay Order'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('How many minutes delay?'),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: delayMinutes.toDouble(),
                            min: 5,
                            max: 60,
                            divisions: 11,
                            label: '$delayMinutes min',
                            onChanged: (value) {
                              setState(() {
                                delayMinutes = value.toInt();
                              });
                            },
                            activeColor: Colors.orange,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            '$delayMinutes min',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      provider.delayOrder(order.id, delayMinutes);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Order delayed by $delayMinutes minutes',
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.orange),
                    child: const Text('Confirm'),
                  ),
                ],
              );
            },
          ),
    );
  }

  Color _getStatusColor(RestaurantOrderStatus status) {
    switch (status) {
      case RestaurantOrderStatus.accepted:
        return Colors.blue;
      case RestaurantOrderStatus.preparing:
        return Colors.orange;
      case RestaurantOrderStatus.ready:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(RestaurantOrderStatus status) {
    switch (status) {
      case RestaurantOrderStatus.accepted:
        return 'Accepted';
      case RestaurantOrderStatus.preparing:
        return 'Preparing';
      case RestaurantOrderStatus.ready:
        return 'Ready for Pickup';
      default:
        return '';
    }
  }
}
