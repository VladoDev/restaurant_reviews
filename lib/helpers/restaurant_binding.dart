import 'package:get/get.dart';
import 'package:restaurants_reviews/repositories/restaurant_repository.dart';
import 'package:restaurants_reviews/services/restaurant_provider.dart';
import 'package:restaurants_reviews/viewmodels/restaurants_view_model.dart';

class RestaurantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RestaurantProvider());
    Get.lazyPut(() => RestaurantRepository(Get.find()));
    Get.lazyPut(() => RestaurantsViewModel(Get.find()));
  }
}
