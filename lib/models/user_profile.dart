import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final int age;
  final String dietType;
  final int calorieTarget;
  final int proteinTarget;
  final bool isGlutenFree;
  final bool isVegetarian;
  final bool isLactoseFree;
  final bool isLowCarb;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.age,
    required this.dietType,
    required this.calorieTarget,
    required this.proteinTarget,
    this.isGlutenFree = false,
    this.isVegetarian = false,
    this.isLactoseFree = false,
    this.isLowCarb = false,
  });

  // Convert Firestore document to UserProfile
  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      age: data['age'] ?? 0,
      dietType: data['dietType'] ?? 'Balanced',
      calorieTarget: data['calorieTarget'] ?? 2000,
      proteinTarget: data['proteinTarget'] ?? 80,
      isGlutenFree: data['isGlutenFree'] ?? false,
      isVegetarian: data['isVegetarian'] ?? false,
      isLactoseFree: data['isLactoseFree'] ?? false,
      isLowCarb: data['isLowCarb'] ?? false,
    );
  }

  // Convert UserProfile to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'age': age,
      'dietType': dietType,
      'calorieTarget': calorieTarget,
      'proteinTarget': proteinTarget,
      'isGlutenFree': isGlutenFree,
      'isVegetarian': isVegetarian,
      'isLactoseFree': isLactoseFree,
      'isLowCarb': isLowCarb,
    };
  }

  UserProfile copyWith({
    String? uid,
    String? name,
    String? email,
    int? age,
    String? dietType,
    int? calorieTarget,
    int? proteinTarget,
    bool? isGlutenFree,
    bool? isVegetarian,
    bool? isLactoseFree,
    bool? isLowCarb,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
      dietType: dietType ?? this.dietType,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isLactoseFree: isLactoseFree ?? this.isLactoseFree,
      isLowCarb: isLowCarb ?? this.isLowCarb,
    );
  }
}