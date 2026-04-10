import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:reverie/views/doctor_match/models/doctor_db_model.dart';

class DoctorRemoteService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<DoctorDbModel>> getVerifiedDoctors() async {
    final response = await _client
        .from('doctor_public_view')
        .select()
        .eq('verification_status', 'verified');

    return (response as List)
        .map((e) => DoctorDbModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<DoctorDbModel?> getDoctorById(String userId) async {
    final response = await _client
        .from('doctor_public_view')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return DoctorDbModel.fromMap(response);
  }

  Future<bool> isInviteCodeValid(String code) async {
    final response = await _client
        .from('doctor_invite_codes')
        .select('code')
        .eq('code', code)
        .eq('is_active', true)
        .maybeSingle();

    return response != null;
  }

  Future<DoctorDbModel?> getDoctorByInviteCode(String code) async {
    final invite = await _client
        .from('doctor_invite_codes')
        .select('doctor_user_id')
        .eq('code', code)
        .eq('is_active', true)
        .maybeSingle();

    if (invite == null) return null;

    final doctorUserId = invite['doctor_user_id'] as String;
    return getDoctorById(doctorUserId);
  }
}
