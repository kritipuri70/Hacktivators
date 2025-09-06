class Therapist {
  final String id;
  final String name;
  final String email;
  final String qualifications;
  final List<String> expertise;
  final int yearsExperience;
  final String bio;
  final double rating;
  final bool isAvailable;
  final String? profileImageUrl;

  Therapist({
    required this.id,
    required this.name,
    required this.email,
    required this.qualifications,
    required this.expertise,
    required this.yearsExperience,
    required this.bio,
    this.rating = 0.0,
    this.isAvailable = true,
    this.profileImageUrl,
  });

  Therapist copyWith({
    String? id,
    String? name,
    String? email,
    String? qualifications,
    List<String>? expertise,
    int? yearsExperience,
    String? bio,
    double? rating,
    bool? isAvailable,
    String? profileImageUrl,
  }) {
    return Therapist(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      qualifications: qualifications ?? this.qualifications,
      expertise: expertise ?? this.expertise,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      isAvailable: isAvailable ?? this.isAvailable,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}