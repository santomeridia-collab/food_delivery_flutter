import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/restaurant_owner/model/restaurant_stats_model.dart';

class EarningsChart extends StatelessWidget {
  final List<DailyEarning> earnings;

  const EarningsChart({super.key, required this.earnings});

  @override
  Widget build(BuildContext context) {
    if (earnings.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final maxEarning = earnings
        .map((e) => e.amount)
        .reduce((a, b) => a > b ? a : b);
    final maxBarHeight = 120.0; // Reduced from 150 to prevent overflow

    return SizedBox(
      height: 180.h, // Fixed height for the chart
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children:
              earnings.map((earning) {
                // Calculate height
                double barHeight = 10.0;
                if (maxEarning > 0) {
                  barHeight = (earning.amount / maxEarning) * maxBarHeight;
                  if (barHeight < 10.0) barHeight = 10.0;
                }

                final dayName = _getDayName(earning.date.weekday);

                return Container(
                  width: 55.w, // Slightly wider
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end, // Align to bottom
                    children: [
                      // Amount text
                      Text(
                        '\$${earning.amount.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      // Bar
                      Container(
                        width: 28.w,
                        height: barHeight.h,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(6.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // Day name
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      // Order count
                      Text(
                        '${earning.orders}',
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      SizedBox(height: 4.h), // Bottom padding
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}
