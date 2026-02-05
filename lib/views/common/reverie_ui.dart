import 'package:flutter/material.dart';

class Rv {
  static const bg = Color(0xFFF6F7FB);
  static const card = Colors.white;
  static const primary = Color(0xFF2563FF);

  static const text = Color(0xFF0F172A);
  static const subtext = Color(0xFF64748B);

  static const chipBg = Color(0xFFEFF4FF);
  static const chipGray = Color(0xFFF1F5F9);

  static BorderRadius radius([double r = 20]) => BorderRadius.circular(r);

  static BoxDecoration cardDeco() => BoxDecoration(
        color: card,
        borderRadius: radius(),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 18,
            offset: Offset(0, 10),
          )
        ],
      );
}
