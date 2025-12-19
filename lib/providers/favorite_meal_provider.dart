import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:recipe_app/models/meal.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

Future<Database> getDatabase() async {
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'new_favorite_meals.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE favs(id INTEGER PRIMARY KEY, name TEXT, rating TEXT, image TEXT, time TEXT, instructions TEXT,ingredients TEXT, isFavorite INTEGER)',
      );
    },
    version: 1,
  );
  return database;
}

final favoriteMealsProvider = NotifierProvider<MyNotifier, List<Meal>>(() {
  return MyNotifier();
});

class MyNotifier extends Notifier<List<Meal>> {
  MyNotifier();

  @override
  List<Meal> build() {
    return state = <Meal>[];
  }

  Future<void> addFavoriteMeal(Meal newMeal) async {
    state = [...state, newMeal];

    final db = await getDatabase();
    await db.insert('favs', {
      'id': newMeal.mealId,
      'name': newMeal.mealName,
      'rating': newMeal.mealRating,
      'image': newMeal.mealImage,
      'time': newMeal.cookTime,
      'instructions': newMeal.mealInstructions,
      'ingredients': newMeal.mealIngredients.toString(),
      'isFavorite': newMeal.isFavorite,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Meal>> getAllFavorites() async {
    //print('----------------called');
    final db = await getDatabase();

    final allFavs = await db.query('favs');

    //print('-----------${allFavs[0]['ingredients']}');

    List<Meal> favorites = [];

    for (final item in allFavs) {
      favorites.add(
        Meal(
          mealName: item['name'] as String,
          mealRating: item['rating'] as String,
          mealImage: item['image'] as String,
          cookTime: item['time'] as String,
          mealId: int.tryParse(item['id'].toString())!,
          mealIngredients: item['ingredients'] as String,
          mealInstructions: item['instructions'] as String,
          isFavorite: 1
        ),
      );
    }
    //print('---------i--$favorites');
    state = favorites;
    return favorites;
  }
}
