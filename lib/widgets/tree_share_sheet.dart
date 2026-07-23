import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:grove/models/grove_models.dart';
import 'package:grove/theme/grove_theme.dart';
import 'package:grove/widgets/tree_snapshot_card.dart';

Future<void> showTreeShareSheet(
  BuildContext context, {
  required HabitTree habit,
  required GroveTheme theme,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _TreeShareSheet(habit: habit, theme: theme),
  );
}

class _TreeShareSheet extends StatefulWidget {
  final HabitTree habit;
  final GroveTheme theme;
  const _TreeShareSheet({required this.habit, required this.theme});

  @override
  State<_TreeShareSheet> createState() => _TreeShareSheetState();
}

class _TreeShareSheetState extends State<_TreeShareSheet> {
  final GlobalKey _captureKey = GlobalKey();
  bool _busy = false;

  Future<Uint8List?> _capturePng() async {
    try {
      await WidgetsBinding.instance.endOfFrame;
      final boundary =
          _captureKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  Future<void> _share() async {
    setState(() => _busy = true);
    final bytes = await _capturePng();
    if (!mounted) return;
    setState(() => _busy = false);
    if (bytes == null) {
      _showError();
      return;
    }
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/grove_${widget.habit.id}_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes);
    if (!mounted) return;
    unawaited(HapticFeedback.lightImpact());
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: '${widget.habit.name} - ${widget.habit.daysElapsed} days 🌱',
      ),
    );
  }

  Future<void> _saveAsFile() async {
    setState(() => _busy = true);
    final bytes = await _capturePng();
    if (!mounted) return;
    setState(() => _busy = false);
    if (bytes == null) {
      _showError();
      return;
    }
    final safeName = widget.habit.name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    final fileName =
        'Grove_${safeName}_${DateFormat("yyyy-MM-dd").format(DateTime.now())}.png';
    final outputPath = await FilePicker.saveFile(
      dialogTitle: 'Save Tree Snapshot',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['png'],
      bytes: bytes,
    );
    if (outputPath != null &&
        !kIsWeb &&
        !Platform.isAndroid &&
        !Platform.isIOS) {
      await File(outputPath).writeAsBytes(bytes);
    }
    if (!mounted) return;
    unawaited(HapticFeedback.lightImpact());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✓ Snapshot saved'),
        backgroundColor: widget.theme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Could not create snapshot'),
        backgroundColor: GroveTheme.clayRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Your Tree',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: RepaintBoundary(
                key: _captureKey,
                child: TreeSnapshotCard(habit: widget.habit, theme: theme),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _busy ? null : _saveAsFile,
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text('Save'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.textPrimary,
                      side: BorderSide(
                        color: theme.textMuted.withValues(alpha: 0.4),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _busy ? null : _share,
                    icon: _busy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.ios_share_rounded, size: 18),
                    label: const Text('Share'),
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.habit.color,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
