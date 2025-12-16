import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/ingredients_display.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:http/http.dart' as http;

class SearchMealDetail extends StatefulWidget {
  const SearchMealDetail({
    super.key,
    required this.image,
    required this.mealId,
    required this.mealName,
  });

  final String image;
  final String mealId;
  final String mealName;

  @override
  State<SearchMealDetail> createState() => _SearchMealDetailScreenState();
}

class _SearchMealDetailScreenState extends State<SearchMealDetail> {
  Future? _getMeal;
  late Map _meal;

  Future<void> getMealDetail(String mealId) async {
    var url = Uri.parse(
      'https://api.spoonacular.com/recipes/$mealId/information?includeNutrition=true&apiKey=b7934698a77b4021ac88ea11adfda7b5',
    );
    var response = await http.get(url);
    _meal = jsonDecode(response.body) as Map;
  }

  @override
  void initState() {
    super.initState();
    _getMeal = getMealDetail(widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          widget.mealName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Hero(
        tag: widget.mealId,
        child: Material(
          color: Colors.transparent,
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: SizedBox(
                            width: double.infinity,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.favorite_outline,
                            color: Colors.lightGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: DraggableScrollableSheet(
                      minChildSize: 0.2,
                      maxChildSize: 0.6,
                      initialChildSize: 0.4,
                      builder: (context, scrollController) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: FutureBuilder(
                              future: _getMeal,
                              builder: (context, asyncSnapshot) {
                                if (asyncSnapshot.connectionState !=
                                    ConnectionState.waiting) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 15,
                                          bottom: 25,
                                        ),
                                        child: Container(
                                          height: 3,
                                          width: 65,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          'Ingredients',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10.0,
                                          ),
                                          child: Row(
                                            children: [
                                              for (final item
                                                  in _meal['extendedIngredients'])
                                                IngredientsDisplay(
                                                  ingredientPic:
                                                      'https://img.spoonacular.com/ingredients_100x100/${item['image']}',
                                                  ingredientMeasurement:
                                                      '${item['measures']['metric']['amount']}${item['measures']['metric']['unitShort']}',
                                                ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsetsGeometry.only(
                                          bottom: 15,
                                          top: 15,
                                        ),
                                        child: Text(
                                          'Recipe',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                        ),
                                        child: Text(
                                          _meal['instructions'],
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: Column(
                                      mainAxisSize: .min,
                                      children: [
                                        LoadingAnimationWidget.staggeredDotsWave(
                                          color: Colors.lightGreen,
                                          size: 50,
                                        ),
                                        const Text(
                                          'Loading...',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
