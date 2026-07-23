import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/restaurant_owner/model/restaurant_order_model.dart';
import 'package:food_delivery/screens/restaurant_owner/provider/restaurant_provider.dart';
import 'package:food_delivery/screens/restaurant_owner/widget/order_timer.dart';
import 'package:provider/provider.dart';

class IncomingOrdersScreen extends StatefulWidget {
  const IncomingOrdersScreen({super.key});

  @override
  State<IncomingOrdersScreen> createState() => _IncomingOrdersScreenState();
}

class _IncomingOrdersScreenState extends State<IncomingOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final pendingOrders = restaurantProvider.pendingOrders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incoming Orders'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (pendingOrders.isNotEmpty)
            TextButton(
              onPressed: () {
                _showAcceptAllDialog(context, restaurantProvider);
              },
              child: const Text('Accept All'),
            ),
        ],
      ),
      body:
          pendingOrders.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 80.sp,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No incoming orders',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'New orders will appear here',
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
                  itemCount: pendingOrders.length,
                  itemBuilder: (context, index) {
                    final order = pendingOrders[index];
                    return _buildIncomingOrderCard(
                      context,
                      order,
                      restaurantProvider,
                    );
                  },
                ),
              ),
    );
  }

  Widget _buildIncomingOrderCard(
    BuildContext context,
    RestaurantOrder order,
    RestaurantProvider provider,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
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
              color: Colors.orange.withOpacity(0.05),
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
                    Text(
                      _formatTime(order.createdAt),
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
                OrderTimer(
                  duration: const Duration(seconds: 60),
                  onTimeout: () {
                    provider.rejectOrder(order.id, 'Auto-cancelled: Timeout');
                  },
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
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Text(order.customerPhone),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        order.customerAddress,
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Order Items Preview
                const Text(
                  'Order Items',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8.h),
                ...order.items.take(2).map((item) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text(
                      '${item.quantity}x ${item.name}',
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  );
                }),
                if (order.items.length > 2)
                  Text(
                    '+${order.items.length - 2} more items',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),

                SizedBox(height: 16.h),

                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(fontWeight: FontWeight.bold),
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

                SizedBox(height: 16.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _showRejectDialog(context, order, provider);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: const Text('Reject'),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          provider.acceptOrder(order.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(
    BuildContext context,
    RestaurantOrder order,
    RestaurantProvider provider,
  ) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reject Order'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please provide a reason for rejection:'),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Reason...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
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
                  final reason = reasonController.text.trim();
                  if (reason.isNotEmpty) {
                    provider.rejectOrder(order.id, reason);
                    Navigator.pop(context);
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Reject'),
              ),
            ],
          ),
    );
  }

  void _showAcceptAllDialog(BuildContext context, RestaurantProvider provider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Accept All Orders'),
            content: const Text(
              'Are you sure you want to accept all pending orders?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  provider.acceptAllOrders();
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.green),
                child: const Text('Accept All'),
              ),
            ],
          ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
