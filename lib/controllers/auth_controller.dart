import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/profile.dart';

class AuthController {
  final SupabaseClient _sb;

  AuthController(this._sb);

  /// SIGN UP: creates auth user + inserts row in public.profiles
  Future<Profile> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    String role = 'consumer', // you can change default later
    String? phoneNumber,
  }) async {
    final res = await _sb.auth.signUp(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user == null) {
      // Usually happens if email confirmation is ON. You said it's OFF, but just in case:
      throw Exception('Signup succeeded but no user returned. Check Supabase Auth email confirmation settings.');
    }

    // Insert profile row linked to auth.users.id
    final profilePayload = {
      'id': user.id,
      'full_name': fullName,
      'email': email,
      'role': role,
      'phone_number': phoneNumber,
    };

    // upsert protects you if user retries
    final data = await _sb
        .from('profiles')
        .upsert(profilePayload)
        .select()
        .single();

    return Profile.fromMap(data);
  }

  /// SIGN IN: auth + fetch profile
  Future<Profile> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final res = await _sb.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = res.user;
    if (user == null) {
      throw Exception('Invalid login: no user returned.');
    }

    final data = await _sb
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    return Profile.fromMap(data);
  }

  Future<void> signOut() async {
    await _sb.auth.signOut();
  }

  /// Get current session user (if any)
  User? get currentAuthUser => _sb.auth.currentUser;

  /// Fetch current user's profile (if logged in)
  Future<Profile?> fetchCurrentProfile() async {
    final user = _sb.auth.currentUser;
    if (user == null) return null;

    final data = await _sb
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (data == null) return null;
    return Profile.fromMap(data);
  }
}
