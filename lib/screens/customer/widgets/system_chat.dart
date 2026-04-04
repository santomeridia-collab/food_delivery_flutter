import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/models/chat_message.dart';

class SystemMessageBubble extends StatelessWidget {
  final ChatMessage message;
  const SystemMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 14.sp, color: Colors.grey.shade600),
          SizedBox(width: 8.w),
          Text(
            message.text,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
