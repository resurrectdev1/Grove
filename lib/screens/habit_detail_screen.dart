import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
          _appBar(context, habit, theme),
          SliverToBoxAdapter(child: _treeHero(habit)),
          SliverToBoxAdapter(child: _stats(habit, theme)),
          SliverToBoxAdapter(child: _timeSinceRelapseCard(habit, theme)),
          SliverToBoxAdapter(child: _calendarSection(habit, theme)),
          SliverToBoxAdapter(child: _historyHeader(habit, theme)),
          habit.relapses.isEmpty
          ? SliverToBoxAdapter(child: _noHistory(theme))
          : SliverList(delegate: SliverChildBuilderDelegate(
            (_, i) => RelapseEventTile(event: habit.relapses[i], index: i),
            childCount: habit.relapses.length)),
            SliverToBoxAdapter(child: _deleteSection(context, habit, theme)),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _timeSinceRelapseCard(HabitTree habit, GroveTheme theme) {
    final d       = _timeSinceRelapse;
    final days    = d.inDays;
    final hours   = d.inHours   % 24;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    final label   = habit.relapses.isEmpty ? 'Clean since start' : 'Time since last relapse';

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
                        TimeUnit(value: days,    label: 'DAYS', color: habit.color),
                        TimeDivider(color: theme.textMuted),
                        TimeUnit(value: hours,   label: 'HRS',  color: habit.color),
                        TimeDivider(color: theme.textMuted),
                        TimeUnit(value: minutes, label: 'MIN',  color: habit.color),
                        TimeDivider(color: theme.textMuted),
                        TimeUnit(value: seconds, label: 'SEC',  color: habit.color),
                      ]),
        ]),
      ),
    );
  }

  Widget _appBar(BuildContext ctx, HabitTree habit, GroveTheme theme) =>
  SliverAppBar(
    backgroundColor: theme.bg, pinned: true,
    leading: IconButton(
      icon:      const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
      color:     theme.textSecondary, onPressed: () => Navigator.pop(ctx)),
      title: Text(habit.name,
                  style: TextStyle(color: theme.textPrimary, fontWeight: FontWeight.w600, fontSize: 18)),
                  actions: [
                    Padding(padding: const EdgeInsets.only(right: 16),
                    child: Container(width: 10, height: 10,
                                     decoration: BoxDecoration(color: habit.color, shape: BoxShape.circle,
                                                               boxShadow: [BoxShadow(color: habit.color.withValues(alpha: 0.6), blurRadius: 6)]))),
                  ],
  );

  Widget _treeHero(HabitTree habit) {
    final treeCanvas = switch (habit.stage) {
      GrowthStage.groveTree => 260.0,
      GrowthStage.youngTree => 220.0,
      GrowthStage.sapling   => 190.0,
      _                     => 170.0,
    };
    const containerHeight = 220.0;

    return SizedBox(
      height: containerHeight,
      child: ClipRect(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Hero(
              tag: 'tree_${habit.id}',
              child: Material(
                color: Colors.transparent,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width:  treeCanvas,
                    height: treeCanvas,
                    child:  AnimatedTreeWidget(habit: habit),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stats(HabitTree habit, GroveTheme theme) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: Row(children: [
      StatChip(label: 'Current Streak', value: '${habit.daysElapsed}d', color: habit.color),
      const SizedBox(width: 10),
      StatChip(label: 'Peak Record',    value: '${habit.peakDays}d',    color: GroveTheme.streakGold),
      const SizedBox(width: 10),
      StatChip(label: 'Relapses',       value: '${habit.relapses.length}', color: GroveTheme.clayRed),
    ]),
  );

  Widget _calendarSection(HabitTree habit, GroveTheme theme) {
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Interactive Monthly Logs',
               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                color: theme.textSecondary, letterSpacing: 1.0)),
            const Spacer(),
            Text('Swipe ← for earlier months',
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
          ? '← Log a date before tracking started'
        : _currentMonthOffset == 0
        ? 'This month'
        : DateFormat('MMMM yyyy').format(DateTime(now.year, now.month + _currentMonthOffset, 1)),
        style: TextStyle(fontSize: 10, color: theme.textMuted, fontStyle: FontStyle.italic),
        )),
      ]),
    );
  }

  void _showEarlierDatePicker(BuildContext ctx, HabitTree habit) {
    final theme      = ctx.read<GroveSettings>().theme;
    final model      = ctx.read<GroveModel>();
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
                                                                    Text('Log Earlier Date', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: theme.textPrimary)),
                                                                    Text('Before tracking started', style: TextStyle(fontSize: 12, color: theme.textSecondary)),
                                                                  ])),
                                                      ]),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: theme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12), border: Border.all(color: theme.primary.withValues(alpha: 0.2))),
                              child: Row(children: [
                                Icon(Icons.info_outline, size: 16, color: theme.primary), const SizedBox(width: 8),
                                Expanded(child: Text('This will extend your tracking history earlier and recalculate your peak streaks.',
                                                     style: TextStyle(fontSize: 11, color: theme.textSecondary, height: 1.4))),
                              ]),
                            ),
                            const SizedBox(height: 20),
                            Text('DATE', style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
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
                            Text('TIME', style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
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
                            Text('LOGGED REASON (Optional)', style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            TextField(controller: reasonCtrl, maxLines: 3,
                                      style: TextStyle(color: theme.textPrimary, fontSize: 14),
                                      decoration: const InputDecoration(hintText: 'What happened that day…', contentPadding: EdgeInsets.all(12))),
                                      const SizedBox(height: 24),
                                      FilledButton.icon(
                                        onPressed: () {
                                          final ts = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
                                          model.updateStartDate(habit.id, ts);
                                          model.recordCustomRelapse(habit.id, reasonCtrl.text.trim(), ts);
                                          HapticFeedback.mediumImpact(); Navigator.pop(sheetCtx);
                                        },
                                        icon: const Icon(Icons.refresh_rounded, size: 16),
                                        label: const Text('Log as Relapse on This Date', style: TextStyle(fontWeight: FontWeight.w600)),
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
                              label: const Text('Only Extend Start Date (No Relapse)'),
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

  Widget _historyHeader(HabitTree habit, GroveTheme theme) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
    child: Row(children: [
      Text('Relapse Timeline Sweep',
           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.textSecondary, letterSpacing: 1.0)),
           const Spacer(),
           Container(
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
             decoration: BoxDecoration(color: GroveTheme.clayRed.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
             child: Text('${habit.relapses.length} total',
                         style: const TextStyle(fontSize: 11, color: GroveTheme.clayRed, fontWeight: FontWeight.w500))),
    ]),
  );

  Widget _noHistory(GroveTheme theme) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Center(child: Text('No relapses recorded. Keep growing.',
                              style: TextStyle(color: theme.textMuted, fontStyle: FontStyle.italic, fontSize: 13))),
  );

  Widget _deleteSection(BuildContext ctx, HabitTree habit, GroveTheme theme) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Divider(color: theme.textMuted.withValues(alpha: 0.2), height: 1),
      const SizedBox(height: 24),
      Text('Danger Zone', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.textMuted, letterSpacing: 1.0)),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: () => _confirmDelete(ctx, habit),
        icon:  const Icon(Icons.delete_outline, size: 18),
        label: const Text('Delete Habit Permanently'),
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
    showDialog(
      context: ctx,
      builder: (dialogContext) => AlertDialog(
        title:   const Text('Delete Habit?'),
        content: Text(
          'This will permanently delete "${habit.name}" and all its history. This action cannot be undone.',
          style: TextStyle(color: settingsTheme.textSecondary)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: TextStyle(color: settingsTheme.textSecondary))),
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
              child: const Text('Delete'),
            ),
          ],
      ),
    );
  }
}
