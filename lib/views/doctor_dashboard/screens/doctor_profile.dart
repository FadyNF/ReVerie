import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = DoctorProfileVM.fake();

    return ColoredBox(
      color: DoctorTokens.bg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
            children: [
              const _Header(),
              const SizedBox(height: 14),

              _DoctorIdentityCard(
                initials: vm.initials,
                name: vm.name,
                specialty: vm.specialty,
                email: vm.email,
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: vm.activePatients.toString(),
                      label: "Active Patients",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      value: vm.totalSessions.toString(),
                      label: "Total Sessions",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _DoctorIdCard(
                doctorId: vm.doctorId,
                onCopy: () async {
                  await Clipboard.setData(ClipboardData(text: vm.doctorId));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Doctor ID copied")),
                    );
                  }
                },
              ),

              const SizedBox(height: 12),

              _TileCard(
                child: _TileRow(
                  leading: _IconBubble(
                    icon: Icons.key_outlined,
                    bg: DoctorTokens.orangeSoft,
                    fg: DoctorTokens.orange,
                  ),
                  title: "Priority Admission Code",
                  subtitle: "Share temporary access code",
                  onTap: vm.onPriorityCode,
                  showChevron: true,
                ),
              ),

              const SizedBox(height: 10),

              _TileCard(
                child: Column(
                  children: [
                    _TileRow(
                      leading: const _IconBubble(
                        icon: Icons.settings_outlined,
                        bg: DoctorTokens.graySoft,
                        fg: DoctorTokens.iconMuted,
                      ),
                      title: "Settings",
                      subtitle: "",
                      onTap: vm.onSettings,
                      showChevron: true,
                      dense: true,
                    ),
                    const _Divider(),
                    _TileRow(
                      leading: const _IconBubble(
                        icon: Icons.help_outline_rounded,
                        bg: DoctorTokens.graySoft,
                        fg: DoctorTokens.iconMuted,
                      ),
                      title: "Help & Support",
                      subtitle: "",
                      onTap: vm.onHelp,
                      showChevron: true,
                      dense: true,
                    ),
                    const _Divider(),
                    _TileRow(
                      leading: const _IconBubble(
                        icon: Icons.logout_rounded,
                        bg: DoctorTokens.redSoft,
                        fg: DoctorTokens.danger,
                      ),
                      title: "Sign Out",
                      subtitle: "",
                      onTap: vm.onSignOut,
                      showChevron: false,
                      dense: true,
                      titleColor: DoctorTokens.danger,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  "ReVerie Doctor Mode v${vm.appVersion}",
                  style: const TextStyle(
                    fontSize: 12,
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
   VM (swap with Provider)
   ========================= */

class DoctorProfileVM {
  final String initials;
  final String name;
  final String specialty;
  final String email;

  final int activePatients;
  final int totalSessions;

  final String doctorId;
  final String appVersion;

  final VoidCallback? onPriorityCode;
  final VoidCallback? onSettings;
  final VoidCallback? onHelp;
  final VoidCallback? onSignOut;

  DoctorProfileVM({
    required this.initials,
    required this.name,
    required this.specialty,
    required this.email,
    required this.activePatients,
    required this.totalSessions,
    required this.doctorId,
    required this.appVersion,
    required this.onPriorityCode,
    required this.onSettings,
    required this.onHelp,
    required this.onSignOut,
  });

  factory DoctorProfileVM.fake() => DoctorProfileVM(
        initials: "SC",
        name: "Dr. Sarah Chen",
        specialty: "Clinical Psychology",
        email: "sarah.chen@reverie.health",
        activePatients: 18,
        totalSessions: 156,
        doctorId: "DR-SC-2024-7891",
        appVersion: "1.0.0",
        onPriorityCode: null,
        onSettings: null,
        onHelp: null,
        onSignOut: null,
      );
}

/* =========================
   Tokens
   ========================= */

class DoctorTokens {
  static const bg = Color(0xFFF7F8FA);
  static const card = Colors.white;

  static const border = Color(0xFFE5E7EB);
  static const shadow = Color(0x14000000);

  static const primary = Color(0xFF2563EB);

  static const text = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);

  static const iconMuted = Color(0xFF475569);

  static const graySoft = Color(0xFFF1F5F9);

  static const orange = Color(0xFFF59E0B);
  static const orangeSoft = Color(0xFFFFF7ED);

  static const danger = Color(0xFFEF4444);
  static const redSoft = Color(0xFFFFF1F2);

  static const blueSoft = Color(0xFFEAF1FF);
}

/* =========================
   Widgets
   ========================= */

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Profile",
          style: TextStyle(
            fontSize: 28,
            height: 1.05,
            fontWeight: FontWeight.w900,
            color: DoctorTokens.text,
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Manage your account and settings",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: DoctorTokens.textMuted,
          ),
        ),
      ],
    );
  }
}

class _DoctorIdentityCard extends StatelessWidget {
  const _DoctorIdentityCard({
    required this.initials,
    required this.name,
    required this.specialty,
    required this.email,
  });

  final String initials;
  final String name;
  final String specialty;
  final String email;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: DoctorTokens.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                      color: DoctorTokens.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: DoctorTokens.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: DoctorTokens.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: DoctorTokens.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: DoctorTokens.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorIdCard extends StatelessWidget {
  const _DoctorIdCard({required this.doctorId, required this.onCopy});

  final String doctorId;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _IconBubble(
                  icon: Icons.badge_outlined,
                  bg: DoctorTokens.blueSoft,
                  fg: DoctorTokens.primary,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "Your Doctor ID (for patient search)",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: DoctorTokens.text,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              doctorId,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.2,
                color: DoctorTokens.text,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 38,
              child: OutlinedButton.icon(
                onPressed: onCopy,
                icon: const Icon(Icons.copy_rounded, size: 16, color: DoctorTokens.primary),
                label: const Text(
                  "Copy ID",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: DoctorTokens.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: DoctorTokens.border),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Patients can use this permanent ID to find and connect with you",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: DoctorTokens.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TileCard extends StatelessWidget {
  const _TileCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => _Card(child: child);
}

class _TileRow extends StatelessWidget {
  const _TileRow({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.showChevron,
    this.dense = false,
    this.titleColor = DoctorTokens.text,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool dense;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    final pad = dense ? const EdgeInsets.fromLTRB(14, 12, 12, 12) : const EdgeInsets.fromLTRB(14, 14, 12, 14);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: pad,
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: DoctorTokens.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              const Icon(Icons.chevron_right_rounded, color: DoctorTokens.textMuted),
          ],
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.bg, required this.fg});

  final IconData icon;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Icon(icon, size: 18, color: fg),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: DoctorTokens.border);
  }
}

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
