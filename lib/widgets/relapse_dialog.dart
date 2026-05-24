import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:grove/providers/grove_settings.dart';
import 'package:grove/theme/grove_theme.dart';

class RelapseDialog extends StatefulWidget {
  final String habitName;
  final void Function(String reason, DateTime customTimestamp) onCustomRelapseConfirm;
  const RelapseDialog({super.key, required this.habitName, required this.onCustomRelapseConfirm});
  @override State<RelapseDialog> createState() => _RelapseDialogState();
}

class _RelapseDialogState extends State<RelapseDialog> {
  final _ctrl       = TextEditingController();
  DateTime  _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<GroveSettings>().theme;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: theme.surfaceHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(width: 40, height: 40,
                                    decoration: const BoxDecoration(color: Color(0x269E4C3B), shape: BoxShape.circle),
                                    child: const Icon(Icons.refresh_rounded, color: GroveTheme.clayRed, size: 20)),
                                    const SizedBox(width: 12),
                                    Expanded(child: Text('Log a Relapse?',
                                                         style: TextStyle(color: theme.textPrimary, fontSize: 18, fontWeight: FontWeight.w700))),
                        ]),
                      const SizedBox(height: 16),
                      Text('You are stronger than you think.',
                           style: TextStyle(color: theme.textSecondary, fontSize: 13, height: 1.5)),
                           const SizedBox(height: 20),
                           Text('CUSTOM TIMESTAMP',
                                style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 12),
                                Row(children: [
                                  Expanded(child: OutlinedButton.icon(
                                    onPressed: () async {
                                      final picked = await showDatePicker(context: context, initialDate: _selectedDate,
                                                                          firstDate: DateTime(2010), lastDate: DateTime.now());
                                      if (picked != null) setState(() => _selectedDate = picked);
                                    },
                                    icon: const Icon(Icons.calendar_today, size: 14),
                                    label: Text(DateFormat('MMM d').format(_selectedDate), style: const TextStyle(fontSize: 12)),
                                    style: OutlinedButton.styleFrom(foregroundColor: theme.textPrimary, padding: const EdgeInsets.symmetric(vertical: 12)),
                                  )),
                                  const SizedBox(width: 12),
                                  Expanded(child: OutlinedButton.icon(
                                    onPressed: () async {
                                      final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                                      if (picked != null) setState(() => _selectedTime = picked);
                                    },
                                    icon: const Icon(Icons.access_time, size: 14),
                                    label: Text(_selectedTime.format(context), style: const TextStyle(fontSize: 12)),
                                    style: OutlinedButton.styleFrom(foregroundColor: theme.textPrimary, padding: const EdgeInsets.symmetric(vertical: 12)),
                                  )),
                                ]),
                      const SizedBox(height: 20),
                      Text('LOGGED REASON (Optional)',
                      style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      TextField(controller: _ctrl, maxLines: 3,
                                style: TextStyle(color: theme.textPrimary, fontSize: 14),
                                decoration: const InputDecoration(
                                  hintText: 'Stress, Anxiety, Burnout, Peer pressure, Trigger? etc...',
                                  contentPadding: EdgeInsets.all(12))),
                                  const SizedBox(height: 24),
                                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel', style: TextStyle(color: theme.textSecondary)),
                                    ),
                                    const SizedBox(width: 8),
                                    FilledButton(
                                      onPressed: () {
                                        final ts = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day,
                                                            _selectedTime.hour, _selectedTime.minute);
                                        widget.onCustomRelapseConfirm(_ctrl.text.trim(), ts);
                                        Navigator.pop(context);
                                      },
                                      style: FilledButton.styleFrom(backgroundColor: GroveTheme.clayRed,
                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                                                    child: const Text('Confirm Log'),
                                    ),
                                  ]),
                      ],
        ),
      ),
    );
  }
}
