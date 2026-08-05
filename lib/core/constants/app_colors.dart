import 'package:flutter/material.dart';

/// AppColors defines the Apple-inspired, premium dark and light theme palettes
/// for Second Brain AI. Minimal, calm, elegant, zero clutter.
class AppColors {
  AppColors._();

  // Dark Theme Palette (Primary UI)
  static const Color darkBackground = Color(0xFF0D0F12);
  static const Color darkSurface = Color(0xFF161920);
  static const Color darkSurfaceCard = Color(0xFF1E222D);
  static const Color darkGlassBorder = Color(0xFF2C3242);
  
  // Accent & Brand Colors
  static const Color primaryAccent = Color(0xFF6366F1); // Indigo / Violet
  static const Color primaryGlow = Color(0xFF818CF8);
  static const Color micRecording = Color(0xFFFF453A); // Apple Red
  static const Color micRecordingGlow = Color(0xFFFF6961);
  
  // Semantic Colors
  static const Color priorityHigh = Color(0xFFFF453A);
  static const Color priorityMedium = Color(0xFFFF9F0A);
  static const Color priorityLow = Color(0xFF30D158);
  
  // Category Accents
  static const Color categoryTask = Color(0xFF6366F1);
  static const Color categoryMeeting = Color(0xFF0A84FF);
  static const Color categoryIdea = Color(0xFFBF5AF2);
  static const Color categoryDecision = Color(0xFFFF9F0A);
  
  // Text Colors
  static const Color textPrimaryDark = Color(0xFFF3F4F6);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textMutedDark = Color(0xFF6B7280);

  // Gradient Overlays
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient micGradient = LinearGradient(
    colors: [Color(0xFFFF453A), Color(0xFFFF7A00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
