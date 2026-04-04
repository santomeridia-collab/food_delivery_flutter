import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'models/order_model.dart';
import 'providers/order_provider.dart';
import 'utils/app_theme.dart';

class CancelOrderScreen extends StatefulWidget {
  final Order order;
  const CancelOrderScreen({super.key, required this.order});

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  String? _selectedReason;
  final TextEditingController _otherReasonController = TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, String>> _cancellationReasons = [
    {
      'title': 'Order taking too long',
      'description': 'Preparation time is longer than expected',
    },
    {
      'title': 'Wrong item ordered',
      'description': 'I selected the wrong item by mistake',
    },
    {'title': 'Change of mind', 'description': 'I no longer want this order'},
    {
      'title': 'Found better price',
      'description': 'Found better deal elsewhere',
    },
    {
      'title': 'Payment issue',
      'description': 'I want to change payment method',
    },
    {'title': 'Other', 'description': 'Please specify the reason'},
  ];

  @override
  Widget build(BuildContext context) {
    final refundAmount =
        widget.order.total * 0.85; // 85% refund before preparation

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancel Order'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning Card
            Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cancellation Policy',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          'If cancelled before preparation, you\'ll get 85% refund',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Refund Info
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Order Total'),
                      Text(widget.order.formattedTotal),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Refund Amount'),
                      Text(
                        '\$${refundAmount.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'You\'ll lose',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${(widget.order.total - refundAmount).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Cancellation Reasons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const Text(
                'Why do you want to cancel?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 12.h),

            ..._cancellationReasons.asMap().entries.map((entry) {
              final index = entry.key;
              final reason = entry.value;
              final isSelected = _selectedReason == reason['title'];
              return RadioListTile<String>(
                value: reason['title']!,
                groupValue: _selectedReason,
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value;
                  });
                },
                title: Text(reason['title']!),
                subtitle: Text(reason['description']!),
                activeColor: AppTheme.primaryColor,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              );
            }),

            if (_selectedReason == 'Other')
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextFormField(
                  controller: _otherReasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Please specify your reason',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),

            SizedBox(height: 32.h),

            // Cancel Button
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed:
                      _isSubmitting || _selectedReason == null
                          ? null
                          : _cancelOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child:
                      _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Confirm Cancellation'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cancelOrder() async {
    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final refundAmount = widget.order.total * 0.85;

    orderProvider.updateOrderStatus(widget.order.id, OrderStatus.cancelled);
    orderProvider.updateCancellationInfo(
      widget.order.id,
      _selectedReason == 'Other'
          ? _otherReasonController.text
          : _selectedReason!,
      refundAmount,
    );

    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order cancelled successfully')),
    );
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
