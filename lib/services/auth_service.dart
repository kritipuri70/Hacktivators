import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_models.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  AppUser? _currentAppUser;
  AppUser? get currentAppUser => _currentAppUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user != null) {
      await _loadCurrentAppUser();
    } else {
      _currentAppUser = null;
    }
    notifyListeners();
  }

  Future<void> _loadCurrentAppUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          _currentAppUser = AppUser.fromFirestore(doc);
        }
      }
    } catch (e) {
      print('Error loading current app user: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Email & Password Sign Up
  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final now = DateTime.now();
        final appUser = AppUser(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          role: role,
          createdAt: now,
          updatedAt: now,
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set(appUser.toFirestore());

        // Update display name
        await userCredential.user!.updateDisplayName(name);

        _currentAppUser = appUser;
        _setLoading(false);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      _setError(_getFirebaseAuthErrorMessage(e));
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
    }

    _setLoading(false);
    return false;
  }

  // Email & Password Sign In
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _loadCurrentAppUser();
        _setLoading(false);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      _setError(_getFirebaseAuthErrorMessage(e));
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
    }

    _setLoading(false);
    return false;
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    try {
      _setLoading(true);
      _setError(null);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setLoading(false);
        return false; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final user = userCredential.user!;

        // Check if user document exists
        final doc = await _firestore.collection('users').doc(user.uid).get();

        if (!doc.exists) {
          // Create new user document
          final now = DateTime.now();
          final appUser = AppUser(
            id: user.uid,
            email: user.email ?? '',
            name: user.displayName ?? '',
            profileImageUrl: user.photoURL,
            role: UserRole.user, // Default role
            createdAt: now,
            updatedAt: now,
          );

          await _firestore.collection('users').doc(user.uid).set(appUser.toFirestore());
          _currentAppUser = appUser;
        } else {
          await _loadCurrentAppUser();
        }

        _setLoading(false);
        return true;
      }
    } catch (e) {
      _setError('Google sign in failed. Please try again.');
    }

    _setLoading(false);
    return false;
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _googleSignIn.signOut();
      await _auth.signOut();
      _currentAppUser = null;
    } catch (e) {
      _setError('Sign out failed. Please try again.');
    }
    _setLoading(false);
  }

  // Reset Password
  Future<bool> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setError(null);

      await _auth.sendPasswordResetEmail(email: email);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getFirebaseAuthErrorMessage(e));
    } catch (e) {
      _setError('Failed to send reset email. Please try again.');
    }

    _setLoading(false);
    return false;
  }

  // Update Profile
  Future<bool> updateProfile({
    String? name,
    String? profileImageUrl,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final user = _auth.currentUser;
      if (user != null && _currentAppUser != null) {
        final now = DateTime.now();
        final updatedUser = _currentAppUser!.copyWith(
          name: name,
          profileImageUrl: profileImageUrl,
          updatedAt: now,
        );

        await _firestore.collection('users').doc(user.uid).update(updatedUser.toFirestore());

        if (name != null) {
          await user.updateDisplayName(name);
        }

        _currentAppUser = updatedUser;
        _setLoading(false);
        return true;
      }
    } catch (e) {
      _setError('Failed to update profile. Please try again.');
    }

    _setLoading(false);
    return false;
  }

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Signing in with Email and Password is not enabled.';
      default:
        return 'An authentication error occurred.';
    }
  }
}