import 'package:flutter/material.dart';

enum GroveThemeMode { forestDark, amoledBlack, whiteMinimal }

enum LayoutMode { verticalWheel, horizontalCarousel, compactGrid, compactList }

class GroveTheme {
  final GroveThemeMode mode;

  final bool materialYou;
  final ColorScheme? dynamicLight;
  final ColorScheme? dynamicDark;
  final Color? customAccent;
  const GroveTheme({
    required this.mode,
    this.materialYou = false,
    this.dynamicLight,
    this.dynamicDark,
    this.customAccent,
  });

  ColorScheme? get _dyn {
    if (!materialYou) return null;
    return brightness == Brightness.light ? dynamicLight : dynamicDark;
  }

  bool get _dynSurfaces => _dyn != null && mode != GroveThemeMode.amoledBlack;

  Color get bg {
    if (_dynSurfaces) return _dyn!.surface;
    switch (mode) {
      case GroveThemeMode.forestDark:
        return const Color(0xFF0A0F0B);
      case GroveThemeMode.amoledBlack:
        return const Color(0xFF000000);
      case GroveThemeMode.whiteMinimal:
        return const Color(0xFFF5F5F5);
    }
  }

  Color get surface {
    if (_dynSurfaces) return _dyn!.surfaceContainerLow;
    switch (mode) {
      case GroveThemeMode.forestDark:
        return const Color(0xFF111A13);
      case GroveThemeMode.amoledBlack:
        return const Color(0xFF0A0A0A);
      case GroveThemeMode.whiteMinimal:
        return const Color(0xFFFFFFFF);
    }
  }

  Color get surfaceHigh {
    if (_dynSurfaces) return _dyn!.surfaceContainerHigh;
    switch (mode) {
      case GroveThemeMode.forestDark:
        return const Color(0xFF182117);
      case GroveThemeMode.amoledBlack:
        return const Color(0xFF121212);
      case GroveThemeMode.whiteMinimal:
        return const Color(0xFFE8E8E8);
    }
  }

  Color get cardBg {
    if (_dynSurfaces) return _dyn!.surfaceContainer;
    switch (mode) {
      case GroveThemeMode.forestDark:
        return const Color(0xFF0E1610);
      case GroveThemeMode.amoledBlack:
        return const Color(0xFF000000);
      case GroveThemeMode.whiteMinimal:
        return const Color(0xFFFAFAFA);
    }
  }

  Color get primary {
    if (_dyn != null) return _dyn!.primary;
    if (customAccent != null) return customAccent!;
    switch (mode) {
      case GroveThemeMode.forestDark:
      case GroveThemeMode.amoledBlack:
        return const Color(0xFF4E8B5F);
      case GroveThemeMode.whiteMinimal:
        return const Color(0xFF2E7D4E);
    }
  }

  Color get textPrimary {
    if (_dynSurfaces) return _dyn!.onSurface;
    switch (mode) {
      case GroveThemeMode.forestDark:
        return const Color(0xFFE0EBE0);
      case GroveThemeMode.amoledBlack:
        return const Color(0xFFFFFFFF);
      case GroveThemeMode.whiteMinimal:
        return const Color(0xFF1A1A1A);
    }
  }

  Color get textSecondary {
    if (_dynSurfaces) return _dyn!.onSurfaceVariant;
    switch (mode) {
      case GroveThemeMode.forestDark:
        return const Color(0xFF8AA88C);
      case GroveThemeMode.amoledBlack:
        return const Color(0xFFAAAAAA);
      case GroveThemeMode.whiteMinimal:
        return const Color(0xFF666666);
    }
  }

  Color get textMuted {
    if (_dynSurfaces) return _dyn!.outline;
    switch (mode) {
      case GroveThemeMode.forestDark:
        return const Color(0xFF4A5E4C);
      case GroveThemeMode.amoledBlack:
        return const Color(0xFF555555);
      case GroveThemeMode.whiteMinimal:
        return const Color(0xFF999999);
    }
  }

  Brightness get brightness {
    switch (mode) {
      case GroveThemeMode.whiteMinimal:
        return Brightness.light;
      default:
        return Brightness.dark;
    }
  }

  static const mossGreen = Color(0xFF4E8B5F);
  static const sageLight = Color(0xFF7DB08A);
  static const barkBrown = Color(0xFF7A5C3E);
  static const clayRed = Color(0xFF9E4C3B);
  static const goldenLich = Color(0xFFB8973A);
  static const dewWhite = Color(0xFFD4E8D0);
  static const slateGrey = Color(0xFF6B7A7D);
  static const streakGold = Color(0xFFB8973A);

  static const deepIndigo = Color(0xFF4A5E9E);
  static const oliveGreen = Color(0xFF7A9E3B);
  static const terracotta = Color(0xFFC46A4A);
  static const dustyRose = Color(0xFFC77B93);
  static const amberBrown = Color(0xFF8C6239);

  static const List<Color> treePalette = [
    Color(0xFF9E4C3B),
    Color(0xFFC46A4A),
    Color(0xFFB87C3A),
    Color(0xFF8C6239),
    Color(0xFFB8973A),
    Color(0xFF7A9E3B),
    Color(0xFF4E8B5F),
    Color(0xFF4E8B7A),
    Color(0xFF6B7A7D),
    Color(0xFF42A5C8),
    Color(0xFF4A5E9E),
    Color(0xFF8B5E9E),
    Color(0xFF9E3B6B),
    Color(0xFFC77B93),
  ];
}
