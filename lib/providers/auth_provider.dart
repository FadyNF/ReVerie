import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/auth_controller.dart';
import '../model/profile.dart';

class AuthProvider extends ChangeNotifier {
  final AuthController _auth;

  AuthProvider(SupabaseClient client) : _auth = AuthController(client);

  Profile? currentUser;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadSession() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentUser = await _auth.fetchCurrentProfile();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
    String role = 'consumer',
    String? phoneNumber,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentUser = await _auth.signUpWithEmail(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        phoneNumber: phoneNumber,
      );
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentUser = await _auth.signInWithEmail(email: email, password: password);
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }
}
