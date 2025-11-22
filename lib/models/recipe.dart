class Recipe {
  final String name;
  final String imageURL;
  final int calories;
  final int cookingTime;
  final String instructions;
  final List<String> ingredients;
  final bool isVegetarian;
  final bool isLactoseFree;
  final bool isFavourite;

  const Recipe({
    required this.name,
    required this.imageURL,
    required this.calories,
    required this.cookingTime,
    required this.instructions,
    required this.ingredients,
    this.isVegetarian = false,
    this.isLactoseFree = false,
    this.isFavourite = false,
  });
}