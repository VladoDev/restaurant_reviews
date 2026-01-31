import 'package:flutter/material.dart';

class AddRestaurantIcon extends StatelessWidget {
  final double size;

  const AddRestaurantIcon({super.key, this.size = 40.0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(Icons.storefront, size: size, color: Colors.black),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
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
