import 'package:flutter/material.dart';
import 'package:reverie/views/auth/auth_ui.dart';
import 'package:reverie/views/doctor_match/models/doctor_profile_model.dart';
import 'package:reverie/views/doctor_match/screens/doctor_profile_screen.dart';
import 'package:reverie/views/doctor_match/screens/doctors_list_screen.dart';
import 'package:reverie/views/doctor_match/screens/recommended_doctors_screen.dart';
import 'package:reverie/views/doctor_match/widgets/step_progress_bar.dart';
import 'package:reverie/views/doctor_match/models/recommended_doctor.dart';

class WaitingApprovalScreen extends StatelessWidget {
  final RecommendedDoctor doctor;

  // later in backend stage will come from request table (pending/review/approved)
  final AppointmentStage stage;

  const WaitingApprovalScreen({
    super.key,
    required this.doctor,
    this.stage = AppointmentStage.requestSent,
  });

  bool get _requestSentDone =>
      stage.index >= AppointmentStage.requestSent.index;
  bool get _doctorReviewDone =>
      stage.index >= AppointmentStage.doctorReview.index;
  bool get _confirmationDone =>
      stage.index >= AppointmentStage.confirmation.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step bar (this is after recommendations, so step 4/4)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StepProgressBar(currentStep: 4, totalSteps: 4),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    // Icon circle
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        color: AuthUI.primaryBlue.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AuthUI.primaryBlue.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.access_time_rounded,
                          size: 26,
                          color: AuthUI.primaryBlue,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Waiting for Approval',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Your appointment request has been sent to\nthe doctor. You'll receive a notification\nonce it's approved.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.4,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _DoctorSummaryCard(doctor: doctor),

                    const SizedBox(height: 18),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'What happens next:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    _StepRow(
                      active: _requestSentDone,
                      title: 'Request sent',
                      subtitle: 'Your appointment request has been submitted',
                    ),
                    const SizedBox(height: 10),
                    _StepRow(
                      active: _doctorReviewDone,
                      title: 'Doctor review',
                      subtitle: 'Usually within 24 hours',
                    ),
                    const SizedBox(height: 10),
                    _StepRow(
                      active: _confirmationDone,
                      title: 'Confirmation',
                      subtitle: "You'll get notified of the approval",
                    ),
                  ],
                ),
              ),
            ),

            // Bottom actions
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoctorProfileScreen(
                              doctor: DoctorProfileModel.dummySarah(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AuthUI.primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('See doctor profile'),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: () => _showCancelDialog(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade800,
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Cancel request'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Cancel request?',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Text(
            'What would you like to do?',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx); //close dialog first
                  // dummy data for now change with backend retieval
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecommendedDoctorsScreen(
                        doctors: const [
                          RecommendedDoctor(
                            id: 'd1',
                            initials: 'DSC',
                            name: 'Dr. Sarah Chen',
                            specialty: 'Cognitive Specialist',
                            clinic: 'Memory Care Center',
                            rating: 4.9,
                            reasons: [
                              'Matches your availability',
                              'Calm approach',
                              'Arabic',
                            ],
                          ),
                          RecommendedDoctor(
                            id: 'd2',
                            initials: 'DMF',
                            name: 'Dr. Michael Foster',
                            specialty: 'Memory Care Specialist',
                            clinic: 'Sunnyvale Clinic',
                            rating: 4.8,
                            reasons: [
                              'Speaks Arabic',
                              'Video sessions',
                              'Nearby',
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AuthUI.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Let us recommend another doctor'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(ctx); // close dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FindDoctorScreen(
                        allDoctors: [
                          DoctorProfileModel.dummySarah(),
                          // add more dummy doctors here
                        ],
                      ),
                    ),
                  );
                },

                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade800,
                  side: BorderSide(color: Colors.grey.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('View other doctors'),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum AppointmentStage { requestSent, doctorReview, confirmation }

class _DoctorSummaryCard extends StatelessWidget {
  final RecommendedDoctor doctor;

  const _DoctorSummaryCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AuthUI.primaryBlue,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              doctor.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.specialty,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.clinic,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Color(0xFFF4B000),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      doctor.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final bool active;
  final String title;
  final String subtitle;

  const _StepRow({
    required this.active,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = active ? AuthUI.primaryBlue : Colors.grey.shade300;
    final titleColor = active ? Colors.black : Colors.grey.shade600;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: dotColor, width: 2),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
