import 'package:flutter/material.dart';
import '../common/reverie_ui.dart';

class SessionsPlaceholderScreen extends StatelessWidget {
  const SessionsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Rv.bg,
      padding: const EdgeInsets.all(18),
      child: const Center(child: Text("Sessions (coming next)")),
    );
  }
}
