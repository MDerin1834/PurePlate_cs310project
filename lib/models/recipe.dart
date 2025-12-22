import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String? id;
  final String name;
  final String imageURL;
  final int calories;
  final int protein;
  final int cookingTime;
  final String instructions;
  final List<String> ingredients;
  final bool isVegetarian;
  final bool isLactoseFree;
  final bool isFavourite;

  const Recipe({
    this.id,
    required this.name,
    required this.imageURL,
    required this.calories,
    required this.protein,
    required this.cookingTime,
    required this.instructions,
    required this.ingredients,
    this.isVegetarian = false,
    this.isLactoseFree = false,
    this.isFavourite = false,
  });

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: doc.id,
      name: data['name'] ?? '',
      imageURL: data['imageURL'] ?? '',
      calories: data['calories'] ?? 0,
      protein: data['protein'] ?? 0,
      cookingTime: data['cookingTime'] ?? 0,
      instructions: data['instructions'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      isVegetarian: data['isVegetarian'] ?? false,
      isLactoseFree: data['isLactoseFree'] ?? false,
      isFavourite: data['isFavourite'] ?? false,
    );
  }

  factory Recipe.fromMap(Map<String, dynamic> data) {
    return Recipe(
      id: data['id'] ?? "",
      name: data['name'] ?? '',
      imageURL: data['imageURL'] ?? '',
      calories: data['calories'] ?? 0,
      cookingTime: data['cookingTime'] ?? 0,
      instructions: data['instructions'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      isVegetarian: data['isVegetarian'] ?? false,
      isLactoseFree: data['isLactoseFree'] ?? false,
      isFavourite: data['isFavourite'] ?? false,
      protein: data['protein'] ?? 0,
    );
  }

  // Convert Recipe to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageURL': imageURL,
      'calories': calories,
      'protein': protein,
      'cookingTime': cookingTime,
      'instructions': instructions,
      'ingredients': ingredients,
      'isVegetarian': isVegetarian,
      'isLactoseFree': isLactoseFree,
      'isFavourite': isFavourite,
    };
  }

  Recipe copyWith({
    String? id,
    String? name,
    String? imageURL,
    int? calories,
    int? protein,
    int? cookingTime,
    String? instructions,
    List<String>? ingredients,
    bool? isVegetarian,
    bool? isLactoseFree,
    bool? isFavourite,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      imageURL: imageURL ?? this.imageURL,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      cookingTime: cookingTime ?? this.cookingTime,
      instructions: instructions ?? this.instructions,
      ingredients: ingredients ?? this.ingredients,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isLactoseFree: isLactoseFree ?? this.isLactoseFree,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}