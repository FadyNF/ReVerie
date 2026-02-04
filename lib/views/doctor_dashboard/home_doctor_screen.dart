import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/reverie_ui.dart';
import '../../providers/doctor_dashboard_provider.dart';
import 'notification_page.dart';

class HomeDoctorScreen extends StatelessWidget {
  const HomeDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DoctorDashboardProvider>();

    return Container(
      color: Rv.bg,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const NotificationPage()),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
            "Quick Actions",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),

          _PrimaryActionButton(
            text: "Join Session at 2:00 PM",
            icon: Icons.play_arrow_rounded,
            onTap: () {
              // TODO later: open live session / VR join link
            },
          ),

          const SizedBox(height: 10),

          _GhostActionButton(
            text: "Review Requests",
            onTap: () {
              // For now: switch to Requests tab? later: navigate with routing
              // TODO: implement tab switching via callback or provider if needed
            },
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _GhostActionButton(
                  text: "View Patients",
                  onTap: () {
                    // TODO: switch to Patients tab
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GhostActionButton(
                  text: "Schedule\nSession",
                  onTap: () {
                    // TODO later: open schedule flow
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Text(
                  "Today's Schedule",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO later: go to Sessions tab / full schedule
                },
                child: const Text(
                  "View All",
                  style: TextStyle(fontWeight: FontWeight.w900, color: Rv.primary),
                ),
              ),
            ],
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
                              Text(
                                s.subtitle,
                                style: TextStyle(color: Rv.subtext, fontWeight: FontWeight.w600),
                              ),
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

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryActionButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(text, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Rv.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: Rv.radius(18)),
        ),
      ),
    );
  }
}

class _GhostActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _GhostActionButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Rv.text,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: Rv.radius(18)),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
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
