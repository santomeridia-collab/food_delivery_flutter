import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/restaurant_owner/add_edit_item_screen.dart';
import 'package:food_delivery/screens/restaurant_owner/category_management_screen.dart';
import 'package:food_delivery/screens/restaurant_owner/widget/menu_item_card.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery/screens/restaurant_owner/model/menu_item_model.dart';
import 'package:food_delivery/screens/restaurant_owner/provider/menu_provider.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final filteredItems = menuProvider.filteredItems;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom SliverAppBar
          SliverAppBar(
            title: const Text('Menu Management'),
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            floating: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.category),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CategoryManagementScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddEditItemScreen(),
                    ),
                  ).then((_) => menuProvider.notifyListeners());
                },
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(130.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search Bar
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 4.h,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search menu items...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon:
                            _searchController.text.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    menuProvider.setSearchQuery('');
                                  },
                                )
                                : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                      ),
                      onChanged: (value) {
                        menuProvider.setSearchQuery(value);
                      },
                    ),
                  ),
                  // Categories Filter
                  SizedBox(
                    height: 40.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: menuProvider.categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildCategoryChip(
                            'All',
                            menuProvider.selectedCategory == 'All',
                            () {
                              menuProvider.setCategory('All');
                            },
                          );
                        }
                        final category = menuProvider.categories[index - 1];
                        return _buildCategoryChip(
                          category.name,
                          menuProvider.selectedCategory == category.name,
                          () {
                            menuProvider.setCategory(category.name);
                          },
                        );
                      },
                    ),
                  ),
                  // Filter Toggle
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 4.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${filteredItems.length} items',
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                        Row(
                          children: [
                            Text(
                              'Show available only',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: menuProvider.showOnlyAvailable,
                                onChanged:
                                    (_) =>
                                        menuProvider.toggleShowOnlyAvailable(),
                                activeColor: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Content
          if (filteredItems.isEmpty)
            const SliverFillRemaining(child: Center(child: _EmptyState()))
          else
            SliverPadding(
              padding: EdgeInsets.all(16.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = filteredItems[index];
                  return MenuItemCard(
                    item: item,
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditItemScreen(item: item),
                        ),
                      ).then((_) => menuProvider.notifyListeners());
                    },
                    onDelete: () {
                      _showDeleteDialog(context, item.id, menuProvider);
                    },
                    onToggleAvailability: () {
                      menuProvider.toggleAvailability(item.id);
                    },
                  );
                }, childCount: filteredItems.length),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditItemScreen()),
          ).then((_) => menuProvider.notifyListeners());
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 12.sp)),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.grey.shade100,
        selectedColor: AppTheme.primaryColor.withOpacity(0.1),
        labelStyle: TextStyle(
          color: isSelected ? AppTheme.primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        checkmarkColor: AppTheme.primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    String itemId,
    MenuProvider provider,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Item'),
            content: const Text(
              'Are you sure you want to delete this item? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  provider.deleteMenuItem(itemId);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item deleted successfully')),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.restaurant_menu, size: 80.sp, color: Colors.grey.shade400),
        SizedBox(height: 16.h),
        Text(
          'No menu items found',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Add your first menu item to get started',
          style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
        ),
        SizedBox(height: 24.h),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditItemScreen()),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Menu Item'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ],
    );
  }
}
