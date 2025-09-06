import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfile? _profile;
  bool _isLoading = false;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> loadUserProfile(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate loading profile
      await Future.delayed(const Duration(seconds: 1));

      // Create dummy profile for testing
      _profile = UserProfile(
        id: userId,
        email: 'user@example.com',
        name: 'John Doe',
        mentalHealthNeeds: ['Anxiety', 'Stress Management'],
        currentMood: 'good',
        favoriteAffirmations: [
          'I am worthy of love and happiness',
          'I have the strength to overcome challenges'
        ],
        createdAt: DateTime.now(),
      );
    } catch (e) {
      print('Load profile error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMood(String mood) async {
    if (_profile == null) return;

    try {
      // Simulate update
      await Future.delayed(const Duration(milliseconds: 500));

      _profile = _profile!.copyWith(currentMood: mood);
      notifyListeners();
    } catch (e) {
      print('Update mood error: $e');
    }
  }

  Future<void> updateMentalHealthNeeds(List<String> needs) async {
    if (_profile == null) return;

    try {
      // Simulate update
      await Future.delayed(const Duration(milliseconds: 500));

      _profile = _profile!.copyWith(mentalHealthNeeds: needs);
      notifyListeners();
    } catch (e) {
      print('Update mental health needs error: $e');
    }
  }

  Future<void> addFavoriteAffirmation(String affirmation) async {
    if (_profile == null) return;

    try {
      final updatedFavorites = [..._profile!.favoriteAffirmations, affirmation];

      // Simulate update
      await Future.delayed(const Duration(milliseconds: 500));

      _profile = _profile!.copyWith(favoriteAffirmations: updatedFavorites);
      notifyListeners();
    } catch (e) {
      print('Add favorite affirmation error: $e');
    }
  }

  Future<void> removeFavoriteAffirmation(String affirmation) async {
    if (_profile == null) return;

    try {
      final updatedFavorites = _profile!.favoriteAffirmations
          .where((fav) => fav != affirmation)
          .toList();

      // Simulate update
      await Future.delayed(const Duration(milliseconds: 500));

      _profile = _profile!.copyWith(favoriteAffirmations: updatedFavorites);
      notifyListeners();
    } catch (e) {
      print('Remove favorite affirmation error: $e');
    }
  }

  Future<void> updateProfile({
    String? name,
    String? avatarUrl,
  }) async {
    if (_profile == null) return;

    try {
      // Simulate update
      await Future.delayed(const Duration(milliseconds: 500));

      _profile = _profile!.copyWith(
        name: name ?? _profile!.name,
        avatarUrl: avatarUrl ?? _profile!.avatarUrl,
      );
      notifyListeners();
    } catch (e) {
      print('Update profile error: $e');
    }
  }

  // Initialize with dummy data for testing
  void initializeWithDummyData() {
    _profile = UserProfile(
      id: 'dummy_user_123',
      email: 'test@lumina.com',
      name: 'Test User',
      mentalHealthNeeds: ['Anxiety', 'Stress Management'],
      currentMood: 'neutral',
      favoriteAffirmations: [],
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }
}