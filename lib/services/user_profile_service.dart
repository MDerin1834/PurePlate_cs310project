import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile_model.dart';

/// Firestore Service for UserProfile CRUD Operations
/// Handles all database interactions for user profiles
class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _usersCollection =>
      _firestore.collection('users');

  // ========================================================================
  // CREATE - Create new user profile
  // ========================================================================

  /// Create a new user profile in Firestore
  /// This should be called after Firebase Authentication sign-up
  Future<void> createUserProfile({
    required String userId,
    required String name,
    required String email,
    required int age,
    String dietType = 'Balanced',
    int calorieTarget = 2000,
    int proteinTarget = 80,
    String? profileImageUrl,
    bool isGlutenFree = false,
    bool isVegetarian = false,
    bool isLactoseFree = false,
    bool isLowCarb = false,
  }) async {
    try {
      final now = DateTime.now();

      final userData = {
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
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': null,
      };

      // Use userId as document ID (same as Firebase Auth UID)
      await _usersCollection.doc(userId).set(userData);
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  // ========================================================================
  // READ - Get user profile
  // ========================================================================

  /// Get user profile by ID (real-time stream)
  Stream<UserProfile?> getUserProfileStream(String userId) {
    try {
      return _usersCollection
          .doc(userId)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          return UserProfile.fromFirestore(snapshot);
        }
        return null;
      });
    } catch (e) {
      throw Exception('Failed to get user profile stream: $e');
    }
  }

  /// Get user profile by ID (one-time fetch)
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();

      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Check if user profile exists
  Future<bool> userProfileExists(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      return doc.exists;
    } catch (e) {
      throw Exception('Failed to check user profile existence: $e');
    }
  }

  // ========================================================================
  // UPDATE - Modify user profile
  // ========================================================================

  /// Update user profile fields
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    int? age,
    String? dietType,
    int? calorieTarget,
    int? proteinTarget,
    String? profileImageUrl,
    bool? isGlutenFree,
    bool? isVegetarian,
    bool? isLactoseFree,
    bool? isLowCarb,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (name != null) updateData['name'] = name;
      if (age != null) updateData['age'] = age;
      if (dietType != null) updateData['dietType'] = dietType;
      if (calorieTarget != null) updateData['calorieTarget'] = calorieTarget;
      if (proteinTarget != null) updateData['proteinTarget'] = proteinTarget;
      if (profileImageUrl != null) updateData['profileImageUrl'] = profileImageUrl;
      if (isGlutenFree != null) updateData['isGlutenFree'] = isGlutenFree;
      if (isVegetarian != null) updateData['isVegetarian'] = isVegetarian;
      if (isLactoseFree != null) updateData['isLactoseFree'] = isLactoseFree;
      if (isLowCarb != null) updateData['isLowCarb'] = isLowCarb;

      await _usersCollection.doc(userId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Update dietary preferences
  Future<void> updateDietaryPreferences({
    required String userId,
    required bool isGlutenFree,
    required bool isVegetarian,
    required bool isLactoseFree,
    required bool isLowCarb,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        'isGlutenFree': isGlutenFree,
        'isVegetarian': isVegetarian,
        'isLactoseFree': isLactoseFree,
        'isLowCarb': isLowCarb,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update dietary preferences: $e');
    }
  }

  /// Update nutrition goals
  Future<void> updateNutritionGoals({
    required String userId,
    required int calorieTarget,
    required int proteinTarget,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        'calorieTarget': calorieTarget,
        'proteinTarget': proteinTarget,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update nutrition goals: $e');
    }
  }

  /// Update profile picture
  Future<void> updateProfilePicture({
    required String userId,
    required String imageUrl,
  }) async {
    try {
      await _usersCollection.doc(userId).update({
        'profileImageUrl': imageUrl,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update profile picture: $e');
    }
  }

  // ========================================================================
  // DELETE - Remove user profile
  // ========================================================================

  /// Delete user profile (use with caution!)
  /// Should typically be called when user deletes their account
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user profile: $e');
    }
  }

  // ========================================================================
  // UTILITY METHODS
  // ========================================================================

  /// Get all users (admin function - requires security rules)
  Future<List<UserProfile>> getAllUsers() async {
    try {
      final querySnapshot = await _usersCollection.get();

      return querySnapshot.docs
          .map((doc) => UserProfile.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all users: $e');
    }
  }

  /// Search users by name (requires proper indexing)
  Future<List<UserProfile>> searchUsersByName(String searchTerm) async {
    try {
      final querySnapshot = await _usersCollection
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThanOrEqualTo: searchTerm + '\uf8ff')
          .get();

      return querySnapshot.docs
          .map((doc) => UserProfile.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }
}