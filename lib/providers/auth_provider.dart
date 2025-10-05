import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;

  AuthProvider() {
    // Initialize current user if already logged in
    _user = FirebaseAuth.instance.currentUser;
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  // Sign in using email and password. Returns an error message or null if successful.
  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential cred = await AuthService.signInWithEmail(email, password);
      _user = cred.user;
      notifyListeners();
      return null; // success
    } on FirebaseAuthException catch (e) {
      // Return Firebase error message
      return e.message ?? 'Login failed. Please try again.';
    } catch (e) {
      return 'An unknown error occurred';
    }
  }

  // Register a new account. Returns an error message or null if successful.
  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential cred = await AuthService.registerWithEmail(email, password);
      _user = cred.user;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Registration failed. Please try again.';
    } catch (e) {
      return 'An unknown error occurred';
    }
  }

  Future<void> signOut() async {
    await AuthService.signOut();
    _user = null;
    notifyListeners();
  }
}
