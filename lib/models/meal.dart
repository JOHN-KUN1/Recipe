class Meal {
  const Meal({
    required this.mealName,
    required this.mealRating,
    required this.mealImage,
    required this.cookTime,
    required this.mealId,
    required this.mealIngredients,
    required this.mealInstructions,
    this.isFavorite = 0,
  });

  final String mealName;
  final String mealRating;
  final String mealImage;
  final String cookTime;
  final int mealId;
  final String mealInstructions;
  final List mealIngredients;
  final int isFavorite;
}
