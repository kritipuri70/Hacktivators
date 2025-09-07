import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_models.dart';

class FirestoreService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Therapist> _therapists = [];
  List<Therapist> get therapists => _therapists;

  List<AnonymousPost> _anonymousPosts = [];
  List<AnonymousPost> get anonymousPosts => _anonymousPosts;

  List<Booking> _userBookings = [];
  List<Booking> get userBookings => _userBookings;

  List<Booking> _therapistBookings = [];
  List<Booking> get therapistBookings => _therapistBookings;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Initialize dummy data for Chitwan therapists
  Future<void> initializeDummyData() async {
    try {
      final querySnapshot = await _firestore.collection('therapists').limit(1).get();

      if (querySnapshot.docs.isEmpty) {
        // Add dummy therapists from Chitwan
        final dummyTherapists = [
          {
            'name': 'Dr. Anjana Sharma',
            'email': 'anjana.sharma@lumina.com',
            'phone': '+977-9841234567',
            'qualification': 'Ph.D in Clinical Psychology',
            'yearsOfExperience': 12,
            'specialty': 'Anxiety & Depression',
            'bio': 'Specialized in cognitive behavioral therapy with over a decade of experience helping individuals overcome anxiety and depression.',
            'location': 'Chitwan',
            'isAvailable': true,
            'rating': 4.8,
            'reviewCount': 156,
            'profileImageUrl': 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Dr. Rajesh Koirala',
            'email': 'rajesh.koirala@lumina.com',
            'phone': '+977-9851234568',
            'qualification': 'M.D. Psychiatrist',
            'yearsOfExperience': 15,
            'specialty': 'PTSD & Trauma Therapy',
            'bio': 'Expert in trauma-informed care and PTSD treatment. Passionate about helping individuals heal from traumatic experiences.',
            'location': 'Chitwan',
            'isAvailable': true,
            'rating': 4.9,
            'reviewCount': 203,
            'profileImageUrl': 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Dr. Priya Thapa',
            'email': 'priya.thapa@lumina.com',
            'phone': '+977-9861234569',
            'qualification': 'Masters in Counseling Psychology',
            'yearsOfExperience': 8,
            'specialty': 'Relationship Counseling',
            'bio': 'Dedicated to helping couples and families build stronger, healthier relationships through evidence-based therapeutic approaches.',
            'location': 'Chitwan',
            'isAvailable': true,
            'rating': 4.7,
            'reviewCount': 98,
            'profileImageUrl': 'https://images.unsplash.com/photo-1594824804732-ca8db2c10e3f?w=400',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Dr. Kumar Gurung',
            'email': 'kumar.gurung@lumina.com',
            'phone': '+977-9871234570',
            'qualification': 'Ph.D in Behavioral Psychology',
            'yearsOfExperience': 10,
            'specialty': 'Addiction Recovery',
            'bio': 'Specializes in addiction recovery and behavioral modification with a compassionate, non-judgmental approach.',
            'location': 'Chitwan',
            'isAvailable': true,
            'rating': 4.6,
            'reviewCount': 134,
            'profileImageUrl': 'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          {
            'name': 'Dr. Samjhana Rai',
            'email': 'samjhana.rai@lumina.com',
            'phone': '+977-9881234571',
            'qualification': 'Masters in Child Psychology',
            'yearsOfExperience': 6,
            'specialty': 'Child & Adolescent Therapy',
            'bio': 'Passionate about supporting children and teenagers through their mental health challenges with play therapy and family involvement.',
            'location': 'Chitwan',
            'isAvailable': true,
            'rating': 4.9,
            'reviewCount': 87,
            'profileImageUrl': 'https://images.unsplash.com/photo-1551836022-deb4988cc6c0?w=400',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
        ];

        final batch = _firestore.batch();
        for (final therapist in dummyTherapists) {
          final docRef = _firestore.collection('therapists').doc();
          batch.set(docRef, therapist);
        }
        await batch.commit();

        // Add dummy anonymous posts
        final dummyPosts = [
          {
            'content': 'Started therapy last month and it\'s been life-changing. Never thought talking to someone could help this much.',
            'createdAt': FieldValue.serverTimestamp(),
            'likes': 24,
            'isVisible': true,
          },
          {
            'content': 'To anyone struggling with anxiety - you\'re not alone. Taking the first step to seek help was the hardest but best decision I made.',
            'createdAt': FieldValue.serverTimestamp(),
            'likes': 41,
            'isVisible': true,
          },
          {
            'content': 'Meditation and mindfulness really do work. Been practicing for 3 months and my stress levels have significantly decreased.',
            'createdAt': FieldValue.serverTimestamp(),
            'likes': 18,
            'isVisible': true,
          },
          {
            'content': 'Remember: healing isn\'t linear. Some days are harder than others, and that\'s completely okay.',
            'createdAt': FieldValue.serverTimestamp(),
            'likes': 67,
            'isVisible': true,
          },
          {
            'content': 'Found an amazing therapist here who truly understands. Grateful for platforms like this that make mental health care accessible.',
            'createdAt': FieldValue.serverTimestamp(),
            'likes': 33,
            'isVisible': true,
          },
        ];

        final postBatch = _firestore.batch();
        for (final post in dummyPosts) {
          final docRef = _firestore.collection('anonymous_posts').doc();
          postBatch.set(docRef, post);
        }
        await postBatch.commit();
      }
    } catch (e) {
      print('Error initializing dummy data: $e');
    }
  }

  // Fetch all therapists
  Future<void> fetchTherapists() async {
    try {
      _setLoading(true);
      _setError(null);

      final querySnapshot = await _firestore
          .collection('therapists')
          .orderBy('rating', descending: true)
          .get();

      _therapists = querySnapshot.docs
          .map((doc) => Therapist.fromFirestore(doc))
          .toList();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to fetch therapists');
      _setLoading(false);
    }
  }

  // Get therapist by ID
  Future<Therapist?> getTherapistById(String therapistId) async {
    try {
      final doc = await _firestore.collection('therapists').doc(therapistId).get();
      if (doc.exists) {
        return Therapist.fromFirestore(doc);
      }
    } catch (e) {
      print('Error fetching therapist: $e');
    }
    return null;
  }

  // Create booking
  Future<bool> createBooking({
    required String userId,
    required String therapistId,
    required String userName,
    required String userEmail,
    required String userPhone,
    required DateTime preferredDate,
    required String preferredTime,
    required String concern,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final now = DateTime.now();
      final booking = Booking(
        id: '',
        userId: userId,
        therapistId: therapistId,
        userName: userName,
        userEmail: userEmail,
        userPhone: userPhone,
        preferredDate: preferredDate,
        preferredTime: preferredTime,
        concern: concern,
        status: BookingStatus.pending,
        createdAt: now,
        updatedAt: now,
      );

      await _firestore.collection('bookings').add(booking.toFirestore());

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to create booking');
      _setLoading(false);
      return false;
    }
  }

  // Fetch user bookings
  Future<void> fetchUserBookings(String userId) async {
    try {
      _setLoading(true);
      _setError(null);

      final querySnapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _userBookings = querySnapshot.docs
          .map((doc) => Booking.fromFirestore(doc))
          .toList();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to fetch bookings');
      _setLoading(false);
    }
  }

  // Fetch therapist bookings
  Future<void> fetchTherapistBookings(String therapistId) async {
    try {
      _setLoading(true);
      _setError(null);

      final querySnapshot = await _firestore
          .collection('bookings')
          .where('therapistId', isEqualTo: therapistId)
          .orderBy('createdAt', descending: true)
          .get();

      _therapistBookings = querySnapshot.docs
          .map((doc) => Booking.fromFirestore(doc))
          .toList();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to fetch therapist bookings');
      _setLoading(false);
    }
  }

  // Update booking status
  Future<bool> updateBookingStatus(String bookingId, BookingStatus status) async {
    try {
      _setLoading(true);
      _setError(null);

      await _firestore.collection('bookings').doc(bookingId).update({
        'status': status.toString(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update booking status');
      _setLoading(false);
      return false;
    }
  }

  // Create anonymous post
  Future<bool> createAnonymousPost(String content) async {
    try {
      _setLoading(true);
      _setError(null);

      final post = AnonymousPost(
        id: '',
        content: content,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('anonymous_posts').add(post.toFirestore());

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to create post');
      _setLoading(false);
      return false;
    }
  }

  // Fetch anonymous posts
  Future<void> fetchAnonymousPosts() async {
    try {
      _setLoading(true);
      _setError(null);

      final querySnapshot = await _firestore
          .collection('anonymous_posts')
          .where('isVisible', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      _anonymousPosts = querySnapshot.docs
          .map((doc) => AnonymousPost.fromFirestore(doc))
          .toList();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to fetch posts');
      _setLoading(false);
    }
  }

  // Update therapist profile
  Future<bool> updateTherapistProfile(String therapistId, Map<String, dynamic> data) async {
    try {
      _setLoading(true);
      _setError(null);

      data['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('therapists').doc(therapistId).update(data);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update profile');
      _setLoading(false);
      return false;
    }
  }

  // Create therapist profile
  Future<bool> createTherapistProfile(Therapist therapist) async {
    try {
      _setLoading(true);
      _setError(null);

      await _firestore.collection('therapists').doc(therapist.id).set(therapist.toFirestore());

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to create therapist profile');
      _setLoading(false);
      return false;
    }
  }

  // Search therapists
  List<Therapist> searchTherapists(String query) {
    if (query.isEmpty) return _therapists;

    return _therapists.where((therapist) {
      return therapist.name.toLowerCase().contains(query.toLowerCase()) ||
          therapist.specialty.toLowerCase().contains(query.toLowerCase()) ||
          therapist.qualification.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Filter therapists by specialty
  List<Therapist> filterTherapistsBySpecialty(String specialty) {
    if (specialty.isEmpty) return _therapists;

    return _therapists.where((therapist) {
      return therapist.specialty.toLowerCase().contains(specialty.toLowerCase());
    }).toList();
  }

  // Sort therapists
  List<Therapist> sortTherapists(List<Therapist> therapists, String sortBy) {
    final sortedList = List<Therapist>.from(therapists);

    switch (sortBy) {
      case 'rating':
        sortedList.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'experience':
        sortedList.sort((a, b) => b.yearsOfExperience.compareTo(a.yearsOfExperience));
        break;
      case 'name':
        sortedList.sort((a, b) => a.name.compareTo(b.name));
        break;
      default:
        sortedList.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return sortedList;
  }
}