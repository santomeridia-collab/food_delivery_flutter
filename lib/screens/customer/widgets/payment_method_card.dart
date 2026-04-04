import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_theme.dart';

class PaymentMethodCard extends StatelessWidget {
  final Map<String, dynamic> method;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppTheme.primaryColor.withOpacity(0.05)
                  : Colors.transparent,
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Icon(method['icon'], size: 30, color: method['color']),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(method['name'], style: const TextStyle(fontSize: 16)),
            ),
            Radio(
              value: method['id'],
              groupValue: isSelected ? method['id'] : null,
              onChanged: (value) => onTap(),
              activeColor: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
