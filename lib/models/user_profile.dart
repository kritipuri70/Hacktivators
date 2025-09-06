import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final List<String> mentalHealthNeeds;
  final String currentMood;
  final List<String> favoriteAffirmations;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.mentalHealthNeeds = const [],
    this.currentMood = 'neutral',
    this.favoriteAffirmations = const [],
    required this.createdAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      avatarUrl: data['avatarUrl'],
      mentalHealthNeeds: List<String>.from(data['mentalHealthNeeds'] ?? []),
      currentMood: data['currentMood'] ?? 'neutral',
      favoriteAffirmations: List<String>.from(data['favoriteAffirmations'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'mentalHealthNeeds': mentalHealthNeeds,
      'currentMood': currentMood,
      'favoriteAffirmations': favoriteAffirmations,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    List<String>? mentalHealthNeeds,
    String? currentMood,
    List<String>? favoriteAffirmations,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      mentalHealthNeeds: mentalHealthNeeds ?? this.mentalHealthNeeds,
      currentMood: currentMood ?? this.currentMood,
      favoriteAffirmations: favoriteAffirmations ?? this.favoriteAffirmations,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}