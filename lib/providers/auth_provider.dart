import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? user;
  bool isLoading = false;
  String? errorMessage;

  bool get isLoggedIn => user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((u) {
      user = u;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.';
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = 'Şifre hatalı, lütfen tekrar deneyin.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Geçersiz e-posta formatı.';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'İnternet bağlantınızı kontrol edin.';
      } else {
        errorMessage = e.message ?? 'Giriş yapılırken bir hata oluştu.';
      }
    } catch (e) {
      errorMessage = 'Beklenmedik bir hata oluştu: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Bu e-posta adresi zaten kullanımda.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Şifre çok zayıf (en az 6 karakter olmalı).';
      } else {
        errorMessage = e.message;
      }
    } catch (e) {
      errorMessage = 'Kayıt hatası: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      errorMessage = null;
      notifyListeners();
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      errorMessage = 'Sıfırlama e-postası gönderilemedi: $e';
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    errorMessage = null;
    notifyListeners();
  }
}
