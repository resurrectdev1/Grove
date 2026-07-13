import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:grove/models/grove_models.dart';
import 'package:grove/painters/fractal_tree_painter.dart';

class AnimatedTreeWidget extends StatefulWidget {
  final HabitTree habit;
  const AnimatedTreeWidget({super.key, required this.habit});
  @override
  State<AnimatedTreeWidget> createState() => _AnimatedTreeWidgetState();
}

class _AnimatedTreeWidgetState extends State<AnimatedTreeWidget>
    with TickerProviderStateMixin {
  late AnimationController _windController;
  late AnimationController _burstController;
  late GrowthStage _lastStage;

  @override
  void initState() {
    super.initState();
    _lastStage = widget.habit.stage;
    _windController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _burstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
  }

  @override
  void didUpdateWidget(AnimatedTreeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newStage = widget.habit.stage;
    if (newStage != _lastStage && newStage.index > _lastStage.index) {
      _burstController.forward(from: 0);
    }
    _lastStage = newStage;
  }

  @override
  void dispose() {
    _windController.dispose();
    _burstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([_windController, _burstController]),
    builder: (_, _) => CustomPaint(
      painter: FractalTreePainter(
        stage: widget.habit.stage,
        baseColor: widget.habit.color,
        progress: widget.habit.stageProgress,
        windPhase: _windController.value * 2 * math.pi,
        daysElapsed: widget.habit.daysElapsed,
        geneticSeed: widget.habit.geneticSeed,
        burstProgress: _burstController.value,
      ),
    ),
  );
}
