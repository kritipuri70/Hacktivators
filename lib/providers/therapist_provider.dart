import 'package:flutter/material.dart';
import '../models/therapist.dart';

class TherapistProvider extends ChangeNotifier {
  List<Therapist> _therapists = [];
  bool _isLoading = false;

  List<Therapist> get therapists => _therapists;
  bool get isLoading => _isLoading;

  Future<void> loadTherapists() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate loading therapists
      await Future.delayed(const Duration(seconds: 1));

      // Add some dummy data for testing
      _therapists = [
        Therapist(
          id: '1',
          name: 'Dr. Sarah Johnson',
          email: 'sarah@example.com',
          qualifications: 'PhD in Clinical Psychology',
          expertise: ['Anxiety', 'Depression'],
          yearsExperience: 8,
          bio: 'Experienced therapist specializing in anxiety and depression.',
          rating: 4.8,
        ),
        Therapist(
          id: '2',
          name: 'Dr. Michael Chen',
          email: 'michael@example.com',
          qualifications: 'Licensed Clinical Social Worker',
          expertise: ['Stress Management', 'Relationship Counseling'],
          yearsExperience: 5,
          bio: 'Helping individuals and couples build stronger relationships.',
          rating: 4.9,
        ),
        Therapist(
          id: '3',
          name: 'Dr. Emily Davis',
          email: 'emily@example.com',
          qualifications: 'MA in Counseling Psychology',
          expertise: ['Trauma Therapy', 'PTSD'],
          yearsExperience: 12,
          bio: 'Specialized in trauma-informed care and recovery.',
          rating: 4.7,
        ),
      ];
    } catch (e) {
      print('Load therapists error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Therapist> searchTherapists(String query, List<String> filters) {
    return _therapists.where((therapist) {
      final nameMatch = therapist.name.toLowerCase().contains(query.toLowerCase());
      final expertiseMatch = filters.isEmpty ||
          therapist.expertise.any((exp) => filters.contains(exp));
      return nameMatch && expertiseMatch;
    }).toList();
  }

  Future<bool> registerTherapist(Therapist therapist) async {
    try {
      // Simulate registration
      await Future.delayed(const Duration(seconds: 1));
      _therapists.add(therapist);
      notifyListeners();
      return true;
    } catch (e) {
      print('Register therapist error: $e');
      return false;
    }
  }

  List<Therapist> getRecommendedTherapists(List<String> userNeeds) {
    final recommended = _therapists.where((therapist) {
      return therapist.expertise.any((exp) => userNeeds.contains(exp));
    }).toList();

    // Sort by rating
    recommended.sort((a, b) => b.rating.compareTo(a.rating));
    return recommended.take(5).toList();
  }
}