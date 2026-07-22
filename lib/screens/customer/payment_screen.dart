import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'models/address_model.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'utils/app_theme.dart';
import '../customer/order_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  final String paymentMethod;
  final Address address;
  final String instructions;
  final DateTime? scheduledDate;
  final bool scheduleOrder;
  final double subtotal;
  final double deliveryFee;
  final double packagingFee;
  final double tax;
  final double tipAmount;
  final double couponDiscount;
  final String? appliedCoupon;

  const PaymentScreen({
    super.key,
    required this.total,
    required this.paymentMethod,
    required this.address,
    required this.instructions,
    this.scheduledDate,
    required this.scheduleOrder,
    required this.subtotal,
    required this.deliveryFee,
    required this.packagingFee,
    required this.tax,
    required this.tipAmount,
    required this.couponDiscount,
    this.appliedCoupon,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  String? _upiId;
  String? _cardNumber;
  String? _cardExpiry;
  String? _cardCvv;
  String? _walletNumber;

  // UPI Apps
  final List<Map<String, dynamic>> _upiApps = [
    {'name': 'Google Pay', 'icon': Icons.account_balance_wallet},
    {'name': 'PhonePe', 'icon': Icons.phone_android},
    {'name': 'Paytm', 'icon': Icons.payment},
    {'name': 'Amazon Pay', 'icon': Icons.shopping_bag},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
          _isProcessing
              ? _buildProcessingPayment()
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount to Pay
                    Container(
                      margin: EdgeInsets.all(16.w),
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Amount to Pay',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '\$${widget.total.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Payment Method Specific UI
                    _buildPaymentMethodUI(),

                    SizedBox(height: 24.h),

                    // Pay Button
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: _processPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: const Text(
                            'Pay Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildPaymentMethodUI() {
    switch (widget.paymentMethod) {
      case 'upi':
        return _buildUPIPayment();
      case 'card':
        return _buildCardPayment();
      case 'wallet':
        return _buildWalletPayment();
      case 'cod':
        return _buildCODPayment();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildUPIPayment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: const Text(
            'Select UPI App',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ..._upiApps.map((app) {
          return ListTile(
            leading: Icon(app['icon'], size: 30),
            title: Text(app['name']),
            trailing: Radio<String>(
              value: app['name'],
              groupValue: _upiId,
              onChanged: (value) {
                setState(() {
                  _upiId = value;
                });
              },
              activeColor: AppTheme.primaryColor,
            ),
            onTap: () {
              setState(() {
                _upiId = app['name'];
              });
            },
          );
        }),
        Padding(
          padding: EdgeInsets.all(16.w),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Enter UPI ID (Optional)',
              hintText: 'username@bank',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _upiId = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCardPayment() {
    return Container(
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
            'Card Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Card Number',
              hintText: '1234 5678 9012 3456',
              prefixIcon: const Icon(Icons.credit_card),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            keyboardType: TextInputType.number,
            maxLength: 19,
            onChanged: (value) {
              _cardNumber = value;
            },
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    hintText: 'MM/YY',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onChanged: (value) {
                    _cardExpiry = value;
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  obscureText: true,
                  onChanged: (value) {
                    _cardCvv = value;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Cardholder Name',
              hintText: 'Name on card',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletPayment() {
    return Container(
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
            'Wallet Balance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Available Balance'),
                Text(
                  '\$50.00',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          const Text(
            'Add Money to Wallet',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 12.w,
            children:
                [10, 20, 50, 100].map((amount) {
                  return ChoiceChip(
                    label: Text('\$$amount'),
                    selected: false,
                    onSelected: (selected) {},
                    selectedColor: AppTheme.primaryColor,
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCODPayment() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
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
          Row(
            children: [
              Icon(Icons.money, size: 30, color: AppTheme.primaryColor),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cash on Delivery',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Pay \$${widget.total.toStringAsFixed(2)} in cash when your order arrives',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Please keep exact change ready for faster delivery',
                    style: TextStyle(fontSize: 12.sp, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingPayment() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 24.h),
          Text(
            'Processing Payment...',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please do not press back',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    // Simulate success (for demo)
    final isSuccess = true;

    setState(() {
      _isProcessing = false;
    });

    if (isSuccess) {
      // Clear cart
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final cartItems = cartProvider.getCartItemsList();

      // Get restaurant info from cart items
      String restaurantId = '';
      String restaurantName = '';
      String restaurantImage = '';

      if (cartItems.isNotEmpty) {
        restaurantId = cartItems.first.restaurantId;
        restaurantName = cartItems.first.restaurantName;
        restaurantImage = cartItems.first.imageUrl ?? '';
      }

      cartProvider.clearCart();

      // Create order with required parameters
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.addOrder(
        total: widget.total,
        address: widget.address,
        items: cartItems,
        paymentMethod: widget.paymentMethod,
        scheduledDate: widget.scheduledDate,
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        restaurantImage: restaurantImage,
      );

      // Navigate to success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (_) => OrderSuccessScreen(
                orderId: 'ORD${DateTime.now().millisecondsSinceEpoch}',
                total: widget.total,
                paymentMethod: widget.paymentMethod,
                isScheduled: widget.scheduleOrder,
                scheduledDate: widget.scheduledDate,
              ),
        ),
      );
    } else {
      // Show failure dialog
      showDialog(
        context: context,
        builder:
            (BuildContext dialogContext) => AlertDialog(
              title: const Text('Payment Failed'),
              content: const Text(
                'Your payment could not be processed. Please try again.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Try Again'),
                ),
              ],
            ),
      );
    }
  }
}
