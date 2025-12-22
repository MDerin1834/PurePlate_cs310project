import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pure_plate/models/user_profile.dart';
import 'package:pure_plate/services/user_service.dart';
import 'package:pure_plate/providers/auth_provider.dart';

class UserProfileProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  final AuthProvider _authProvider;

  StreamSubscription? _subscription;

  UserProfile? _userProfile;
  bool _isLoading = false;

  UserProfileProvider(this._authProvider) {
    _listenToUserProfile();
  }

  // =========================
  // Getters
  // =========================

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;

  // =========================
  // Listen to user profile changes
  // =========================

  void _listenToUserProfile() {
    final user = _authProvider.user;
    if (user == null) {
      _userProfile = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _userService.streamUserProfile(user.uid).listen((profile) {
      _userProfile = profile;
      _isLoading = false;
      notifyListeners();
    });
  }

  // =========================
  // Create profile for new user
  // =========================

  Future<void> createProfile({
    required String uid,
    required String email,
    String? name,
    int? age,  // ← THIS IS THE FIX
  }) async {
    await _userService.createUserProfile(
      uid: uid,
      email: email,
      name: name,
      age: age,  // ← THIS IS THE FIX
    );
  }

  // =========================
  // Update profile
  // =========================

  Future<void> updateProfile(UserProfile profile) async {
    await _userService.updateUserProfile(profile);
  }

  // =========================
  // Cleanup
  // =========================

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}