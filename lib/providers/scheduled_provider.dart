import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pure_plate/models/recipe.dart';
import 'package:pure_plate/models/scheduled_recipe.dart';
import 'package:pure_plate/providers/auth_provider.dart';
import 'package:pure_plate/services/scheduled_service.dart';

class ScheduleProvider with ChangeNotifier {
  final AuthProvider _authProvider;
  final _scheduledService = ScheduledService();

  StreamSubscription? _subscription;

  List<ScheduledRecipe> _scheduledRecipes = [];
  bool _isLoading = false;

  ScheduleProvider(this._authProvider) {
    _listenToScheduled();
  }

  List<ScheduledRecipe> get scheduledRecipes => _scheduledRecipes;
  bool get isLoading => _isLoading;

  void _listenToScheduled() {
    final user = _authProvider.user;
    if (user == null) return;
    
    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();

    _subscription = _scheduledService.getScheduled(user.uid).listen((scheduled) {
      _scheduledRecipes = scheduled;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addToSchedule(Recipe recipe, DateTime date) async {
    final user = _authProvider.user;
    if (user == null) return;

    await _scheduledService.scheduleMeal(userId: user.uid, recipeId: recipe.name, time: date);
    notifyListeners();
  }

  Future<void> removeFromSchedule(String scheduleId) async {
    final user = _authProvider.user;
    if (user == null) return;

    await _scheduledService.deleteScheduled(userId: user.uid, scheduleId: scheduleId);
    notifyListeners();
  }

  void clearSchedule() {
    _scheduledRecipes.clear();
    notifyListeners();
  }
}
