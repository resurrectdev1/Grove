import 'package:flutter/animation.dart';

abstract final class Motion {
  static const Duration fast = Duration(milliseconds: 140);

  static const Duration base = Duration(milliseconds: 220);

  static const Duration slow = Duration(milliseconds: 300);

  static const Duration drawerClose = Duration(milliseconds: 200);

  static const Duration emphasized = Duration(milliseconds: 380);
  static const Duration emphasizedReverse = Duration(milliseconds: 250);

  static const Curve standard = Curves.easeOutCubic;

  static const Curve exit = Curves.easeInCubic;

  static const AnimationStyle sheet = AnimationStyle(
    duration: slow,
    reverseDuration: drawerClose,
    curve: standard,
    reverseCurve: exit,
  );

  static const AnimationStyle dialog = AnimationStyle(
    duration: base,
    reverseDuration: fast,
  );
}
