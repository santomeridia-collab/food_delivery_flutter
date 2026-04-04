import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/payment_screen.dart';
import 'package:food_delivery/screens/customer/widgets/payment_method_card.dart';
import 'package:provider/provider.dart';
import 'providers/address_provider.dart';
import 'utils/app_theme.dart';
import '../customer/address_list_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final double subtotal;
  final double deliveryFee;
  final double packagingFee;
  final double tax;
  final double tipAmount;
  final double couponDiscount;
  final String? appliedCoupon;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.packagingFee,
    required this.tax,
    required this.tipAmount,
    required this.couponDiscount,
    this.appliedCoupon,
    required this.total,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedAddressId;
  String _selectedPaymentMethod = 'card';
  TextEditingController _instructionsController = TextEditingController();
  DateTime? _scheduledDate;
  bool _scheduleOrder = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'upi', 'name': 'UPI', 'icon': Icons.qr_code, 'color': Colors.purple},
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'icon': Icons.credit_card,
      'color': Colors.blue,
    },
    {
      'id': 'wallet',
      'name': 'Wallet',
      'icon': Icons.account_balance_wallet,
      'color': Colors.green,
    },
    {
      'id': 'cod',
      'name': 'Cash on Delivery',
      'icon': Icons.money,
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final addresses = addressProvider.addresses;
    final defaultAddress = addressProvider.getDefaultAddress();

    if (_selectedAddressId == null && defaultAddress != null) {
      _selectedAddressId = defaultAddress.id;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Section
            Container(
              margin: EdgeInsets.all(16.w),
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
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddressListScreen(),
                              ),
                            );
                            if (result == true && mounted) {
                              setState(() {});
                            }
                          },
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                  ),
                  if (addresses.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: const Text(
                        'No addresses saved. Please add an address.',
                      ),
                    )
                  else
                    ...addresses.map((address) {
                      final isSelected = _selectedAddressId == address.id;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAddressId = address.id;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? AppTheme.primaryColor.withOpacity(0.05)
                                    : Colors.transparent,
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Row(
                            children: [
                              Radio(
                                value: address.id,
                                groupValue: _selectedAddressId,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAddressId = value;
                                  });
                                },
                                activeColor: AppTheme.primaryColor,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          address.label,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (address.isDefault)
                                          Container(
                                            margin: EdgeInsets.only(left: 8.w),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 2.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                            child: const Text(
                                              'Default',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(address.street),
                                    Text(
                                      '${address.area}, ${address.city} - ${address.pincode}',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),

            // Payment Method Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
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
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ..._paymentMethods.map((method) {
                    return PaymentMethodCard(
                      method: method,
                      isSelected: _selectedPaymentMethod == method['id'],
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = method['id'];
                        });
                      },
                    );
                  }),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Delivery Instructions
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
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
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: const Text(
                      'Delivery Instructions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: TextFormField(
                      controller: _instructionsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'e.g., Gate code, landmark, etc.',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Schedule Order
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
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
                  SwitchListTile(
                    title: const Text('Schedule for Later'),
                    subtitle: const Text('Choose a future delivery time'),
                    value: _scheduleOrder,
                    onChanged: (value) {
                      setState(() {
                        _scheduleOrder = value;
                      });
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                  if (_scheduleOrder)
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('Select Date & Time'),
                        subtitle:
                            _scheduledDate != null
                                ? Text(
                                  '${_scheduledDate!.day}/${_scheduledDate!.month}/${_scheduledDate!.year} at ${_scheduledDate!.hour}:${_scheduledDate!.minute.toString().padLeft(2, '0')}',
                                )
                                : null,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 30),
                            ),
                          );
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() {
                                _scheduledDate = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                              });
                            }
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Order Summary
            Container(
              margin: EdgeInsets.all(16.w),
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
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        _buildSummaryRow(
                          'Subtotal',
                          '\$${widget.subtotal.toStringAsFixed(2)}',
                        ),
                        _buildSummaryRow(
                          'Delivery Fee',
                          '\$${widget.deliveryFee.toStringAsFixed(2)}',
                        ),
                        _buildSummaryRow(
                          'Packaging Fee',
                          '\$${widget.packagingFee.toStringAsFixed(2)}',
                        ),
                        _buildSummaryRow(
                          'Tax (8%)',
                          '\$${widget.tax.toStringAsFixed(2)}',
                        ),
                        if (widget.tipAmount > 0)
                          _buildSummaryRow(
                            'Tip',
                            '\$${widget.tipAmount.toStringAsFixed(2)}',
                          ),
                        if (widget.couponDiscount > 0)
                          _buildSummaryRow(
                            'Coupon Discount',
                            '-\$${widget.couponDiscount.toStringAsFixed(2)}',
                          ),
                        Divider(height: 16.h, thickness: 1),
                        _buildSummaryRow(
                          'Total',
                          '\$${widget.total.toStringAsFixed(2)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),

            SizedBox(height: 80.h),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed:
                  _selectedAddressId == null
                      ? null
                      : () {
                        final selectedAddress = addressProvider.addresses
                            .firstWhere((a) => a.id == _selectedAddressId);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => PaymentScreen(
                                  total: widget.total,
                                  paymentMethod: _selectedPaymentMethod,
                                  address: selectedAddress,
                                  instructions: _instructionsController.text,
                                  scheduledDate: _scheduledDate,
                                  scheduleOrder: _scheduleOrder,
                                  subtotal: widget.subtotal,
                                  deliveryFee: widget.deliveryFee,
                                  packagingFee: widget.packagingFee,
                                  tax: widget.tax,
                                  tipAmount: widget.tipAmount,
                                  couponDiscount: widget.couponDiscount,
                                  appliedCoupon: widget.appliedCoupon,
                                ),
                          ),
                        );
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text(
                'Place Order',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppTheme.primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }
}
