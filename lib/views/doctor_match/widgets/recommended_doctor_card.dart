import 'package:flutter/material.dart';
import 'package:reverie/views/auth/auth_ui.dart';
import 'package:reverie/views/doctor_match/models/recommended_doctor.dart';

class RecommendedDoctorCard extends StatelessWidget {
  final RecommendedDoctor doctor;
  final VoidCallback onChoose;

  const RecommendedDoctorCard({
    super.key,
    required this.doctor,
    required this.onChoose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: avatar + info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
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
                    fontSize: 14,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialty,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.clinic,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Color(0xFFF4B400),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          doctor.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            'WHY RECOMMENDED',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 0.6,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: doctor.reasons.map((r) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  r,
                  style: const TextStyle(
                    color: AuthUI.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: onChoose,
              style: ElevatedButton.styleFrom(
                backgroundColor: AuthUI.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              child: const Text('Choose Doctor'),
            ),
          ),
        ],
      ),
    );
  }
}
