import 'package:cloud_firestore/cloud_firestore.dart';

/// MealRecord Model for Firestore
/// Represents a single meal logged by a user
class MealRecord {
  final String id; // Unique Firestore document ID
  final String mealName;
  final int calories;
  final int protein; // in grams
  final int carbs; // in grams
  final int fats; // in grams
  final String time; // e.g., "08:30 AM"
  final DateTime date; // Date of the meal
  final String createdBy; // User ID who created this record
  final DateTime createdAt; // Timestamp when created
  final DateTime? updatedAt; // Optional: last update timestamp

  const MealRecord({
    required this.id,
    required this.mealName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.time,
    required this.date,
    required this.createdBy,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convert Firestore document to MealRecord object
  factory MealRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MealRecord(
      id: doc.id,
      mealName: data['mealName'] ?? '',
      calories: data['calories'] ?? 0,
      protein: data['protein'] ?? 0,
      carbs: data['carbs'] ?? 0,
      fats: data['fats'] ?? 0,
      time: data['time'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert MealRecord object to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'mealName': mealName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'time': time,
      'date': Timestamp.fromDate(date),
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// Create a copy with updated fields
  MealRecord copyWith({
    String? id,
    String? mealName,
    int? calories,
    int? protein,
    int? carbs,
    int? fats,
    String? time,
    DateTime? date,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MealRecord(
      id: id ?? this.id,
      mealName: mealName ?? this.mealName,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      time: time ?? this.time,
      date: date ?? this.date,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get total macronutrients
  int get totalMacros => protein + carbs + fats;

  /// Calculate calories from macros (cross-check)
  int get calculatedCalories => (protein * 4) + (carbs * 4) + (fats * 9);
}
