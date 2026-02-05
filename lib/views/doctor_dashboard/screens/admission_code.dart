import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriorityAdmissionCodeScreen extends StatefulWidget {
  const PriorityAdmissionCodeScreen({super.key});

  @override
  State<PriorityAdmissionCodeScreen> createState() => _PriorityAdmissionCodeScreenState();
}

class _PriorityAdmissionCodeScreenState extends State<PriorityAdmissionCodeScreen> {
  late String code;

  @override
  void initState() {
    super.initState();
    code = _generateCode();
  }

  String _generateCode() {
    const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // no 0/O/1/I
    final r = Random();
    return List.generate(6, (_) => chars[r.nextInt(chars.length)]).join();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Code copied")),
    );
  }

  void _regenerate() => setState(() => code = _generateCode());

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: DoctorTokens.bg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            children: [
              // Back
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      size: 28,
                      color: DoctorTokens.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: DoctorTokens.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const Text(
                "Priority Admission Code",
                style: TextStyle(
                  fontSize: 22,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                  color: DoctorTokens.text,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Share this code with patients for priority access",
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: DoctorTokens.textMuted,
                ),
              ),

              const SizedBox(height: 14),

              _Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                  child: Column(
                    children: [
                      Text(
                        code,
                        style: const TextStyle(
                          fontSize: 34,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w900,
                          color: DoctorTokens.primary,
                        ),
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: ElevatedButton.icon(
                                onPressed: _copy,
                                icon: const Icon(Icons.copy_rounded, size: 18),
                                label: const Text(
                                  "Copy",
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: DoctorTokens.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 42,
                              child: OutlinedButton.icon(
                                onPressed: _regenerate,
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  size: 18,
                                  color: DoctorTokens.text,
                                ),
                                label: const Text(
                                  "Regenerate",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: DoctorTokens.text,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: DoctorTokens.border),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: DoctorTokens.graySoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: DoctorTokens.border),
                ),
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: const Text(
                  "Patients using this code skip the assessment and appear first in your review list. This does not grant immediate admission—your approval is still required.",
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                    color: DoctorTokens.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* =========================
   Tokens (local to avoid circular imports)
   ========================= */

class DoctorTokens {
  static const bg = Color(0xFFF7F8FA);
  static const card = Colors.white;

  static const border = Color(0xFFE5E7EB);
  static const shadow = Color(0x14000000);

  static const primary = Color(0xFF2563EB);

  static const text = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  static const graySoft = Color(0xFFF1F5F9);
}

/* =========================
   Card
   ========================= */

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DoctorTokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DoctorTokens.border),
        boxShadow: const [
          BoxShadow(
            color: DoctorTokens.shadow,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
