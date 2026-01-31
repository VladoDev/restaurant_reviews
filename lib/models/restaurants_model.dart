class RestaurantModel {
  late int id;
  late String slug, name, url, image;
  late double rating;

  RestaurantModel({
    required this.id,
    required this.slug,
    required this.name,
    required this.url,
    required this.image,
    required this.rating,
  });

  RestaurantModel.fromJson(Map<String, dynamic> map) {
    id = map['id'] ?? 0;
    slug = map['slug'] ?? '';
    name = map['name'] ?? '';
    url = map['url'] ?? '';
    image = map['image'] ?? '';
    rating = (map['rating'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'url': url,
      'image': image,
      'rating': rating,
    };
  }
}
