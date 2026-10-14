import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:grove/l10n/app_localizations.dart';
import 'package:grove/providers/grove_settings.dart';

class CheckInEditDialog extends StatefulWidget {
  final DateTime day;
  final bool isExcused;
  final DateTime initialTime;
  final String initialNote;
  final Color accent;
  final void Function(TimeOfDay time, String note) onSave;

  const CheckInEditDialog({
    super.key,
    required this.day,
    required this.isExcused,
    required this.initialTime,
    required this.initialNote,
    required this.accent,
    required this.onSave,
  });

  @override
  State<CheckInEditDialog> createState() => _CheckInEditDialogState();
}

class _CheckInEditDialogState extends State<CheckInEditDialog> {
  late final TextEditingController _ctrl;
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialNote);
    _time = TimeOfDay.fromDateTime(widget.initialTime);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<GroveSettings>().theme;
    final l10n = AppLocalizations.of(context);
    final labelStyle = TextStyle(
      color: theme.textMuted,
      fontSize: 11,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w600,
    );
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: theme.surfaceHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.updateLog,
              style: TextStyle(
                color: theme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('EEEE, MMMM d, yyyy').format(widget.day),
              style: TextStyle(
                color: widget.isExcused
                    ? const Color(0xFF42A5C8)
                    : widget.accent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            if (!widget.isExcused) ...[
              Text(l10n.timeOverride, style: labelStyle),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _time,
                  );
                  if (picked != null) setState(() => _time = picked);
                },
                icon: const Icon(Icons.access_time, size: 14),
                label: Text(
                  l10n.checkInTimeLabel(_time.format(context)),
                  style: const TextStyle(fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(l10n.editNote, style: labelStyle),
            const SizedBox(height: 8),
            TextField(
              controller: _ctrl,
              maxLines: 3,
              style: TextStyle(color: theme.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: l10n.noteHint,
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l10n.cancel,
                    style: TextStyle(color: theme.textSecondary),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    widget.onSave(_time, _ctrl.text.trim());
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.isExcused
                        ? const Color(0xFF42A5C8)
                        : widget.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
