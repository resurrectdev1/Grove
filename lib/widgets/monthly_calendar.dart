import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:grove/models/grove_models.dart';
import 'package:grove/providers/grove_model.dart';
import 'package:grove/providers/grove_settings.dart';
import 'package:grove/theme/grove_theme.dart';

class MonthlyCalendar extends StatelessWidget {
  final HabitTree habit;
  final int       monthOffset;
  const MonthlyCalendar({super.key, required this.habit, required this.monthOffset});

  @override
  Widget build(BuildContext context) {
    final theme          = context.watch<GroveSettings>().theme;
    final model          = context.read<GroveModel>();
    final now            = DateTime.now();
    final targetMonth    = DateTime(now.year, now.month + monthOffset, 1);
    final monthName      = DateFormat('MMMM yyyy').format(targetMonth);
    final lastDayOfMonth = DateTime(targetMonth.year, targetMonth.month + 1, 0);
    final daysInMonth    = lastDayOfMonth.day;
    final firstWeekday   = targetMonth.weekday;
    final startOffset    = firstWeekday - 1;
    const dayLabels      = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final totalCells      = startOffset + daysInMonth;
    final numWeeks        = (totalCells / 7).ceil();
    final daysInPrevMonth = DateTime(targetMonth.year, targetMonth.month, 0).day;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: theme.surfaceHigh)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Center(child: Text(monthName,
                           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: theme.textPrimary, letterSpacing: 0.5))),
                           const SizedBox(height: 12),
                           Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                               children: dayLabels.map((label) => Expanded(child: Center(
                                 child: Text(label, style: TextStyle(fontSize: 10, color: theme.textMuted, fontWeight: FontWeight.w600))))).toList()),
                                 const SizedBox(height: 8),
                                 Expanded(
                                   child: Column(children: List.generate(numWeeks, (weekIndex) => Expanded(
                                     child: Row(children: List.generate(7, (dayIndex) {
                                       final cellIndex = weekIndex * 7 + dayIndex;
                                       if (cellIndex < startOffset || cellIndex >= startOffset + daysInMonth) {
                                         final overflowDay = cellIndex < startOffset
                                         ? daysInPrevMonth - (startOffset - cellIndex - 1)
                                         : cellIndex - (startOffset + daysInMonth) + 1;
                                         return Expanded(
                                           child: Container(
                                             margin: const EdgeInsets.all(2),
                                             decoration: BoxDecoration(
                                               color: theme.surfaceHigh.withValues(alpha: 0.15),
                                               borderRadius: BorderRadius.circular(8)),
                                               alignment: Alignment.center,
                                               child: Text('$overflowDay', style: TextStyle(
                                                 fontSize: 11,
                                                 fontWeight: FontWeight.w400,
                                                 color: theme.textMuted.withValues(alpha: 0.35))),
                                           ),
                                         );
                                       }
                                       final day        = cellIndex - startOffset + 1;
                                       final cellDate   = DateTime(targetMonth.year, targetMonth.month, day);
                                       final today      = DateTime(now.year, now.month, now.day);
                                       final isToday    = cellDate == today;
                                       final isFuture   = cellDate.isAfter(today);
                                       final isCheckIn  = habit.mode == HabitMode.checkIn;
                                       final hasRelapse = habit.relapseDays.contains(cellDate);
                                       final hasCheckIn = isCheckIn && habit.checkInDays.contains(cellDate);
                                       final hasMark    = isCheckIn ? hasCheckIn : hasRelapse;

                                       final cellColor = isFuture
                                       ? theme.surfaceHigh.withValues(alpha: 0.3)
                                       : hasMark
                                         ? (isCheckIn ? habit.color.withValues(alpha: 0.7) : GroveTheme.clayRed.withValues(alpha: 0.7))
                                         : theme.surfaceHigh;

                                       return Expanded(
                                         child: GestureDetector(
                                               onTap: isFuture ? null : () {
                                                 HapticFeedback.selectionClick();
                                                 _showCellManager(context, cellDate, hasMark, model, theme);
                                               },
                                               child: Container(
                                                 margin: const EdgeInsets.all(2),
                                                 decoration: BoxDecoration(color: cellColor, borderRadius: BorderRadius.circular(8),
                                                 border: isToday ? Border.all(color: habit.color, width: 2) : null),
                                                 alignment: Alignment.center,
                                                 child: Text('$day', style: TextStyle(
                                                   fontSize: 11, fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                                   color: hasMark ? GroveTheme.dewWhite : isFuture
                                                   ? theme.textMuted.withValues(alpha: 0.5) : theme.textSecondary)),
                                               ),
                                             ),
                                       );
                                     })),
                                   ))),
                                 ),
                    const SizedBox(height: 12),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      _legendDot(theme.surfaceHigh), const SizedBox(width: 5),
                      Text('Clean', style: TextStyle(fontSize: 9, color: theme.textMuted)),
                      const SizedBox(width: 14),
                      _legendDot(isCheckIn ? habit.color.withValues(alpha: 0.7) : GroveTheme.clayRed.withValues(alpha: 0.7)),
                      const SizedBox(width: 5),
                      Text(isCheckIn ? 'Check-in' : 'Relapse', style: TextStyle(fontSize: 9, color: theme.textMuted)),
                    ]),
      ]),
    );
  }

  void _showCellManager(BuildContext ctx, DateTime targetDate, bool hasMark,
                        GroveModel model, GroveTheme theme) {
    showModalBottomSheet(
      context: ctx, backgroundColor: theme.surfaceHigh,
      isScrollControlled: true, useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        builder: (_) => _CellManagerSheet(
          habit:      habit,
          targetDate: targetDate,
          hasRelapse: hasMark,
          model:      model,
          theme:      theme,
        ),
    );
                        }

                        Widget _legendDot(Color c) => Container(
                          width: 10, height: 10,
                          decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3)));
}

