import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/auth_provider.dart';
import 'views/splash_gate.dart';
import 'views/doctor_match/entry_page.dart';
import 'views/doctor_dashboard/screens/doctor_profile.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) load env
  await dotenv.load(fileName: ".env");

  // 2) init supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const ReVerieApp());
}

class ReVerieApp extends StatelessWidget {
  const ReVerieApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;

    return ChangeNotifierProvider(
      create: (_) => AuthProvider(client),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ReVerie',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: Colors.white,
        ),
        // home: const SplashGate(),
        // home: const DoctorProfileScreen(),
      ),
    );
  }
}
