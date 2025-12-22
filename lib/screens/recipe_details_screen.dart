import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pure_plate/models/recipe.dart';
import 'package:pure_plate/services/recipe_service.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeService _recipeService = RecipeService();

  StreamSubscription? _subscription;

  List<Recipe> _recipes = [];
  bool _isLoading = false;

  RecipeProvider() {
    _listenToRecipes();
  }

  // =========================
  // Getters
  // =========================

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;

  List<Recipe> get favouriteRecipes =>
      _recipes.where((r) => r.isFavourite).toList();

  // =========================
  // Listen to Firestore
  // =========================

  void _listenToRecipes() {
    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();

    _subscription = _recipeService.getRecipes().listen((recipes) {
      _recipes = recipes;
      _isLoading = false;
      notifyListeners();
    });
  }

  // =========================
  // Cleanup
  // =========================

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}