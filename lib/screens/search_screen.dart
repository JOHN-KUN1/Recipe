import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:recipe_app/widgets/meal_display.dart';
import 'package:recipe_app/widgets/meal_search_display.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> _mealSuggestions = [
    'Cheese Cake',
    'Taramisu',
    'Apple Pie',
  ];
  String? _mealName;
  late List _allMeals;
  late int _totalResults;

  Future<void> getMeals(String? meal) async {
    var url = Uri.parse(
      'https://api.spoonacular.com/recipes/complexSearch?query=$meal&apiKey=b7934698a77b4021ac88ea11adfda7b5',
    );
    var response = await http.get(url);
    var resposeBody = jsonDecode(response.body);
    _allMeals = resposeBody['results'];
    _totalResults = resposeBody['totalResults'];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchAnchor(
              builder: (context, controller) {
                return SearchBar(
                  onSubmitted: (value) {
                    setState(() {
                      _mealName = value;
                    });
                  },
                  controller: controller,
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (value) {
                    controller.openView();
                  },
                  leading: const Icon(Icons.search),
                );
              },
              suggestionsBuilder: (context, controller) {
                return List.generate(3, (int index) {
                  return ListTile(
                    title: Text(_mealSuggestions[index]),
                    onTap: () {
                      controller.closeView(_mealSuggestions[index]);
                    },
                  );
                });
              },
            ),
          ),
          if (_mealName != null)
            FutureBuilder(
              future: getMeals(_mealName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      child: Center(
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
                      ),
                    ),
                  );
                } else {
                  if (_totalResults > 0) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: GridView.builder(
                          itemCount: _allMeals.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.6,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                crossAxisCount: 2,
                              ),
                          itemBuilder: (context, index) {
                            return MealSearchDisplay(
                              mealName: _allMeals[index]['title'].toString(),
                              mealImage: _allMeals[index]['image'].toString(),
                              mealId: _allMeals[index]['id'].toString(),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return const Expanded(
                      child: SizedBox(
                        height: double.infinity,
                        child: Center(
                          child: Text('No meals found..'),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
        ],
      ),
    );
  }
}
