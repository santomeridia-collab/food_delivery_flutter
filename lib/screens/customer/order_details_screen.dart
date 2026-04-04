import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/cancel_screen.dart';
import 'models/order_model.dart';
import 'utils/app_theme.dart';
import 'widgets/status_timeline.dart';
import 'live_tracking_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.orderNumber}'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (order.canCancel)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CancelOrderScreen(order: order),
                  ),
                );
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Timeline
            Container(
              margin: EdgeInsets.all(16.w),
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
                    'Order Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.h),
                  StatusTimeline(
                    currentStatus: order.status,
                    statusUpdates: [],
                    compact: false,
                  ),
                ],
              ),
            ),

            // Delivery Address
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
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
                    'Delivery Address',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(order.address.street),
                  Text('${order.address.area}, ${order.address.city}'),
                  Text('Pincode: ${order.address.pincode}'),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Order Items
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
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
                    'Order Items',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  ...order.items.map((item) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: const Icon(Icons.fastfood),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.dishName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (item.size != null)
                                  Text(
                                    'Size: ${item.size}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                Text(
                                  'Qty: ${item.quantity}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    );
                  }),
                  Divider(height: 24.h),
                  _buildDetailRow(
                    'Subtotal',
                    order.formattedSubtotal,
                  ), // Fixed: using formattedSubtotal
                  _buildDetailRow('Delivery Fee', '\$2.99'),
                  _buildDetailRow('Tax', '\$1.50'),
                  if (order.status == OrderStatus.cancelled &&
                      order.refundAmount != null)
                    _buildDetailRow(
                      'Refund Amount',
                      '\$${order.refundAmount!.toStringAsFixed(2)}',
                      isRefund: true,
                    ),
                  Divider(height: 16.h),
                  _buildDetailRow('Total', order.formattedTotal, isTotal: true),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Invoice Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: OutlinedButton.icon(
                  onPressed: () => _downloadInvoice(context), // Pass context
                  icon: const Icon(Icons.download),
                  label: const Text('Download Invoice'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 32.h),
          ],
        ),
      ),
      bottomNavigationBar:
          order.isActive
              ? Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LiveTrackingScreen(order: order),
                          ),
                        );
                      },
                      icon: const Icon(Icons.location_on),
                      label: const Text('Track Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              : null,
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isTotal = false,
    bool isRefund = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color:
                  isRefund
                      ? Colors.green
                      : (isTotal ? AppTheme.primaryColor : null),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadInvoice(BuildContext context) {
    // Implement invoice download
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Invoice downloaded')));
  }
}
