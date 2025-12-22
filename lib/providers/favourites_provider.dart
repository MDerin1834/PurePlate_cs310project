import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pure_plate/services/favourites_service.dart';
import 'auth_provider.dart';

class FavouritesProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final FavouritesService _favouritesService = FavouritesService();

  StreamSubscription? _subscription;

  Set<String> _favourites = {};
  bool _isLoading = false;

  FavouritesProvider(this._authProvider) {
    _listenToFavourites();
  }

  Set<String> get favourites => _favourites;
  bool get isLoading => _isLoading;

  void _listenToFavourites() {
    final user = _authProvider.user;
    if (user == null) return;
    
    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();

    _subscription = _favouritesService.getFavourites(user.uid).listen((favourites) {
      _favourites = { ...favourites };
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addFavourite(String recipeId) async {
    final user = _authProvider.user;
    if (user == null) return;
    
    await _favouritesService.addFavourite(
      userId: user.uid,
      recipeId: recipeId,
    );
  }

  Future<void> deleteFavourite({
    required String recipeId
  }) async {
    final user = _authProvider.user;
    if (user == null) return;

    await _favouritesService.deleteFavourite(userId: user.uid, recipeId: recipeId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}