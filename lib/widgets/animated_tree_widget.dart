import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:grove/models/grove_models.dart';
import 'package:grove/painters/fractal_tree_painter.dart';

class AnimatedTreeWidget extends StatefulWidget {
  final HabitTree habit;
  const AnimatedTreeWidget({super.key, required this.habit});
  @override State<AnimatedTreeWidget> createState() => _AnimatedTreeWidgetState();
}

class _AnimatedTreeWidgetState extends State<AnimatedTreeWidget>
with SingleTickerProviderStateMixin {
  late AnimationController _windController;

  @override
  void initState() {
    super.initState();
    _windController = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
  }

  @override
  void dispose() { _windController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _windController,
    builder: (_, _) => CustomPaint(
      painter: FractalTreePainter(
        stage:       widget.habit.stage,
        baseColor:   widget.habit.color,
        progress:    widget.habit.stageProgress,
        windPhase:   _windController.value * 2 * math.pi,
        daysElapsed: widget.habit.daysElapsed,
        geneticSeed: widget.habit.geneticSeed,
        shadowStage: widget.habit.shadowStage,
      ),
    ),
  );
}
