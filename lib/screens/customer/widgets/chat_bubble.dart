import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/chat_message.dart';
import '../utils/app_theme.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isCustomer = message.sender == MessageSender.customer;

    return Align(
      alignment: isCustomer ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 12.h,
          left: isCustomer ? 60.w : 0,
          right: isCustomer ? 0 : 60.w,
        ),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isCustomer ? AppTheme.primaryColor : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft:
                isCustomer ? Radius.circular(16.r) : Radius.circular(4.r),
            bottomRight:
                isCustomer ? Radius.circular(4.r) : Radius.circular(16.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sender Name
            if (!isCustomer)
              Text(
                _getSenderName(message.sender),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            SizedBox(height: isCustomer ? 0 : 4.h),

            // Message Text
            Text(
              message.text,
              style: TextStyle(
                fontSize: 14.sp,
                color: isCustomer ? Colors.white : Colors.black87,
              ),
            ),

            SizedBox(height: 4.h),

            // Timestamp
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10.sp,
                color: isCustomer ? Colors.white70 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSenderName(MessageSender sender) {
    switch (sender) {
      case MessageSender.customer:
        return 'You';
      case MessageSender.restaurant:
        return 'Restaurant';
      case MessageSender.delivery:
        return 'Delivery Partner';
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
