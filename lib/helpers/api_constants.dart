class ApiConstants {
  static const String baseUrl = "https://dv2.behuns.com";

  static const String restaurants = "/api/reviews/restaurant/";
  static String deleteRestaurant(String slug) =>
      "/api/reviews/restaurant/$slug/";
}
