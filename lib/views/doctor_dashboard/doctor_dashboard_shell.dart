import 'package:flutter/material.dart';
import 'home_doctor_screen.dart';
import 'requests_screen.dart';
import 'patients_screen.dart';
import 'sessions_placeholder_screen.dart';
import 'profile_placeholder_screen.dart';

class DoctorDashboardShell extends StatefulWidget {
  const DoctorDashboardShell({super.key});

  @override
  State<DoctorDashboardShell> createState() => _DoctorDashboardShellState();
}

class _DoctorDashboardShellState extends State<DoctorDashboardShell> {
  int _index = 0;

  final _tabs = const [
    HomeDoctorScreen(),
    RequestsScreen(),
    PatientsScreen(),
    SessionsPlaceholderScreen(),
    ProfilePlaceholderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _tabs[_index]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563FF),
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: "Requests"),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt_rounded), label: "Patients"),
          BottomNavigationBarItem(icon: Icon(Icons.videocam_rounded), label: "Sessions"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profile"),
        ],
      ),
    );
  }
}
