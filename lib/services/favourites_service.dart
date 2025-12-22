import 'package:cloud_firestore/cloud_firestore.dart';

class FavouritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFavourite({
    required String userId,
    required String recipeId,
  }) async {
    final favRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .doc(recipeId);

    await favRef.set({
      'createdBy': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<String>> getFavourites(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => doc.id).toList(),
    );
  }

  Future<void> deleteFavourite({
    required String userId,
    required String recipeId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .doc(recipeId)
        .delete();
  }

  Future<bool> isFavourite({
    required String userId,
    required String recipeId,
  }) async {
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favourites')
        .doc(recipeId)
        .get();

    return doc.exists;
  }
}
