import 'package:flutter/material.dart';

class IngredientsDisplay extends StatelessWidget {
  const IngredientsDisplay({super.key, required this.ingredientPic, required this.ingredientMeasurement});

  final String ingredientPic;
  final String ingredientMeasurement;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        height: 100,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: Row(
            mainAxisSize: .min,
            children: [
              Image.network(ingredientPic),
              Expanded(child: const SizedBox(width: double.infinity,)),
              Text(ingredientMeasurement)
            ],
          ),
        ),
      ),
    );
  }
}