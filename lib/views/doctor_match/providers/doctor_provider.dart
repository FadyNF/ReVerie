import 'package:reverie/views/doctor_match/data/doctor_remote_service.dart';
import 'package:reverie/views/doctor_match/models/doctor_db_model.dart';
import 'package:reverie/views/doctor_match/models/doctor_profile_model.dart';
import 'package:reverie/views/doctor_match/models/recommended_doctor.dart';

class DoctorProviderService {
  final DoctorRemoteService _remote = DoctorRemoteService();

  Future<List<RecommendedDoctor>> getRecommendedDoctors() async {
    final doctors = await _remote.getVerifiedDoctors();
    return doctors.map(_toRecommendedDoctor).toList();
  }

  Future<List<DoctorProfileModel>> getAllDoctorProfiles() async {
    final doctors = await _remote.getVerifiedDoctors();
    return doctors.map(_toDoctorProfileModel).toList();
  }

  Future<DoctorProfileModel?> getDoctorProfileByInviteCode(String code) async {
    final doctor = await _remote.getDoctorByInviteCode(code);
    if (doctor == null) return null;
    return _toDoctorProfileModel(doctor);
  }

  Future<DoctorProfileModel?> getDoctorProfileById(String userId) async {
    final doctor = await _remote.getDoctorById(userId);
    if (doctor == null) return null;
    return _toDoctorProfileModel(doctor);
  }

  RecommendedDoctor _toRecommendedDoctor(DoctorDbModel d) {
    return RecommendedDoctor(
      id: d.userId,
      initials: _initials(d.fullName),
      name: d.fullName,
      specialty: d.specialization ?? 'Doctor',
      clinic: 'Clinic not specified',
      rating: d.rating ?? 0.0,
      reasons: [
        if (d.languages.any((e) => e.toLowerCase() == 'arabic')) 'Arabic',
        if (d.sessionDuration != null) '${d.sessionDuration} min session',
      ],
    );
  }

  DoctorProfileModel _toDoctorProfileModel(DoctorDbModel d) {
    return DoctorProfileModel(
      id: d.userId,
      initials: _initials(d.fullName),
      name: d.fullName,
      specialty: d.specialization ?? 'Doctor',
      clinic: 'Clinic not specified',
      rating: d.rating ?? 0.0,
      reviews: 0,
      yearsExperience: 0,
      patients: 0,
      about: d.specialization != null
          ? 'Specialized in ${d.specialization}'
          : '',
      education: const [],
      languages: d.languages,
      availability: const {},
      tags: const [],
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
