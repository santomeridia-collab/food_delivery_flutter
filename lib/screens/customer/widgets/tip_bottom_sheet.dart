import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_theme.dart';

class TipBottomSheet extends StatefulWidget {
  final double currentTip;
  final Function(double) onTipSelected;

  const TipBottomSheet({
    super.key,
    required this.currentTip,
    required this.onTipSelected,
  });

  @override
  State<TipBottomSheet> createState() => _TipBottomSheetState();
}

class _TipBottomSheetState extends State<TipBottomSheet> {
  late double _selectedTip;

  final List<double> _tipOptions = [1, 2, 3, 4, 5];
  double _customTip = 0;

  @override
  void initState() {
    super.initState();
    _selectedTip = widget.currentTip;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tip Delivery Partner',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            'Thank your delivery partner for their service',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          SizedBox(height: 24.h),

          // Tip Options
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children:
                _tipOptions.map((tip) {
                  final isSelected = _selectedTip == tip;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTip = tip;
                        _customTip = 0;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppTheme.primaryColor
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        '\$$tip',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),

          SizedBox(height: 16.h),

          // Custom Tip
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Custom Tip Amount',
              hintText: 'Enter amount',
              prefixIcon: const Icon(Icons.volunteer_activism),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _customTip = double.parse(value);
                  _selectedTip = 0;
                });
              }
            },
          ),

          SizedBox(height: 24.h),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    widget.onTipSelected(0);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text('No Tip'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final tip = _customTip > 0 ? _customTip : _selectedTip;
                    widget.onTipSelected(tip);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text('Apply Tip'),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
