import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:restaurants_reviews/models/review_model.dart';
import 'package:restaurants_reviews/viewmodels/review_view_model.dart';

class ReviewFormSheet extends StatefulWidget {
  final String restaurantSlug;
  final ReviewModel? review;

  const ReviewFormSheet({super.key, required this.restaurantSlug, this.review});

  @override
  State<ReviewFormSheet> createState() => _ReviewFormSheetState();
}

class _ReviewFormSheetState extends State<ReviewFormSheet> {
  final controller = Get.find<ReviewViewModel>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _currentRating = 3;

  bool get isEditing => widget.review != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.review!.name;
      _descriptionController.text = widget.review!.description;
      _currentRating = widget.review!.rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
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
              isEditing ? "Edit Review" : "Add Review",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            RatingBar.builder(
              initialRating: _currentRating.toDouble(),
              minRating: 1,
              itemCount: 5,
              itemSize: 30,
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) => _currentRating = rating.toInt(),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Review",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            GetBuilder<ReviewViewModel>(
              builder: (vm) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.black,
                  ),
                  onPressed: vm.loading ? null : _handleSubmit,
                  child: vm.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isEditing ? "UPDATE" : "SUBMIT",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty || description.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (!isEditing) {
      final bool alreadyReviewed = controller.reviews.any(
        (r) => r.name.toLowerCase() == name.toLowerCase(),
      );

      if (alreadyReviewed) {
        Get.snackbar("Action Denied", "Only one review is allowed per person");
        return;
      }

      await controller.addReview(
        restaurantSlug: widget.restaurantSlug,
        name: name,
        description: description,
        rating: _currentRating,
      );
    } else {
      await controller.updateReview(
        reviewSlug: widget.review!.slug,
        restaurantSlug: widget.restaurantSlug,
        name: name,
        description: description,
        rating: _currentRating,
      );
    }

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
