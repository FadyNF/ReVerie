import 'package:flutter/material.dart';
import '../../auth/auth_ui.dart';

import 'package:reverie/views/doctor_match/screens/enter_doctor_code_screen.dart';
import 'package:reverie/views/doctor_match/screens/onboarding_questions_screen.dart';

class DoctorRequiredScreen extends StatelessWidget {
  const DoctorRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Top-left logo text
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'ReVerie',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.shade900,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Lock icon in a soft circle
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: AuthUI.primaryBlue,
                  size: 32,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                'Doctor Required',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade900,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'To continue, a doctor must guide your\nsessions. This ensures you receive the best\ncare and support.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 40),

              // Button cards
              _ActionCard(
                background: AuthUI.primaryBlue,
                icon: Icons.key,
                title: 'Enter Doctor Code',
                subtitle: 'If you have a code from your doctor',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EnterDoctorCodeScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 13),

              _ActionCard(
                background: const Color(0xFF7B61FF),
                icon: Icons.favorite_border,
                title: 'Find the Right Doctor',
                subtitle: 'Answer a few questions to get\nmatched',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OnboardingQuestionsScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 13),

              _BrowseCard(
                background: Colors.grey.shade600,
                onTap: () {
                  // TODO: navigate later
                },
              ),

              const Spacer(),

              // Bottom info pill
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Your doctor will help create a personalized\nexperience and monitor your progress with',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final Color background;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.background,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrowseCard extends StatelessWidget {
  final Color background;
  final VoidCallback onTap;

  const _BrowseCard({required this.onTap, required this.background});

  @override
  Widget build(BuildContext context) {
    return Material(
      //color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.search,
                  color: Colors.grey.shade700,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Browse All Doctors',
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View available doctors',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
