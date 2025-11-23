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
}
