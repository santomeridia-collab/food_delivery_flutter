import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/restaurant_owner/model/restaurant_order_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final RestaurantOrder order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.orderNumber}'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Customer Info Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  _buildInfoRow(Icons.person, 'Name', order.customerName),
                  _buildInfoRow(Icons.phone, 'Phone', order.customerPhone),
                  _buildInfoRow(
                    Icons.location_on,
                    'Address',
                    order.customerAddress,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Order Items Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Items',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  ...order.items.map((item) => _buildOrderItemRow(item)),
                  Divider(height: 24.h),
                  _buildPriceRow(
                    'Subtotal',
                    '\$${order.subtotal.toStringAsFixed(2)}',
                  ),
                  _buildPriceRow(
                    'Delivery Fee',
                    '\$${order.deliveryFee.toStringAsFixed(2)}',
                  ),
                  _buildPriceRow('Tax', '\$${order.tax.toStringAsFixed(2)}'),
                  Divider(height: 16.h),
                  _buildPriceRow('Total', order.formattedTotal, isTotal: true),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Payment Info Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  _buildInfoRow(
                    Icons.payment,
                    'Method',
                    order.paymentMethod.toUpperCase(),
                  ),
                  _buildInfoRow(
                    Icons.access_time,
                    'Order Time',
                    _formatDateTime(order.createdAt),
                  ),
                  if (order.acceptedAt != null)
                    _buildInfoRow(
                      Icons.check_circle,
                      'Accepted',
                      _formatDateTime(order.acceptedAt!),
                    ),
                  if (order.readyAt != null)
                    _buildInfoRow(
                      Icons.notifications_active,
                      'Ready',
                      _formatDateTime(order.readyAt!),
                    ),
                  if (order.completedAt != null)
                    _buildInfoRow(
                      Icons.delivery_dining,
                      'Completed',
                      _formatDateTime(order.completedAt!),
                    ),
                ],
              ),
            ),

            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          SizedBox(width: 12.w),
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemRow(OrderItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Text(
                '${item.quantity}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (item.size != null)
                  Text(
                    'Size: ${item.size}',
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                  ),
                if (item.addons != null && item.addons!.isNotEmpty)
                  Text(
                    'Add-ons: ${item.addons!.join(', ')}',
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                  ),
              ],
            ),
          ),
          Text(
            '\$${item.total.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 14.sp : 13.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18.sp : 13.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppTheme.primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} • ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
