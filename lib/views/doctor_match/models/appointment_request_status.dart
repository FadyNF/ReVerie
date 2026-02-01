enum AppointmentStage { requestSent, doctorReview, confirmation }

class AppointmentRequestStatus {
  final AppointmentStage stage;

  const AppointmentRequestStatus(this.stage);

  bool get isRequestSentDone =>
      stage.index >= AppointmentStage.requestSent.index;
  bool get isDoctorReviewDone =>
      stage.index >= AppointmentStage.doctorReview.index;
  bool get isConfirmationDone =>
      stage.index >= AppointmentStage.confirmation.index;
}
