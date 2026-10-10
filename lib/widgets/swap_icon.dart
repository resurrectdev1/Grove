import 'package:flutter/widgets.dart';
import 'package:grove/theme/motion.dart';

class SwapIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const SwapIcon(this.icon, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: Motion.base,
    switchInCurve: Motion.standard,
    switchOutCurve: Motion.exit,
    transitionBuilder: (child, anim) => ScaleTransition(
      scale: anim,
      child: FadeTransition(opacity: anim, child: child),
    ),
    child: Icon(icon, key: ValueKey(icon), size: size, color: color),
  );
}
