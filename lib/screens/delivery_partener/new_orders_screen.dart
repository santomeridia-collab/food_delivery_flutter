import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/delivery_partener/model/delivery_order_model.dart';
import 'package:food_delivery/screens/delivery_partener/provider/delivery_provider.dart';
import 'package:food_delivery/screens/delivery_partener/widget/delivery_order_card.dart';
import 'package:provider/provider.dart';

class NewOrdersScreen extends StatelessWidget {
  const NewOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deliveryProvider = Provider.of<DeliveryProvider>(context);
    final newOrders = deliveryProvider.newOrders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Orders'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (newOrders.isNotEmpty)
            TextButton(
              onPressed: () {
                _showAcceptAllDialog(context, deliveryProvider);
              },
              child: const Text('Accept All'),
            ),
        ],
      ),
      body:
          newOrders.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 80.sp,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No new orders',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'New delivery requests will appear here',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: () async {
                  await deliveryProvider.refreshData();
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: newOrders.length,
                  itemBuilder: (context, index) {
                    final order = newOrders[index];
                    return DeliveryOrderCard(
                      order: order,
                      onAccept: () {
                        deliveryProvider.acceptOrder(order.id);
                      },
                      onReject: () {
                        _showRejectDialog(context, order, deliveryProvider);
                      },
                      showTimer: true,
                    );
                  },
                ),
              ),
    );
  }

  void _showRejectDialog(
    BuildContext context,
    DeliveryOrder order,
    DeliveryProvider provider,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reject Order'),
            content: const Text(
              'Are you sure you want to reject this delivery?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  provider.rejectOrder(order.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order rejected')),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Reject'),
              ),
            ],
          ),
    );
  }

  void _showAcceptAllDialog(BuildContext context, DeliveryProvider provider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Accept All Orders'),
            content: const Text(
              'Are you sure you want to accept all pending deliveries?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  provider.acceptAllOrders();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All orders accepted')),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.green),
                child: const Text('Accept All'),
              ),
            ],
          ),
    );
  }
}
