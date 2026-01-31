import 'package:dio/dio.dart';
import 'package:restaurants_reviews/helpers/api_constants.dart';
import 'package:restaurants_reviews/services/base_client.dart';

class RestaurantProvider {
  final Dio _client = BaseClient.dio;

  Future<Response> getRestaurants(String query) async {
    return await _client.get(
      ApiConstants.restaurants,
      queryParameters: {'search': query},
    );
  }

  Future<Response> postRestaurant({
    required String name,
    required String url,
    required String imagePath,
  }) async {
    FormData formData = FormData.fromMap({
      "name": name,
      "url": url,
      "image": await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split("/").last,
      ),
    });

    return await _client.post(ApiConstants.restaurants, data: formData);
  }

  Future<Response> deleteRestaurant(String slug) async {
    return await _client.delete(ApiConstants.deleteRestaurant(slug));
  }
}
