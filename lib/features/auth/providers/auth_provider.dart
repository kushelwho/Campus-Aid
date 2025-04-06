import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authService.currentUser != null;
  String? get userEmail => _authService.currentUser?.email;
  bool get isEmailVerified => _authService.isEmailVerified();

  // Listen to auth state changes
  Stream<dynamic> get authStateChanges => _authService.authStateChanges;

  // Sign in with email and password
  Future<bool> signInWithEmailPassword(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final userCredential = await _authService.signInWithEmailPassword(
        email,
        password,
      );
      _setLoading(false);
      return userCredential != null;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Register with email and password
  Future<bool> registerWithEmailPassword(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final userCredential = await _authService.registerWithEmailPassword(
        email,
        password,
      );
      if (userCredential != null) {
        await _authService.sendEmailVerification();
      }
      _setLoading(false);
      return userCredential != null;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signOut();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Send email verification
  Future<bool> sendEmailVerification() async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.sendEmailVerification();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message.replaceAll('Exception: ', '');
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
