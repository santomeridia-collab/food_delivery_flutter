import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/delivery_partener/incentives_screen.dart';
import 'package:food_delivery/screens/delivery_partener/provider/delivery_profile_provider.dart';
import 'package:food_delivery/screens/delivery_partener/widget/earnings_card.dart';
import 'package:provider/provider.dart';

class DeliveryEarningsScreen extends StatelessWidget {
  const DeliveryEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<DeliveryProfileProvider>(context);
    final earnings = profileProvider.earnings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IncentivesScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Total Earnings Card
            Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Earnings',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '\$${earnings.totalEarnings.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Deliveries',
                        earnings.totalDeliveries.toString(),
                        Icons.delivery_dining,
                      ),
                      _buildStatItem(
                        'Avg/Delivery',
                        '\$${earnings.averagePerDelivery.toStringAsFixed(2)}',
                        Icons.trending_up,
                      ),
                      _buildStatItem(
                        'Active Hours',
                        '${earnings.activeHours}h',
                        Icons.access_time,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Earnings Cards
            EarningsCard(
              title: 'Today\'s Earnings',
              amount: earnings.todayEarnings,
              icon: Icons.today,
              color: Colors.blue,
              onTap: () {},
            ),
            EarningsCard(
              title: 'This Week',
              amount: earnings.thisWeekEarnings,
              icon: Icons.calendar_month,
              color: Colors.green,
              onTap: () {},
            ),
            EarningsCard(
              title: 'This Month',
              amount: earnings.thisMonthEarnings,
              icon: Icons.calendar_month,
              color: Colors.orange,
              onTap: () {},
            ),

            SizedBox(height: 16.h),

            // Earnings Chart Placeholder
            Container(
              margin: EdgeInsets.all(16.w),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weekly Earnings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 200.h,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bar_chart,
                            size: 50.sp,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Chart will appear here',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20.sp),
        SizedBox(height: 4.h),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
