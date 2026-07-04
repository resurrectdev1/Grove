import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:grove/l10n/app_localizations.dart';
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
    final l10n           = AppLocalizations.of(context);
    final locale         = Localizations.localeOf(context).toString();
    final now            = DateTime.now();
    final isCheckIn      = habit.mode == HabitMode.checkIn;
    final targetMonth    = DateTime(now.year, now.month + monthOffset, 1);
    final monthName      = DateFormat('MMMM yyyy', locale).format(targetMonth);
    final lastDayOfMonth = DateTime(targetMonth.year, targetMonth.month + 1, 0);
    final daysInMonth    = lastDayOfMonth.day;
    final firstWeekday   = targetMonth.weekday;
    final startOffset    = firstWeekday - 1;
    final dayLabels      = List.generate(7, (i) {
      final sample = DateTime(2024, 1, 1 + i);
      final short  = DateFormat.E(locale).format(sample);
      return short.characters.first.toUpperCase();
    });
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
                                       final hasRelapse = habit.relapseDays.contains(cellDate);
                                       final hasCheckIn = isCheckIn && habit.checkInDays.contains(cellDate);
                                       final hasNullDay = isCheckIn && habit.nullDays.contains(cellDate);
                                       final hasMark    = isCheckIn ? (hasCheckIn || hasNullDay) : hasRelapse;

                                       final cellColor = isFuture
                                       ? theme.surfaceHigh.withValues(alpha: 0.3)
                                       : hasNullDay
                                       ? const Color(0xFF42A5C8).withValues(alpha: 0.25)
                                       : hasMark
                                       ? (isCheckIn ? habit.color.withValues(alpha: 0.7) : GroveTheme.clayRed.withValues(alpha: 0.7))
                                       : theme.surfaceHigh;

                                       return Expanded(
                                         child: GestureDetector(
                                           onTap: isFuture ? null : () {
                                             HapticFeedback.selectionClick();
                                             _showCellManager(context, cellDate, hasMark, hasNullDay, model, theme);
                                           },
                                           child: Container(
                                             margin: const EdgeInsets.all(2),
                                             decoration: BoxDecoration(color: cellColor, borderRadius: BorderRadius.circular(8),
                                             border: isToday ? Border.all(color: habit.color, width: 2) : null),
                                             alignment: Alignment.center,
                                             child: Text('$day', style: TextStyle(
                                               fontSize: 11, fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                               color: hasNullDay
                                               ? const Color(0xFF42A5C8)
                                               : hasMark ? GroveTheme.dewWhite : isFuture
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
                      Text(isCheckIn ? l10n.legendMissed : l10n.legendAbstained, style: TextStyle(fontSize: 9, color: theme.textMuted)),
                      const SizedBox(width: 14),
                      _legendDot(isCheckIn ? habit.color.withValues(alpha: 0.7) : GroveTheme.clayRed.withValues(alpha: 0.7)),
                      const SizedBox(width: 5),
                      Text(isCheckIn ? l10n.legendCheckIn : l10n.legendRelapse, style: TextStyle(fontSize: 9, color: theme.textMuted)),
                      if (isCheckIn) ...[
                        const SizedBox(width: 14),
                        _legendDot(const Color(0xFF42A5C8).withValues(alpha: 0.25)),
                        const SizedBox(width: 5),
                        Text(l10n.legendExcused, style: TextStyle(fontSize: 9, color: theme.textMuted)),
                      ],
                    ]),
      ]),
    );
  }

  void _showCellManager(BuildContext ctx, DateTime targetDate, bool hasMark, bool hasNullDay,
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
          hasNullDay: hasNullDay,
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
  final bool      hasNullDay;
  final GroveModel model;
  final GroveTheme theme;

  const _CellManagerSheet({
    required this.habit,
    required this.targetDate,
    required this.hasRelapse,
    required this.hasNullDay,
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
    } else {
      final day = DateTime(widget.targetDate.year, widget.targetDate.month, widget.targetDate.day);
      final existing = widget.habit.checkInTimestamps[day];
      if (existing != null) {
        _selectedTime = TimeOfDay.fromDateTime(existing);
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
    final l10n      = AppLocalizations.of(context);
    final locale    = Localizations.localeOf(context).toString();
    final bottomPad = math.max(
      MediaQuery.of(context).viewInsets.bottom,
      MediaQuery.of(context).padding.bottom);

    final dateStr = DateFormat('EEEE, MMMM d, yyyy', locale).format(widget.targetDate);
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
                     if (!_isCheckIn) ...[
                       const SizedBox(height: 6),
                       Text(
                         hasMark ? l10n.relapseLoggedThisDay : l10n.cleanRecord,
                         style: TextStyle(
                           fontSize:   12,
                           color:      hasMark ? GroveTheme.clayRed : theme.textSecondary,
                           fontWeight: FontWeight.w600)),
                     ],
                      const SizedBox(height: 20),
                      if (!_isCheckIn) ...[
                        Text(l10n.timeOverride,
                             style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                             const SizedBox(height: 8),
                             OutlinedButton.icon(
                               onPressed: () async {
                                 final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                                 if (picked != null) setState(() => _selectedTime = picked);
                               },
                               icon:  const Icon(Icons.access_time, size: 14),
                               label: Text(l10n.anchorTime(_selectedTime.format(context)), style: const TextStyle(fontSize: 13)),
                               style: OutlinedButton.styleFrom(
                                 foregroundColor: theme.textPrimary,
                                   padding:         const EdgeInsets.symmetric(vertical: 12)),
                             ),
                      const SizedBox(height: 16),
                      Text(hasMark ? l10n.editReason : l10n.reasonOptional,
                      style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _reasonCtrl,
                        maxLines:   3,
                        style:      TextStyle(color: theme.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          hintText:       l10n.reasonHint,
                          contentPadding: const EdgeInsets.all(12))),
                          const SizedBox(height: 24),
                      ],
                      if (_isCheckIn) ...[
                        const SizedBox(height: 6),
                        Text(
                          widget.hasNullDay
                          ? l10n.excusedStreakPreserved
                        : hasMark
                        ? l10n.checkedInThisDay
                        : l10n.noCheckInRecorded,
                        style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600,
                          color: widget.hasNullDay
                          ? const Color(0xFF42A5C8)
                          : hasMark ? widget.habit.color : theme.textSecondary,
                        ),
                        ),
                      const SizedBox(height: 20),
                      if (!widget.hasNullDay) ...[
                        Text(l10n.timeOverride,
                             style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                             const SizedBox(height: 8),
                             OutlinedButton.icon(
                               onPressed: () async {
                                 final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                                 if (picked != null) setState(() => _selectedTime = picked);
                               },
                               icon:  const Icon(Icons.access_time, size: 14),
                               label: Text(l10n.checkInTimeLabel(_selectedTime.format(context)), style: const TextStyle(fontSize: 13)),
                               style: OutlinedButton.styleFrom(
                                 foregroundColor: theme.textPrimary,
                                   padding:         const EdgeInsets.symmetric(vertical: 12)),
                             ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () {
                            if (hasMark) {
                              widget.model.removeCheckInOnDate(widget.habit.id, widget.targetDate);
                            } else {
                              widget.model.toggleCheckIn(widget.habit.id, date: widget.targetDate, overrideTime: _selectedTime);
                            }
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            hasMark ? Icons.clear : Icons.check_circle_outline,
                            size: 16,
                            color: hasMark ? theme.textPrimary : Colors.white,
                          ),
                          label: Text(hasMark ? l10n.removeCheckIn : l10n.checkInThisDay,
                                      style: TextStyle(color: hasMark ? theme.textPrimary : Colors.white)),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: hasMark ? theme.surfaceHigh : widget.habit.color,
                                        minimumSize: const Size.fromHeight(48),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          side: hasMark ? BorderSide(color: theme.textMuted.withValues(alpha: 0.3)) : BorderSide.none,
                                        ),
                                      ),
                        ),
                        if (hasMark) ...[
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () {
                              widget.model.setCheckInTime(widget.habit.id, widget.targetDate, _selectedTime);
                              HapticFeedback.lightImpact();
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.save_outlined, size: 16),
                            label: Text(l10n.saveNewTime),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: widget.habit.color,
                              side: BorderSide(color: widget.habit.color.withValues(alpha: 0.45)),
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () {
                            widget.model.toggleNullDay(widget.habit.id, widget.targetDate);
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.ac_unit_rounded, size: 16),
                          label: Text(l10n.excuseThisDayInstead),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF42A5C8),
                              side: BorderSide(color: const Color(0xFF42A5C8).withValues(alpha: 0.45)),
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ] else ...[
                        FilledButton.icon(
                          onPressed: () {
                            widget.model.toggleNullDay(widget.habit.id, widget.targetDate);
                            widget.model.toggleCheckIn(widget.habit.id, date: widget.targetDate);
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.check_circle_outline, size: 16),
                          label: Text(l10n.checkInInstead),
                          style: FilledButton.styleFrom(
                            backgroundColor: widget.habit.color,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () {
                            widget.model.toggleNullDay(widget.habit.id, widget.targetDate);
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.remove_circle_outline, size: 16),
                          label: Text(l10n.removeExcuse),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF42A5C8),
                              side: BorderSide(color: const Color(0xFF42A5C8).withValues(alpha: 0.45)),
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
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
                          label: Text(l10n.updateLog),
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
                        label: Text(l10n.removeRelapseBtn),
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
                          label: Text(l10n.addRelapseHere),
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
