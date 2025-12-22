import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pure_plate/models/meal_log.dart';
import 'package:pure_plate/providers/auth_provider.dart';
import 'package:pure_plate/services/meal_service.dart';

class MealLogProvider extends ChangeNotifier {
  final MealService _mealService = MealService();
  final AuthProvider _authProvider;

  StreamSubscription? _subscription;

  List<MealLog> _mealLogs = [];
  bool _isLoading = false;

  MealLogProvider(this._authProvider) {
    _listenToMealLogs();
  }

  // =========================
  // Public getters
  // =========================

  List<MealLog> get mealLogs => _mealLogs;
  bool get isLoading => _isLoading;

  /// Total calories consumed today
  int get todayCalories {
    final today = DateTime.now();

    return _mealLogs
        .where((log) =>
    log.createdAt.year == today.year &&
        log.createdAt.month == today.month &&
        log.createdAt.day == today.day)
        .fold(0, (sum, log) => sum + log.calories);
  }

  // =========================
  // Firestore stream listener
  // =========================

  void _listenToMealLogs() {
    final user = _authProvider.user;

    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();

    _subscription = _mealService.getMeals(user.uid).listen((meals) {
      _mealLogs = meals;
      _isLoading = false;
      notifyListeners();
    });
  }

  // =========================
  // CREATE - Add meal to log
  // =========================

  Future<void> logMeal(String recipeName, int calories) async {
    final user = _authProvider.user;
    if (user == null) return;

    await _mealService.addMeal(
      userId: user.uid,
      recipeName: recipeName,
      calories: calories,
    );
  }

  // =========================
  // UPDATE - Edit meal
  // =========================

  Future<void> updateMeal(String mealId, String recipeName, int calories) async {
    final user = _authProvider.user;
    if (user == null) return;

    await _mealService.updateMeal(
      userId: user.uid,
      mealId: mealId,
      recipeName: recipeName,
      calories: calories,
    );
  }

  // =========================
  // DELETE - Remove meal
  // =========================

  Future<void> deleteMeal(String mealId) async {
    final user = _authProvider.user;
    if (user == null) return;

    await _mealService.deleteMeal(
      userId: user.uid,
      mealId: mealId,
    );
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