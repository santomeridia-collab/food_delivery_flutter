import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/delivery_partener/provider/delivery_profile_provider.dart';
import 'package:food_delivery/screens/delivery_partener/widget/incentive_card.dart';
import 'package:provider/provider.dart';

class IncentivesScreen extends StatelessWidget {
  const IncentivesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<DeliveryProfileProvider>(context);
    final incentives = profileProvider.incentives;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incentives & Bonuses'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          incentives.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 80.sp,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No incentives available',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Complete more deliveries to earn bonuses',
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
                itemCount: incentives.length,
                itemBuilder: (context, index) {
                  final incentive = incentives[index];
                  return IncentiveCard(incentive: incentive);
                },
              ),
    );
  }
}
