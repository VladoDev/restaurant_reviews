import 'package:restaurants_reviews/models/review_model.dart';
import 'package:restaurants_reviews/services/review_provider.dart';

class ReviewRepository {
  final ReviewProvider provider;
  ReviewRepository(this.provider);

  Future<List<ReviewModel>> fetchReviews(String slug) async {
    try {
      final response = await provider.getReviews(slug);

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((item) => ReviewModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> createReview({
    required String restaurantSlug,
    required String name,
    required String description,
    required int rating,
  }) async {
    try {
      final response = await provider.postReview(
        restaurantSlug: restaurantSlug,
        name: name,
        description: description,
        rating: rating,
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeReview(String slug) async {
    try {
      final response = await provider.deleteReview(slug);
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateReview(String slug, Map<String, dynamic> data) async {
    try {
      final response = await provider.patchReview(reviewSlug: slug, data: data);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
