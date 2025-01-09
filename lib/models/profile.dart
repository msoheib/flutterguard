
class Profile {
  final String name;
  final String title;
  final String about;
  final String? photoUrl;

  Profile({
    required this.name,
    required this.title,
    required this.about,
    this.photoUrl,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      name: map['name'] as String? ?? 'مستخدم جديد',
      title: map['title'] as String? ?? 'حارس أمن',
      about: map['about'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'title': title,
      'about': about,
      'photoUrl': photoUrl,
    };
  }
} 