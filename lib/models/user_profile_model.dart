import 'package:cloud_firestore/cloud_firestore.dart';

/// UserProfile Model for Firestore
/// Stores user profile information and preferences
class UserProfile {
  final String id; // Firebase Auth UID
  final String name;
  final String email;
  final int age;
  final String dietType; // e.g., "Balanced", "High Protein", "Low Carb"
  final int calorieTarget;
  final int proteinTarget;
  final String? profileImageUrl;
  final bool isGlutenFree;
  final bool isVegetarian;
  final bool isLactoseFree;
  final bool isLowCarb;
  final DateTime createdAt; // When user registered
  final DateTime? updatedAt; // Last profile update

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.dietType,
    required this.calorieTarget,
    required this.proteinTarget,
    this.profileImageUrl,
    this.isGlutenFree = false,
    this.isVegetarian = false,
    this.isLactoseFree = false,
    this.isLowCarb = false,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convert Firestore document to UserProfile object
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserProfile(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      age: data['age'] ?? 0,
      dietType: data['dietType'] ?? 'Balanced',
      calorieTarget: data['calorieTarget'] ?? 2000,
      proteinTarget: data['proteinTarget'] ?? 80,
      profileImageUrl: data['profileImageUrl'],
      isGlutenFree: data['isGlutenFree'] ?? false,
      isVegetarian: data['isVegetarian'] ?? false,
      isLactoseFree: data['isLactoseFree'] ?? false,
      isLowCarb: data['isLowCarb'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert UserProfile object to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'dietType': dietType,
      'calorieTarget': calorieTarget,
      'proteinTarget': proteinTarget,
      'profileImageUrl': profileImageUrl,
      'isGlutenFree': isGlutenFree,
      'isVegetarian': isVegetarian,
      'isLactoseFree': isLactoseFree,
      'isLowCarb': isLowCarb,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// Create a copy with updated fields
  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    int? age,
    String? dietType,
    int? calorieTarget,
    int? proteinTarget,
    String? profileImageUrl,
    bool? isGlutenFree,
    bool? isVegetarian,
    bool? isLactoseFree,
    bool? isLowCarb,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      dietType: dietType ?? this.dietType,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isLactoseFree: isLactoseFree ?? this.isLactoseFree,
      isLowCarb: isLowCarb ?? this.isLowCarb,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get list of dietary restrictions
  List<String> get dietaryRestrictions {
    List<String> restrictions = [];
    if (isGlutenFree) restrictions.add('Gluten-Free');
    if (isVegetarian) restrictions.add('Vegetarian');
    if (isLactoseFree) restrictions.add('Lactose-Free');
    if (isLowCarb) restrictions.add('Low Carb');
    return restrictions;
  }
}
