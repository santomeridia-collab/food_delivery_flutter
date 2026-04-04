import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../models/dish_model.dart';
import '../providers/cart_provider.dart';
import '../utils/app_theme.dart';

class CustomizationBottomSheet extends StatefulWidget {
  final Dish dish;
  const CustomizationBottomSheet({super.key, required this.dish});

  @override
  State<CustomizationBottomSheet> createState() =>
      _CustomizationBottomSheetState();
}

class _CustomizationBottomSheetState extends State<CustomizationBottomSheet> {
  String? _selectedSize;
  final List<String> _selectedAddons = [];
  int _quantity = 1;
  double _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _totalPrice = widget.dish.finalPrice;
    if (widget.dish.sizes != null && widget.dish.sizes!.isNotEmpty) {
      _selectedSize = widget.dish.sizes![0];
    }
  }

  void _updateTotalPrice() {
    double price = widget.dish.finalPrice * _quantity;
    // Add addons price (simplified - each addon adds $0.50)
    price += _selectedAddons.length * 0.5 * _quantity;
    setState(() {
      _totalPrice = price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customize ${widget.dish.name}',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Size Selection
          if (widget.dish.sizes != null && widget.dish.sizes!.isNotEmpty) ...[
            const Text(
              'Select Size',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              children:
                  widget.dish.sizes!.map((size) {
                    final isSelected = _selectedSize == size;
                    return ChoiceChip(
                      label: Text(size),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedSize = size;
                        });
                        _updateTotalPrice();
                      },
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: Colors.grey.shade100,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    );
                  }).toList(),
            ),
            SizedBox(height: 16.h),
          ],

          // Add-ons
          if (widget.dish.addons.isNotEmpty) ...[
            const Text(
              'Add-ons',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            ...widget.dish.addons.map((addon) {
              return CheckboxListTile(
                title: Row(
                  children: [
                    Expanded(child: Text(addon)),
                    Text(
                      '+ \$0.50',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                value: _selectedAddons.contains(addon),
                onChanged: (checked) {
                  setState(() {
                    if (checked!) {
                      _selectedAddons.add(addon);
                    } else {
                      _selectedAddons.remove(addon);
                    }
                  });
                  _updateTotalPrice();
                },
                activeColor: AppTheme.primaryColor,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
            SizedBox(height: 16.h),
          ],

          // Quantity
          const Text(
            'Quantity',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                          });
                          _updateTotalPrice();
                        }
                      },
                      constraints: BoxConstraints(
                        minWidth: 40.w,
                        minHeight: 40.h,
                      ),
                    ),
                    Container(
                      width: 40.w,
                      child: Text(
                        '$_quantity',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                        _updateTotalPrice();
                      },
                      constraints: BoxConstraints(
                        minWidth: 40.w,
                        minHeight: 40.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Add to Cart Button
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Price',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final cartProvider = Provider.of<CartProvider>(
                      context,
                      listen: false,
                    );

                    // Fixed: Added restaurantName parameter
                    cartProvider.addItem(
                      widget.dish.id,
                      widget.dish.name,
                      _totalPrice / _quantity, // Price per unit
                      widget.dish.restaurantId,
                      widget.dish.restaurantName, // Added restaurantName
                      quantity: _quantity,
                      size: _selectedSize,
                      addons:
                          _selectedAddons.isNotEmpty ? _selectedAddons : null,
                      imageUrl: widget.dish.imageUrl,
                    );

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added ${_quantity}x ${widget.dish.name} to cart',
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    minimumSize: Size(double.infinity, 48.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
