import 'package:flutter/material.dart';
import '../common/reverie_ui.dart';

class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Rv.bg,
      padding: const EdgeInsets.all(18),
      child: const Center(child: Text("Profile (coming next)")),
    );
  }
}
