import 'package:flutter/material.dart';

class SessionHistoryScreen extends StatelessWidget {
  const SessionHistoryScreen({super.key, this.onBackToHome});

  /// When used inside PatientShell, pass:
  /// onBackToHome: () => setState(() => _index = 0)
  final VoidCallback? onBackToHome;

  // === Local tokens (NO main.dart edits) ===
  // Mock base is NOT pure white — it’s a soft off-white.
  static const Color bg = Color(0xFFF9FAFB);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  // Segmented control
  static const Color pillBg = Color(0xFFF3F4F6);
  static const Color pillSelectedBg = Color(0xFF2F6FED);
  static const Color pillSelectedText = Color(0xFFFFFFFF);
  static const Color pillText = Color(0xFF111827);

  static const Color tagBlueBg = Color(0xFFEAF1FF);
  static const Color tagBlueText = Color(0xFF2F6FED);

  static const Color tagGreenBg = Color(0xFFE9F9EE);
  static const Color tagGreenText = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    // Backend-ready dummy data (replace later with provider/Supabase)
    final items = <HistoryItem>[
      HistoryItem(
        title: "Family Gathering 2025",
        type: HistoryType.vr,
        subtitleTop: "Yesterday at 2:15 PM",
        subtitleBottom: "15 min  •  Calm",
      ),
      HistoryItem(
        title: "Memory Recall",
        type: HistoryType.activity,
        subtitleTop: "Jan 19, 2026",
        subtitleBottom: "10 min  •  Neutral",
      ),
    ];

    return DefaultTabController(
      length: 3,
      child: ColoredBox(
        color: bg, // ✅ forces the real background color behind everything
        child: Scaffold(
          backgroundColor: Colors.transparent, // ✅ avoid theme tint fighting us
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: textPrimary,
                size: 20,
              ),
              onPressed: () {
                if (onBackToHome != null) return onBackToHome!.call();
                Navigator.of(context).maybePop();
              },
            ),
            title: const Text(
              "Session History",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
            centerTitle: true,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: _HistoryTabs(),
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _HistoryList(items: items), // All
                _HistoryList(items: items.where((e) => e.type == HistoryType.vr).toList()),
                _HistoryList(items: items.where((e) => e.type == HistoryType.activity).toList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryTabs extends StatelessWidget {
  const _HistoryTabs();

  static const Color pillBg = Color(0xFFF3F4F6);
  static const Color pillSelectedBg = Color(0xFF2F6FED);
  static const Color pillSelectedText = Color(0xFFFFFFFF);
  static const Color pillText = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: pillBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: TabBar(
        // ✅ makes the blue indicator fit inside the grey pill (no weird fat blob)
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        labelPadding: EdgeInsets.zero,

        indicator: BoxDecoration(
          color: pillSelectedBg,
          borderRadius: BorderRadius.circular(999),
        ),
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),

        labelColor: pillSelectedText,
        unselectedLabelColor: pillText.withOpacity(0.65),
        labelStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
        unselectedLabelStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),

        tabs: const [
          Tab(text: "All"),
          Tab(text: "VR Sessions"),
          Tab(text: "Activities"),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.items});
  final List<HistoryItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          "No items yet",
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _HistoryTile(
        item: items[i],
        onTap: () {
          // TODO PR06
        },
      ),
    );
  }
}

// =====================
// Models (backend-ready)
// =====================
enum HistoryType { vr, activity }

class HistoryItem {
  final String title;
  final HistoryType type;
  final String subtitleTop;
  final String subtitleBottom;

  // Later:
  // final DateTime createdAt;
  // final String? sessionId;
  // final String? notesPreview;

  HistoryItem({
    required this.title,
    required this.type,
    required this.subtitleTop,
    required this.subtitleBottom,
  });
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.item, required this.onTap});
  final HistoryItem item;
  final VoidCallback onTap;

  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color tagBlueBg = Color(0xFFEAF1FF);
  static const Color tagBlueText = Color(0xFF2F6FED);

  static const Color tagGreenBg = Color(0xFFE9F9EE);
  static const Color tagGreenText = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    final isVr = item.type == HistoryType.vr;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _Tag(
                  label: isVr ? "VR" : "Activity",
                  bg: isVr ? tagBlueBg : tagGreenBg,
                  fg: isVr ? tagBlueText : tagGreenText,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item.subtitleTop,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.subtitleBottom,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }
}
