import 'package:flutter/material.dart';
import 'package:reverie/views/doctor_match/models/recommended_doctor.dart';
import 'package:reverie/views/doctor_match/widgets/recommended_doctor_card.dart';
import 'package:reverie/views/doctor_match/widgets/step_progress_bar.dart';

import 'package:reverie/views/doctor_match/screens/waiting_approval_screen.dart';
class RecommendedDoctorsScreen extends StatelessWidget {
  // Later will pass backend results in this list.
  final List<RecommendedDoctor> doctors;

  const RecommendedDoctorsScreen({super.key, required this.doctors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recommended for You',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StepProgressBar(currentStep: 4, totalSteps: 4),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                children: [
                  Text(
                    'We found ${doctors.length} doctors that match your\npreferences',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),

                  ...doctors.map((d) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: RecommendedDoctorCard(
                        doctor: d,
                        onChoose: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => WaitingApprovalScreen(
                                doctor: DoctorUiModel(
                                  id: 'doc_1',
                                  initials: 'DSC',
                                  name: 'Dr. Sarah Chen',
                                  specialty: 'Cognitive Specialist',
                                  clinic: 'Memory Care Center',
                                  rating: 4.9,
                                ),
                                stage: AppointmentStage.requestSent,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected: ${d.name}')),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
