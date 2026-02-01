import 'package:flutter/material.dart';
import 'package:reverie/views/auth/auth_ui.dart';
import 'package:reverie/views/doctor_match/models/doctor_profile_model.dart';
import 'package:reverie/views/doctor_match/screens/doctor_profile_screen.dart';

class EnterDoctorCodeScreen extends StatefulWidget {
  const EnterDoctorCodeScreen({super.key});

  @override
  State<EnterDoctorCodeScreen> createState() => _EnterDoctorCodeScreenState();
}

class _EnterDoctorCodeScreenState extends State<EnterDoctorCodeScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  String? _errorText;
  bool _checking = false;

  // DR + 4 digits
  final RegExp _codeRegex = RegExp(r'^DR\d{4}$');

  bool get _isFormatValid => _codeRegex.hasMatch(_controller.text.trim());

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      // Live validation (format only). Backend validation happens on Continue.
      final text = _controller.text.trim();

      String? nextError;
      if (text.isEmpty) {
        nextError = null; // no error while empty, just disabled button
      } else if (!_codeRegex.hasMatch(text)) {
        nextError = 'Enter a valid doctor code';
      } else {
        nextError = null;
      }

      if (nextError != _errorText) {
        setState(() => _errorText = nextError);
      } else {
        // Still need rebuild for button enabled state
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    FocusScope.of(context).unfocus();

    final code = _controller.text.trim();

    // Guard: format
    if (!_codeRegex.hasMatch(code)) {
      setState(() => _errorText = 'Enter a valid doctor code');
      return;
    }

    setState(() {
      _checking = true;
      _errorText = null;
    });

    try {
      // Later will replace this with Supabase / API call
      final exists = await DoctorCodeRepository.verifyDoctorCode(code);

      if (!mounted) return;

      if (!exists) {
        setState(() => _errorText = 'Enter a valid doctor code');
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              DoctorProfileScreen(doctor: DoctorProfileModel.dummySarah()),
        ),
      );
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _isFormatValid && !_checking;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Enter the code from your doctor',
                style: AuthUI.title.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 10),
              Text(
                'Your doctor will provide you with a unique\naccess code',
                style: AuthUI.subtitle.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 22),

              // Input
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _errorText != null
                        ? Colors.redAccent
                        : AuthUI.primaryBlue.withOpacity(0.9),
                    width: 1.6,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 6,
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'XXXXXX',
                    hintStyle: TextStyle(
                      color: Color(0xFFB9C0CC),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  onChanged: (v) {
                    // Force uppercase as user types
                    final upper = v.toUpperCase();
                    if (upper != v) {
                      final sel = _controller.selection;
                      _controller.value = TextEditingValue(
                        text: upper,
                        selection: sel,
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Error message (red)
              if (_errorText != null) ...[
                Text(
                  _errorText!,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
              ] else ...[
                const SizedBox(height: 26),
              ],

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: canContinue ? _onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canContinue
                        ? AuthUI.primaryBlue
                        : AuthUI.primaryBlue.withOpacity(0.25),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _checking
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// Later will replace verifyDoctorCode with a Supabase call.
/// For now it always returns true so UI can proceed.
class DoctorCodeRepository {
  static Future<bool> verifyDoctorCode(String code) async {
    // TODO: integrate backend (Supabase) here.
    // Example later:
    // final res = await Supabase.instance.client
    //   .from('doctor_codes')
    //   .select('code')
    //   .eq('code', code)
    //   .maybeSingle();
    // return res != null;

    await Future.delayed(const Duration(milliseconds: 250));
    return true;
  }
}
