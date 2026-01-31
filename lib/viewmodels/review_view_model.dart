import 'package:get/get.dart';
import 'package:restaurants_reviews/models/review_model.dart';
import 'package:restaurants_reviews/repositories/review_repository.dart';

class ReviewViewModel extends GetxController {
  final ReviewRepository repository;
  ReviewViewModel(this.repository);
  List<ReviewModel> reviews = [];
  bool loading = false;

  Future<void> loadReviews(String slug) async {
    loading = true;
    update();
    reviews = await repository.fetchReviews(slug);
    loading = false;
    update();
  }

  Future<void> addReview({
    required String restaurantSlug,
    required String name,
    required String description,
    required int rating,
  }) async {
    loading = true;
    update();

    final success = await repository.createReview(
      restaurantSlug: restaurantSlug,
      name: name,
      description: description,
      rating: rating,
    );

    if (success) {
      await loadReviews(restaurantSlug);
      Get.snackbar("Success", "Review added successfully");
    } else {
      Get.snackbar("Error", "Failed to add review");
    }

    loading = false;
    update();
  }

  Future<void> deleteReview(String reviewSlug) async {
    loading = true;
    update();

    final success = await repository.removeReview(reviewSlug);

    if (success) {
      reviews.removeWhere((item) => item.slug == reviewSlug);
      Get.snackbar("Deleted", "Review removed successfully");
    } else {
      Get.snackbar("Error", "Failed to delete review");
    }

    loading = false;
    update();
  }
}
