import 'package:flutter/material.dart';

class AuthUI {
  static const Color primaryBlue = Color(0xFF2663EB);

  static TextStyle title = const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: Colors.black,
  );

  static TextStyle subtitle = TextStyle(
    fontSize: 14,
    height: 1.3,
    color: Colors.grey.shade500,
    fontWeight: FontWeight.w500,
  );

  static TextStyle label = TextStyle(
    fontSize: 13,
    color: Colors.grey.shade700,
    fontWeight: FontWeight.w600,
  );

  static InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  static ButtonStyle primaryButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
