import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/models/address_model.dart';
import 'package:food_delivery/screens/customer/providers/cart_provider.dart';
import 'package:food_delivery/screens/customer/address_list_screen.dart';
import 'package:food_delivery/screens/customer/cart_screen.dart';
import 'package:food_delivery/screens/customer/fav_screen.dart';
import 'package:food_delivery/screens/customer/order_screen.dart';
import 'package:food_delivery/screens/customer/profile_screen.dart';
import 'package:food_delivery/screens/customer/search_screen.dart';
import 'package:provider/provider.dart';
import 'models/restaurant_model.dart';
import 'providers/address_provider.dart';
import 'utils/app_theme.dart';
import 'widgets/category_card.dart';
import 'widgets/restaurant_card.dart';
import 'restaurant_detail_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _selectedIndex = 0;

  final List<String> _banners = [
    'assets/download (1).png',
    'assets/download (2).png',
    'assets/download.png',
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Pizza',
      'icon': Icons.local_pizza,
      'color': AppTheme.primaryColor,
    },
    {'name': 'Burger', 'icon': Icons.lunch_dining, 'color': Colors.orange},
    {'name': 'Sushi', 'icon': Icons.set_meal, 'color': Colors.red},
    {'name': 'Biryani', 'icon': Icons.rice_bowl, 'color': Colors.brown},
    {'name': 'Dessert', 'icon': Icons.cake, 'color': Colors.pink},
    {'name': 'Drinks', 'icon': Icons.local_cafe, 'color': Colors.blue},
    {'name': 'Medicine', 'icon': Icons.medication, 'color': Colors.green},
    {'name': 'More', 'icon': Icons.more_horiz, 'color': Colors.grey},
  ];

  late List<Restaurant> _nearbyRestaurants;
  late List<Restaurant> _topRatedRestaurants;
  late List<Restaurant> _offerRestaurants;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  void _loadRestaurants() {
    _nearbyRestaurants = [
      Restaurant(
        id: '1',
        name: 'Pizza Hut',
        imageUrl: 'assets/pizzahut.png',
        cuisine: 'Italian, Fast Food',
        rating: 4.5,
        reviewCount: 1234,
        deliveryTime: '25-30 min',
        deliveryFee: 2.99,
        minOrder: 10,
        isVeg: false,
        isOpen: true,
        distance: '1.2 km',
        offers: ['50% OFF', 'Free Delivery'],
      ),
      Restaurant(
        id: '2',
        name: 'McDonald\'s',
        imageUrl: 'assets/mcdonalds.png',
        cuisine: 'Burgers, Fast Food',
        rating: 4.3,
        reviewCount: 2345,
        deliveryTime: '20-25 min',
        deliveryFee: 1.99,
        minOrder: 8,
        isVeg: false,
        isOpen: true,
        distance: '0.8 km',
        offers: ['Free Fries', 'Combo Deal'],
      ),
      Restaurant(
        id: '3',
        name: 'Starbucks',
        imageUrl: 'assets/starbucks.png',
        cuisine: 'Coffee, Bakery',
        rating: 4.7,
        reviewCount: 3456,
        deliveryTime: '15-20 min',
        deliveryFee: 1.49,
        minOrder: 5,
        isVeg: true,
        isOpen: true,
        distance: '0.5 km',
        offers: ['Buy 1 Get 1'],
      ),
    ];
    _topRatedRestaurants = [
      Restaurant(
        id: '6',
        name: 'The Grand Buffet',
        imageUrl: 'assets/pizzahut.png',
        cuisine: 'Multi-Cuisine',
        rating: 4.9,
        reviewCount: 8901,
        deliveryTime: '35-40 min',
        deliveryFee: 3.99,
        minOrder: 15,
        isVeg: false,
        isOpen: true,
        distance: '2.5 km',
        offers: ['20% OFF', 'Free Drink'],
      ),
      Restaurant(
        id: '7',
        name: 'Sushi King',
        imageUrl: 'assets/pizzahut.png',
        cuisine: 'Japanese, Sushi',
        rating: 4.8,
        reviewCount: 6789,
        deliveryTime: '25-30 min',
        deliveryFee: 2.99,
        minOrder: 20,
        isVeg: false,
        isOpen: true,
        distance: '1.8 km',
        offers: ['15% OFF', 'Free Wasabi'],
      ),
    ];

    _offerRestaurants = [
      Restaurant(
        id: '8',
        name: 'Burger King',
        imageUrl: 'assets/pizzahut.png',
        cuisine: 'Burgers, Fast Food',
        rating: 4.3,
        reviewCount: 3456,
        deliveryTime: '15-20 min',
        deliveryFee: 1.99,
        minOrder: 8,
        isVeg: false,
        isOpen: true,
        distance: '1.0 km',
        offers: ['Whopper Deal', '50% OFF'],
      ),
      Restaurant(
        id: '9',
        name: 'Taco Bell',
        imageUrl: 'assets/pizzahut.png',
        cuisine: 'Mexican, Fast Food',
        rating: 4.4,
        reviewCount: 2345,
        deliveryTime: '20-25 min',
        deliveryFee: 2.49,
        minOrder: 10,
        isVeg: false,
        isOpen: true,
        distance: '1.3 km',
        offers: ['Taco Tuesday', 'Buy 2 Get 1'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final defaultAddress = addressProvider.getDefaultAddress();
    final cartItemCount = cartProvider.totalQuantity;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home Tab
          _buildHomeContent(defaultAddress),

          // Search Tab
          const SearchScreen(),

          // Favorites Tab
          const FavoritesScreen(),

          // Orders Tab
          const OrdersScreen(),

          // Profile Tab
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHomeContent(Address? defaultAddress) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemCount = cartProvider.totalQuantity;

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh data
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _loadRestaurants();
        });
      },
      child: CustomScrollView(
        slivers: [
          // App Bar with Address Selector and Cart Icon
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddressListScreen()),
                );
                if (result == true && mounted) {
                  setState(() {});
                }
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      defaultAddress != null
                          ? '${defaultAddress.area}, ${defaultAddress.city}'
                          : 'Select Location',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 20),
                ],
              ),
            ),
            actions: [
              // Search Icon
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black87),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
              ),
              // Cart Icon with Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                  ),
                  if (cartItemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          cartItemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              // Notification Icon
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.black87,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifications coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      Icon(Icons.search, color: Colors.grey.shade600),
                      SizedBox(width: 12.w),
                      Text(
                        'Search for restaurants or dishes...',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Banner Carousel
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 180.h,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  onPageChanged: (index, reason) {
                    // Track banner changes if needed
                  },
                ),
                items:
                    _banners.map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              image: DecorationImage(
                                image: AssetImage(url),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) {
                                  // Fallback to placeholder if image not found
                                  const DecorationImage(
                                    image: AssetImage('assets/pizzahut.png'),
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
              ),
            ),
          ),

          // Categories
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: const Text(
                    'Categories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 100.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        name: _categories[index]['name'],
                        icon: _categories[index]['icon'],
                        color: _categories[index]['color'],
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${_categories[index]['name']} category coming soon!',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Nearby Restaurants
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nearby Restaurants',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // Show all nearby restaurants
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'View all restaurants feature coming soon!',
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return RestaurantCard(
                restaurant: _nearbyRestaurants[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => RestaurantDetailScreen(
                            restaurant: _nearbyRestaurants[index],
                          ),
                    ),
                  );
                },
              );
            }, childCount: _nearbyRestaurants.length),
          ),

          // Top Rated Restaurants Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Rated',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text('See All')),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 220.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _topRatedRestaurants.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 280.w,
                    margin: EdgeInsets.only(right: 12.w),
                    child: RestaurantCard(
                      restaurant: _topRatedRestaurants[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => RestaurantDetailScreen(
                                  restaurant: _topRatedRestaurants[index],
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          // Offers Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              child: const Text(
                'Today\'s Offers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 220.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _offerRestaurants.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 280.w,
                    margin: EdgeInsets.only(right: 12.w),
                    child: RestaurantCard(
                      restaurant: _offerRestaurants[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => RestaurantDetailScreen(
                                  restaurant: _offerRestaurants[index],
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 80.h)),
        ],
      ),
    );
  }
}
