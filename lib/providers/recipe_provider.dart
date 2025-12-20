import 'package:flutter/material.dart';
import 'package:pure_plate/models/recipe.dart';
import 'package:pure_plate/models/filter.dart';
import 'package:pure_plate/data/recipes.dart';

class RecipeProvider extends ChangeNotifier {
  final List<Recipe> _allRecipes = [...recipes];

  String _searchQuery = '';
  Filter? _activeFilter;

  // ================= GETTERS =================

  List<Recipe> get allRecipes => [..._allRecipes];

  List<Recipe> get favouriteRecipes =>
      _allRecipes.where((r) => r.isFavourite).toList();

  List<Recipe> get suggestedRecipes =>
      _allRecipes.where((r) => r.isFavourite).toList();

  List<Recipe> get filteredRecipes {
    List<Recipe> list = [..._allRecipes];

    if (_searchQuery.isNotEmpty) {
      list = list
          .where((r) =>
              r.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_activeFilter != null) {
      list = list.where(_activeFilter!.matches).toList();
    }

    return list;
  }

  // ================= ACTIONS =================

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void toggleFavourite(String recipeId) {
    final index = _allRecipes.indexWhere((r) => r.id == recipeId);
    if (index != -1) {
      _allRecipes[index] =
          _allRecipes[index].copyWith(isFavourite: !_allRecipes[index].isFavourite);
      notifyListeners();
    }
  }

  void applyFilter(Filter filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  void clearFilter() {
    _activeFilter = null;
    notifyListeners();
  }
}
