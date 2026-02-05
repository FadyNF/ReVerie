import 'package:flutter/material.dart';

/// Activities (Patient) — UI only
/// Matches mock:
/// - Off-white background (NOT lavender)
/// - Scrollable "tiny bit long"
/// - Two sections: Recommended + Other Activities
/// - Recommended cards include a big "Start Activity" button
/// - Backend-ready via ActivityItem lists (swap with provider/Supabase later)
class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key, this.onBackToHome});

  /// When used inside PatientShell, pass:
  /// onBackToHome: () => setState(() => _index = 0)
  final VoidCallback? onBackToHome;

  // ===== Tokens (local, no theme dependency) =====
  static const Color bg = Color(0xFFF9FAFB); // soft off-white like mock
  static const Color card = Colors.white;
  static const Color border = Color(0xFFE5E7EB);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  static const Color blue = Color(0xFF2F6FED);

  static const Color shadow = Color(0x14000000);

  @override
  Widget build(BuildContext context) {
    // Backend-ready dummy data
    final recommended = <ActivityItem>[
      ActivityItem(
        title: "Name Recognition",
        description: "Practice recognizing familiar faces",
        durationLabel: "5–10 min",
        isRecommended: true,
      ),
      ActivityItem(
        title: "Memory Recall",
        description: "Remember and share a favorite moment",
        durationLabel: "10–15 min",
        isRecommended: true,
      ),
    ];

    final other = <ActivityItem>[
      ActivityItem(
        title: "Gentle Movement",
        description: "Simple guided movements",
        durationLabel: "5 min",
      ),
      ActivityItem(
        title: "Storytelling",
        description: "Share stories from photos",
        durationLabel: "15–20 min",
      ),
    ];

    return ColoredBox(
      color: bg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary, size: 20),
            onPressed: () {
              if (onBackToHome != null) return onBackToHome!.call();
              Navigator.of(context).maybePop();
            },
          ),
          title: const Text(
            "Activities",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
            children: [
              const _SectionHeader("RECOMMENDED FOR YOU"),
              const SizedBox(height: 10),
              ...recommended.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ActivityCard(
                    item: a,
                    onStart: () {
                      // TODO PR07: launch activity flow
                      // e.g. Navigator.push(...)
                    },
                    onTap: () {
                      // optional: open details
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const _SectionHeader("OTHER ACTIVITIES"),
              const SizedBox(height: 10),
              ...other.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ActivityCard(
                    item: a,
                    onStart: null, // 👈 no button for "other" in mock
                    onTap: () {
                      // optional: open details
                    },
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

// =====================
// Model (backend-ready)
// =====================
class ActivityItem {
  final String title;
  final String description;
  final String durationLabel;
  final bool isRecommended;

  // Later you can add:
  // final String id;
  // final String type;
  // final int difficulty;
  // final String? assetUrl;

  ActivityItem({
    required this.title,
    required this.description,
    required this.durationLabel,
    this.isRecommended = false,
  });
}

// =====================
// UI bits
// =====================
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);
  final String text;

  static const Color textMuted = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
        color: textMuted,
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.item,
    required this.onTap,
    required this.onStart,
  });

  final ActivityItem item;
  final VoidCallback? onTap;
  final VoidCallback? onStart;

  static const Color card = Colors.white;
  static const Color border = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color blue = Color(0xFF2F6FED);
  static const Color shadow = Color(0x14000000);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
          boxShadow: const [
            BoxShadow(
              color: shadow,
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w900,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.description,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.durationLabel,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: textSecondary,
              ),
            ),

            if (onStart != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: FilledButton(
                  onPressed: onStart,
                  style: FilledButton.styleFrom(
                    backgroundColor: blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Start Activity",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
