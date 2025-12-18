import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/models/meal.dart';
import 'package:recipe_app/providers/favorite_meal_provider.dart';
import 'package:recipe_app/screens/detail_screen.dart';

class MealDisplay extends ConsumerStatefulWidget {
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
  ConsumerState<MealDisplay> createState() => _MealDisplayState();
}

class _MealDisplayState extends ConsumerState<MealDisplay>
    with SingleTickerProviderStateMixin {
  bool _inFavorites = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // todo: fix the problem of the card not expanding to show all its contents
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              image: widget.mealImage,
              ingredients: widget.mealIngredients,
              instructions: widget.mealInstructions,
              mealId: widget.mealId,
              mealName: widget.mealName,
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
                      ScaleTransition(
                        scale: _animation,
                        child: IconButton(
                          onPressed: () async {
                            _animationController.forward();
                            if (_animationController.isCompleted) {
                              _animationController.reset();
                            }
                            if (!_inFavorites) {
                              await ref
                                  .read(favoriteMealsProvider.notifier)
                                  .addFavoriteMeal(
                                    Meal(
                                      mealName: widget.mealName,
                                      mealRating: widget.mealRating,
                                      mealImage: widget.mealImage,
                                      cookTime: widget.cookTime,
                                      mealId: int.tryParse(widget.mealId)!,
                                      mealIngredients: widget.mealIngredients,
                                      mealInstructions: widget.mealInstructions,
                                      isFavorite: 1,
                                    ),
                                  );
                            }
                            setState(() {
                              _inFavorites = !_inFavorites;
                            });
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: _inFavorites
                                ? Colors.red
                                : const Color.fromARGB(255, 216, 211, 211),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                child: Hero(
                  tag: widget.mealId,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(widget.mealImage),
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
                  maxLines: 3,
                  widget.mealName,
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
                        '${widget.cookTime} min',
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
                        widget.mealRating,
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
