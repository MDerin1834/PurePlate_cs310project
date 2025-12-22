import 'package:cloud_firestore/cloud_firestore.dart';

class MealLog {
  final String id;              // Firestore document ID
  final String recipeName;
  final int calories;
  final DateTime createdAt;     // Required by Step 3
  final String createdBy;       // Required by Step 3 (user ID)

  MealLog({
    required this.id,
    required this.recipeName,
    required this.calories,
    required this.createdAt,
    required this.createdBy,
  });

  // Convert Firestore document to MealLog
  factory MealLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MealLog(
      id: doc.id,
      recipeName: data['recipeName'] ?? '',
      calories: data['calories'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  // Convert MealLog to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'recipeName': recipeName,
      'calories': calories,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }
}