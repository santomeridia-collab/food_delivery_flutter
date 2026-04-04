import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/coupon_bottom_sheet.dart';
import 'package:food_delivery/screens/customer/widgets/cart_item_card.dart';
import 'package:food_delivery/screens/customer/widgets/tip_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/address_provider.dart';
import 'utils/app_theme.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double _tipAmount = 0;
  String? _appliedCoupon;
  double _couponDiscount = 0;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _coupons = [
    {'code': 'SAVE20', 'discount': 20, 'type': 'percentage', 'minOrder': 20},
    {'code': 'FLAT50', 'discount': 50, 'type': 'fixed', 'minOrder': 30},
    {'code': 'WELCOME10', 'discount': 10, 'type': 'percentage', 'minOrder': 15},
  ];

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);
    final cartItems = cartProvider.cartItems;
    final subtotal = cartProvider.totalAmount;
    final defaultAddress = addressProvider.getDefaultAddress();

    final deliveryFee = 2.99;
    final packagingFee = 0.99;
    final tax = (subtotal * 0.08); // 8% tax
    final total =
        subtotal +
        deliveryFee +
        packagingFee +
        tax +
        _tipAmount -
        _couponDiscount;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Cart'),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          actions: [
            if (cartItems.isNotEmpty)
              TextButton(
                onPressed: () {
                  _showClearCartDialog(context, cartProvider);
                },
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
        body:
            cartItems.isEmpty
                ? _buildEmptyCart()
                : Column(
                  children: [
                    // Item List
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems.values.toList()[index];
                          return CartItemCard(
                            item: item,
                            onQuantityChanged: (newQuantity) {
                              cartProvider.updateQuantity(
                                item.dishId,
                                newQuantity,
                              );
                            },
                            onRemove: () {
                              cartProvider.removeItem(item.dishId);
                            },
                          );
                        },
                      ),
                    ),

                    // Bottom Section
                    Container(
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
                      child: Column(
                        children: [
                          // Coupon Section
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _showCouponBottomSheet();
                              },
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(
                                    0.05,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppTheme.primaryColor.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.local_offer,
                                      color: AppTheme.primaryColor,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        _appliedCoupon != null
                                            ? 'Coupon $_appliedCoupon applied'
                                            : 'Apply Coupon',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight:
                                              _appliedCoupon != null
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color:
                                              _appliedCoupon != null
                                                  ? AppTheme.primaryColor
                                                  : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    if (_appliedCoupon != null)
                                      IconButton(
                                        icon: Icon(Icons.close, size: 16.sp),
                                        onPressed: () {
                                          setState(() {
                                            _appliedCoupon = null;
                                            _couponDiscount = 0;
                                          });
                                        },
                                      ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey,
                                      size: 20.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Tip Section
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _showTipBottomSheet();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.volunteer_activism,
                                    color: AppTheme.primaryColor,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      _tipAmount > 0
                                          ? 'Tip: \$${_tipAmount.toStringAsFixed(2)}'
                                          : 'Add a tip for delivery partner',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color:
                                            _tipAmount > 0
                                                ? AppTheme.primaryColor
                                                : Colors.black87,
                                        fontWeight:
                                            _tipAmount > 0
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                    size: 20.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Bill Breakdown
                          Container(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              children: [
                                _buildBillRow(
                                  'Item Total',
                                  '\$${subtotal.toStringAsFixed(2)}',
                                ),
                                _buildBillRow(
                                  'Delivery Fee',
                                  '\$${deliveryFee.toStringAsFixed(2)}',
                                ),
                                _buildBillRow(
                                  'Packaging Fee',
                                  '\$${packagingFee.toStringAsFixed(2)}',
                                ),
                                _buildBillRow(
                                  'Tax (8%)',
                                  '\$${tax.toStringAsFixed(2)}',
                                ),
                                if (_tipAmount > 0)
                                  _buildBillRow(
                                    'Tip',
                                    '\$${_tipAmount.toStringAsFixed(2)}',
                                  ),
                                if (_couponDiscount > 0)
                                  _buildBillRow(
                                    'Coupon Discount',
                                    '-\$${_couponDiscount.toStringAsFixed(2)}',
                                    isNegative: true,
                                  ),
                                Divider(height: 16.h, thickness: 1),
                                _buildBillRow(
                                  'Total Amount',
                                  '\$${total.toStringAsFixed(2)}',
                                  isTotal: true,
                                ),
                              ],
                            ),
                          ),

                          // Checkout Button
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50.h,
                              child: ElevatedButton(
                                onPressed:
                                    defaultAddress == null
                                        ? () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Please add a delivery address',
                                              ),
                                            ),
                                          );
                                        }
                                        : () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => CheckoutScreen(
                                                    subtotal: subtotal,
                                                    deliveryFee: deliveryFee,
                                                    packagingFee: packagingFee,
                                                    tax: tax,
                                                    tipAmount: _tipAmount,
                                                    couponDiscount:
                                                        _couponDiscount,
                                                    appliedCoupon:
                                                        _appliedCoupon,
                                                    total: total,
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
                                  'Proceed to Checkout',
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
                  ],
                ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80.sp,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add items to get started',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Browse Restaurants'),
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(
    String label,
    String amount, {
    bool isTotal = false,
    bool isNegative = false,
  }) {
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
              color: isTotal ? Colors.black87 : Colors.grey.shade700,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color:
                  isNegative
                      ? Colors.green
                      : isTotal
                      ? AppTheme.primaryColor
                      : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Cart'),
            content: const Text(
              'Are you sure you want to remove all items from your cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  cartProvider.clearCart();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Cart cleared')));
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  void _showCouponBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return CouponBottomSheet(
          coupons: _coupons,
          subtotal:
              Provider.of<CartProvider>(context, listen: false).totalAmount,
          onApplyCoupon: (couponCode, discount) {
            setState(() {
              _appliedCoupon = couponCode;
              _couponDiscount = discount;
            });
          },
        );
      },
    );
  }

  void _showTipBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return TipBottomSheet(
          currentTip: _tipAmount,
          onTipSelected: (tip) {
            setState(() {
              _tipAmount = tip;
            });
          },
        );
      },
    );
  }
}
