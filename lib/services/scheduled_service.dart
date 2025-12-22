import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pure_plate/models/scheduled_recipe.dart';

class ScheduledService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> scheduleMeal({
    required String userId,
    required String recipeId,
    required DateTime time,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('scheduled')
        .add({
          'recipeId': recipeId,
          'time': time.toIso8601String(),
          'createdBy': userId,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  Stream<List<ScheduledRecipe>> getScheduled(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('scheduled')
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => ScheduledRecipe(id: doc.id, recipeId: doc['recipeId'] as String, isoTime: doc['time'] as String)).toList();
        });
  }

  Future<void> deleteScheduled({
    required String userId,
    required String scheduleId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('scheduled')
        .doc(scheduleId)
        .delete();
  }
}
