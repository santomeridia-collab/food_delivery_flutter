import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/delivery_partener/delivery_status_screen.dart';
import 'package:food_delivery/screens/delivery_partener/model/delivery_order_model.dart';
import 'package:food_delivery/screens/delivery_partener/provider/delivery_provider.dart';
import 'package:provider/provider.dart';

class ActiveDeliveryScreen extends StatelessWidget {
  const ActiveDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deliveryProvider = Provider.of<DeliveryProvider>(context);
    final activeOrders = deliveryProvider.activeOrders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Deliveries'),
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
                      Icons.delivery_dining,
                      size: 80.sp,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No active deliveries',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Accepted deliveries will appear here',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: activeOrders.length,
                itemBuilder: (context, index) {
                  final order = activeOrders[index];
                  return _buildActiveOrderCard(
                    context,
                    order,
                    deliveryProvider,
                  );
                },
              ),
    );
  }

  Widget _buildActiveOrderCard(
    BuildContext context,
    DeliveryOrder order,
    DeliveryProvider provider,
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
          // Header
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
                      order.orderNumber,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Info
                Row(
                  children: [
                    const Icon(Icons.restaurant, size: 16, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.restaurantName,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            order.restaurantAddress,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Customer Info
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            order.customerAddress,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Distance and Time
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.orange),
                    SizedBox(width: 4.w),
                    Text(
                      order.formattedDistance,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Icons.access_time, size: 16, color: Colors.blue),
                    SizedBox(width: 4.w),
                    Text(
                      '${order.estimatedTime} min',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DeliveryStatusScreen(order: order),
                        ),
                      );
                    },
                    icon: Icon(
                      order.status == DeliveryOrderStatus.accepted
                          ? Icons.directions_car
                          : Icons.location_on,
                    ),
                    label: Text(
                      order.status == DeliveryOrderStatus.accepted
                          ? 'Navigate to Restaurant'
                          : order.status == DeliveryOrderStatus.pickedUp
                          ? 'Navigate to Customer'
                          : 'Continue Delivery',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(DeliveryOrderStatus status) {
    switch (status) {
      case DeliveryOrderStatus.accepted:
        return Colors.blue;
      case DeliveryOrderStatus.pickedUp:
        return Colors.orange;
      case DeliveryOrderStatus.onTheWay:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(DeliveryOrderStatus status) {
    switch (status) {
      case DeliveryOrderStatus.accepted:
        return 'Accepted';
      case DeliveryOrderStatus.pickedUp:
        return 'Picked Up';
      case DeliveryOrderStatus.onTheWay:
        return 'On The Way';
      default:
        return 'Active';
    }
  }
}
