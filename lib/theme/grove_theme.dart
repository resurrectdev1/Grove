import 'package:flutter/material.dart';

enum GroveThemeMode { forestDark, amoledBlack, materialYou, whiteMinimal }
enum LayoutMode { verticalWheel, horizontalCarousel, compactGrid, compactList }

class GroveTheme {
  final GroveThemeMode mode;
  final ColorScheme?   dynamicScheme;
  final Color?         customAccent;
  const GroveTheme({required this.mode, this.dynamicScheme, this.customAccent});

  Color get bg {
    switch (mode) {
      case GroveThemeMode.forestDark:   return const Color(0xFF0A0F0B);
      case GroveThemeMode.amoledBlack:  return const Color(0xFF000000);
      case GroveThemeMode.whiteMinimal: return const Color(0xFFF5F5F5);
      case GroveThemeMode.materialYou:  return dynamicScheme?.surface ?? const Color(0xFF0A0F0B);
    }
  }

  Color get surface {
    switch (mode) {
      case GroveThemeMode.forestDark:   return const Color(0xFF111A13);
      case GroveThemeMode.amoledBlack:  return const Color(0xFF0A0A0A);
      case GroveThemeMode.whiteMinimal: return const Color(0xFFFFFFFF);
      case GroveThemeMode.materialYou:  return dynamicScheme?.surfaceContainerLow ?? const Color(0xFF111A13);
    }
  }

  Color get surfaceHigh {
    switch (mode) {
      case GroveThemeMode.forestDark:   return const Color(0xFF182117);
      case GroveThemeMode.amoledBlack:  return const Color(0xFF121212);
      case GroveThemeMode.whiteMinimal: return const Color(0xFFE8E8E8);
      case GroveThemeMode.materialYou:  return dynamicScheme?.surfaceContainerHigh ?? const Color(0xFF182117);
    }
  }

  Color get cardBg {
    switch (mode) {
      case GroveThemeMode.forestDark:   return const Color(0xFF0E1610);
      case GroveThemeMode.amoledBlack:  return const Color(0xFF000000);
      case GroveThemeMode.whiteMinimal: return const Color(0xFFFAFAFA);
      case GroveThemeMode.materialYou:  return dynamicScheme?.surfaceContainer ?? const Color(0xFF0E1610);
    }
  }

  Color get primary {
    if (customAccent != null && mode != GroveThemeMode.materialYou) return customAccent!;
    switch (mode) {
      case GroveThemeMode.forestDark:   return const Color(0xFF4E8B5F);
      case GroveThemeMode.amoledBlack:  return const Color(0xFF4E8B5F);
      case GroveThemeMode.whiteMinimal: return const Color(0xFF2E7D4E);
      case GroveThemeMode.materialYou:  return dynamicScheme?.primary ?? const Color(0xFF4E8B5F);
    }
  }

  Color get textPrimary {
    switch (mode) {
      case GroveThemeMode.forestDark:   return const Color(0xFFE0EBE0);
      case GroveThemeMode.amoledBlack:  return const Color(0xFFFFFFFF);
      case GroveThemeMode.whiteMinimal: return const Color(0xFF1A1A1A);
      case GroveThemeMode.materialYou:  return dynamicScheme?.onSurface ?? const Color(0xFFE0EBE0);
    }
  }

  Color get textSecondary {
    switch (mode) {
      case GroveThemeMode.forestDark:   return const Color(0xFF8AA88C);
      case GroveThemeMode.amoledBlack:  return const Color(0xFFAAAAAA);
      case GroveThemeMode.whiteMinimal: return const Color(0xFF666666);
      case GroveThemeMode.materialYou:  return dynamicScheme?.onSurfaceVariant ?? const Color(0xFF8AA88C);
    }
  }

  Color get textMuted {
    switch (mode) {
      case GroveThemeMode.forestDark:   return const Color(0xFF4A5E4C);
      case GroveThemeMode.amoledBlack:  return const Color(0xFF555555);
      case GroveThemeMode.whiteMinimal: return const Color(0xFF999999);
      case GroveThemeMode.materialYou:  return dynamicScheme?.outline ?? const Color(0xFF4A5E4C);
    }
  }

  Brightness get brightness {
    switch (mode) {
      case GroveThemeMode.whiteMinimal: return Brightness.light;
      default:                          return Brightness.dark;
    }
  }

  static const mossGreen  = Color(0xFF4E8B5F);
  static const sageLight  = Color(0xFF7DB08A);
  static const barkBrown  = Color(0xFF7A5C3E);
  static const clayRed    = Color(0xFF9E4C3B);
  static const goldenLich = Color(0xFFB8973A);
  static const dewWhite   = Color(0xFFD4E8D0);
  static const slateGrey  = Color(0xFF6B7A7D);
  static const streakGold = Color(0xFFB8973A);

  static const deepIndigo   = Color(0xFF4A5E9E);
  static const oliveGreen   = Color(0xFF7A9E3B);
  static const terracotta   = Color(0xFFC46A4A);
  static const dustyRose    = Color(0xFFC77B93);
  static const amberBrown   = Color(0xFF8C6239);

  static const List<Color> treePalette = [
    Color(0xFF9E4C3B), Color(0xFFC46A4A), Color(0xFFB87C3A),
    Color(0xFF8C6239), Color(0xFFB8973A), Color(0xFF7A9E3B),
    Color(0xFF4E8B5F), Color(0xFF4E8B7A), Color(0xFF6B7A7D),
    Color(0xFF42A5C8), Color(0xFF4A5E9E), Color(0xFF8B5E9E),
    Color(0xFF9E3B6B), Color(0xFFC77B93),
  ];
}
