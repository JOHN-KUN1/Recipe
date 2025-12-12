import 'package:flutter/material.dart';
import 'package:recipe_app/screens/detail_screen.dart';

class MealDisplay extends StatelessWidget {
  const MealDisplay({
    super.key,
    required this.mealName,
    required this.mealRating,
    required this.mealImage,
    required this.cookTime,
    required this.mealId,
    required this.mealIngredients,
    required this.mealInstructions,
  });

  final String mealName;
  final String mealRating;
  final String mealImage;
  final String cookTime;
  final String mealId;
  final String mealInstructions;
  final List mealIngredients;

  @override
  Widget build(BuildContext context) {
    // todo: fix the problem of the card not expanding to show all its contents
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              image: mealImage,
              ingredients: mealIngredients,
              instructions: mealInstructions,
              mealId: mealId,
              mealName: mealName,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 7,
        child: Center(
          child: Column(
            crossAxisAlignment: .center,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: Row(
                    mainAxisAlignment: .end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.favorite_border),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                child: Hero(
                  tag: mealId,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(mealImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  mealName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        '$cookTime min',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                        ),
                      ),
                      Icon(
                        Icons.health_and_safety_outlined,
                        color: Colors.lightGreen,
                        size: 16,
                      ),
                      Text(
                        mealRating,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
