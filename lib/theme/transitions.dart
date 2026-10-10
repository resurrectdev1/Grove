import 'package:flutter/material.dart';
import 'package:grove/theme/motion.dart';

class GroveRoute<T> extends PageRouteBuilder<T> {
  GroveRoute({required WidgetBuilder builder, super.settings})
    : super(
        pageBuilder: (context, _, _) => builder(context),
        transitionDuration: Motion.emphasized,
        reverseTransitionDuration: Motion.emphasizedReverse,
        transitionsBuilder: _transition,
      );

  static Widget _transition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final closing = animation.status == AnimationStatus.reverse;
    final t = animation.drive(
      CurveTween(curve: closing ? Motion.exit : Motion.standard),
    );
    return FadeTransition(
      opacity: t,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.97, end: 1).animate(t),
        child: child,
      ),
    );
  }
}

Future<T?> showGroveDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) => showDialog<T>(
  context: context,
  barrierDismissible: barrierDismissible,
  animationStyle: Motion.dialog,
  builder: (ctx) => _DialogPopIn(child: builder(ctx)),
);

class _DialogPopIn extends StatelessWidget {
  final Widget child;
  const _DialogPopIn({required this.child});

  @override
  Widget build(BuildContext context) {
    final animation = ModalRoute.of(context)?.animation;
    if (animation == null) return child;
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.94,
        end: 1,
      ).chain(CurveTween(curve: Motion.standard)).animate(animation),
      child: child,
    );
  }
}
