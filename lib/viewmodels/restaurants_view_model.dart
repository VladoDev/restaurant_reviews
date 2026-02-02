import 'package:get/get.dart';
import 'package:restaurants_reviews/models/restaurants_model.dart';
import 'package:restaurants_reviews/repositories/restaurant_repository.dart';

class RestaurantsViewModel extends GetxController {
  final RestaurantRepository repository;

  RestaurantsViewModel(this.repository);

  List<RestaurantModel> _restaurants = [];
  bool _loading = false;
  bool _loadingMore = false;
  int _offset = 0;
  final int _limit = 10;
  bool _hasMore = true;

  List<RestaurantModel> get restaurants => _restaurants;
  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get hasMore => _hasMore;

  @override
  void onInit() {
    super.onInit();
    fetchInitialRestaurants();
  }

  Future<void> fetchInitialRestaurants() async {
    try {
      _loading = true;
      _offset = 0;
      _hasMore = true;
      _restaurants = [];
      update();

      final List<RestaurantModel> data = await repository.getRestaurants(
        _limit,
        _offset,
      );

      _restaurants = data;

      if (data.length < _limit) {
        _hasMore = false;
      }
    } catch (e) {
      Get.snackbar("Error", "Could not fetch restaurants");
    } finally {
      _loading = false;
      update();
    }
  }

  Future<void> fetchMoreRestaurants() async {
    if (_loadingMore || !_hasMore) return;

    try {
      _loadingMore = true;
      update();

      _offset += _limit;
      final List<RestaurantModel> data = await repository.getRestaurants(
        _limit,
        _offset,
      );

      if (data.isEmpty || data.length < _limit) {
        _hasMore = false;
      }

      _restaurants.addAll(data);
    } catch (e) {
      Get.snackbar("Error", "Could not load more restaurants");
    } finally {
      _loadingMore = false;
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
      update();

      await repository.createRestaurant(
        name: name,
        url: url,
        imagePath: imagePath,
      );

      await fetchInitialRestaurants();
      Get.snackbar("Saved!", "Restaurant successfully saved!");
    } catch (e) {
      Get.snackbar("Error", "An error has occurred.");
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
        _restaurants.removeWhere((item) => item.slug == slug);
        Get.snackbar("Success!", "Restaurant removed.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete restaurant");
    } finally {
      _loading = false;
      update();
    }
  }

  Future<void> editRestaurant({
    required String slug,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      _loading = true;
      update();

      final success = await repository.updateRestaurant(slug, updatedData);

      if (success) {
        await fetchInitialRestaurants();
        Get.snackbar("Success!", "Restaurant updated successfully");
      } else {
        Get.snackbar("Error", "Could not update the restaurant information");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred during update");
    } finally {
      _loading = false;
      update();
    }
  }
}
