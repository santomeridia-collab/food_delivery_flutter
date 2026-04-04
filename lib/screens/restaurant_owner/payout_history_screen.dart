import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/restaurant_owner/provider/restaurant_settings_provider.dart';
import 'package:food_delivery/screens/restaurant_owner/widget/payout_card.dart';
import 'package:provider/provider.dart';

class PayoutHistoryScreen extends StatelessWidget {
  const PayoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final payouts = Provider.of<RestaurantSettingsProvider>(context).payouts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payout History'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          payouts.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 80.sp,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No payout history',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Your payout requests will appear here',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: payouts.length,
                itemBuilder: (context, index) {
                  final payout = payouts[index];
                  return PayoutCard(payout: payout);
                },
              ),
    );
  }
}
