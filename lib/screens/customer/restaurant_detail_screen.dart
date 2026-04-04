import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/models/dish_model.dart';
import 'package:food_delivery/screens/customer/models/restaurant_model.dart';
import 'package:food_delivery/screens/customer/models/review_model.dart';
import 'package:food_delivery/screens/customer/providers/cart_provider.dart';
import 'package:food_delivery/screens/customer/add_review.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/customer/widgets/customization_buttom_sheet.dart';
import 'package:food_delivery/screens/customer/widgets/menu_item_card.dart';
import 'package:food_delivery/screens/customer/widgets/review_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  String _selectedCategory = 'All';

  final List<String> _menuCategories = [
    'All',
    'Popular',
    'Pizza',
    'Burgers',
    'Sides',
    'Beverages',
    'Desserts',
  ];

  final List<Dish> _menuItems = [
    Dish(
      id: '1',
      name: 'Margherita Pizza',
      imageUrl: 'assets/pizzahut.png',
      description: 'Fresh mozzarella, tomato sauce, basil leaves',
      price: 12.99,
      discountedPrice: 9.99,
      isVeg: true,
      rating: 4,
      reviewCount: 123,
      restaurantId: '1',
      restaurantName: 'Pizza Hut',
      addons: ['Extra Cheese', 'Olives', 'Mushrooms', 'Jalapenos'],
      sizes: ['Small', 'Medium', 'Large'],
    ),
    Dish(
      id: '2',
      name: 'Pepperoni Pizza',
      imageUrl: 'assets/pizzahut.png',
      description: 'Pepperoni, mozzarella, tomato sauce',
      price: 14.99,
      discountedPrice: null,
      isVeg: false,
      rating: 5,
      reviewCount: 89,
      restaurantId: '1',
      restaurantName: 'Pizza Hut',
      addons: ['Extra Pepperoni', 'Jalapenos', 'Olives'],
      sizes: ['Small', 'Medium', 'Large'],
    ),
    Dish(
      id: '3',
      name: 'Garlic Bread',
      imageUrl: 'assets/pizzahut.png',
      description: 'Toasted bread with garlic butter',
      price: 4.99,
      discountedPrice: null,
      isVeg: true,
      rating: 4,
      reviewCount: 45,
      restaurantId: '1',
      restaurantName: 'Pizza Hut',
      addons: ['Cheese Dip', 'Marinara Sauce'],
      sizes: ['4 pcs', '8 pcs'],
    ),
    Dish(
      id: '4',
      name: 'Coca-Cola',
      imageUrl: 'assets/pizzahut.png',
      description: 'Chilled soft drink',
      price: 2.49,
      discountedPrice: null,
      isVeg: true,
      rating: 4,
      reviewCount: 67,
      restaurantId: '1',
      restaurantName: 'Pizza Hut',
      addons: ['Extra Ice', 'Lemon Slice'],
      sizes: ['Small', 'Medium', 'Large'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // Restaurant Header
            SliverAppBar(
              expandedHeight: 280.h,
              pinned: true,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Cover Image
                    Image.asset(widget.restaurant.imageUrl, fit: BoxFit.cover),
                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    // Restaurant Info Overlay
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.restaurant.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              RatingBar.builder(
                                initialRating: widget.restaurant.rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 14,
                                itemBuilder:
                                    (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                onRatingUpdate: (rating) {},
                                ignoreGestures: true,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '${widget.restaurant.rating} (${widget.restaurant.reviewCount}+)',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Container(
                                width: 4,
                                height: 4,
                                margin: EdgeInsets.symmetric(horizontal: 8.w),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      widget.restaurant.isOpen
                                          ? Colors.green
                                          : Colors.red,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  widget.restaurant.isOpen ? 'Open' : 'Closed',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                IconButton(icon: const Icon(Icons.share), onPressed: () {}),
              ],
            ),

            // Restaurant Info Bar
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoItem(
                      Icons.access_time,
                      widget.restaurant.deliveryTime,
                      'Delivery Time',
                    ),
                    _buildInfoItem(
                      Icons.location_on,
                      widget.restaurant.distance,
                      'Distance',
                    ),
                    _buildInfoItem(
                      Icons.money,
                      '\$${widget.restaurant.deliveryFee}',
                      'Delivery Fee',
                    ),
                    _buildInfoItem(
                      Icons.shopping_bag,
                      '\$${widget.restaurant.minOrder}',
                      'Min Order',
                    ),
                  ],
                ),
              ),
            ),

            // Tab Bar
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppTheme.primaryColor,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'Menu'),
                    Tab(text: 'Reviews'),
                    Tab(text: 'Info'),
                  ],
                  onTap: (index) {
                    setState(() {
                      _selectedTabIndex = index;
                    });
                  },
                ),
              ),
              pinned: true,
            ),

            // Tab Bar Views
            SliverFillRemaining(
              child: IndexedStack(
                index: _selectedTabIndex,
                children: [
                  _buildMenuTab(),
                  _buildReviewsTab(),
                  _buildInfoTab(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        SizedBox(height: 4.h),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildMenuTab() {
    return Column(
      children: [
        // Category Filter
        Container(
          height: 45.h,
          margin: EdgeInsets.symmetric(vertical: 12.h),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _menuCategories.length,
            itemBuilder: (context, index) {
              final category = _menuCategories[index];
              final isSelected = _selectedCategory == category;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? AppTheme.primaryColor
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Menu Items
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _menuItems.length,
            itemBuilder: (context, index) {
              final dish = _menuItems[index];
              if (_selectedCategory != 'All' &&
                  !dish.name.contains(_selectedCategory)) {
                return const SizedBox.shrink();
              }
              return MenuItemCard(
                dish: dish,
                onAddToCart: () {
                  _showCustomizationBottomSheet(dish);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsTab() {
    return FutureBuilder(
      future: _getReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final reviews = snapshot.data as List<Review>;

        return Column(
          children: [
            // Rating Summary
            Container(
              padding: EdgeInsets.all(16.w),
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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.restaurant.rating.toString(),
                          style: TextStyle(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        RatingBar.builder(
                          initialRating: widget.restaurant.rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 16,
                          itemBuilder:
                              (context, _) =>
                                  const Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {},
                          ignoreGestures: true,
                        ),
                        Text(
                          '${widget.restaurant.reviewCount} reviews',
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 80, color: Colors.grey.shade200),
                  Expanded(
                    child: Column(
                      children: [
                        _buildRatingBar(5, 0.8),
                        _buildRatingBar(4, 0.6),
                        _buildRatingBar(3, 0.4),
                        _buildRatingBar(2, 0.2),
                        _buildRatingBar(1, 0.1),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Write Review Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => AddReviewScreen(
                            restaurantId: widget.restaurant.id,
                            restaurantName: widget.restaurant.name,
                          ),
                    ),
                  );
                  if (result == true && mounted) {
                    setState(() {});
                  }
                },
                icon: const Icon(Icons.rate_review),
                label: const Text('Write a Review'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Reviews List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return ReviewCard(review: reviews[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRatingBar(int star, double percentage) {
    return Row(
      children: [
        Text('$star', style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey.shade200,
            color: Colors.amber,
            minHeight: 6,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(percentage * 100).toInt()}%',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this restaurant',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            widget.restaurant.cuisine,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          SizedBox(height: 16.h),
          const Divider(),
          SizedBox(height: 16.h),
          const Text(
            'Opening Hours',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          _buildInfoRow('Monday - Friday', '10:00 AM - 10:00 PM'),
          _buildInfoRow('Saturday', '11:00 AM - 11:00 PM'),
          _buildInfoRow('Sunday', '11:00 AM - 9:00 PM'),
          SizedBox(height: 16.h),
          const Divider(),
          SizedBox(height: 16.h),
          const Text(
            'Address',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            '123 Main Street, Downtown, New York, NY 10001',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.directions),
            label: const Text('Get Directions'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems =
        cartProvider.cartItems.values
            .where((item) => item.restaurantId == widget.restaurant.id)
            .toList();

    if (cartItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalAmount = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    final totalItems = cartItems.fold(0, (sum, item) => sum + item.quantity);

    return Container(
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$totalItems item${totalItems > 1 ? 's' : ''} in cart',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to cart screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                minimumSize: Size(120.w, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('View Cart'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomizationBottomSheet(Dish dish) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return CustomizationBottomSheet(dish: dish);
      },
    );
  }

  Future<List<Review>> _getReviews() async {
    // Mock reviews data
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Review(
        id: '1',
        userId: '1',
        userName: 'John Doe',
        userAvatar: '',
        rating: 5,
        comment:
            'Amazing food! The pizza was perfectly cooked and delivered hot.',
        images: [],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        likes: 45,
        isVerified: true,
      ),
      Review(
        id: '2',
        userId: '2',
        userName: 'Jane Smith',
        userAvatar: '',
        rating: 4,
        comment: 'Great service and tasty food. Will order again!',
        images: [],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        likes: 32,
        isVerified: true,
      ),
    ];
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
