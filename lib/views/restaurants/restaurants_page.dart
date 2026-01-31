import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurants_reviews/models/restaurants_model.dart';
import 'package:restaurants_reviews/viewmodels/restaurants_view_model.dart';
import 'package:restaurants_reviews/views/restaurants/restaurant_detail_page.dart';
import 'package:restaurants_reviews/views/widgets/add_restaurant_icon.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  String? _searchValue;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _selectImage() async {
    final XFile? selected = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (selected != null) {
      setState(() {
        _pickedImage = selected;
      });
    }
  }

  @override
  void initState() {
    _searchValue = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Restaurants")),
      body: GetBuilder<RestaurantsViewModel>(
        builder: (controller) {
          if (controller.loading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Search for:",
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.search, color: Colors.black),
                            hintText: "Search for restaurants...",
                          ),
                          initialValue: _searchValue,
                          onFieldSubmitted: (value) {
                            setState(() {
                              _searchValue = value.toLowerCase();
                              Get.find<RestaurantsViewModel>()
                                  .searchRestaurants(value);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: _buildRestaurantsContent(controller.restaurants),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            _buildAddRestaurantForm(),
            backgroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          );
        },
        child: AddRestaurantIcon(),
      ),
    );
  }

  Widget _buildRestaurantsContent(List<RestaurantModel> restaurants) {
    if (_searchValue!.isEmpty) {
      return _messageViewContent("Search for restaurants!");
    }
    if (restaurants.isEmpty) {
      return _messageViewContent(
        "No restaurants available. \nTry again or add a new restaurant.",
      );
    }
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final item = restaurants[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Hero(
            tag: item.slug,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
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
      },
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

  Widget _buildAddRestaurantForm() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setSheetState) {
        return Container(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add New Restaurant",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () async {
                    final XFile? selected = await _picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (selected != null) {
                      setSheetState(() {
                        _pickedImage = selected;
                      });
                    }
                  },
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: _pickedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey[400],
                              ),
                              const Text(
                                "Tap to select photo",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(_pickedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Restaurant Name *",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.restaurant),
                  ),
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: "Website URL (Optional)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link),
                  ),
                ),

                const SizedBox(height: 25),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    final String name = _nameController.text.trim();
                    final String url = _urlController.text.trim();
                    if (_nameController.text.trim().isEmpty) {
                      Get.snackbar("Error", "Name is required");
                      return;
                    }
                    if (_pickedImage == null) {
                      Get.snackbar("Error", "Please select an image");
                      return;
                    }

                    if (url.isNotEmpty) {
                      final urlRegExp = RegExp(
                        r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
                      );

                      if (!urlRegExp.hasMatch(url)) {
                        Get.snackbar(
                          "Invalid URL",
                          "Please insert a valid URL: (ex: https://google.com)",
                        );
                        return;
                      }
                    }

                    await Get.find<RestaurantsViewModel>().saveRestaurant(
                      name: name,
                      url: url,
                      imagePath: _pickedImage!.path,
                    );

                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }

                    _nameController.clear();
                    _urlController.clear();
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (mounted) {
                        setState(() => _pickedImage = null);
                      }
                    });
                  },
                  child: const Text(
                    "SAVE RESTAURANT",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
