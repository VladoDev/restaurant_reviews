import 'package:flutter/material.dart';
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
      Get.snackbar(
        "Success",
        "Review added successfully",
        borderColor: Colors.green,
        borderWidth: 2,
      );
    } else {
      Get.snackbar(
        "Error",
        "Only one review allowed per person",
        borderColor: Colors.red,
        borderWidth: 2,
      );
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
      Get.snackbar(
        "Deleted",
        "Review removed successfully",
        borderColor: Colors.green,
        borderWidth: 2,
      );
    } else {
      Get.snackbar(
        "Error",
        "Failed to delete review",
        borderColor: Colors.red,
        borderWidth: 2,
      );
    }

    loading = false;
    update();
  }

  Future<void> updateReview({
    required String reviewSlug,
    required String restaurantSlug,
    required String name,
    required String description,
    required int rating,
  }) async {
    loading = true;
    update();

    final Map<String, dynamic> data = {
      "restaurant": restaurantSlug,
      "name": name,
      "description": description,
      "rating": rating,
    };

    final success = await repository.updateReview(reviewSlug, data);

    if (success) {
      await loadReviews(restaurantSlug);
      Get.snackbar(
        "Success!",
        "Review updated successfully",
        borderColor: Colors.green,
        borderWidth: 2,
      );
    } else {
      Get.snackbar(
        "Error",
        "Could not update the review",
        borderColor: Colors.red,
        borderWidth: 2,
      );
    }

    loading = false;
    update();
  }
}
