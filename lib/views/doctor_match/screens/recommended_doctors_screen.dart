import 'package:flutter/material.dart';
import 'package:reverie/views/common/current_user_service.dart';
import 'package:reverie/views/doctor_match/models/recommended_doctor.dart';
import 'package:reverie/views/doctor_match/providers/admission_provider.dart';
import 'package:reverie/views/doctor_match/providers/doctor_provider.dart';
import 'package:reverie/views/doctor_match/screens/waiting_approval_screen.dart';
import 'package:reverie/views/doctor_match/widgets/recommended_doctor_card.dart';
import 'package:reverie/views/doctor_match/widgets/step_progress_bar.dart';

class RecommendedDoctorsScreen extends StatefulWidget {
  static const routeName = '/recommended_doctors';

  const RecommendedDoctorsScreen({super.key});

  @override
  State<RecommendedDoctorsScreen> createState() =>
      _RecommendedDoctorsScreenState();
}

class _RecommendedDoctorsScreenState extends State<RecommendedDoctorsScreen> {
  final DoctorProviderService _doctorProvider = DoctorProviderService();
  final AdmissionProviderService _admissionProvider =
      AdmissionProviderService();

  late Future<List<RecommendedDoctor>> _doctorsFuture;

  @override
  void initState() {
    super.initState();
    _doctorsFuture = _doctorProvider.getRecommendedDoctors();
  }

  Future<void> _onChooseDoctor(RecommendedDoctor doctor) async {
    try {
      final consumerUserId = CurrentUserService.requireUserId();

      debugPrint('consumerUserId = $consumerUserId');
      debugPrint('doctorUserId = ${doctor.id}');

      final request = await _admissionProvider.createRequest(
        consumerUserId: consumerUserId,
        doctorUserId: doctor.id,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WaitingApprovalScreen(
            doctor: doctor,
            requestId: request.id,
            doctorUserId: request.doctorUserId,
            consumerUserId: request.consumerUserId,
            status: request.status,
          ),
        ),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Selected: ${doctor.name}')));
    } catch (e, st) {
      debugPrint('CREATE REQUEST ERROR: $e');
      debugPrintStack(stackTrace: st);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not send request: $e')));
    }
  }

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
              child: FutureBuilder<List<RecommendedDoctor>>(
                future: _doctorsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Failed to load recommended doctors'),
                    );
                  }

                  final doctors = snapshot.data ?? [];

                  if (doctors.isEmpty) {
                    return const Center(
                      child: Text('No recommended doctors found'),
                    );
                  }

                  return ListView(
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
                            onChoose: () => _onChooseDoctor(d),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
