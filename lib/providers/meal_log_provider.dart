import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pure_plate/models/recipe.dart';
import 'package:pure_plate/providers/auth_provider.dart';

/// Single meal log entry model
class MealLog {
  final String id;
  final String recipeId;
  final String recipeName;
  final int calories;
  final DateTime loggedAt;

  MealLog({
    required this.id,
    required this.recipeId,
    required this.recipeName,
    required this.calories,
    required this.loggedAt,
  });

  factory MealLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MealLog(
      id: doc.id,
      recipeId: data['recipeId'],
      recipeName: data['recipeName'],
      calories: data['calories'],
      loggedAt: (data['loggedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'recipeName': recipeName,
      'calories': calories,
      'loggedAt': Timestamp.fromDate(loggedAt),
    };
  }
}

/// Provider responsible for meal logging & calorie tracking
class MealLogProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
            log.loggedAt.year == today.year &&
            log.loggedAt.month == today.month &&
            log.loggedAt.day == today.day)
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

    _subscription = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meal_logs')
        .orderBy('loggedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _mealLogs =
          snapshot.docs.map((doc) => MealLog.fromFirestore(doc)).toList();

      _isLoading = false;
      notifyListeners();
    });
  }

  // =========================
  // Add meal to log
  // =========================

  Future<void> logMeal(Recipe recipe) async {
    final user = _authProvider.user;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meal_logs')
        .doc();

    final log = MealLog(
      id: docRef.id,
      recipeId: recipe.id,
      recipeName: recipe.name,
      calories: recipe.calories,
      loggedAt: DateTime.now(),
    );

    await docRef.set(log.toMap());
  }

  // =========================
  // Remove meal (optional but useful)
  // =========================

  Future<void> deleteMeal(String logId) async {
    final user = _authProvider.user;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meal_logs')
        .doc(logId)
        .delete();
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
