import 'package:cloud_firestore/cloud_firestore.dart';

class MealLog {
  final String id;
  final String recipeName;
  final int calories;
  final int protein;  // ← ADD THIS
  final DateTime createdAt;
  final String createdBy;

  MealLog({
    required this.id,
    required this.recipeName,
    required this.calories,
    required this.protein,  // ← ADD THIS
    required this.createdAt,
    required this.createdBy,
  });

  // Create from Firestore document
  factory MealLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MealLog(
      id: doc.id,
      recipeName: data['recipeName'] ?? '',
      calories: data['calories'] ?? 0,
      protein: data['protein'] ?? 0,  // ← ADD THIS
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'recipeName': recipeName,
      'calories': calories,
      'protein': protein,  // ← ADD THIS
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }
}