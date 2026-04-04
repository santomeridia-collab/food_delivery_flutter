import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/restaurant_owner/model/restaurant_settings_model.dart';

class EarningsSummaryCard extends StatelessWidget {
  final EarningsSummary earnings;

  const EarningsSummaryCard({super.key, required this.earnings});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Earnings Summary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),

          _buildSummaryRow(
            'Today',
            '\$${earnings.todayEarnings.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'This Week',
            '\$${earnings.thisWeekEarnings.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'This Month',
            '\$${earnings.thisMonthEarnings.toStringAsFixed(2)}',
          ),
          Divider(height: 24.h),
          _buildSummaryRow(
            'Total Earnings',
            '\$${earnings.totalEarnings.toStringAsFixed(2)}',
            isTotal: true,
          ),
          SizedBox(height: 12.h),
          _buildSummaryRow('Total Orders', earnings.totalOrders.toString()),
          _buildSummaryRow(
            'Average Order Value',
            '\$${earnings.averageOrderValue.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
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
            value,
            style: TextStyle(
              fontSize: isTotal ? 18.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? AppTheme.primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
}
