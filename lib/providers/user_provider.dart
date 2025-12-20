class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? user;
  bool isLoading = false;

  Future<void> loadUser(String uid) async {
    isLoading = true;
    notifyListeners();

    final doc = await _firestore.collection('users').doc(uid).get();
    user = AppUser.fromMap(doc.data()!, uid);

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(AppUser updatedUser) async {
    await _firestore
        .collection('users')
        .doc(updatedUser.uid)
        .update(updatedUser.toMap());

    user = updatedUser;
    notifyListeners();
  }
}
