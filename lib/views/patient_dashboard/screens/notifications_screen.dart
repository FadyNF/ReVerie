import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  // Keep tokens local so we don't touch global theme/main.dart
  static const Color bg = Colors.white; // ✅ mock is basically white
  static const Color card = Colors.white;
  static const Color border = Color(0xFFE5E7EB);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  // Subtle shadow like Figma (Android loves to overdo it)
  static const Color shadow = Color(0x0F000000);

  @override
  Widget build(BuildContext context) {
    final items = <NotificationItem>[
      NotificationItem(
        icon: Icons.check_circle_outline_rounded,
        iconBg: const Color(0xFFE9F9EE),
        iconColor: const Color(0xFF22C55E),
        title: "Session Confirmed",
        message: "Your appointment with Dr. Sarah Chen on\n15/03/2026 has been confirmed.",
        timeAgo: "2 hours ago",
        isUnread: true,
      ),
      NotificationItem(
        icon: Icons.auto_awesome_rounded,
        iconBg: const Color(0xFFF2E8FF),
        iconColor: const Color(0xFF7C3AED),
        title: "New VR Experience",
        message: "Available now — “Ocean Serenity” VR\nexperience added for relaxation.",
        timeAgo: "5 hours ago",
        isUnread: true,
      ),
      NotificationItem(
        icon: Icons.system_update_alt_rounded,
        iconBg: const Color(0xFFEAF1FF),
        iconColor: const Color(0xFF2F6FED),
        title: "App Update",
        message: "Version 2.1 is now available with improved\nsession tracking and new features.",
        timeAgo: "1 day ago",
        isUnread: false,
      ),
      NotificationItem(
        icon: Icons.notifications_none_rounded,
        iconBg: const Color(0xFFFFF3E6),
        iconColor: const Color(0xFFF97316),
        title: "Reminder",
        message: "You have completed 5 sessions this month.\nKeep going 💙",
        timeAgo: "2 days ago",
        isUnread: false,
      ),
      NotificationItem(
        icon: Icons.description_outlined,
        iconBg: const Color(0xFFEAF1FF),
        iconColor: const Color(0xFF2F6FED),
        title: "Weekly Report Ready",
        message: "Your weekly progress report is ready to\nview.",
        timeAgo: "3 days ago",
        isUnread: false,
      ),
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        surfaceTintColor: bg,
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          // ✅ match mock spacing (tighter than what you had)
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, i) => _NotificationCard(item: items[i]),
        ),
      ),
    );
  }
}

class NotificationItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String message;
  final String timeAgo;
  final bool isUnread;

  NotificationItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.timeAgo,
    required this.isUnread,
  });
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});
  final NotificationItem item;

  static const Color card = Colors.white;
  static const Color border = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color shadow = Color(0x0F000000);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {},
      child: Ink(
        padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border),
          boxShadow: const [
            BoxShadow(
              color: shadow,
              blurRadius: 16,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        item.timeAgo,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.message,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (item.isUnread)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2E8FF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            "Unread",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                      const Spacer(),
                      const Icon(Icons.chevron_right_rounded, color: textSecondary),
                    ],
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
