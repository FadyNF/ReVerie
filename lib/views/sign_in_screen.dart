import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'auth/auth_ui.dart';
import 'common/app_dialogs.dart';
import 'create_account_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _validate() {
    setState(() {
      emailError = null;
      passwordError = null;

      final email = _email.text.trim();
      final password = _password.text;

      if (email.isEmpty) {
        emailError = 'Please enter your email.';
      } else if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(email)) {
        emailError = 'Enter a valid email address.';
      }

      if (password.isEmpty) {
        passwordError = 'Please enter your password.';
      }
    });

    return emailError == null && passwordError == null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_validate()) return;

    final auth = context.read<AuthProvider>();
    final ok = await auth.signIn(
      email: _email.text.trim(),
      password: _password.text,
    );

    if (!mounted) return;

    if (ok) {
      Navigator.pop(context);
    } else {
      await AppDialogs.showError(
        context,
        title: 'Sign in failed',
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

              Text('Sign In', style: AuthUI.title),
              const SizedBox(height: 6),
              Text('Welcome back to ReVerie', style: AuthUI.subtitle),
              const SizedBox(height: 28),

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
                  'Enter your password',
                ).copyWith(errorText: passwordError),
                obscureText: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => auth.isLoading ? null : _submit(),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // later
                    AppDialogs.showError(
                      context,
                      title: 'Not yet',
                      message: 'Forgot password will be added next.',
                    );
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: AuthUI.primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

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
                      : const Text('Sign In'),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateAccountScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Create one',
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
