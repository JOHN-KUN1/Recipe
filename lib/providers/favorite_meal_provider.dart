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
    join(await getDatabasesPath(), 'all_favorite_meals.db'),
    onCreate: (db, version) {
      return db.execute('CREATE TABLE favmeals(id INTEGER PRIMARY KEY, name TEXT, rating TEXT, image TEXT, time TEXT, instructions TEXT,ingredients TEXT, isFavorite INTEGER)');
    },
    version: 2
  );
  return database;
}


final favoriteMealsProvider = NotifierProvider<MyNotifier, List<Meal>>((){
  return MyNotifier();
});

class MyNotifier extends Notifier<List<Meal>>{
  MyNotifier();

  @override
  List<Meal> build() {
    return state = <Meal>[];
  }

  Future<void> addFavoriteMeal(Meal newMeal) async {
    state = [...state, newMeal];

    final db = await getDatabase();
    await db.insert('favmeals', {
      'id' : newMeal.mealId,
      'name' : newMeal.mealName,
      'rating' : newMeal.mealRating,
      'image' : newMeal.mealImage,
      'time' : newMeal.cookTime,
      'instructions' : newMeal.mealInstructions,
      'ingredients' : newMeal.mealIngredients.toString(),
      'isFavorite' : newMeal.isFavorite
    },
    conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Meal>> getAllFavorites() async{
    final db = await getDatabase();

    final allFavs = await db.query('favmeals');

    final favorites = allFavs.map((item){
      return Meal(mealName: item['name'] as String, mealRating: item['rating'] as String, mealImage: item['image'] as String , cookTime: item['time'] as String , mealId: item['id'] as int, mealIngredients: item['ingredients'] as List, mealInstructions: item['instructions'] as String, isFavorite: item['isFavorite'] as int);
    }).toList();

    state = favorites;
    return favorites;
  }

}