import 'package:flutter/material.dart';
import 'package:recipe_app/screens/detail_screen.dart';
import 'package:recipe_app/screens/search_meal_detail.dart';

class MealSearchDisplay extends StatelessWidget {
  const MealSearchDisplay({
    super.key,
    required this.mealName,
    required this.mealImage,
    required this.mealId,
  });

  final String mealName;
  final String mealImage;
  final String mealId;

  @override
  Widget build(BuildContext context) {
    // todo: fix the problem of the card not expanding to show all its contents
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchMealDetail(
              image: mealImage,
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
                child: Text(maxLines: 3,
                  mealName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
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
