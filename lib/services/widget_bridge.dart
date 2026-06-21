import 'package:grove/models/grove_models.dart';
import 'package:grove/painters/fractal_tree_painter.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GroveWidgetBridge {
  GroveWidgetBridge._();
  static final GroveWidgetBridge instance = GroveWidgetBridge._();

  static const _channel = MethodChannel('com.grove.app/widgets');

  Future<void> renderAndUpdate(List<HabitTree> habits) async {
    try {
      final filesDir = await _channel.invokeMethod<String>('getFilesDir');
      if (filesDir != null) {
        for (final habit in habits) {
          try {
            final bytes = await _renderHabit(habit);
            if (bytes == null) continue;

            await _channel.invokeMethod<void>('saveTreeImage', {
              'habitId': habit.id,
              'bytes':   bytes,
            });
          } catch (e) {
            debugPrint('GroveWidgetBridge: failed to render habit ${habit.id}: $e');
          }
        }
      }
    } on MissingPluginException {
    } catch (e) {
      debugPrint('GroveWidgetBridge.renderAndUpdate error: $e');
    }

    await requestUpdate();
  }

  Future<void> requestUpdate() async {
    try {
      await _channel.invokeMethod<void>('updateWidgets');
    } on MissingPluginException {

    } catch (e) {
      debugPrint('GroveWidgetBridge.requestUpdate error: $e');
    }
  }

  Future<Uint8List?> _renderHabit(HabitTree habit) async {
    try {
      const size = Size(400, 400);

      final recorder = ui.PictureRecorder();
      final canvas   = Canvas(recorder, Offset.zero & size);

      final painter = FractalTreePainter(
        stage:       habit.stage,
        baseColor:   habit.color,
        progress:    habit.stageProgress,
        windPhase:   0,
        daysElapsed: habit.daysElapsed,
        geneticSeed: habit.geneticSeed,
      );

      painter.paint(canvas, size);

      final picture  = recorder.endRecording();
      final image    = await picture.toImage(size.width.toInt(), size.height.toInt());
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('GroveWidgetBridge._renderHabit(${habit.id}) error: $e');
      return null;
    }
  }
}
