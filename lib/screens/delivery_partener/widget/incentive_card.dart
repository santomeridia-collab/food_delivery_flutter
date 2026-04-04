import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/delivery_partener/model/delivery_earnings_model.dart';

class IncentiveCard extends StatelessWidget {
  final Incentive incentive;

  const IncentiveCard({super.key, required this.incentive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color:
              incentive.isCompleted
                  ? Colors.green
                  : Colors.orange.withOpacity(0.3),
        ),
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
          Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: _getTypeColor(incentive.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    _getTypeIcon(incentive.type),
                    color: _getTypeColor(incentive.type),
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        incentive.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        incentive.description,
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '\$${incentive.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    if (incentive.isCompleted)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: const Text(
                          'Earned',
                          style: TextStyle(fontSize: 10, color: Colors.green),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (!incentive.isCompleted)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress: ${incentive.progress}/${incentive.target}',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      Text(
                        '${(incentive.progressPercentage * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: LinearProgressIndicator(
                      value: incentive.progressPercentage,
                      backgroundColor: Colors.grey.shade200,
                      color: _getTypeColor(incentive.type),
                      minHeight: 8.h,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'bonus':
        return Icons.card_giftcard;
      case 'peak':
        return Icons.timer;
      case 'referral':
        return Icons.people;
      default:
        return Icons.emoji_events;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'bonus':
        return Colors.purple;
      case 'peak':
        return Colors.orange;
      case 'referral':
        return Colors.blue;
      default:
        return Colors.green;
    }
  }
}
