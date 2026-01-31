class ReviewModel {
  late String slug, restaurant, name, description, created;
  late int rating;

  ReviewModel({
    required this.slug,
    required this.restaurant,
    required this.name,
    required this.description,
    required this.rating,
    required this.created,
  });

  ReviewModel.fromJson(Map<String, dynamic> map) {
    slug = map['slug'] ?? '';
    restaurant = map['restaurant'] ?? '';
    name = map['name'] ?? '';
    description = map['description'] ?? '';
    rating = map['rating'] ?? 0;
    created = map['created'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurant': restaurant,
      'name': name,
      'description': description,
      'rating': rating,
    };
  }
}
