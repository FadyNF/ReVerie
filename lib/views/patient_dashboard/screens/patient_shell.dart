import 'package:flutter/material.dart';

import 'patient_home_screen.dart';
import 'activities_screen.dart';
import 'profile_screen.dart';
import 'session_history_screen.dart';

class PatientShell extends StatefulWidget {
  const PatientShell({super.key});

  @override
  State<PatientShell> createState() => _PatientShellState();
}

class _PatientShellState extends State<PatientShell> {
  int _index = 0;

  late final List<Widget> _tabs = [
  PatientHomeScreen(onNav: (i) => setState(() => _index = i)),
  SessionHistoryScreen(onBackToHome: () => setState(() => _index = 0)),
  ActivitiesScreen(onBackToHome: () => setState(() => _index = 0)),
  ProfileScreen(onBackToHome: () => setState(() => _index = 0)),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_index],

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border(
            top: BorderSide(color: PatientHomeScreen.border),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  label: "Home",
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  selected: _index == 0,
                  onTap: () => setState(() => _index = 0),
                ),
                _NavItem(
                  label: "Sessions",
                  icon: Icons.vrpano_outlined,
                  selectedIcon: Icons.vrpano_rounded,
                  selected: _index == 1,
                  onTap: () => setState(() => _index = 1),
                ),
                _NavItem(
                  label: "Activities",
                  icon: Icons.local_activity_outlined,
                  selectedIcon: Icons.local_activity_rounded,
                  selected: _index == 2,
                  onTap: () => setState(() => _index = 2),
                ),
                _NavItem(
                  label: "Profile",
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person_rounded,
                  selected: _index == 3,
                  onTap: () => setState(() => _index = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  static const Color active = PatientHomeScreen.blue;
  static const Color inactive = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    final color = selected ? active : inactive;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? selectedIcon : icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                color: color,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
