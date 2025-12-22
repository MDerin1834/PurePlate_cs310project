import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pure_plate/models/meal_log.dart';

class MealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== CREATE ==========
  Future<void> addMeal({
    required String userId,
    required String recipeName,
    required int calories,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('meal_logs')
        .add({
      'recipeName': recipeName,
      'calories': calories,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': userId,
    });
  }

  // ========== READ (Real-time Stream) ==========
  Stream<List<MealLog>> getMeals(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('meal_logs')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MealLog.fromFirestore(doc))
        .toList());
  }

  // ========== UPDATE ==========
  Future<void> updateMeal({
    required String userId,
    required String mealId,
    required String recipeName,
    required int calories,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('meal_logs')
        .doc(mealId)
        .update({
      'recipeName': recipeName,
      'calories': calories,
    });
  }

  // ========== DELETE ==========
  Future<void> deleteMeal({
    required String userId,
    required String mealId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('meal_logs')
        .doc(mealId)
        .delete();
  }
}