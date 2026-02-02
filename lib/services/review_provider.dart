import 'package:dio/dio.dart';
import 'package:restaurants_reviews/helpers/api_constants.dart';
import 'package:restaurants_reviews/services/base_client.dart';

class ReviewProvider {
  final Dio _client = BaseClient.dio;

  Future<Response> getReviews(String slug) async {
    return await _client.get(
      ApiConstants.review,
      queryParameters: {'restaurant__slug': slug},
    );
  }

  Future<Response> postReview({
    required String restaurantSlug,
    required String name,
    required String description,
    required int rating,
  }) async {
    final Map<String, dynamic> data = {
      "restaurant": restaurantSlug,
      "name": name,
      "description": description,
      "rating": rating,
    };

    return await _client.post(ApiConstants.review, data: data);
  }

  Future<Response> deleteReview(String slug) async {
    return await _client.delete("${ApiConstants.review}$slug/");
  }

  Future<Response> patchReview({
    required String reviewSlug,
    required Map<String, dynamic> data,
  }) async {
    return await _client.patch(
      "${ApiConstants.review}$reviewSlug/",
      data: data,
    );
  }
}
