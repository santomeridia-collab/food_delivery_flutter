import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback onTimeout;

  const OrderTimer({
    super.key,
    required this.duration,
    required this.onTimeout,
  });

  @override
  State<OrderTimer> createState() => _OrderTimerState();
}

class _OrderTimerState extends State<OrderTimer> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds <= 1) {
        _timer.cancel();
        widget.onTimeout();
      } else {
        setState(() {
          _remaining = Duration(seconds: _remaining.inSeconds - 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _remaining.inMinutes;
    final seconds = _remaining.inSeconds % 60;
    final isWarning = _remaining.inSeconds <= 30;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color:
            isWarning
                ? Colors.red.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 14.sp,
            color: isWarning ? Colors.red : Colors.orange,
          ),
          SizedBox(width: 4.w),
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: isWarning ? Colors.red : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
