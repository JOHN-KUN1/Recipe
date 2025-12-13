import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/ingredients_display.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.image,
    required this.ingredients,
    required this.instructions,
    required this.mealId,
    required this.mealName,
  });

  final String image;
  final List ingredients;
  final String instructions;
  final String mealId;
  final String mealName;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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
                            child: Column(
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
                                      borderRadius: BorderRadius.circular(10),
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
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Row(
                                      children: [
                                        for (final item in widget.ingredients)
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
                                Text(
                                  widget.instructions,
                                  textAlign: TextAlign.center,
                                ),
                              ],
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
