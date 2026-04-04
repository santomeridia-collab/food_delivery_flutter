import 'package:flutter/material.dart';
import 'package:food_delivery/screens/customer/providers/search_provider.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/customer/widgets/dish_card.dart';
import 'package:food_delivery/screens/customer/widgets/filter_chip.dart';
import 'package:food_delivery/screens/customer/widgets/restaurant_card.dart';
import 'package:provider/provider.dart';
import 'restaurant_detail_screen.dart';
import 'dish_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;
  final FocusNode _focusNode = FocusNode();

  // Track if this is the first time the screen is loaded
  bool _isFirstLoad = true;

  final List<Map<String, dynamic>> _recentSearchesWithTime = [
    {
      'query': 'Pizza',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      'query': 'Burger',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
    },
    {
      'query': 'Sushi',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'query': 'Coffee',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'query': 'Biryani',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
    },
  ];

  @override
  void initState() {
    super.initState();
    // Request focus only on first load, not when coming back
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isFirstLoad && mounted) {
        _focusNode.requestFocus();
        _isFirstLoad = false;
      }
    });
  }

  @override
  void dispose() {
    // Clear focus and dispose
    _focusNode.unfocus();
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addToRecentSearches(String query) {
    if (query.trim().isEmpty) return;

    // Remove if already exists
    _recentSearchesWithTime.removeWhere((item) => item['query'] == query);

    // Add to beginning
    _recentSearchesWithTime.insert(0, {
      'query': query,
      'timestamp': DateTime.now(),
    });

    // Keep only last 10 searches
    if (_recentSearchesWithTime.length > 10) {
      _recentSearchesWithTime.removeLast();
    }

    setState(() {});
  }

  void _clearRecentSearches() {
    _recentSearchesWithTime.clear();
    setState(() {});
  }

  void _removeRecentSearch(String query) {
    _recentSearchesWithTime.removeWhere((item) => item['query'] == query);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return GestureDetector(
      // Dismiss keyboard when tapping outside
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              autofocus: false, // Changed to false - no auto focus
              decoration: InputDecoration(
                hintText: 'Search for restaurants or dishes...',
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            searchProvider.clearSearch();
                            setState(() {});
                            // Keep focus on text field
                            _focusNode.requestFocus();
                          },
                        )
                        : null,
              ),
              onChanged: (value) {
                setState(() {});
                if (value.length >= 2) {
                  searchProvider.search(value);
                } else if (value.isEmpty) {
                  searchProvider.clearSearch();
                }
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _addToRecentSearches(value);
                  searchProvider.search(value);
                }
              },
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(
                _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                color: _showFilters ? AppTheme.primaryColor : Colors.black87,
              ),
              onPressed: () {
                // Dismiss keyboard when opening filters
                _focusNode.unfocus();
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Filters Panel
            if (_showFilters)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rating Filter
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Minimum Rating',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: searchProvider.ratingFilter,
                                min: 0,
                                max: 5,
                                divisions: 10,
                                label: searchProvider.ratingFilter.toString(),
                                onChanged: (value) {
                                  searchProvider.setRatingFilter(value);
                                },
                                activeColor: AppTheme.primaryColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${searchProvider.ratingFilter}+',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Distance Filter
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Maximum Distance',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: searchProvider.distanceFilter,
                                min: 1,
                                max: 10,
                                divisions: 9,
                                label:
                                    '${searchProvider.distanceFilter.toInt()} km',
                                onChanged: (value) {
                                  searchProvider.setDistanceFilter(value);
                                },
                                activeColor: AppTheme.primaryColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${searchProvider.distanceFilter.toInt()} km',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Price Filter
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Maximum Price',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: searchProvider.priceFilter,
                                min: 0,
                                max: 100,
                                divisions: 20,
                                label:
                                    '\$${searchProvider.priceFilter.toInt()}',
                                onChanged: (value) {
                                  searchProvider.setPriceFilter(value);
                                },
                                activeColor: AppTheme.primaryColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '\$${searchProvider.priceFilter.toInt()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Veg/Non-veg Filter
                    const Text(
                      'Dietary Preference',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: FilterChipWidget(
                            label: 'All',
                            isSelected: searchProvider.dietaryFilter == 'all',
                            onTap: () {
                              searchProvider.setDietaryFilter('all');
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilterChipWidget(
                            label: 'Veg',
                            isSelected: searchProvider.dietaryFilter == 'veg',
                            onTap: () {
                              searchProvider.setDietaryFilter('veg');
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilterChipWidget(
                            label: 'Non-Veg',
                            isSelected:
                                searchProvider.dietaryFilter == 'non-veg',
                            onTap: () {
                              searchProvider.setDietaryFilter('non-veg');
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            searchProvider.clearFilters();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                            side: const BorderSide(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          child: const Text('Clear All'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showFilters = false;
                            });
                            if (_searchController.text.length >= 2) {
                              searchProvider.search(_searchController.text);
                            } else if (_searchController.text.isEmpty) {
                              searchProvider.clearSearch();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                          ),
                          child: const Text('Apply Filters'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Search Results
            Expanded(
              child:
                  _searchController.text.isEmpty
                      ? _buildRecentSearches()
                      : searchProvider.isLoading
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Searching...'),
                          ],
                        ),
                      )
                      : searchProvider.searchResults.isEmpty
                      ? _buildNoResults()
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: searchProvider.searchResults.length,
                        itemBuilder: (context, index) {
                          final result = searchProvider.searchResults[index];
                          if (result['type'] == 'restaurant') {
                            return RestaurantCard(
                              restaurant: result['data'],
                              onTap: () {
                                _addToRecentSearches(_searchController.text);
                                // Dismiss keyboard before navigation
                                _focusNode.unfocus();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => RestaurantDetailScreen(
                                          restaurant: result['data'],
                                        ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return DishCard(
                              dish: result['data'],
                              onTap: () {
                                _addToRecentSearches(_searchController.text);
                                // Dismiss keyboard before navigation
                                _focusNode.unfocus();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DishDetailScreen(
                                          dish: result['data'],
                                        ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    if (_recentSearchesWithTime.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No recent searches',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Your search history will appear here',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: _clearRecentSearches,
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Clear All'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _recentSearchesWithTime.length,
            itemBuilder: (context, index) {
              final item = _recentSearchesWithTime[index];
              final query = item['query'];
              final timestamp = item['timestamp'] as DateTime;
              final difference = DateTime.now().difference(timestamp);

              String timeAgo;
              if (difference.inMinutes < 1) {
                timeAgo = 'Just now';
              } else if (difference.inHours < 1) {
                timeAgo = '${difference.inMinutes} min ago';
              } else if (difference.inDays < 1) {
                timeAgo =
                    '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
              } else {
                timeAgo =
                    '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
              }

              return ListTile(
                leading: const Icon(Icons.history, color: Colors.grey),
                title: Text(query),
                subtitle: Text(
                  timeAgo,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => _removeRecentSearch(query),
                ),
                onTap: () {
                  _searchController.text = query;
                  Provider.of<SearchProvider>(
                    context,
                    listen: false,
                  ).search(query);
                  setState(() {});
                  // Keep focus on text field
                  _focusNode.requestFocus();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _showFilters = true;
              });
            },
            icon: const Icon(Icons.filter_alt),
            label: const Text('Adjust Filters'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
