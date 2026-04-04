import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/providers/restaurant_provider.dart';
import 'package:food_delivery/screens/customer/restaurant_list_card.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/customer/widgets/restaurant_grid_card.dart';
import 'package:provider/provider.dart';
import 'restaurant_detail_screen.dart';

class RestaurantListingScreen extends StatefulWidget {
  final String? category;
  final String? searchQuery;
  const RestaurantListingScreen({super.key, this.category, this.searchQuery});

  @override
  State<RestaurantListingScreen> createState() =>
      _RestaurantListingScreenState();
}

class _RestaurantListingScreenState extends State<RestaurantListingScreen> {
  bool _isGridView = false;
  String _sortBy = 'rating';
  String _selectedFilter = 'all';

  final List<String> _sortOptions = [
    'rating',
    'deliveryTime',
    'price',
    'distance',
  ];

  final Map<String, String> _sortLabels = {
    'rating': 'Top Rated',
    'deliveryTime': 'Fast Delivery',
    'price': 'Price: Low to High',
    'distance': 'Nearest First',
  };

  final List<Map<String, dynamic>> _filters = [
    {'label': 'All', 'value': 'all'},
    {'label': 'Open Now', 'value': 'open'},
    {'label': 'Pure Veg', 'value': 'veg'},
    {'label': 'Offers', 'value': 'offers'},
  ];

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<CustomerRestaurantProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category ?? 'Restaurants',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Sort Button
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortBottomSheet,
          ),
          // View Toggle Button
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: _buildFilterChips(),
        ),
      ),
      body: Column(
        children: [
          // Results Count
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${restaurantProvider.filteredRestaurants.length} restaurants found',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (_sortBy != 'rating')
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.sort,
                          size: 14.sp,
                          color: AppTheme.primaryColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Sorted by ${_sortLabels[_sortBy]}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Restaurant List/Grid
          Expanded(
            child:
                _isGridView
                    ? _buildGridView(restaurantProvider)
                    : _buildListView(restaurantProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50.h,
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter['value'];
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: FilterChip(
              label: Text(filter['label']),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter['value'];
                });
                _applyFilters();
              },
              backgroundColor: Colors.grey.shade100,
              selectedColor: AppTheme.primaryColor.withOpacity(0.1),
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryColor : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              checkmarkColor: AppTheme.primaryColor,
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(CustomerRestaurantProvider provider) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: provider.filteredRestaurants.length,
      itemBuilder: (context, index) {
        return RestaurantListCard(
          restaurant: provider.filteredRestaurants[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => RestaurantDetailScreen(
                      restaurant: provider.filteredRestaurants[index],
                    ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGridView(CustomerRestaurantProvider provider) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: provider.filteredRestaurants.length,
      itemBuilder: (context, index) {
        return RestaurantGridCard(
          restaurant: provider.filteredRestaurants[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => RestaurantDetailScreen(
                      restaurant: provider.filteredRestaurants[index],
                    ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSortBottomSheet() {
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
                  Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ..._sortOptions.map((sort) {
                    return RadioListTile(
                      title: Text(_sortLabels[sort]!),
                      value: sort,
                      groupValue: _sortBy,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          _sortBy = value.toString();
                        });
                        Navigator.pop(context);
                        _applySort();
                      },
                    );
                  }),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _applySort() {
    final provider = Provider.of<CustomerRestaurantProvider>(
      context,
      listen: false,
    );
    provider.sortRestaurants(_sortBy);
    setState(() {});
  }

  void _applyFilters() {
    final provider = Provider.of<CustomerRestaurantProvider>(
      context,
      listen: false,
    );
    provider.filterRestaurants(_selectedFilter);
    setState(() {});
  }
}
