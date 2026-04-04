import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/delivery_partener/model/delivery_order_model.dart';
import 'package:food_delivery/screens/delivery_partener/provider/delivery_provider.dart';
import 'package:food_delivery/screens/delivery_partener/widget/delivery_map.dart';
import 'package:provider/provider.dart';

class DeliveryStatusScreen extends StatefulWidget {
  final DeliveryOrder order;
  const DeliveryStatusScreen({super.key, required this.order});

  @override
  State<DeliveryStatusScreen> createState() => _DeliveryStatusScreenState();
}

class _DeliveryStatusScreenState extends State<DeliveryStatusScreen> {
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    final deliveryProvider = Provider.of<DeliveryProvider>(context);
    final order = widget.order;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Delivery #${order.orderNumber}'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Map View
            Expanded(
              flex: 2,
              child: DeliveryMap(
                restaurantLocation: order.restaurantLocation,
                customerLocation: order.customerLocation,
                currentStatus: order.status,
                isNavigating: _isNavigating,
              ),
            ),

            // Status Timeline
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Status Steps
                  Row(
                    children: [
                      _buildStatusStep(
                        'Pickup',
                        order.status == DeliveryOrderStatus.pickedUp ||
                            order.status == DeliveryOrderStatus.onTheWay ||
                            order.status == DeliveryOrderStatus.delivered,
                        order.status == DeliveryOrderStatus.accepted,
                      ),
                      Expanded(
                        child: _buildConnectingLine(order.status.index >= 1),
                      ),
                      _buildStatusStep(
                        'On The Way',
                        order.status == DeliveryOrderStatus.onTheWay ||
                            order.status == DeliveryOrderStatus.delivered,
                        order.status == DeliveryOrderStatus.pickedUp,
                      ),
                      Expanded(
                        child: _buildConnectingLine(order.status.index >= 3),
                      ),
                      _buildStatusStep(
                        'Delivered',
                        order.status == DeliveryOrderStatus.delivered,
                        order.status == DeliveryOrderStatus.onTheWay,
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Order Details
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.restaurant,
                              size: 20,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.restaurantName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    order.restaurantAddress,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.customerName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    order.customerPhone,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.phone,
                                color: AppTheme.primaryColor,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _updateStatus(context, deliveryProvider, order);
                      },
                      icon: Icon(_getButtonIcon(order.status)),
                      label: Text(_getButtonText(order.status)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColor(order.status),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),

                  // Update the OutlinedButton section
                  if (order.status == DeliveryOrderStatus.accepted ||
                      order.status == DeliveryOrderStatus.pickedUp)
                    SizedBox(height: 12.h),
                  if (order.status == DeliveryOrderStatus.accepted ||
                      order.status == DeliveryOrderStatus.pickedUp)
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isNavigating = !_isNavigating;
                        });
                      },
                      icon: Icon(
                        _isNavigating ? Icons.close : Icons.directions,
                      ),
                      label: Text(
                        _isNavigating ? 'Stop Navigation' : 'Start Navigation',
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.primaryColor),
                        minimumSize: Size(double.infinity, 45.h),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusStep(String label, bool isCompleted, bool isCurrent) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isCompleted
                    ? Colors.green
                    : isCurrent
                    ? AppTheme.primaryColor
                    : Colors.grey.shade300,
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.circle_outlined,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color:
                isCompleted || isCurrent ? AppTheme.primaryColor : Colors.grey,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectingLine(bool isActive) {
    return Container(
      height: 2.h,
      color: isActive ? Colors.green : Colors.grey.shade300,
    );
  }

  IconData _getButtonIcon(DeliveryOrderStatus status) {
    switch (status) {
      case DeliveryOrderStatus.accepted:
        return Icons.directions_car;
      case DeliveryOrderStatus.pickedUp:
        return Icons.delivery_dining;
      case DeliveryOrderStatus.onTheWay:
        return Icons.home;
      default:
        return Icons.check;
    }
  }

  String _getButtonText(DeliveryOrderStatus status) {
    switch (status) {
      case DeliveryOrderStatus.accepted:
        return 'Mark as Picked Up';
      case DeliveryOrderStatus.pickedUp:
        return 'Start Delivery';
      case DeliveryOrderStatus.onTheWay:
        return 'Mark as Delivered';
      default:
        return 'Complete';
    }
  }

  Color _getButtonColor(DeliveryOrderStatus status) {
    switch (status) {
      case DeliveryOrderStatus.accepted:
        return Colors.orange;
      case DeliveryOrderStatus.pickedUp:
        return Colors.blue;
      case DeliveryOrderStatus.onTheWay:
        return Colors.green;
      default:
        return AppTheme.primaryColor;
    }
  }

  void _updateStatus(
    BuildContext context,
    DeliveryProvider provider,
    DeliveryOrder order,
  ) {
    switch (order.status) {
      case DeliveryOrderStatus.accepted:
        provider.updateOrderStatus(order.id, DeliveryOrderStatus.pickedUp);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order marked as picked up')),
        );
        break;
      case DeliveryOrderStatus.pickedUp:
        provider.updateOrderStatus(order.id, DeliveryOrderStatus.onTheWay);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Delivery started')));
        break;
      case DeliveryOrderStatus.onTheWay:
        provider.updateOrderStatus(order.id, DeliveryOrderStatus.delivered);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order delivered successfully!')),
        );
        Navigator.pop(context);
        break;
      default:
        break;
    }
  }
}
