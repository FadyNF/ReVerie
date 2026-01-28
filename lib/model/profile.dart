class Profile {
  final String id; // auth.users.id (uuid)
  final String? fullName;
  final String? email;
  final String? role;
  final String? phoneNumber;

  const Profile({
    required this.id,
    this.fullName,
    this.email,
    this.role,
    this.phoneNumber,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      fullName: map['full_name'] as String?,
      email: map['email'] as String?,
      role: map['role'] as String?,
      phoneNumber: map['phone_number'] as String?,
    );
  }
}
