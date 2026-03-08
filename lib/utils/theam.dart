import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2539A4);
  static const Color secondary = Color(0xFF1E2939);
  static const Color accent = Color(0xFF2B45C4);
  static const Color background = Colors.white;
  static const Color textBody = Colors.black;
  static const Color textSecondary = Color(0xFF717171);

  static const Color primaryText = Color(0xFF1E2939);
  static const Color bodyText = Color(0xFF4B5563);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFE5E7EB);
  static const Color successGreen = Color(0xFF10B981);
  static const Color surfaceWhite = Colors.white;

  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment(0.01, 0.50),
    end: Alignment(0.75, 0.50),
    colors: [Color(0xFF1A2475), Color(0xFF2B45C4)],
  );
}
