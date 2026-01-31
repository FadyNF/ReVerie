import 'package:flutter/material.dart';
import 'package:reverie/views/auth/auth_ui.dart';
import 'package:reverie/views/doctor_match/models/doctor_profile_model.dart';
import 'package:reverie/views/doctor_match/models/recommended_doctor.dart';
import 'package:reverie/views/doctor_match/screens/waiting_approval_screen.dart';

class DoctorProfileScreen extends StatelessWidget {
  final DoctorProfileModel doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

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
        title: const Text(
          'Doctor Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderCard(doctor: doctor),
                    const SizedBox(height: 14),

                    // About
                    const _SectionTitle(title: 'About'),
                    const SizedBox(height: 8),
                    Text(
                      doctor.about.isEmpty ? '—' : doctor.about,
                      style: TextStyle(
                        height: 1.45,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Education
                    const _SectionTitle(title: 'Education'),
                    const SizedBox(height: 10),
                    if (doctor.education.isEmpty)
                      Text(
                        '—',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    else
                      ...doctor.education.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _InfoTile(
                            icon: Icons.school_outlined,
                            title: e.title,
                            subtitle: '${e.subtitle}\n${e.year}',
                          ),
                        ),
                      ),

                    const SizedBox(height: 10),

                    // Languages
                    const _SectionTitle(title: 'Languages'),
                    const SizedBox(height: 10),
                    if (doctor.languages.isEmpty)
                      Text(
                        '—',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: doctor.languages
                            .map((lang) => _Chip(text: lang))
                            .toList(),
                      ),

                    const SizedBox(height: 18),

                    // Availability
                    const _SectionTitle(title: 'Availability'),
                    const SizedBox(height: 10),
                    if (doctor.availability.isEmpty)
                      Text(
                        '—',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    else
                      ...doctor.availability.entries.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _AvailabilityRow(day: e.key, time: e.value),
                        ),
                      ),

                    const SizedBox(height: 18),

                    // Tags (optional)
                    if (doctor.tags.isNotEmpty) ...[
                      const _SectionTitle(title: 'Highlights'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: doctor.tags
                            .map((t) => _Chip(text: t))
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Apply button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    final rec = _toRecommended(doctor);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WaitingApprovalScreen(
                          doctor: rec,
                          stage: AppointmentStage.requestSent,
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
                  child: const Text('Apply to Doctor'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  RecommendedDoctor _toRecommended(DoctorProfileModel d) {
    return RecommendedDoctor(
      id: d.id,
      initials: d.initials,
      name: d.name,
      specialty: d.specialty,
      clinic: d.clinic,
      rating: d.rating,
      reasons: const [], // not needed here
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final DoctorProfileModel doctor;

  const _HeaderCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialty,
                      style: TextStyle(
                        fontSize: 12.8,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.clinic,
                      style: TextStyle(
                        fontSize: 12.8,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MiniStat(
                top: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: Color(0xFFF4B000),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      doctor.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                bottom: '${doctor.reviews} reviews',
              ),
              _MiniStat(
                top: Text(
                  '${doctor.yearsExperience} years',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                bottom: 'Experience',
              ),
              _MiniStat(
                top: Text(
                  '${doctor.patients}+',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                bottom: 'Patients',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final Widget top;
  final String bottom;

  const _MiniStat({required this.top, required this.bottom});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        top,
        const SizedBox(height: 4),
        Text(
          bottom,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: Colors.black,
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AuthUI.primaryBlue.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AuthUI.primaryBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    height: 1.35,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;

  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w700,
          fontSize: 12.5,
        ),
      ),
    );
  }
}

class _AvailabilityRow extends StatelessWidget {
  final String day;
  final String time;

  const _AvailabilityRow({required this.day, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
