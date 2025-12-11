import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:recipe_app/widgets/meal_display.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List _allMeals;
  Future? _loadRandomMeals;
  bool _allCategoriesSelected = true;
  bool _glutenFreeCategorySelected = false;
  bool _veganCategorySelected = false;
  bool _vegetarianCategorySelected = false;
  bool _ketogenicCategorySelected = false;

  Future<void> loadRandomMeals({String category = 'random'}) async {
    if (category == 'random') {
      var url = Uri.parse(
        'https://api.spoonacular.com/recipes/random?apiKey=b7934698a77b4021ac88ea11adfda7b5&number=10',
      );
      var response = await http.get(url);
      var resposeBody = jsonDecode(response.body);
      _allMeals = resposeBody['recipes'];
    } else {
      var url = Uri.parse(
        'https://api.spoonacular.com/recipes/random?apiKey=b7934698a77b4021ac88ea11adfda7b5&number=10&include-tags=$category',
      );
      var response = await http.get(url);
      var resposeBody = jsonDecode(response.body);
      _allMeals = resposeBody['recipes'];
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRandomMeals = loadRandomMeals();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadRandomMeals,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Center(
            child: Column(
              mainAxisSize: .max,
              crossAxisAlignment: .start,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(
                    bottom: 12,
                    top: 15,
                    left: 10,
                    right: 5,
                  ),
                  child: Text(
                    'Popular Categories',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 5,
                    bottom: 3,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _allCategoriesSelected = true;
                              _veganCategorySelected = false;
                              _vegetarianCategorySelected = false;
                              _glutenFreeCategorySelected = false;
                              _ketogenicCategorySelected = false;
                              loadRandomMeals();
                            });
                          },
                          child: Text(
                            'All',
                            style: TextStyle(
                              color: _allCategoriesSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            shadowColor: _allCategoriesSelected
                                ? Colors.greenAccent
                                : null,
                            elevation: 4,
                            backgroundColor: _allCategoriesSelected
                                ? Colors.lightGreen
                                : Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _allCategoriesSelected = false;
                              _veganCategorySelected = false;
                              _vegetarianCategorySelected = false;
                              _glutenFreeCategorySelected = true;
                              _ketogenicCategorySelected = false;
                              loadRandomMeals(category: 'gluten free');
                            });
                          },
                          child: Text(
                            'Gluten Free',
                            style: TextStyle(
                              color: _glutenFreeCategorySelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            elevation: 4,
                            shadowColor: _glutenFreeCategorySelected
                                ? Colors.greenAccent
                                : null,
                            backgroundColor: _glutenFreeCategorySelected
                                ? Colors.lightGreen
                                : Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _allCategoriesSelected = false;
                              _veganCategorySelected = true;
                              _vegetarianCategorySelected = false;
                              _glutenFreeCategorySelected = false;
                              _ketogenicCategorySelected = false;
                              loadRandomMeals(category: 'vegan');
                            });
                          },
                          child: Text(
                            'Vegan',
                            style: TextStyle(
                              color: _veganCategorySelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            elevation: 4,
                            shadowColor: _veganCategorySelected
                                ? Colors.greenAccent
                                : null,
                            backgroundColor: _veganCategorySelected
                                ? Colors.lightGreen
                                : Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _allCategoriesSelected = false;
                              _veganCategorySelected = false;
                              _vegetarianCategorySelected = true;
                              _glutenFreeCategorySelected = false;
                              _ketogenicCategorySelected = false;
                              loadRandomMeals(category: 'vegetarian');
                            });
                          },
                          child: Text(
                            'Vegetarian',
                            style: TextStyle(
                              color: _vegetarianCategorySelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            elevation: 4,
                            shadowColor: _vegetarianCategorySelected
                                ? Colors.greenAccent
                                : null,
                            backgroundColor: _vegetarianCategorySelected
                                ? Colors.lightGreen
                                : Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _allCategoriesSelected = false;
                              _veganCategorySelected = false;
                              _vegetarianCategorySelected = false;
                              _glutenFreeCategorySelected = false;
                              _ketogenicCategorySelected = true;
                              loadRandomMeals(category: 'ketogenic');
                            });
                          },
                          child: Text(
                            'Ketogenic',
                            style: TextStyle(
                              color: _ketogenicCategorySelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            shadowColor: _ketogenicCategorySelected
                                ? Colors.greenAccent
                                : null,
                            elevation: 4,
                            backgroundColor: _ketogenicCategorySelected
                                ? Colors.lightGreen
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 10),
                  child: Text(
                    'Popular',
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
                      itemCount: 10,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return MealDisplay(
                          mealName: _allMeals[index]['title'].toString(),
                          mealRating: _allMeals[index]['aggregateLikes']
                              .toString(),
                          mealImage: _allMeals[index]['image'].toString(),
                          cookTime: _allMeals[index]['readyInMinutes']
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
