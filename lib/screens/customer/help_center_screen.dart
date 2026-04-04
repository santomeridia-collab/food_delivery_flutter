import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/widgets/faq_item.dart';
import 'models/faq_model.dart';
import 'utils/app_theme.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Order',
    'Payment',
    'Delivery',
    'Account',
    'Refund',
  ];

  final List<FAQ> _faqs = [
    FAQ(
      id: '1',
      question: 'How do I track my order?',
      answer:
          'You can track your order in real-time from the "My Orders" section. Tap on the active order and select "Track Order" to see the delivery partner\'s location.',
      category: 'Order',
    ),
    FAQ(
      id: '2',
      question: 'What payment methods are accepted?',
      answer:
          'We accept Credit/Debit Cards, UPI, Net Banking, Wallets, and Cash on Delivery.',
      category: 'Payment',
    ),
    FAQ(
      id: '3',
      question: 'How can I cancel my order?',
      answer:
          'Orders can be cancelled from the Order Details screen before the restaurant starts preparing. Cancellation fees may apply.',
      category: 'Order',
    ),
    FAQ(
      id: '4',
      question: 'What is the refund policy?',
      answer:
          'Refunds are processed within 5-7 business days. The amount is credited back to the original payment method.',
      category: 'Refund',
    ),
    FAQ(
      id: '5',
      question: 'How do I change my delivery address?',
      answer:
          'You can add/edit addresses from Profile > Addresses section. Select your preferred address before placing the order.',
      category: 'Delivery',
    ),
    FAQ(
      id: '6',
      question: 'How can I reset my password?',
      answer:
          'Go to Login screen > Forgot Password. Enter your registered email to receive reset instructions.',
      category: 'Account',
    ),
  ];

  List<FAQ> get _filteredFaqs {
    var filtered = _faqs;

    if (_selectedCategory != 'All') {
      filtered =
          filtered.where((faq) => faq.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered
              .where(
                (faq) =>
                    faq.question.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    faq.answer.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for help...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Categories
          SizedBox(
            height: 50.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: AppTheme.primaryColor.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color:
                          isSelected ? AppTheme.primaryColor : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          // FAQs List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _filteredFaqs.length,
              itemBuilder: (context, index) {
                return FAQItem(faq: _filteredFaqs[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
