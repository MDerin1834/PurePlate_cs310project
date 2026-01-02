import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pure_plate/models/meal_log.dart';
import 'package:pure_plate/providers/auth_provider.dart';
import 'package:pure_plate/services/meal_service.dart';

class MealLogProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final MealService _mealService;

  List<MealLog> _mealLogs = [];
  bool _isLoading = false;
  StreamSubscription<List<MealLog>>? _mealsSubscription;

  /// Constructor with dependency injection (REQUIRED for unit testing)
  MealLogProvider(
      this._authProvider,
      {MealService? mealService}
      ) : _mealService = mealService ?? MealService() {
    _init();
  }

  /// Expose immutable state
  List<MealLog> get mealLogs => List.unmodifiable(_mealLogs);
  bool get isLoading => _isLoading;

  /// ---- Derived state ----

  int get todayCalories {
    final today = _now;
    return _mealLogs
        .where((meal) =>
            meal.createdAt.year == today.year &&
            meal.createdAt.month == today.month &&
            meal.createdAt.day == today.day)
        .fold(0, (sum, meal) => sum + meal.calories);
  }

  int get todayProtein {
    final today = _now;
    return _mealLogs
        .where((meal) =>
            meal.createdAt.year == today.year &&
            meal.createdAt.month == today.month &&
            meal.createdAt.day == today.day)
        .fold(0, (sum, meal) => sum + meal.protein);
  }

  /// ---- Initialization ----

  void _init() {
    if (_authProvider.user != null) {
      _loadMeals();
    }
  }

  /// ---- Data loading ----

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

  /// ---- Actions ----

  Future<void> logMeal(
    String recipeName,
    int calories,
    int protein,
  ) async {
    final userId = _authProvider.user?.uid;
    if (userId == null) return;

    await _mealService.addMeal(
      userId,
      recipeName,
      calories,
      protein,
    );
  }

  Future<void> updateMeal(
    String mealId,
    String recipeName,
    int calories,
    int protein,
  ) async {
    final userId = _authProvider.user?.uid;
    if (userId == null) return;

    await _mealService.updateMeal(
      userId,
      mealId,
      recipeName,
      calories,
      protein,
    );
  }

  Future<void> deleteMeal(String mealId) async {
    final userId = _authProvider.user?.uid;
    if (userId == null) return;

    await _mealService.deleteMeal(userId, mealId);
  }

  /// ---- Time abstraction (test-friendly) ----

  DateTime get _now => DateTime.now();

  /// ---- Cleanup ----

  @override
  void dispose() {
    _mealsSubscription?.cancel();
    super.dispose();
  }
}
