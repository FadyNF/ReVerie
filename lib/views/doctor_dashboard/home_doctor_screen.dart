import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/reverie_ui.dart';
import '../../providers/doctor_dashboard_provider.dart';

class HomeDoctorScreen extends StatelessWidget {
  const HomeDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DoctorDashboardProvider>();

    return Container(
      color: Rv.bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Welcome back, ${p.doctorDisplayName}",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Rv.text,
                        ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none_rounded),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              "Here's what needs your attention today.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Rv.subtext),
            ),
            const SizedBox(height: 16),

            _StatCard(
              title: "Pending Requests",
              value: p.pendingRequests.toString(),
              subtitle: "${p.admissionRequests} admission, ${p.sessionRequests} session",
              icon: Icons.assignment_rounded,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _MiniCard(
                    title: "Active Patients",
                    value: p.activePatients.toString(),
                    icon: Icons.people_alt_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniCard(
                    title: "Today's Sessions",
                    value: p.todaysSessionsCount.toString(),
                    icon: Icons.calendar_month_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              "Today's Schedule",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),

            Container(
              decoration: Rv.cardDeco(),
              padding: const EdgeInsets.all(14),
              child: Column(
                children: p.todaysSchedule.map((s) {
                  final last = s == p.todaysSchedule.last;
                  return Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Rv.chipBg,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              s.timeLabel,
                              style: const TextStyle(fontWeight: FontWeight.w900, color: Rv.primary),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s.patientName, style: const TextStyle(fontWeight: FontWeight.w900)),
                                const SizedBox(height: 4),
                                Text(s.subtitle, style: TextStyle(color: Rv.subtext, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (!last) const Divider(height: 22),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Rv.cardDeco(),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Rv.chipBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Rv.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Rv.primary, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MiniCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Rv.cardDeco(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Rv.chipBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Rv.primary),
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(title, style: TextStyle(color: Rv.subtext, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
