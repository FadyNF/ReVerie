import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'auth/auth_ui.dart';
import 'common/app_dialogs.dart';
import 'sign_in_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  String? fullNameError;
  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _validate() {
    setState(() {
      fullNameError = null;
      emailError = null;
      passwordError = null;

      final name = _fullName.text.trim();
      final email = _email.text.trim();
      final password = _password.text;

      if (name.isEmpty) {
        fullNameError = 'Please enter your full name.';
      } else if (name.length < 3) {
        fullNameError = 'Name looks too short.';
      }

      if (email.isEmpty) {
        emailError = 'Please enter your email.';
      } else if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(email)) {
        emailError = 'Enter a valid email address.';
      }

      if (password.isEmpty) {
        passwordError = 'Please create a password.';
      } else if (password.length < 6) {
        passwordError = 'Password must be at least 6 characters.';
      }
    });

    return fullNameError == null && emailError == null && passwordError == null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_validate()) return;

    final auth = context.read<AuthProvider>();
    final ok = await auth.signUp(
      fullName: _fullName.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
      role: 'consumer',
    );

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context);
      // later: route to welcome/onboarding
    } else {
      await AppDialogs.showError(
        context,
        title: 'Couldn’t create account',
        message: auth.errorMessage ?? 'Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.chevron_left, size: 28),
              ),
              const SizedBox(height: 8),

              Text('Create Account', style: AuthUI.title),
              const SizedBox(height: 6),
              Text(
                'Join ReVerie to start your journey',
                style: AuthUI.subtitle,
              ),
              const SizedBox(height: 28),

              Text('Full Name', style: AuthUI.label),
              const SizedBox(height: 8),
              TextField(
                controller: _fullName,
                decoration: AuthUI.inputDecoration(
                  'Enter your full name',
                ).copyWith(errorText: fullNameError),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 18),

              Text('Email', style: AuthUI.label),
              const SizedBox(height: 8),
              TextField(
                controller: _email,
                decoration: AuthUI.inputDecoration(
                  'Enter your email',
                ).copyWith(errorText: emailError),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 18),

              Text('Password', style: AuthUI.label),
              const SizedBox(height: 8),
              TextField(
                controller: _password,
                decoration: AuthUI.inputDecoration(
                  'Create a password',
                ).copyWith(errorText: passwordError),
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => auth.isLoading ? null : _submit(),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: AuthUI.primaryButtonStyle(),
                  onPressed: auth.isLoading ? null : _submit,
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Create Account'),
                ),
              ),

              const SizedBox(height: 22),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const SignInScreen()),
                      );
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: AuthUI.primaryBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
