import 'package:flutter/material.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/next_session_card.dart';
import '../widgets/section_title.dart';
import 'notifications_screen.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key, this.onNav});

  final void Function(int index)? onNav;

  // === ReVerie UI Tokens (LOCAL, no main.dart/theme dependency) ===
  // Use this SAME color in Activities / History / Profile to match mockup.
  static const Color pageBg = Color(0xFFF9FAFB); // soft off-white like mock cards background

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color blue = Color(0xFF2F6FED);
  static const Color blue2 = Color(0xFF4A8DFF);

  static const Color cardBlue = Color(0xFFEAF1FF); // top quick cards
  static const Color iconBubble = Color(0xFFF3F4F6); // mini card icon bubble
  static const Color border = Color(0xFFE5E7EB);

  static const Color shadow = Color(0x14000000);

  @override
  Widget build(BuildContext context) {
    // Dummy data (backend-ready later)
    const doctorName = "Dr. Sarah Chen";
    const doctorRole = "Psychiatrist";
    const nextSessionDate = "15/03/2025";
    const lastSessionTitle = "Family Gathering 2025";
    const hasUnreadNotifications = true;

    return ColoredBox(
      color: pageBg, // ✅ shared background token
      child: Scaffold(
        backgroundColor: Colors.transparent, // ✅ prevents Material3 surface tint
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Header =====
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Welcome back",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "How are you feeling today?",
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bell
                    Stack(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                            );
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: border),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Icon(Icons.notifications_none_rounded, color: textPrimary),
                          ),
                        ),
                        if (hasUnreadNotifications)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ===== Top quick cards =====
                Row(
                  children: const [
                    Expanded(
                      child: QuickActionCard(
                        backgroundColor: cardBlue,
                        icon: Icons.person_outline_rounded,
                        title: "Dr. Sarah Chen",
                        subtitle: "Your doctor",
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: QuickActionCard(
                        backgroundColor: cardBlue,
                        icon: Icons.description_outlined,
                        title: "MMSE Checkup",
                        subtitle: "Assessment",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ===== Start VR CTA =====
                _StartVrCard(
                  onTap: () {
                    // TODO PR05/SR05-SR08
                  },
                ),

                const SizedBox(height: 16),

                // ===== Mini cards row (switch tabs, no routes) =====
                Row(
                  children: [
                    Expanded(
                      child: _MiniCard(
                        icon: Icons.description_outlined,
                        title: "Activities",
                        subtitle: "Recommended",
                        subtitleBlueUnderline: true,
                        onTap: () => onNav?.call(2),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _MiniCard(
                        icon: Icons.description_outlined,
                        title: "History",
                        subtitle: "All sessions",
                        onTap: () => onNav?.call(1),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _MiniCard(
                        icon: Icons.person_outline_rounded,
                        title: "Profile",
                        subtitle: "",
                        onTap: () => onNav?.call(3),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ===== Next session header =====
                Row(
                  children: const [
                    Expanded(child: SectionTitle(title: "NEXT SESSION")),
                    Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                NextSessionCard(
                  date: nextSessionDate,
                  doctorName: doctorName,
                  doctorRole: doctorRole,
                  onTap: () {
                    // TODO PR08/SR13
                  },
                ),

                const SizedBox(height: 18),

                // ===== Last session header =====
                Row(
                  children: const [
                    Expanded(child: SectionTitle(title: "LAST SESSION")),
                    Text(
                      "1w ago",
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                _LastSessionCard(
                  title: lastSessionTitle,
                  onTap: () {
                    // TODO SR09/PR06
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StartVrCard extends StatelessWidget {
  const _StartVrCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [PatientHomeScreen.blue2, PatientHomeScreen.blue],
          ),
          boxShadow: const [
            BoxShadow(
              color: PatientHomeScreen.shadow,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Start VR Session",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Create a new memory experience",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xE6FFFFFF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.subtitleBlueUnderline = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool subtitleBlueUnderline;

  @override
  Widget build(BuildContext context) {
    // Lock text scaling to match mockup.
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 100),
          child: Ink(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white, // ✅ cards sit on pageBg
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: PatientHomeScreen.border),
              boxShadow: const [
                BoxShadow(
                  color: PatientHomeScreen.shadow,
                  blurRadius: 14,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: PatientHomeScreen.iconBubble,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Icon(icon, color: PatientHomeScreen.textSecondary, size: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: PatientHomeScreen.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      color: subtitleBlueUnderline
                          ? PatientHomeScreen.blue
                          : PatientHomeScreen.textSecondary,
                      decoration:
                          subtitleBlueUnderline ? TextDecoration.underline : TextDecoration.none,
                      decorationThickness: 1.2,
                    ),
                  )
                else
                  const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LastSessionCard extends StatelessWidget {
  const _LastSessionCard({required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PatientHomeScreen.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: PatientHomeScreen.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}
