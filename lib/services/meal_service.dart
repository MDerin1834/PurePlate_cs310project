import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pure_plate/models/meal_log.dart';

class MealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CREATE - Add a meal log for a user
  Future<void> addMeal(String userId, String recipeName, int calories, int protein) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('meal_logs')
        .add({
      'recipeName': recipeName,
      'calories': calories,
      'protein': protein,  // ← ADD THIS
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': userId,
    });
  }

  // READ - Get all meal logs for a user (real-time stream)
  Stream<List<MealLog>> getMeals(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('meal_logs')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => MealLog.fromFirestore(doc)).toList();
    });
  }

  // UPDATE - Update a meal log
  Future<void> updateMeal(String userId, String mealId, String recipeName, int calories, int protein) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('meal_logs')
        .doc(mealId)
        .update({
      'recipeName': recipeName,
      'calories': calories,
      'protein': protein,  // ← ADD THIS
    });
  }

  // DELETE - Delete a meal log
  Future<void> deleteMeal(String userId, String mealId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('meal_logs')
        .doc(mealId)
        .delete();
  }
}