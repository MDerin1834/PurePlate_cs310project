import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pure_plate/models/recipe.dart';
import 'package:pure_plate/data/recipes.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== SEED recipes (run once) ==========
  Future<void> seedRecipes() async {
    try {
      // Check if recipes already exist
      final snapshot = await _firestore.collection('recipes').limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        print('⚠️ Recipes already exist in Firestore. Skipping seed.');
        return;
      }

      // Seed the recipes
      final batch = _firestore.batch();

      for (var recipe in recipes) {
        final docRef = _firestore.collection('recipes').doc();
        batch.set(docRef, recipe.toMap());
      }

      await batch.commit();
      print('✅ Successfully seeded ${recipes.length} recipes to Firestore!');
    } catch (e) {
      print('❌ Error seeding recipes: $e');
      rethrow;
    }
  }

  // ========== READ all recipes (Real-time) ==========
  Stream<List<Recipe>> getRecipes() {
    return _firestore
        .collection('recipes')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Recipe.fromFirestore(doc))
        .toList());
  }

  // ========== READ single recipe ==========
  Future<Recipe?> getRecipe(String recipeId) async {
    final doc = await _firestore.collection('recipes').doc(recipeId).get();
    if (doc.exists) {
      return Recipe.fromFirestore(doc);
    }
    return null;
  }
}