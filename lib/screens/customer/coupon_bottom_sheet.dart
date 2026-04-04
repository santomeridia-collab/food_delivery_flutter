import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'utils/app_theme.dart';

class CouponBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> coupons;
  final double subtotal;
  final Function(String, double) onApplyCoupon;

  const CouponBottomSheet({
    super.key,
    required this.coupons,
    required this.subtotal,
    required this.onApplyCoupon,
  });

  @override
  State<CouponBottomSheet> createState() => _CouponBottomSheetState();
}

class _CouponBottomSheetState extends State<CouponBottomSheet> {
  String _couponCode = '';
  String? _appliedCoupon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apply Coupon',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),

          // Coupon Input
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter coupon code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onChanged: (value) {
                    _couponCode = value.toUpperCase();
                  },
                ),
              ),
              SizedBox(width: 12.w),
              ElevatedButton(
                onPressed:
                    _couponCode.isEmpty
                        ? null
                        : () {
                          final coupon = widget.coupons.firstWhere(
                            (c) => c['code'] == _couponCode,
                            orElse: () => {},
                          );
                          if (coupon.isNotEmpty) {
                            double discount = 0;
                            if (coupon['type'] == 'percentage') {
                              discount =
                                  widget.subtotal * (coupon['discount'] / 100);
                            } else {
                              discount = coupon['discount'].toDouble();
                            }
                            widget.onApplyCoupon(_couponCode, discount);
                            setState(() {
                              _appliedCoupon = _couponCode;
                            });
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid coupon code'),
                              ),
                            );
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text('Apply'),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Available Coupons
          const Text(
            'Available Coupons',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          ...widget.coupons.map((coupon) {
            final isEligible = widget.subtotal >= (coupon['minOrder'] ?? 0);
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color:
                    isEligible
                        ? AppTheme.primaryColor.withOpacity(0.05)
                        : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color:
                      isEligible
                          ? AppTheme.primaryColor.withOpacity(0.3)
                          : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon['code'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                isEligible
                                    ? AppTheme.primaryColor
                                    : Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          coupon['type'] == 'percentage'
                              ? '${coupon['discount']}% OFF'
                              : '\$${coupon['discount']} OFF',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isEligible ? Colors.black87 : Colors.grey,
                          ),
                        ),
                        Text(
                          'Min order \$${coupon['minOrder']}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color:
                                isEligible ? Colors.grey : Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isEligible)
                    TextButton(
                      onPressed: () {
                        double discount = 0;
                        if (coupon['type'] == 'percentage') {
                          discount =
                              widget.subtotal * (coupon['discount'] / 100);
                        } else {
                          discount = coupon['discount'].toDouble();
                        }
                        widget.onApplyCoupon(coupon['code'], discount);
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
