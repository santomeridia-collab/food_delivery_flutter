import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/delivery_partener/model/delivery_order_model.dart';

import 'delivery_timer.dart';

class DeliveryOrderCard extends StatelessWidget {
  final DeliveryOrder order;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final bool showTimer;

  const DeliveryOrderCard({
    super.key,
    required this.order,
    required this.onAccept,
    required this.onReject,
    this.showTimer = false,
  });

  @override
  Widget build(BuildContext context) {
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
          // Header
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
                Text(
                  order.orderNumber,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (showTimer)
                  DeliveryTimer(
                    duration: const Duration(seconds: 60),
                    onTimeout: onReject,
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
                // Restaurant
                Row(
                  children: [
                    const Icon(Icons.restaurant, size: 16, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        order.restaurantName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Customer
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Expanded(child: Text(order.customerName)),
                  ],
                ),
                SizedBox(height: 8.h),

                // Distance & Items
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.orange),
                    SizedBox(width: 4.w),
                    Text(
                      order.formattedDistance,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.fastfood, size: 14, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      '${order.items.length} items',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Earnings
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delivery Fee',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    Text(
                      '\$${order.deliveryFee.toStringAsFixed(2)}',
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
                        onPressed: onReject,
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
                        onPressed: onAccept,
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
}
