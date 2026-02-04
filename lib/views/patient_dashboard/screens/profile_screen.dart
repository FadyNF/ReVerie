import 'package:flutter/material.dart';

/// Profile (Patient) — UI only
/// Matches mock:
/// - White/off-white background (NOT lavender)
/// - Scrollable "tiny bit long"
/// - Cards + section headers
/// - Backend-ready via ProfileVM (swap with provider/supabase later)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileVM vm;

  @override
  void initState() {
    super.initState();
    vm = ProfileVM.fake();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileTokens.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          children: [
            // Title + subtitle (left aligned like mock)
            const Text(
              "Profile",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: ProfileTokens.textPrimary,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Manage your ReVerie experience",
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: ProfileTokens.textSecondary,
              ),
            ),

            const SizedBox(height: 14),

            _ProfileHeaderCard(
              name: vm.name,
              role: vm.roleLabel,
              onEditProfile: vm.onEditProfile,
            ),

            const SizedBox(height: 16),

            const _SectionTitle("ACCESSIBILITY"),
            const SizedBox(height: 8),
            _Card(
              children: [
                _RowItem(
                  icon: Icons.visibility_outlined,
                  title: "Display & Text Size",
                  subtitle: "Adjust for comfort",
                  onTap: vm.onDisplayTextSize,
                ),
                const _Divider(),
                _SwitchRow(
                  icon: Icons.notifications_none_rounded,
                  title: "Gentle Reminders",
                  subtitle: "Session prompts",
                  value: vm.gentleReminders,
                  onChanged: (v) {
                    setState(() => vm = vm.copyWith(gentleReminders: v));
                    vm.onToggleGentleReminders?.call(v);
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            const _SectionTitle("PRIVACY & SECURITY"),
            const SizedBox(height: 8),
            _Card(
              children: [
                _RowItem(
                  icon: Icons.lock_outline_rounded,
                  title: "Privacy Settings",
                  subtitle: "Your data stays private",
                  onTap: vm.onPrivacySettings,
                ),
                const _Divider(),
                _RowItem(
                  icon: Icons.group_outlined,
                  title: "Connected Caregivers",
                  subtitle: vm.connectedCaregiversLabel,
                  onTap: vm.onConnectedCaregivers,
                ),
              ],
            ),

            const SizedBox(height: 16),

            const _SectionTitle("SUPPORT"),
            const SizedBox(height: 8),
            _Card(
              children: [
                _RowItem(
                  icon: Icons.help_outline_rounded,
                  title: "Help & Support",
                  subtitle: "We’re here for you",
                  onTap: vm.onHelpSupport,
                ),
                const _Divider(),
                _RowItem(
                  icon: Icons.favorite_border_rounded,
                  title: "About ReVerie",
                  subtitle: "Version ${vm.appVersion}",
                  onTap: vm.onAbout,
                ),
              ],
            ),

            const SizedBox(height: 16),

            _SignOutCard(onTap: vm.onSignOut),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/* =========================
   Backend-ready ViewModel
   ========================= */

class ProfileVM {
  final String name;
  final String roleLabel;
  final bool gentleReminders;

  final int connectedCaregiversCount;
  final String appVersion;

  final VoidCallback? onEditProfile;
  final VoidCallback? onDisplayTextSize;
  final ValueChanged<bool>? onToggleGentleReminders;

  final VoidCallback? onPrivacySettings;
  final VoidCallback? onConnectedCaregivers;

  final VoidCallback? onHelpSupport;
  final VoidCallback? onAbout;
  final VoidCallback? onSignOut;

  ProfileVM({
    required this.name,
    required this.roleLabel,
    required this.gentleReminders,
    required this.connectedCaregiversCount,
    required this.appVersion,
    required this.onEditProfile,
    required this.onDisplayTextSize,
    required this.onToggleGentleReminders,
    required this.onPrivacySettings,
    required this.onConnectedCaregivers,
    required this.onHelpSupport,
    required this.onAbout,
    required this.onSignOut,
  });

  String get connectedCaregiversLabel {
    if (connectedCaregiversCount == 0) return "No caregivers linked";
    if (connectedCaregiversCount == 1) return "1 caregiver linked";
    return "$connectedCaregiversCount caregivers linked";
  }

  factory ProfileVM.fake() {
    return ProfileVM(
      name: "Margaret Williams",
      roleLabel: "Patient",
      gentleReminders: true,
      connectedCaregiversCount: 1,
      appVersion: "1.0.0",
      onEditProfile: null,
      onDisplayTextSize: null,
      onToggleGentleReminders: null,
      onPrivacySettings: null,
      onConnectedCaregivers: null,
      onHelpSupport: null,
      onAbout: null,
      onSignOut: null,
    );
  }

  ProfileVM copyWith({bool? gentleReminders}) {
    return ProfileVM(
      name: name,
      roleLabel: roleLabel,
      gentleReminders: gentleReminders ?? this.gentleReminders,
      connectedCaregiversCount: connectedCaregiversCount,
      appVersion: appVersion,
      onEditProfile: onEditProfile,
      onDisplayTextSize: onDisplayTextSize,
      onToggleGentleReminders: onToggleGentleReminders,
      onPrivacySettings: onPrivacySettings,
      onConnectedCaregivers: onConnectedCaregivers,
      onHelpSupport: onHelpSupport,
      onAbout: onAbout,
      onSignOut: onSignOut,
    );
  }
}

/* =========================
   Tokens / UI atoms
   ========================= */

class ProfileTokens {
  // ✅ Mock background = off-white, NOT lavender
  static const Color bg = Color(0xFFF9FAFB);

  static const Color card = Colors.white;
  static const Color border = Color(0xFFE5E7EB);
  static const Color shadow = Color(0x14000000);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color blue = Color(0xFF2F6FED);
  static const Color danger = Color(0xFFEF4444);
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: ProfileTokens.textSecondary,
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProfileTokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ProfileTokens.border),
        boxShadow: const [
          BoxShadow(
            color: ProfileTokens.shadow,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: ProfileTokens.border);
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showChevron = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(icon, color: ProfileTokens.blue, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: ProfileTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: ProfileTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (showChevron)
              const Icon(Icons.chevron_right_rounded, color: ProfileTokens.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Icon(icon, color: ProfileTokens.blue, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: ProfileTokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: ProfileTokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF22C55E),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.name,
    required this.role,
    required this.onEditProfile,
  });

  final String name;
  final String role;
  final VoidCallback? onEditProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: ProfileTokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ProfileTokens.border),
        boxShadow: const [
          BoxShadow(
            color: ProfileTokens.shadow,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: ProfileTokens.blue,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: ProfileTokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: ProfileTokens.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              onPressed: onEditProfile,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: ProfileTokens.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: ProfileTokens.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SignOutCard extends StatelessWidget {
  const _SignOutCard({required this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: ProfileTokens.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ProfileTokens.border),
      ),
      child: SizedBox(
        height: 46,
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.logout_rounded, color: ProfileTokens.danger, size: 18),
          label: const Text(
            "Sign Out",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: ProfileTokens.danger,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFF3D6D6)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
