import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal_record_model.dart';

/// Firestore Service for MealRecord CRUD Operations
/// Handles all database interactions for meal records
class MealRecordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _mealsCollection =>
      _firestore.collection('meal_records');

  // ========================================================================
  // CREATE - Add new meal record
  // ========================================================================

  /// Add a new meal record to Firestore
  Future<String> createMealRecord({
    required String userId,
    required String mealName,
    required int calories,
    required int protein,
    required int carbs,
    required int fats,
    required String time,
    required DateTime date,
  }) async {
    try {
      final now = DateTime.now();

      final mealData = {
        'mealName': mealName,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fats': fats,
        'time': time,
        'date': Timestamp.fromDate(date),
        'createdBy': userId,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': null,
      };

      final docRef = await _mealsCollection.add(mealData);
      return docRef.id; // Return the generated document ID
    } catch (e) {
      throw Exception('Failed to create meal record: $e');
    }
  }

  // ========================================================================
  // READ - Get meal records
  // ========================================================================

  /// Get all meal records for a specific user (real-time stream)
  Stream<List<MealRecord>> getMealRecordsStream(String userId) {
    try {
      return _mealsCollection
          .where('createdBy', isEqualTo: userId)
          .orderBy('date', descending: true)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => MealRecord.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to get meal records stream: $e');
    }
  }

  /// Get meal records for a specific date (real-time stream)
  Stream<List<MealRecord>> getMealRecordsByDateStream(
      String userId,
      DateTime date,
      ) {
    try {
      // Start of day
      final startOfDay = DateTime(date.year, date.month, date.day);
      // End of day
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      return _mealsCollection
          .where('createdBy', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('date', descending: false)
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => MealRecord.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to get meal records by date: $e');
    }
  }

  /// Get a single meal record by ID (one-time fetch)
  Future<MealRecord?> getMealRecordById(String mealId) async {
    try {
      final doc = await _mealsCollection.doc(mealId).get();

      if (doc.exists) {
        return MealRecord.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get meal record: $e');
    }
  }

  /// Get meal records for a date range (one-time fetch)
  Future<List<MealRecord>> getMealRecordsByDateRange(
      String userId,
      DateTime startDate,
      DateTime endDate,
      ) async {
    try {
      final querySnapshot = await _mealsCollection
          .where('createdBy', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => MealRecord.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get meal records by date range: $e');
    }
  }

  // ========================================================================
  // UPDATE - Modify existing meal record
  // ========================================================================

  /// Update an existing meal record
  Future<void> updateMealRecord({
    required String mealId,
    String? mealName,
    int? calories,
    int? protein,
    int? carbs,
    int? fats,
    String? time,
    DateTime? date,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (mealName != null) updateData['mealName'] = mealName;
      if (calories != null) updateData['calories'] = calories;
      if (protein != null) updateData['protein'] = protein;
      if (carbs != null) updateData['carbs'] = carbs;
      if (fats != null) updateData['fats'] = fats;
      if (time != null) updateData['time'] = time;
      if (date != null) updateData['date'] = Timestamp.fromDate(date);

      await _mealsCollection.doc(mealId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update meal record: $e');
    }
  }

  // ========================================================================
  // DELETE - Remove meal record
  // ========================================================================

  /// Delete a meal record by ID
  Future<void> deleteMealRecord(String mealId) async {
    try {
      await _mealsCollection.doc(mealId).delete();
    } catch (e) {
      throw Exception('Failed to delete meal record: $e');
    }
  }

  /// Delete all meal records for a user (use with caution!)
  Future<void> deleteAllUserMealRecords(String userId) async {
    try {
      final querySnapshot = await _mealsCollection
          .where('createdBy', isEqualTo: userId)
          .get();

      // Delete in batch
      final batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete all user meal records: $e');
    }
  }

  // ========================================================================
  // ANALYTICS - Get statistics
  // ========================================================================

  /// Get total calories for a specific date
  Future<int> getTotalCaloriesForDate(String userId, DateTime date) async {
    try {
      final meals = await getMealRecordsByDateRange(
        userId,
        DateTime(date.year, date.month, date.day),
        DateTime(date.year, date.month, date.day, 23, 59, 59),
      );

      return meals.fold<int>(0, (sum, meal) => sum + meal.calories);
    } catch (e) {
      throw Exception('Failed to get total calories: $e');
    }
  }

  /// Get total protein for a specific date
  Future<int> getTotalProteinForDate(String userId, DateTime date) async {
    try {
      final meals = await getMealRecordsByDateRange(
        userId,
        DateTime(date.year, date.month, date.day),
        DateTime(date.year, date.month, date.day, 23, 59, 59),
      );

      return meals.fold<int>(0, (sum, meal) => sum + meal.protein);
    } catch (e) {
      throw Exception('Failed to get total protein: $e');
    }
  }

  /// Get meal count for a specific date
  Future<int> getMealCountForDate(String userId, DateTime date) async {
    try {
      final meals = await getMealRecordsByDateRange(
        userId,
        DateTime(date.year, date.month, date.day),
        DateTime(date.year, date.month, date.day, 23, 59, 59),
      );

      return meals.length;
    } catch (e) {
      throw Exception('Failed to get meal count: $e');
    }
  }
}
