import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:restaurants_reviews/helpers/restaurant_binding.dart';
import 'package:restaurants_reviews/helpers/review_binding.dart';
import 'package:restaurants_reviews/views/restaurants/restaurant_detail_page.dart';
import 'package:restaurants_reviews/views/restaurants/restaurants_page.dart';

void main() {
  runApp(
    GetMaterialApp(
      getPages: [
        GetPage(
          name: "/",
          page: () => const RestaurantsPage(),
          binding: RestaurantBinding(),
        ),
        GetPage(
          name: '/details',
          page: () => const RestaurantDetailPage(),
          binding: ReviewBinding(),
          transition: Transition.cupertino,
        ),
      ],
      initialBinding: RestaurantBinding(),
      home: const RestaurantsPage(),
    ),
  );
}
