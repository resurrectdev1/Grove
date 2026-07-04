import 'dart:async';
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
import 'package:grove/widgets/animated_tree_widget.dart';
import 'package:grove/widgets/habit_detail_widgets.dart';
import 'package:grove/widgets/monthly_calendar.dart';

class HabitDetailScreen extends StatefulWidget {
  final String habitId;
  const HabitDetailScreen({super.key, required this.habitId});
  @override State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  late PageController _calendarPageController;
  int  _currentMonthOffset = 0;
  static const _initialPageIndex = 12;
  bool _isDeleting = false;

  Timer?   _ticker;
  Duration _timeSinceRelapse = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calendarPageController = PageController(initialPage: _initialPageIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final habit = context.read<GroveModel>().habitById(widget.habitId);
      if (habit != null) {
        setState(() {
          _timeSinceRelapse = DateTime.now().difference(habit.lastReset);
        });
      }
    });
    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final habit = context.read<GroveModel>().habitById(widget.habitId);
      if (habit == null) return;
      setState(() { _timeSinceRelapse = DateTime.now().difference(habit.lastReset); });
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _calendarPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeleting) {
      return Scaffold(
        backgroundColor: context.watch<GroveSettings>().theme.bg,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final habit = context.watch<GroveModel>().habitById(widget.habitId);
    final theme = context.watch<GroveSettings>().theme;
    final l10n  = AppLocalizations.of(context);
    final isCheckIn = habit?.mode == HabitMode.checkIn;
    if (habit == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_isDeleting) Navigator.of(context).pop();
      });
        return Scaffold(backgroundColor: theme.bg);
    }

    return Scaffold(
      backgroundColor: theme.bg,
      body: CustomScrollView(
        slivers: [
          _appBar(context, habit, theme, l10n),
          SliverToBoxAdapter(child: _treeHero(habit)),
          SliverToBoxAdapter(child: _stats(habit, theme, l10n)),
          isCheckIn
          ? SliverToBoxAdapter(child: _checkInStreakCard(habit, theme, l10n))
          : SliverToBoxAdapter(child: _timeSinceRelapseCard(habit, theme, l10n)),
          SliverToBoxAdapter(child: _calendarSection(habit, theme, l10n)),
          if (isCheckIn)
            SliverToBoxAdapter(child: _freezeStreakSection(habit, theme, l10n)),
            if (!isCheckIn) ...[
              SliverToBoxAdapter(child: _historyHeader(habit, theme, l10n)),
              habit.relapses.isEmpty
              ? SliverToBoxAdapter(child: _noHistory(theme, l10n))
              : SliverList(delegate: SliverChildBuilderDelegate(
                (_, i) => RelapseEventTile(event: habit.relapses[i], index: i),
                childCount: habit.relapses.length)),
            ] else ...[
              SliverToBoxAdapter(child: _checkInHistoryHeader(habit, theme, l10n)),
              if (habit.checkInDays.isEmpty && habit.nullDays.isEmpty)
                SliverToBoxAdapter(child: _noHistory(theme, l10n, checkIn: true))
                else
                  Builder(builder: (context) {
                    final sorted = <DateTime>{...habit.checkInDays, ...habit.nullDays}.toList()
                    ..sort((a, b) => b.compareTo(a));
                    return SliverList(delegate: SliverChildBuilderDelegate(
                      (_, i) {
                        final day = sorted[i];
                        final isExcused = habit.nullDays.contains(day);
                        final note = habit.checkInNoteFor(day);
                        const frostColor = Color(0xFF42A5C8);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.surfaceHigh)),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(width: 28, height: 28,
                                      decoration: BoxDecoration(
                                        color: isExcused ? frostColor.withValues(alpha: 0.14) : habit.color.withValues(alpha: 0.12),
                                        shape: BoxShape.circle),
                                      alignment: Alignment.center,
                                      child: isExcused
                                      ? const Text('❄️', style: TextStyle(fontSize: 13))
                                      : Icon(Icons.check, size: 14, color: habit.color)),
                                      const SizedBox(width: 12),
                                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Row(children: [
                                          Expanded(child: Text(
                                            DateFormat('EEEE, MMMM d, yyyy').format(day),
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.textPrimary),
                                          )),
                                          if (isExcused)
                                            Text(l10n.legendExcused,
                                                 style: TextStyle(fontSize: 11, color: frostColor, fontWeight: FontWeight.w500))
                                            else
                                              Text(DateFormat('h:mm a').format(habit.checkInTimeFor(day)),
                                              style: TextStyle(fontSize: 11, color: theme.textMuted)),
                                        ]),
                                        if (note.isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          Text('"$note"',
                                               style: TextStyle(fontSize: 13, color: theme.textSecondary, fontStyle: FontStyle.italic, height: 1.4)),
                                        ],
                                      ])),
                          ]),
                        );
                      },
                      childCount: sorted.length,
                    ));
                  }),
            ],
            SliverToBoxAdapter(child: _deleteSection(context, habit, theme, l10n)),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _timeSinceRelapseCard(HabitTree habit, GroveTheme theme, AppLocalizations l10n) {
    final d       = _timeSinceRelapse;
    final days    = d.inDays;
    final hours   = d.inHours   % 24;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    final label   = habit.relapses.isEmpty ? l10n.abstinentSinceStart : l10n.timeSinceLastRelapse;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          color:        habit.color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(20),
          border:       Border.all(color: habit.color.withValues(alpha: 0.22)),
        ),
        child: Column(children: [
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                                       color: theme.textSecondary, letterSpacing: 0.8)),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        TimeUnit(value: days,    label: l10n.days, color: habit.color),
                        TimeDivider(color: theme.textMuted),
                        TimeUnit(value: hours,   label: l10n.hrs,  color: habit.color),
                        TimeDivider(color: theme.textMuted),
                        TimeUnit(value: minutes, label: l10n.min,  color: habit.color),
                        TimeDivider(color: theme.textMuted),
                        TimeUnit(value: seconds, label: l10n.sec,  color: habit.color),
                      ]),
        ]),
      ),
    );
  }

  Widget _checkInStreakCard(HabitTree habit, GroveTheme theme, AppLocalizations l10n) {
    final checkedIn = habit.checkedInToday;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          color:        habit.color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(20),
          border:       Border.all(color: habit.color.withValues(alpha: 0.22)),
        ),
        child: Column(children: [
          Text(checkedIn ? l10n.checkedInToday : l10n.notCheckedInToday,
               style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                                color: theme.textSecondary, letterSpacing: 0.8)),
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          context.read<GroveModel>().toggleCheckIn(habit.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                          decoration: BoxDecoration(
                            color: checkedIn ? theme.surfaceHigh : habit.color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(
                              checkedIn ? Icons.check_circle : Icons.check_circle_outline,
                              size: 18,
                              color: checkedIn ? habit.color : Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              checkedIn ? l10n.alreadyCheckedIn : l10n.checkInToday,
                              style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600,
                                color: checkedIn ? habit.color : Colors.white,
                              ),
                            ),
                          ]),
                        ),
                      ),
        ]),
      ),
    );
  }

  Widget _appBar(BuildContext ctx, HabitTree habit, GroveTheme theme, AppLocalizations l10n) =>
  SliverAppBar(
    backgroundColor: theme.bg, pinned: true,
    leading: IconButton(
      icon:  const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
      color: theme.textSecondary, onPressed: () => Navigator.pop(ctx)),
      title: GestureDetector(
        onTap: () => _showRenameDialog(ctx, habit, theme, l10n),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(habit.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: theme.textPrimary, fontWeight: FontWeight.w600, fontSize: 18)),
            ),
            const SizedBox(width: 6),
            Icon(Icons.edit_outlined, size: 15, color: theme.textMuted),
          ],
        ),
      ),
      actions: [
        Padding(padding: const EdgeInsets.only(right: 16),
        child: Container(width: 10, height: 10,
                         decoration: BoxDecoration(color: habit.color, shape: BoxShape.circle,
                                                   boxShadow: [BoxShadow(color: habit.color.withValues(alpha: 0.6), blurRadius: 6)]))),
      ],
  );

  void _showRenameDialog(BuildContext ctx, HabitTree habit, GroveTheme theme, AppLocalizations l10n) {
    final ctrl = TextEditingController(text: habit.name);
    showDialog(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: theme.surfaceHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.renameHabit, style: TextStyle(color: theme.textPrimary, fontWeight: FontWeight.w700)),
        content: TextField(
          controller:           ctrl,
          autofocus:            true,
          textCapitalization:   TextCapitalization.words,
          style:                TextStyle(color: theme.textPrimary),
          decoration: InputDecoration(
            labelText:  l10n.habitName,
            prefixIcon: Icon(Icons.edit_outlined, size: 18, color: theme.textMuted),
          ),
          onSubmitted: (val) {
            final trimmed = val.trim();
            if (trimmed.isNotEmpty) {
              context.read<GroveModel>().renameHabit(habit.id, trimmed);
              HapticFeedback.lightImpact();
            }
            Navigator.pop(dialogCtx);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(l10n.cancel, style: TextStyle(color: theme.textSecondary)),
          ),
          FilledButton(
            onPressed: () {
              final trimmed = ctrl.text.trim();
              if (trimmed.isNotEmpty) {
                context.read<GroveModel>().renameHabit(habit.id, trimmed);
                HapticFeedback.lightImpact();
              }
              Navigator.pop(dialogCtx);
            },
            style: FilledButton.styleFrom(
              backgroundColor: habit.color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Widget _treeHero(HabitTree habit) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = switch (habit.stage) {
          GrowthStage.groveTree => constraints.maxWidth * 0.72,
          GrowthStage.youngTree => constraints.maxWidth * 0.65,
          GrowthStage.sapling   => constraints.maxWidth * 0.58,
          _                     => constraints.maxWidth * 0.50,
        };

        final overflow = size * 0.20;
        return SizedBox(
          height: size + overflow,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: OverflowBox(
              maxWidth:  size * 1.15,
              maxHeight: size + overflow,
              alignment: Alignment.bottomCenter,
              child: Hero(
                tag: 'tree_${habit.id}',
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    width: size, height: size,
                    child: AnimatedTreeWidget(habit: habit),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _stats(HabitTree habit, GroveTheme theme, AppLocalizations l10n) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: Row(children: [
      StatChip(label: l10n.currentStreak, value: l10n.daysSuffix(habit.daysElapsed), color: habit.color),
      const SizedBox(width: 10),
      StatChip(label: l10n.peakRecord,    value: l10n.daysSuffix(habit.peakDays),    color: GroveTheme.streakGold),
      const SizedBox(width: 10),
      StatChip(
        label: habit.mode == HabitMode.checkIn ? l10n.checkIns : l10n.relapses,
        value: habit.mode == HabitMode.checkIn ? '${habit.checkInDays.length}' : '${habit.relapses.length}',
        color: habit.mode == HabitMode.checkIn ? habit.color : GroveTheme.clayRed,
      ),
    ]),
  );

  Widget _calendarSection(HabitTree habit, GroveTheme theme, AppLocalizations l10n) {
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(l10n.interactiveMonthlyLogs,
               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                color: theme.textSecondary, letterSpacing: 1.0)),
            const Spacer(),
            Text(l10n.swipeForEarlierMonths,
                 style: TextStyle(fontSize: 10, color: theme.textMuted, fontStyle: FontStyle.italic)),
        ]),
        const SizedBox(height: 12),
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller:    _calendarPageController,
            onPageChanged: (page) {
              setState(() => _currentMonthOffset = page - _initialPageIndex);
              HapticFeedback.selectionClick();
            },
            itemCount:   _initialPageIndex + 1 + 1,
            itemBuilder: (_, index) {
              final monthOffset = index - _initialPageIndex;
              if (index == 0) {
                return EarlierDateSentinel(habit: habit, theme: theme,
                                           onLogEarlierDate: () => _showEarlierDatePicker(context, habit));
              }
              return MonthlyCalendar(habit: habit, monthOffset: monthOffset);
            },
          ),
        ),
        const SizedBox(height: 8),
        Center(child: Text(
          _currentMonthOffset == -_initialPageIndex
          ? l10n.logDateBeforeTracking
          : _currentMonthOffset == 0
          ? l10n.thisMonth
          : DateFormat('MMMM yyyy').format(DateTime(now.year, now.month + _currentMonthOffset, 1)),
          style: TextStyle(fontSize: 10, color: theme.textMuted, fontStyle: FontStyle.italic),
        )),
      ]),
    );
  }

  Widget _freezeStreakSection(HabitTree habit, GroveTheme theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          context.read<GroveModel>().toggleStreakFreeze(habit.id);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: habit.streakFrozen
            ? const Color(0xFF42A5C8).withValues(alpha: 0.15)
            : theme.surfaceHigh,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: habit.streakFrozen
              ? const Color(0xFF42A5C8).withValues(alpha: 0.5)
              : theme.textMuted.withValues(alpha: 0.25),
              width: habit.streakFrozen ? 1.5 : 1,
            ),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              habit.streakFrozen ? Icons.ac_unit_rounded : Icons.ac_unit_outlined,
              size: 15,
              color: habit.streakFrozen
              ? const Color(0xFF42A5C8)
              : theme.textMuted,
            ),
            const SizedBox(width: 8),
            Text(
              habit.streakFrozen ? l10n.streakFrozen : l10n.freezeStreak,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: habit.streakFrozen
                ? const Color(0xFF42A5C8)
                : theme.textMuted,
              ),
            ),
            const SizedBox(width: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                habit.streakFrozen
                ? Icons.toggle_on_rounded
                : Icons.toggle_off_rounded,
                key: ValueKey(habit.streakFrozen),
                size: 28,
                color: habit.streakFrozen
                ? const Color(0xFF42A5C8)
                : theme.textMuted.withValues(alpha: 0.5),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _showEarlierDatePicker(BuildContext ctx, HabitTree habit) {
    final theme      = ctx.read<GroveSettings>().theme;
    final model      = ctx.read<GroveModel>();
    final l10n       = AppLocalizations.of(ctx);
    DateTime selectedDate = habit.startDate.subtract(const Duration(days: 1));
    TimeOfDay selectedTime = TimeOfDay.now();
    final reasonCtrl = TextEditingController();

    showModalBottomSheet(
      context: ctx, backgroundColor: theme.surfaceHigh,
      isScrollControlled: true, useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (builderCtx, setSheet) {
          final bottomPad = math.max(
            MediaQuery.of(builderCtx).viewInsets.bottom, MediaQuery.of(builderCtx).padding.bottom);
          return Padding(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPad),
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(child: Container(width: 36, height: 4,
                                                      decoration: BoxDecoration(color: theme.textMuted.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)))),
                                                      const SizedBox(height: 20),
                                                      Row(children: [
                                                        Container(width: 40, height: 40,
                                                                  decoration: BoxDecoration(color: GroveTheme.clayRed.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                                                                  child: const Icon(Icons.history_rounded, color: GroveTheme.clayRed, size: 20)),
                                                                  const SizedBox(width: 12),
                                                                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                    Text(l10n.logEarlierDateTitle, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: theme.textPrimary)),
                                                                    Text(l10n.beforeTrackingStarted, style: TextStyle(fontSize: 12, color: theme.textSecondary)),
                                                                  ])),
                                                      ]),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: theme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12), border: Border.all(color: theme.primary.withValues(alpha: 0.2))),
                              child: Row(children: [
                                Icon(Icons.info_outline, size: 16, color: theme.primary), const SizedBox(width: 8),
                                Expanded(child: Text(l10n.extendHistoryInfo,
                                                     style: TextStyle(fontSize: 11, color: theme.textSecondary, height: 1.4))),
                              ]),
                            ),
                            const SizedBox(height: 20),
                            Text(l10n.date, style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final picked = await showDatePicker(context: builderCtx, initialDate: selectedDate,
                                                                    firstDate: DateTime(2010), lastDate: habit.startDate.subtract(const Duration(days: 1)));
                                if (picked != null) setSheet(() => selectedDate = picked);
                              },
                              icon: const Icon(Icons.calendar_today, size: 14),
                              label: Text(DateFormat('EEE, MMM d, yyyy').format(selectedDate), style: const TextStyle(fontSize: 13)),
                              style: OutlinedButton.styleFrom(foregroundColor: theme.textPrimary,
                                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            ),
                            const SizedBox(height: 12),
                            Text(l10n.time, style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final picked = await showTimePicker(context: builderCtx, initialTime: selectedTime);
                                if (picked != null) setSheet(() => selectedTime = picked);
                              },
                              icon: const Icon(Icons.access_time, size: 14),
                              label: Text(selectedTime.format(builderCtx), style: const TextStyle(fontSize: 13)),
                              style: OutlinedButton.styleFrom(foregroundColor: theme.textPrimary,
                                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            ),
                            const SizedBox(height: 16),
                            Text(l10n.loggedReason, style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            TextField(controller: reasonCtrl, maxLines: 3,
                                      style: TextStyle(color: theme.textPrimary, fontSize: 14),
                                      decoration: InputDecoration(hintText: l10n.whatHappenedHint, contentPadding: const EdgeInsets.all(12))),
                                      const SizedBox(height: 24),
                                      FilledButton.icon(
                                        onPressed: () {
                                          final ts = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
                                          model.updateStartDate(habit.id, ts);
                                          model.recordCustomRelapse(habit.id, reasonCtrl.text.trim(), ts);
                                          HapticFeedback.mediumImpact(); Navigator.pop(sheetCtx);
                                        },
                                        icon: const Icon(Icons.refresh_rounded, size: 16),
                                        label: Text(l10n.logAsRelapseOnDate, style: const TextStyle(fontWeight: FontWeight.w600)),
                                        style: FilledButton.styleFrom(backgroundColor: GroveTheme.clayRed,
                                                                      minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                      ),
                            const SizedBox(height: 10),
                            OutlinedButton.icon(
                              onPressed: () {
                                final ts = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
                                model.updateStartDate(habit.id, ts);
                                HapticFeedback.lightImpact(); Navigator.pop(sheetCtx);
                              },
                              icon: const Icon(Icons.expand_less_rounded, size: 16),
                              label: Text(l10n.onlyExtendStartDate),
                              style: OutlinedButton.styleFrom(foregroundColor: theme.textPrimary,
                                                              side: BorderSide(color: theme.textMuted.withValues(alpha: 0.4)),
                                                              minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                            ),
                            ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _historyHeader(HabitTree habit, GroveTheme theme, AppLocalizations l10n) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
    child: Row(children: [
      Text(l10n.relapseSweepTimeline,
           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.textSecondary, letterSpacing: 1.0)),
           const Spacer(),
           Container(
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
             decoration: BoxDecoration(color: GroveTheme.clayRed.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
             child: Text(l10n.totalCount(habit.relapses.length),
             style: const TextStyle(fontSize: 11, color: GroveTheme.clayRed, fontWeight: FontWeight.w500))),
    ]),
  );

  Widget _noHistory(GroveTheme theme, AppLocalizations l10n, {bool checkIn = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Center(child: Text(
      checkIn ? l10n.noCheckInsYet
      : l10n.noRelapsesRecorded,
      style: TextStyle(color: theme.textMuted, fontStyle: FontStyle.italic, fontSize: 13))),
  );

  Widget _checkInHistoryHeader(HabitTree habit, GroveTheme theme, AppLocalizations l10n) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
    child: Row(children: [
      Text(l10n.checkInHistory,
           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.textSecondary, letterSpacing: 1.0)),
           const Spacer(),
           Container(
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
             decoration: BoxDecoration(color: habit.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
             child: Text(l10n.totalCount(habit.checkInDays.length + habit.nullDays.length),
             style: TextStyle(fontSize: 11, color: habit.color, fontWeight: FontWeight.w500))),
    ]),
  );

  Widget _deleteSection(BuildContext ctx, HabitTree habit, GroveTheme theme, AppLocalizations l10n) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Divider(color: theme.textMuted.withValues(alpha: 0.2), height: 1),
      const SizedBox(height: 24),
      Text(l10n.dangerZone, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.textMuted, letterSpacing: 1.0)),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: () => _confirmDelete(ctx, habit),
        icon:  const Icon(Icons.delete_outline, size: 18),
        label: Text(l10n.deleteHabitPermanently),
        style: OutlinedButton.styleFrom(
          foregroundColor: GroveTheme.clayRed,
            side:    BorderSide(color: GroveTheme.clayRed.withValues(alpha: 0.4)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:   RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      ),
    ]),
  );

  void _confirmDelete(BuildContext ctx, HabitTree habit) {
    final groveModel    = context.read<GroveModel>();
    final settingsTheme = context.read<GroveSettings>().theme;
    final l10n           = AppLocalizations.of(ctx);
    showDialog(
      context: ctx,
      builder: (dialogContext) => AlertDialog(
        title:   Text(l10n.deleteHabit),
        content: Text(
          l10n.deleteHabitConfirm(habit.name),
          style: TextStyle(color: settingsTheme.textSecondary)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel, style: TextStyle(color: settingsTheme.textSecondary))),
            FilledButton(
              onPressed: () async {
                final nav = Navigator.of(ctx);
                Navigator.pop(dialogContext);
                setState(() => _isDeleting = true);
                await Future.delayed(const Duration(milliseconds: 100));
                if (mounted) {
                  groveModel.deleteHabit(habit.id);
                  HapticFeedback.heavyImpact();
                  await Future.delayed(const Duration(milliseconds: 100));
                  if (mounted) nav.pop();
                }
              },
              style: FilledButton.styleFrom(backgroundColor: GroveTheme.clayRed),
              child: Text(l10n.delete),
            ),
          ],
      ),
    );
  }
}
