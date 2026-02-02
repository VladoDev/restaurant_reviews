import 'package:dio/dio.dart';
import 'package:restaurants_reviews/helpers/api_constants.dart';
import 'package:restaurants_reviews/services/base_client.dart';

class RestaurantProvider {
  final Dio _client = BaseClient.dio;

  Future<Response> getRestaurants({int limit = 10, int offset = 0}) async {
    return await _client.get(
      ApiConstants.restaurants,
      queryParameters: {'limit': limit, 'offset': offset},
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

  Future<Response> patchRestaurant({
    required String slug,
    required dynamic data,
  }) async {
    var response = await _client.patch(
      "${ApiConstants.restaurants}$slug/",
      data: data is Map
          ? FormData.fromMap(Map<String, dynamic>.from(data))
          : data,
    );
    return response;
  }
}
