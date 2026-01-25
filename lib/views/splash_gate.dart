import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'auth_landing_screen.dart';
import 'splash_screen.dart';
// TODO later: import 'welcome_screen.dart';

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    // Load session/profile
    await context.read<AuthProvider>().loadSession();

    if (!mounted) return;

    final auth = context.read<AuthProvider>();

    // ✅ If logged in (profile exists) -> later route to your welcome/dashboard
    if (auth.currentUser != null) {
      // TODO: Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthLandingScreen()),
      );
      return;
    }

    // ✅ Not logged in -> landing
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthLandingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
