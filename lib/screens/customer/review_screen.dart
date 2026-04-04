import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_delivery/screens/customer/models/review_model.dart';
import 'package:food_delivery/screens/customer/add_review.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/customer/widgets/review_card.dart';

class ReviewsScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final double averageRating;
  final int totalReviews;

  const ReviewsScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  String _sortBy = 'recent';
  List<Review> _reviews = [];
  bool _isLoading = true;

  final Map<String, String> _sortOptions = {
    'recent': 'Most Recent',
    'highest': 'Highest Rating',
    'lowest': 'Lowest Rating',
    'helpful': 'Most Helpful',
  };

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _reviews = [
        Review(
          id: '1',
          userId: '1',
          userName: 'John Doe',
          userAvatar: '',
          rating: 5,
          comment:
              'Amazing food! The pizza was perfectly cooked and delivered hot. The crust was crispy and the toppings were fresh. Definitely ordering again!',
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
        Review(
          id: '3',
          userId: '3',
          userName: 'Mike Johnson',
          userAvatar: '',
          rating: 5,
          comment: 'Best pizza in town! Highly recommended.',
          images: [],
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          likes: 28,
          isVerified: false,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews (${widget.totalReviews})'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortBottomSheet,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Rating Summary Card
                  Container(
                    padding: EdgeInsets.all(20.w),
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
                                widget.averageRating.toString(),
                                style: TextStyle(
                                  fontSize: 48.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              RatingBar.builder(
                                initialRating: widget.averageRating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                itemBuilder:
                                    (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                onRatingUpdate: (rating) {},
                                ignoreGestures: true,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Based on ${widget.totalReviews} reviews',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 100,
                          color: Colors.grey.shade200,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              _buildRatingBar(5, 0.8),
                              SizedBox(height: 8.h),
                              _buildRatingBar(4, 0.6),
                              SizedBox(height: 8.h),
                              _buildRatingBar(3, 0.4),
                              SizedBox(height: 8.h),
                              _buildRatingBar(2, 0.2),
                              SizedBox(height: 8.h),
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
                                  restaurantId: widget.restaurantId,
                                  restaurantName: widget.restaurantName,
                                ),
                          ),
                        );
                        if (result == true && mounted) {
                          _loadReviews();
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

                  // Sort Label
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Reviews',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _showSortBottomSheet,
                          icon: Icon(Icons.sort, size: 16),
                          label: Text(_sortOptions[_sortBy]!),
                        ),
                      ],
                    ),
                  ),

                  // Reviews List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: _reviews.length,
                      itemBuilder: (context, index) {
                        return ReviewCard(review: _reviews[index]);
                      },
                    ),
                  ),
                ],
              ),
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

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort Reviews',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              ..._sortOptions.entries.map((entry) {
                return RadioListTile(
                  title: Text(entry.value),
                  value: entry.key,
                  groupValue: _sortBy,
                  activeColor: AppTheme.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value.toString();
                    });
                    Navigator.pop(context);
                    _sortReviews();
                  },
                );
              }),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  void _sortReviews() {
    setState(() {
      switch (_sortBy) {
        case 'recent':
          _reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case 'highest':
          _reviews.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'lowest':
          _reviews.sort((a, b) => a.rating.compareTo(b.rating));
          break;
        case 'helpful':
          _reviews.sort((a, b) => b.likes.compareTo(a.likes));
          break;
      }
    });
  }
}
