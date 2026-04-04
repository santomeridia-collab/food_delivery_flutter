import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/order_model.dart';
import '../utils/app_theme.dart';

class StatusTimeline extends StatelessWidget {
  final OrderStatus currentStatus;
  final List<OrderStatusUpdate> statusUpdates;
  final bool compact;

  const StatusTimeline({
    super.key,
    required this.currentStatus,
    required this.statusUpdates,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = [
      {
        'status': OrderStatus.confirmed,
        'label': 'Confirmed',
        'icon': Icons.check_circle_outline,
      },
      {
        'status': OrderStatus.preparing,
        'label': 'Preparing',
        'icon': Icons.restaurant,
      },
      {
        'status': OrderStatus.ready,
        'label': 'Ready',
        'icon': Icons.check_circle,
      },
      {
        'status': OrderStatus.pickedUp,
        'label': 'Picked Up',
        'icon': Icons.shopping_bag,
      },
      {
        'status': OrderStatus.onTheWay,
        'label': 'On The Way',
        'icon': Icons.delivery_dining,
      },
      {
        'status': OrderStatus.delivered,
        'label': 'Delivered',
        'icon': Icons.home,
      },
    ];

    final currentIndex = statuses.indexWhere(
      (s) => s['status'] == currentStatus,
    );

    return Column(
      children: [
        if (!compact)
          ...statuses.asMap().entries.map((entry) {
            final index = entry.key;
            final status = entry.value;
            final isCompleted = index <= currentIndex;
            final isCurrent = index == currentIndex;

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color:
                          isCompleted
                              ? AppTheme.primaryColor
                              : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      status['icon'] as IconData,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          status['label'] as String,
                          style: TextStyle(
                            fontWeight:
                                isCurrent ? FontWeight.bold : FontWeight.normal,
                            color:
                                isCompleted
                                    ? AppTheme.primaryColor
                                    : Colors.grey,
                          ),
                        ),
                        if (isCurrent && statusUpdates.isNotEmpty)
                          Text(
                            _formatTime(
                              statusUpdates
                                  .firstWhere(
                                    (u) => u.status == currentStatus,
                                    orElse: () => statusUpdates.first,
                                  )
                                  .timestamp,
                            ),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (index < statuses.length - 1 && !compact)
                    Container(
                      width: 2.w,
                      height: 30.h,
                      color:
                          isCompleted
                              ? AppTheme.primaryColor
                              : Colors.grey.shade200,
                    ),
                ],
              ),
            );
          }),

        if (compact)
          SizedBox(
            height: 80.h,
            child: Row(
              children:
                  statuses.asMap().entries.map((entry) {
                    final index = entry.key;
                    final status = entry.value;
                    final isCompleted = index <= currentIndex;

                    return Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color:
                                  isCompleted
                                      ? AppTheme.primaryColor
                                      : Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              status['icon'] as IconData,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            status['label'] as String,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color:
                                  isCompleted
                                      ? AppTheme.primaryColor
                                      : Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
