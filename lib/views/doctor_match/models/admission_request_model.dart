class AdmissionRequestModel {
  final String id;
  final String consumerUserId;
  final String doctorUserId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? rejectionReason;
  final DateTime? approvedAt;

  const AdmissionRequestModel({
    required this.id,
    required this.consumerUserId,
    required this.doctorUserId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.rejectionReason,
    this.approvedAt,
  });

  factory AdmissionRequestModel.fromMap(Map<String, dynamic> map) {
    return AdmissionRequestModel(
      id: map['id'],
      consumerUserId: map['consumer_user_id'],
      doctorUserId: map['doctor_user_id'],
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      rejectionReason: map['rejection_reason'],
      approvedAt: map['approved_at'] != null
          ? DateTime.parse(map['approved_at'])
          : null,
    );
  }
}