class _CellManagerSheet extends StatefulWidget {
  final HabitTree habit;
  final DateTime  targetDate;
  final bool      hasRelapse;
  final GroveModel model;
  final GroveTheme theme;

  const _CellManagerSheet({
    required this.habit,
    required this.targetDate,
    required this.hasRelapse,
    required this.model,
    required this.theme,
  });

  @override
  State<_CellManagerSheet> createState() => _CellManagerSheetState();
}

class _CellManagerSheetState extends State<_CellManagerSheet> {
  late final TextEditingController _reasonCtrl;
  late TimeOfDay _selectedTime;
  late bool _isCheckIn;

  @override
  void initState() {
    super.initState();
    _reasonCtrl   = TextEditingController();
    _selectedTime = TimeOfDay.now();
    _isCheckIn    = widget.habit.mode == HabitMode.checkIn;

    if (!_isCheckIn) {
      final matches = widget.habit.relapses.where((r) =>
      r.timestamp.year  == widget.targetDate.year  &&
      r.timestamp.month == widget.targetDate.month &&
      r.timestamp.day   == widget.targetDate.day).toList();

      if (matches.isNotEmpty) {
        _reasonCtrl.text = matches.first.reason;
        _selectedTime    = TimeOfDay.fromDateTime(matches.first.timestamp);
      }
    }
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme     = widget.theme;
    final bottomPad = math.max(
      MediaQuery.of(context).viewInsets.bottom,
      MediaQuery.of(context).padding.bottom);

    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(widget.targetDate);
    final hasMark = _isCheckIn
      ? widget.habit.checkInDays.contains(DateTime(widget.targetDate.year, widget.targetDate.month, widget.targetDate.day))
      : widget.hasRelapse;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPad),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize:       MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color:        theme.textMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Text(dateStr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: theme.textPrimary)),
                const SizedBox(height: 6),
                Text(hasMark
                  ? (_isCheckIn ? '✅ Checked in on this day.' : '⚠️ Relapse logged on this day.')
                  : '🌿 Clean record.',
                  style: TextStyle(
                    fontSize:   12,
                    color:      hasMark
                      ? (_isCheckIn ? widget.habit.color : GroveTheme.clayRed)
                      : theme.textSecondary,
                    fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                    if (!_isCheckIn) ...[
                      Text('TIME OVERRIDE',
                           style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                           const SizedBox(height: 8),
                           OutlinedButton.icon(
                             onPressed: () async {
                               final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                               if (picked != null) setState(() => _selectedTime = picked);
                             },
                             icon:  const Icon(Icons.access_time, size: 14),
                             label: Text('Anchor: ${_selectedTime.format(context)}', style: const TextStyle(fontSize: 13)),
                             style: OutlinedButton.styleFrom(
                               foregroundColor: theme.textPrimary,
                                 padding:         const EdgeInsets.symmetric(vertical: 12)),
                           ),
                      const SizedBox(height: 16),
                      Text(hasMark ? 'EDIT REASON' : 'REASON (optional)',
                      style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _reasonCtrl,
                        maxLines:   3,
                        style:      TextStyle(color: theme.textPrimary, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText:       'Stress, Anxiety, Burnout, Peer pressure, Trigger? etc...',
                          contentPadding: EdgeInsets.all(12))),
                          const SizedBox(height: 24),
                    ],
                    if (_isCheckIn) ...[
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () {
                           if (hasMark) {
                             widget.model.removeCheckInOnDate(widget.habit.id, widget.targetDate);
                           } else {
                             widget.model.toggleCheckIn(widget.habit.id, date: widget.targetDate);
                           }
                           HapticFeedback.lightImpact();
                           Navigator.pop(context);
                         },
                        icon: Icon(
                          hasMark ? Icons.clear : Icons.check_circle_outline,
                          size: 16,
                          color: hasMark ? theme.textPrimary : Colors.white,
                        ),
                        label: Text(hasMark ? 'Remove Check-in' : 'Check In This Day',
                          style: TextStyle(
                            color: hasMark ? theme.textPrimary : Colors.white,
                          )),
                        style: FilledButton.styleFrom(
                          backgroundColor: hasMark ? theme.surfaceHigh : widget.habit.color,
                            minimumSize:     const Size.fromHeight(48),
                            shape:           RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: hasMark ? BorderSide(color: theme.textMuted.withValues(alpha: 0.3)) : BorderSide.none,
                            ),
                        ),
                      ),
                    ] else if (hasMark) ...[
                      FilledButton.icon(
                        onPressed: () {
                          final ts = DateTime(
                            widget.targetDate.year, widget.targetDate.month, widget.targetDate.day,
                            _selectedTime.hour, _selectedTime.minute);
                          widget.model.recordCustomRelapse(widget.habit.id, _reasonCtrl.text.trim(), ts);
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        icon:  const Icon(Icons.check, size: 16),
                        label: const Text('Update Log'),
                        style: FilledButton.styleFrom(
                          backgroundColor: widget.habit.color,
                          foregroundColor: Colors.white,
                            minimumSize:     const Size.fromHeight(48),
                            shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () {
                          widget.model.removeRelapseOnDate(widget.habit.id, widget.targetDate);
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        icon:  const Icon(Icons.clear, size: 16),
                        label: const Text('Remove Relapse'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: GroveTheme.clayRed,
                            side:            BorderSide(color: GroveTheme.clayRed.withValues(alpha: 0.4)),
                            minimumSize:     const Size.fromHeight(48),
                            shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                    ] else ...[
                      FilledButton.icon(
                        onPressed: () {
                          final ts = DateTime(
                            widget.targetDate.year, widget.targetDate.month, widget.targetDate.day,
                            _selectedTime.hour, _selectedTime.minute);
                          widget.model.recordCustomRelapse(widget.habit.id, _reasonCtrl.text.trim(), ts);
                          HapticFeedback.lightImpact();
                          Navigator.pop(context);
                        },
                        icon:  const Icon(Icons.add, size: 16),
                        label: const Text('Add Relapse Here'),
                        style: FilledButton.styleFrom(
                          backgroundColor: GroveTheme.clayRed,
                          foregroundColor: Colors.white,
                            minimumSize:     const Size.fromHeight(48),
                            shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                    ],
          ],
        ),
      ),
    );
  }
}
