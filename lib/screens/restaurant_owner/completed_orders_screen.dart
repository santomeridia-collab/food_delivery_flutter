import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/restaurant_owner/model/restaurant_order_model.dart';
import 'package:food_delivery/screens/restaurant_owner/provider/restaurant_provider.dart';
import 'package:provider/provider.dart';
import 'order_detail_screen.dart';

class CompletedOrdersScreen extends StatefulWidget {
  const CompletedOrdersScreen({super.key});

  @override
  State<CompletedOrdersScreen> createState() => _CompletedOrdersScreenState();
}

class _CompletedOrdersScreenState extends State<CompletedOrdersScreen> {
  String _filter = 'all';
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final completedOrders = restaurantProvider.completedOrders;

    final filteredOrders = _filterOrders(completedOrders);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Orders'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _showDatePicker,
          ),
        ],
      ),
      body:
          completedOrders.isEmpty
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
                      'No completed orders',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Completed orders will appear here',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  if (_filter != 'all' || _dateRange != null)
                    Container(
                      padding: EdgeInsets.all(12.w),
                      margin: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getFilterText(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _filter = 'all';
                                _dateRange = null;
                              });
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await restaurantProvider.refreshData();
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          return _buildCompletedOrderCard(context, order);
                        },
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildCompletedOrderCard(BuildContext context, RestaurantOrder order) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
          // Order Header
          Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.orderNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _formatDate(order.createdAt),
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: const Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Order Body
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Name
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Text(order.customerName),
                  ],
                ),
                SizedBox(height: 8.h),

                // Items Count
                Text(
                  '${order.items.length} items',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),

                SizedBox(height: 12.h),

                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      order.formattedTotal,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // View Details Button
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailScreen(order: order),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primaryColor),
                    minimumSize: Size(double.infinity, 40.h),
                  ),
                  child: const Text('View Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<RestaurantOrder> _filterOrders(List<RestaurantOrder> orders) {
    var filtered = List<RestaurantOrder>.from(orders);

    if (_filter != 'all') {
      // Apply filter logic
    }

    if (_dateRange != null) {
      filtered =
          filtered.where((order) {
            return order.createdAt.isAfter(_dateRange!.start) &&
                order.createdAt.isBefore(
                  _dateRange!.end.add(const Duration(days: 1)),
                );
          }).toList();
    }

    return filtered;
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Orders',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.h),
                  ...['all', 'delivered', 'cancelled'].map((filter) {
                    return RadioListTile(
                      title: Text(filter.toUpperCase()),
                      value: filter,
                      groupValue: _filter,
                      onChanged: (value) {
                        setState(() {
                          _filter = value.toString();
                        });
                        Navigator.pop(context);
                        this.setState(() {});
                      },
                      activeColor: AppTheme.primaryColor,
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDatePicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  String _getFilterText() {
    if (_dateRange != null) {
      return '${_dateRange!.start.day}/${_dateRange!.start.month} - ${_dateRange!.end.day}/${_dateRange!.end.month}';
    }
    return 'Filter applied';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} • ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
