import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:grove/l10n/app_localizations.dart';
import 'package:grove/models/grove_models.dart';
import 'package:grove/providers/grove_settings.dart';
import 'package:grove/theme/grove_theme.dart';

class TimeUnit extends StatelessWidget {
  final int value; final String label; final Color color;
  const TimeUnit({super.key, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<GroveSettings>().theme;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(value.toString().padLeft(2, '0'),
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: color,
                       fontFeatures: const [FontFeature.tabularFigures()])),
                       const SizedBox(height: 2),
                       Text(label, style: TextStyle(fontSize: 9, color: theme.textMuted, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
    ]);
  }
}

class TimeDivider extends StatelessWidget {
  final Color color;
  const TimeDivider({super.key, required this.color});
  @override
  Widget build(BuildContext context) =>
  Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: color));
}

class EarlierDateSentinel extends StatelessWidget {
  final HabitTree habit; final GroveTheme theme; final VoidCallback onLogEarlierDate;
  const EarlierDateSentinel({super.key, required this.habit, required this.theme, required this.onLogEarlierDate});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: theme.primary.withValues(alpha: 0.25), width: 1.5)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 56, height: 56,
                  decoration: BoxDecoration(color: theme.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
                  child: Icon(Icons.history_rounded, color: theme.primary, size: 28)),
                  const SizedBox(height: 16),
                  Text(l10n.earlierThanLogs, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: theme.textPrimary), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(l10n.trackingStarted(DateFormat('MMM d, yyyy').format(habit.startDate)),
                  style: TextStyle(fontSize: 12, color: theme.textSecondary, height: 1.5), textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: onLogEarlierDate,
                    icon:  const Icon(Icons.add_rounded, size: 18),
                    label: Text(l10n.logEarlierDate, style: const TextStyle(fontWeight: FontWeight.w600)),
                    style: FilledButton.styleFrom(backgroundColor: theme.primary,
                                                  minimumSize: const Size(double.infinity, 50),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  ),
                  const SizedBox(height: 12),
                  Text(l10n.extendsHistoryNote,
                       style: TextStyle(fontSize: 10, color: theme.textMuted), textAlign: TextAlign.center),
      ]),
    );
  }
}

class StatChip extends StatelessWidget {
  final String label, value; final Color color;
  const StatChip({super.key, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, color: GroveTheme.slateGrey, letterSpacing: 0.3), textAlign: TextAlign.center),
      ]),
    ),
  );
}

class RelapseEventTile extends StatelessWidget {
  final RelapseEvent event; final int index;
  const RelapseEventTile({super.key, required this.event, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme   = context.watch<GroveSettings>().theme;
    final l10n    = AppLocalizations.of(context);
    final dateStr = DateFormat('EEE, MMM d yyyy').format(event.timestamp);
    final timeStr = DateFormat('h:mm a').format(event.timestamp);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(16),
      border: Border.all(color: theme.surfaceHigh)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 28, height: 28,
                  decoration: const BoxDecoration(color: Color(0x269E4C3B), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text('${index + 1}', style: const TextStyle(fontSize: 11, color: GroveTheme.clayRed, fontWeight: FontWeight.w700))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text(dateStr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.textPrimary)),
                      const Spacer(),
                      Text(timeStr, style: TextStyle(fontSize: 11, color: theme.textMuted)),
                    ]),
                    if (event.peakDays > 0) ...[
                      const SizedBox(height: 3),
                      Text(l10n.peakSweep(event.peakDays),
                      style: const TextStyle(fontSize: 10, color: GroveTheme.streakGold, fontWeight: FontWeight.w500)),
                    ],
                    if (event.reason.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text('"${event.reason}"',
                           style: TextStyle(fontSize: 13, color: theme.textSecondary, fontStyle: FontStyle.italic, height: 1.4)),
                    ] else ...[
                      const SizedBox(height: 4),
                      Text(l10n.noReasonRecorded, style: TextStyle(fontSize: 12, color: theme.textMuted)),
                    ],
                  ])),
      ]),
    );
  }
}
