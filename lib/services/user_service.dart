import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pure_plate/models/user_profile.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== CREATE user profile ==========
  Future<void> createUserProfile({
    required String uid,
    required String email,
    String? name,
    int? age,
  }) async {
    final userProfile = UserProfile(
      uid: uid,
      name: name ?? 'User',
      email: email,
      age: age ?? 25,
      dietType: 'Balanced',
      calorieTarget: 2000,
      proteinTarget: 80,
    );

    await _firestore
        .collection('users')
        .doc(uid)
        .set(userProfile.toMap());
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (doc.exists) {
      return UserProfile.fromFirestore(doc);
    }
    return null;
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    await _firestore
        .collection('users')
        .doc(profile.uid)
        .update(profile.toMap());
  }

  Stream<UserProfile?> streamUserProfile(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      }
      return null;
    });
  }
}