import 'package:dio/dio.dart';
import 'package:restaurants_reviews/models/restaurants_model.dart';
import 'package:restaurants_reviews/services/restaurant_provider.dart';

class RestaurantRepository {
  final RestaurantProvider provider;

  RestaurantRepository(this.provider);

  Future<List<RestaurantModel>> searchRestaurants(String query) async {
    final response = await provider.getRestaurants(query);

    final List data = response.data['results'];

    return data.map((json) => RestaurantModel.fromJson(json)).toList();
  }

  Future<RestaurantModel> createRestaurant({
    required String name,
    required String url,
    required String imagePath,
  }) async {
    final response = await provider.postRestaurant(
      name: name,
      url: url,
      imagePath: imagePath,
    );

    if (response.statusCode == 201) {
      return RestaurantModel.fromJson(response.data);
    } else {
      throw Exception("Failed to create restaurant.");
    }
  }

  Future<bool> removeRestaurant(String slug) async {
    try {
      final response = await provider.deleteRestaurant(slug);
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateRestaurant(String slug, Map<String, dynamic> data) async {
    try {
      if (data.containsKey('image_path') && data['image_path'] != null) {
        String path = data['image_path'];
        data['image'] = await MultipartFile.fromFile(
          path,
          filename: path.split('/').last,
        );
        data.remove('image_path');
      }

      final response = await provider.patchRestaurant(slug: slug, data: data);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
