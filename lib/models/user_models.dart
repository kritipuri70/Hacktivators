import 'package:cloud_firestore/cloud_firestore.dart';

// User Model
class AppUser {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      role: UserRole.values.firstWhere(
            (role) => role.toString() == data['role'],
        orElse: () => UserRole.user,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'role': role.toString(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  AppUser copyWith({
    String? email,
    String? name,
    String? profileImageUrl,
    UserRole? role,
    DateTime? updatedAt,
  }) {
    return AppUser(
      id: id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum UserRole {
  user,
  therapist,
}

// Therapist Model
class Therapist {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String qualification;
  final int yearsOfExperience;
  final String specialty;
  final String bio;
  final String? profileImageUrl;
  final String location;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Therapist({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.qualification,
    required this.yearsOfExperience,
    required this.specialty,
    required this.bio,
    this.profileImageUrl,
    required this.location,
    this.isAvailable = true,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Therapist.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Therapist(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      qualification: data['qualification'] ?? '',
      yearsOfExperience: data['yearsOfExperience'] ?? 0,
      specialty: data['specialty'] ?? '',
      bio: data['bio'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      location: data['location'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'qualification': qualification,
      'yearsOfExperience': yearsOfExperience,
      'specialty': specialty,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'location': location,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Therapist copyWith({
    String? name,
    String? email,
    String? phone,
    String? qualification,
    int? yearsOfExperience,
    String? specialty,
    String? bio,
    String? profileImageUrl,
    String? location,
    bool? isAvailable,
    double? rating,
    int? reviewCount,
    DateTime? updatedAt,
  }) {
    return Therapist(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      qualification: qualification ?? this.qualification,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      specialty: specialty ?? this.specialty,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      location: location ?? this.location,
      isAvailable: isAvailable ?? this.isAvailable,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Booking Model
class Booking {
  final String id;
  final String userId;
  final String therapistId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final DateTime preferredDate;
  final String preferredTime;
  final String concern;
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;

  Booking({
    required this.id,
    required this.userId,
    required this.therapistId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.preferredDate,
    required this.preferredTime,
    required this.concern,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
      id: doc.id,
      userId: data['userId'] ?? '',
      therapistId: data['therapistId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userPhone: data['userPhone'] ?? '',
      preferredDate: (data['preferredDate'] as Timestamp).toDate(),
      preferredTime: data['preferredTime'] ?? '',
      concern: data['concern'] ?? '',
      status: BookingStatus.values.firstWhere(
            (status) => status.toString() == data['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'therapistId': therapistId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'preferredDate': Timestamp.fromDate(preferredDate),
      'preferredTime': preferredTime,
      'concern': concern,
      'status': status.toString(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'notes': notes,
    };
  }
}

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}

// Anonymous Post Model
class AnonymousPost {
  final String id;
  final String content;
  final DateTime createdAt;
  final int likes;
  final bool isVisible;

  AnonymousPost({
    required this.id,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.isVisible = true,
  });

  factory AnonymousPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AnonymousPost(
      id: doc.id,
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likes: data['likes'] ?? 0,
      isVisible: data['isVisible'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'likes': likes,
      'isVisible': isVisible,
    };
  }
}