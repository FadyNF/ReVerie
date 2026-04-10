class DoctorDbModel {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String verificationStatus;
  final String? gender;
  final int? age;
  final String? specialization;
  final int? sessionDuration;
  final double? fee;
  final double? rating;
  final List<String> languages;

  const DoctorDbModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.verificationStatus,
    this.gender,
    this.age,
    this.specialization,
    this.sessionDuration,
    this.fee,
    this.rating,
    required this.languages,
  });

  factory DoctorDbModel.fromMap(Map<String, dynamic> map) {
    return DoctorDbModel(
      userId: map['user_id'] as String,
      fullName: map['full_name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      verificationStatus: map['verification_status'] ?? 'pending',
      gender: map['gender'],
      age: map['age'],
      specialization: map['specialization'],
      sessionDuration: map['session_duration'],
      fee: map['fee'] != null ? (map['fee'] as num).toDouble() : null,
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : null,
      languages: map['languages'] != null
          ? List<String>.from(map['languages'])
          : <String>[],
    );
  }
}