import 'package:get/get.dart';
import 'package:restaurants_reviews/models/restaurants_model.dart';
import 'package:restaurants_reviews/repositories/restaurant_repository.dart';

class RestaurantsViewModel extends GetxController {
  final RestaurantRepository repository;

  RestaurantsViewModel(this.repository);

  List<RestaurantModel> _restaurants = [];

  List<RestaurantModel> get restaurants => _restaurants;

  bool _loading = false;

  bool get loading => _loading;

  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      _restaurants = [];
      update();
      return;
    }

    try {
      _loading = true;
      update();

      _restaurants = await repository.searchRestaurants(query);
    } catch (e) {
      Get.snackbar("Error", "Could not fetch restaurants");
    } finally {
      _loading = false;
      update();
    }
  }

  Future<void> saveRestaurant({
    required String name,
    required String url,
    required String imagePath,
  }) async {
    try {
      _loading = true;
      await repository.createRestaurant(
        name: name,
        url: url,
        imagePath: imagePath,
      );
      await searchRestaurants(name);
      Get.snackbar("Saved!", "Restaurant succesfuly saved!");
    } catch (e) {
      Get.snackbar("Error", "An error has ocurred.");
    } finally {
      _loading = false;
      update();
    }
  }

  Future<void> deleteRestaurant({required String slug}) async {
    try {
      _loading = true;
      update();
      bool success = await repository.removeRestaurant(slug);
      if (success) {
        restaurants.removeWhere((item) => item.slug == slug);
        update();
        Get.snackbar("Success!", "Restaurant removed.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete restaurant");
    } finally {
      _loading = false;
      update();
    }
  }
}
