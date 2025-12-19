import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:recipe_app/providers/favorite_meal_provider.dart';
import 'package:json_repair_flutter/json_repair_flutter.dart';
import 'dart:convert';

import 'package:recipe_app/widgets/meal_display.dart';

class FavoritesScreen extends ConsumerStatefulWidget{
  const FavoritesScreen({super.key});
  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  late List _allMeals;
  Future? _loadFavoriteMeals;


  @override
  void initState() {
    _loadFavoriteMeals = ref.read(favoriteMealsProvider.notifier).getAllFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allFavoriteMeals = ref.watch(favoriteMealsProvider);
    print('-----------${repairJson(allFavoriteMeals[0].mealIngredients)}');
    return FutureBuilder(
      future: _loadFavoriteMeals,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.lightGreen,
                  size: 50,
                ),
                const Text('Loading...',style: TextStyle(color: Colors.black),)
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisSize: .max,
              crossAxisAlignment: .start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, left: 12,top: 15),
                  child: Text(
                    'Favorites',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: GridView.builder(
                      itemCount: allFavoriteMeals.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            crossAxisCount: 2,
                          ),
                      itemBuilder: (context, index) {
                        return MealDisplay(
                          mealName: allFavoriteMeals[index].mealName.toString(),
                          mealRating: allFavoriteMeals[index].mealRating
                              .toString(),
                          mealImage: allFavoriteMeals[index].mealImage.toString(),
                          cookTime: allFavoriteMeals[index].cookTime
                              .toString(),
                          mealId: allFavoriteMeals[index].mealId.toString(),
                          mealIngredients:
                              repairJson(allFavoriteMeals[index].mealIngredients),
                          mealInstructions: allFavoriteMeals[index].mealInstructions
                              .toString(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
