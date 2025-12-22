import 'package:flutter/material.dart';
import 'package:pure_plate/models/recipe.dart';

class ScheduleProvider with ChangeNotifier {
  final List<Recipe> _scheduledRecipes = [];

  List<Recipe> get scheduledRecipes => _scheduledRecipes;

  void addToSchedule(Recipe recipe, DateTime date) {
    _scheduledRecipes.add(recipe);
    notifyListeners();
  }

  void removeFromSchedule(Recipe recipe) {
    _scheduledRecipes.remove(recipe);
    notifyListeners();
  }

  void clearSchedule() {
    _scheduledRecipes.clear();
    notifyListeners();
  }
}
