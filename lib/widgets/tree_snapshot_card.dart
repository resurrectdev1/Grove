import 'package:flutter/material.dart';
import 'package:grove/models/grove_models.dart';
import 'package:grove/painters/fractal_tree_painter.dart';
import 'package:grove/theme/grove_theme.dart';

class TreeSnapshotCard extends StatelessWidget {
  final HabitTree habit;
  final GroveTheme theme;

  static const double width = 360;
  static const double height = 640;

  const TreeSnapshotCard({super.key, required this.habit, required this.theme});

  @override
  Widget build(BuildContext context) {
    final streak = habit.daysElapsed;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.bg,
            Color.lerp(theme.bg, habit.color, 0.16) ?? theme.bg,
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 28),
          Text(
            'GROVE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 3.0,
              color: theme.textMuted,
            ),
          ),
          const Spacer(flex: 3),
          SizedBox(
            width: width * 0.72,
            height: width * 0.72,
            child: CustomPaint(
              painter: FractalTreePainter(
                stage: habit.stage,
                baseColor: habit.color,
                progress: habit.stageProgress,
                windPhase: 0,
                daysElapsed: habit.daysElapsed,
                geneticSeed: habit.geneticSeed,
                burstProgress: 0,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            habit.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stageLabel(habit.stage),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
              color: habit.color,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '$streak',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w800,
              height: 1.0,
              color: theme.textPrimary,
            ),
          ),
          Text(
            streak == 1 ? 'DAY' : 'DAYS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.0,
              color: theme.textSecondary,
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}
