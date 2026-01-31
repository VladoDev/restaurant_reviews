import 'package:flutter/material.dart';

class AddReviewIcon extends StatelessWidget {
  final double size;

  const AddReviewIcon({super.key, this.size = 40.0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(Icons.grade_outlined, size: size, color: Colors.black),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_circle,
              size: size * 0.45,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
