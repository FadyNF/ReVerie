import 'package:flutter/material.dart';
import '../screens/patient_home_screen.dart';

class NextSessionCard extends StatelessWidget {
  const NextSessionCard({
    super.key,
    required this.date,
    required this.doctorName,
    required this.doctorRole,
    required this.onTap,
  });

  final String date;
  final String doctorName;
  final String doctorRole;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white, // light lavender tint like mock
          border: Border.all(color: PatientHomeScreen.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: PatientHomeScreen.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    doctorName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: PatientHomeScreen.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctorRole,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: PatientHomeScreen.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: PatientHomeScreen.blue, // ✅ no more purple
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
