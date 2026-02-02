import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:restaurants_reviews/models/restaurants_model.dart';
import 'package:restaurants_reviews/models/review_model.dart';
import 'package:restaurants_reviews/viewmodels/review_view_model.dart';
import 'package:restaurants_reviews/views/widgets/add_review_icon.dart';
import 'package:restaurants_reviews/views/widgets/review_form_sheet.dart';

class RestaurantDetailPage extends StatefulWidget {
  const RestaurantDetailPage({super.key});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  void initState() {
    super.initState();
    final RestaurantModel restaurant = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ReviewViewModel>().loadReviews(restaurant.slug);
    });
  }

  @override
  Widget build(BuildContext context) {
    final RestaurantModel restaurant = Get.arguments;

    return Scaffold(
      appBar: AppBar(title: Text(restaurant.name)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            ReviewFormSheet(restaurantSlug: restaurant.slug),
            isScrollControlled: true,
          );
        },
        child: const AddReviewIcon(),
      ),
      body: GetBuilder<ReviewViewModel>(
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRestaurantHeaderCard(restaurant),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Customer Reviews",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (controller.loading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (controller.reviews.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("No reviews yet. Be the first!"),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.reviews.length,
                    itemBuilder: (context, index) {
                      return _buildReviewItem(controller.reviews[index]);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRestaurantHeaderCard(RestaurantModel restaurant) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: restaurant.slug,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: CachedNetworkImage(
                key: ValueKey(restaurant.slug),
                cacheKey: restaurant.slug,
                imageUrl: restaurant.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  restaurant.url.isEmpty ? "No URL available" : restaurant.url,
                  style: const TextStyle(color: Colors.blueGrey),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: restaurant.rating,
                      itemBuilder: (context, index) =>
                          const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 20.0,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      restaurant.rating.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(ReviewModel review) {
    final restaurant = Get.arguments as RestaurantModel;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          title: Row(
            children: [
              Text(
                review.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              RatingBarIndicator(
                rating: review.rating.toDouble(),
                itemBuilder: (context, index) =>
                    const Icon(Icons.star, color: Colors.amber),
                itemCount: 5,
                itemSize: 14.0,
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                review.description,
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                review.created.split('T')[0],
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Get.bottomSheet(
                    ReviewFormSheet(
                      restaurantSlug: restaurant.slug,
                      review: review,
                    ),
                    isScrollControlled: true,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _confirmDelete(review.slug, restaurant.slug),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(String reviewSlug, String restaurantSlug) {
    Get.defaultDialog(
      title: "Delete Review",
      middleText: "Are you sure you want to remove this review?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        Get.find<ReviewViewModel>().deleteReview(reviewSlug);
        Get.back();
      },
    );
  }
}
