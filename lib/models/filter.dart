import 'package:pure_plate/models/recipe.dart';

class Filter {
  int maxCalories;
  int cookingTime;
  bool isGlutenFree;
  bool isVegetarian;
  bool isLactoseFree;
  Set<String> ingredients;

  Filter({
    required this.maxCalories,
    required this.cookingTime,
    this.isGlutenFree = false,
    this.isVegetarian = false,
    this.isLactoseFree = false,
    required this.ingredients,
  });

  bool matches(Recipe r) {
    return r.calories <= maxCalories &&
        r.cookingTime <= cookingTime &&
        (!isVegetarian || r.isVegetarian) &&
        (!isLactoseFree || r.isLactoseFree) &&
        (ingredients.isEmpty ||
            r.ingredients.fold(true, (b, s) => b && ingredients.contains(s)));
  }
}
