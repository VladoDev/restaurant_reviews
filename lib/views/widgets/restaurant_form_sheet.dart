import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurants_reviews/models/restaurants_model.dart';
import 'package:restaurants_reviews/viewmodels/restaurants_view_model.dart';
import 'package:dio/dio.dart' as dio;

class RestaurantFormSheet extends StatefulWidget {
  final RestaurantModel? restaurant;

  const RestaurantFormSheet({super.key, this.restaurant});

  @override
  State<RestaurantFormSheet> createState() => _RestaurantFormSheetState();
}

class _RestaurantFormSheetState extends State<RestaurantFormSheet> {
  final controller = Get.find<RestaurantsViewModel>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  bool get isEditing => widget.restaurant != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.restaurant!.name;
      _urlController.text = widget.restaurant!.url;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              isEditing ? "Edit Restaurant" : "Add New Restaurant",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildImagePicker(),
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
                hintText: "http://www.google.com",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.black,
              ),
              onPressed: _handleSave,
              child: controller.loading
                  ? CircularProgressIndicator()
                  : Text(
                      isEditing ? "UPDATE RESTAURANT" : "SAVE RESTAURANT",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () async {
        final XFile? selected = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );
        if (selected != null) setState(() => _pickedImage = selected);
      },
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: _pickedImage == null && !isEditing
            ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _pickedImage != null
                    ? Image.file(File(_pickedImage!.path), fit: BoxFit.cover)
                    : Image.network(
                        widget.restaurant!.image,
                        fit: BoxFit.cover,
                      ),
              ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final url = _urlController.text.trim();

    if (name.isEmpty) {
      Get.snackbar("Error", "Name is required");
      return;
    }

    if (isEditing) {
      final Map<String, dynamic> dataToUpdate = {
        "name": _nameController.text.trim(),
        "url": _urlController.text.trim(),
      };

      if (_pickedImage != null) {
        dataToUpdate["image"] = await dio.MultipartFile.fromFile(
          _pickedImage!.path,
          filename: _pickedImage!.path.split("/").last,
        );
      }

      await Get.find<RestaurantsViewModel>().editRestaurant(
        slug: widget.restaurant!.slug,
        updatedData: dataToUpdate,
      );
    } else {
      if (_pickedImage == null) {
        Get.snackbar("Error", "Please select an image");
        return;
      }
      await Get.find<RestaurantsViewModel>().saveRestaurant(
        name: name,
        url: url,
        imagePath: _pickedImage!.path,
      );
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
