import 'package:reverie/views/doctor_match/data/admission_remote_service.dart';
import 'package:reverie/views/doctor_match/models/admission_request_model.dart';

class AdmissionProviderService {
  final AdmissionRemoteService _remote = AdmissionRemoteService();

  Future<AdmissionRequestModel> createRequest({
    required String consumerUserId,
    required String doctorUserId,
  }) {
    return _remote.createAdmissionRequest(
      consumerUserId: consumerUserId,
      doctorUserId: doctorUserId,
    );
  }

  Future<void> cancelRequest(String requestId) {
    return _remote.cancelAdmissionRequest(requestId);
  }
}