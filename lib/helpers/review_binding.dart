import 'package:get/get.dart';
import 'package:restaurants_reviews/services/review_provider.dart';
import 'package:restaurants_reviews/viewmodels/review_view_model.dart';
import 'package:restaurants_reviews/repositories/review_repository.dart';

class ReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReviewProvider());
    Get.lazyPut(() => ReviewRepository(Get.find()));
    Get.put(ReviewViewModel(Get.find()));
  }
}
