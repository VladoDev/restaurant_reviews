import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurants_reviews/models/restaurants_model.dart';
import 'package:restaurants_reviews/viewmodels/restaurants_view_model.dart';
import 'package:restaurants_reviews/views/widgets/add_restaurant_icon.dart';
import 'package:restaurants_reviews/views/widgets/restaurant_form_sheet.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        Get.find<RestaurantsViewModel>().fetchMoreRestaurants();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Restaurants")),
      body: GetBuilder<RestaurantsViewModel>(
        builder: (controller) {
          if (controller.loading && controller.restaurants.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.restaurants.isEmpty) {
            return _messageViewContent(
              "No restaurants available. \nTry again or add a new restaurant.",
            );
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount:
                controller.restaurants.length + (controller.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.restaurants.length) {
                return _buildRestaurantItem(controller.restaurants[index]);
              } else {
                return const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            const RestaurantFormSheet(),
            isScrollControlled: true,
          );
        },
        child: AddRestaurantIcon(),
      ),
    );
  }

  Widget _buildRestaurantItem(RestaurantModel item) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Hero(
        tag: item.slug,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            key: ValueKey(item.slug),
            cacheKey: item.slug,
            imageUrl: item.image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[200],
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.restaurant, color: Colors.grey),
            ),
          ),
        ),
      ),
      title: Text(
        item.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.url.isEmpty ? "No URL available" : item.url,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
          ),
          const SizedBox(height: 4),
          item.rating == 0
              ? Text("No reviews", style: TextStyle(color: Colors.blueGrey))
              : RatingBarIndicator(
                  rating: item.rating,
                  itemBuilder: (context, index) =>
                      const Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 18.0,
                  direction: Axis.horizontal,
                ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              Get.bottomSheet(
                RestaurantFormSheet(restaurant: item),
                isScrollControlled: true,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              await Get.find<RestaurantsViewModel>().deleteRestaurant(
                slug: item.slug,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              Get.toNamed('/details', arguments: item);
            },
          ),
        ],
      ),
    );
  }

  Widget _messageViewContent(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(message)],
      ),
    );
  }
}
