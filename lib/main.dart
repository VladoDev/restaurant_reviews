import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:restaurants_reviews/helpers/binding.dart';
import 'package:restaurants_reviews/views/restaurants/restaurants_page.dart';

void main() {
  runApp(
    GetMaterialApp(
      getPages: [GetPage(name: "/", page: () => const RestaurantsPage())],
      initialBinding: Binding(),
      home: const RestaurantsPage(),
    ),
  );
}
