import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/customer_home.dart';
import 'utils/app_theme.dart';
import 'order_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final double total;
  final String paymentMethod;
  final bool isScheduled;
  final DateTime? scheduledDate;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.total,
    required this.paymentMethod,
    this.isScheduled = false,
    this.scheduledDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Animation
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 24.h),

              // Success Message
              Text(
                isScheduled ? 'Order Scheduled!' : 'Order Placed Successfully!',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                isScheduled
                    ? 'Your order has been scheduled for ${_formatDate(scheduledDate)}'
                    : 'Your order has been placed and will be delivered soon',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),

              // Order Details Card
              Container(
                padding: EdgeInsets.all(20.w),
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
                  children: [
                    _buildDetailRow('Order ID', orderId),
                    _buildDetailRow(
                      'Total Amount',
                      '\$${total.toStringAsFixed(2)}',
                    ),
                    _buildDetailRow('Payment Method', _getPaymentMethodName()),
                    if (isScheduled && scheduledDate != null)
                      _buildDetailRow(
                        'Scheduled For',
                        _formatDate(scheduledDate),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CustomerHomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: const Text(
                        'Continue Shopping',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OrdersScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'View Order Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodName() {
    switch (paymentMethod) {
      case 'upi':
        return 'UPI';
      case 'card':
        return 'Credit/Debit Card';
      case 'wallet':
        return 'Wallet';
      case 'cod':
        return 'Cash on Delivery';
      default:
        return paymentMethod;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
