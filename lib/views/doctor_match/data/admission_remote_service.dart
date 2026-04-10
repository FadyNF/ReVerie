import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:reverie/views/doctor_match/models/admission_request_model.dart';

class AdmissionRemoteService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AdmissionRequestModel> createAdmissionRequest({
    required String consumerUserId,
    required String doctorUserId,
  }) async {
    try {
      final inserted = await _client
          .from('doctor_admission_requests')
          .insert({
            'consumer_user_id': consumerUserId,
            'doctor_user_id': doctorUserId,
            'status': 'pending',
          })
          .select()
          .single();

      return AdmissionRequestModel.fromMap(inserted);
    } catch (e) {
      throw Exception('Failed to create admission request: $e');
    }
  }

  Future<void> cancelAdmissionRequest(String requestId) async {
    try {
      await _client
          .from('doctor_admission_requests')
          .delete()
          .eq('id', requestId);
    } catch (e) {
      throw Exception('Failed to cancel admission request: $e');
    }
  }
}
