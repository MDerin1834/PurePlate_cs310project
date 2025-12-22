import 'package:flutter/material.dart';
import 'package:pure_plate/providers/auth_provider.dart';
import 'package:pure_plate/services/meal_service.dart';
import 'package:pure_plate/models/meal_log.dart';
import 'dart:async';

class MealLogProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final MealService _mealService = MealService();

  List<MealLog> _mealLogs = [];
  bool _isLoading = false;
  StreamSubscription? _mealsSubscription;

  MealLogProvider(this._authProvider) {
    _init();
  }

  List<MealLog> get mealLogs => _mealLogs;
  bool get isLoading => _isLoading;

  int get todayCalories {
    final today = DateTime.now();
    return _mealLogs
        .where((meal) =>
    meal.createdAt.year == today.year &&
        meal.createdAt.month == today.month &&
        meal.createdAt.day == today.day)
        .fold(0, (sum, meal) => sum + meal.calories);
  }

  // ← ADD THIS: Calculate today's protein
  int get todayProtein {
    final today = DateTime.now();
    return _mealLogs
        .where((meal) =>
    meal.createdAt.year == today.year &&
        meal.createdAt.month == today.month &&
        meal.createdAt.day == today.day)
        .fold(0, (sum, meal) => sum + meal.protein);
  }

  void _init() {
    if (_authProvider.user != null) {
      _loadMeals();
    }
  }

  void _loadMeals() {
    final userId = _authProvider.user?.uid;
    if (userId == null) return;

    _isLoading = true;
    notifyListeners();

    _mealsSubscription?.cancel();
    _mealsSubscription = _mealService.getMeals(userId).listen((meals) {
      _mealLogs = meals;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> logMeal(String recipeName, int calories, int protein) async {
    final userId = _authProvider.user?.uid;
    if (userId == null) return;

    await _mealService.addMeal(userId, recipeName, calories, protein);
  }

  Future<void> updateMeal(String mealId, String recipeName, int calories, int protein) async {
    final userId = _authProvider.user?.uid;
    if (userId == null) return;

    await _mealService.updateMeal(userId, mealId, recipeName, calories, protein);
  }

  Future<void> deleteMeal(String mealId) async {
    final userId = _authProvider.user?.uid;
    if (userId == null) return;

    await _mealService.deleteMeal(userId, mealId);
  }

  @override
  void dispose() {
    _mealsSubscription?.cancel();
    super.dispose();
  }
}