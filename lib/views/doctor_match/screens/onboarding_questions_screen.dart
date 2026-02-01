import 'package:flutter/material.dart';
import 'package:reverie/views/auth/auth_ui.dart';
import 'package:reverie/views/doctor_match/widgets/step_progress_bar.dart';

import 'package:reverie/views/doctor_match/screens/meeting_time_screen.dart';

class OnboardingQuestionsScreen extends StatefulWidget {
  const OnboardingQuestionsScreen({super.key});

  @override
  State<OnboardingQuestionsScreen> createState() =>
      _OnboardingQuestionsScreenState();
}

class _OnboardingQuestionsScreenState extends State<OnboardingQuestionsScreen> {
  final Set<String> _selected = {};

  // Keep these labels EXACTLY as your mockup
  final List<String> _options = const [
    'Fast appointment',
    'Calm communication',
    'Female doctor',
    'Male doctor',
    'Arabic',
    'English',
    'Video sessions',
    'Clinic near me',
    'Dementia specialist',
    'Memory care expert',
  ];

  bool get _canContinue => _selected.isNotEmpty;

  void _toggle(String value) {
    setState(() {
      if (_selected.contains(value)) {
        _selected.remove(value);
      } else {
        _selected.add(value);
      }
    });
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
          'Find Your Doctor',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Top progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StepProgressBar(currentStep: 1, totalSteps: 4),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'What matters most to you?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select all that apply',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _options.map((label) {
                        final selected = _selected.contains(label);

                        return InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => _toggle(label),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AuthUI.primaryBlue
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom continue button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _canContinue
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MeetingTimeScreen(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AuthUI.primaryBlue,
                    disabledBackgroundColor: AuthUI.primaryBlue.withOpacity(
                      0.35,
                    ),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white.withOpacity(0.7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
