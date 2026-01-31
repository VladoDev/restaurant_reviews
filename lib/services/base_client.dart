import 'package:dio/dio.dart';
import 'package:restaurants_reviews/helpers/api_constants.dart';

class BaseClient {
  static final BaseClient _instance = BaseClient._internal();
  late Dio _dio;

  BaseClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  static Dio get dio => _instance._dio;
}
