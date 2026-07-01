import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class RelapseEvent {
  final DateTime timestamp;
  final String   reason;
  final int      peakDays;

  const RelapseEvent({
    required this.timestamp,
    required this.reason,
    this.peakDays = 0,
  });

  Map<String, dynamic> toMap() => {
    'timestamp': timestamp.toIso8601String(),
    'reason':    reason,
    'peakDays':  peakDays,
  };

  factory RelapseEvent.fromMap(Map<String, dynamic> m) => RelapseEvent(
    timestamp: DateTime.parse(m['timestamp'] as String),
    reason:    (m['reason'] as String? ?? '').trim(),
    peakDays:  m['peakDays'] as int? ?? 0,
  );
}

enum GrowthStage { seed, sprout, sapling, youngTree, groveTree }

enum HabitMode { abstain, checkIn }

GrowthStage stageFromDays(int days) {
  if (days <= 1)  return GrowthStage.seed;
  if (days <= 7)  return GrowthStage.sprout;
  if (days <= 30) return GrowthStage.sapling;
  if (days <= 90) return GrowthStage.youngTree;
  return GrowthStage.groveTree;
}

String stageLabel(GrowthStage s) => const {
  GrowthStage.seed:      'Seed',
  GrowthStage.sprout:    'Sprout',
  GrowthStage.sapling:   'Sapling',
  GrowthStage.youngTree: 'Young Tree',
  GrowthStage.groveTree: 'Grove Tree',
}[s]!;

String stageTagline(GrowthStage s) => const {
  GrowthStage.seed:      'Every great forest starts here.',
  GrowthStage.sprout:    'Roots are forming beneath the surface.',
  GrowthStage.sapling:   'Growing stronger with every sunrise.',
  GrowthStage.youngTree: 'Your canopy is taking shape.',
  GrowthStage.groveTree: 'You have become the forest.',
}[s]!;

class HabitTree {
  final String             id;
  final String             name;
  final Color              color;
  final DateTime           startDate;
  DateTime                 lastReset;
  final List<RelapseEvent> _relapses;
  final HabitMode          mode;
  final Set<DateTime>      _checkInDays;

  final Set<DateTime>      _nullDays;
  final Map<DateTime, DateTime> _checkInTimestamps;

  List<RelapseEvent> get relapses     => _relapses;
  Set<DateTime>      get checkInDays  => _checkInDays;
  Set<DateTime>      get nullDays     => _nullDays;
  Map<DateTime, DateTime> get checkInTimestamps => _checkInTimestamps;

  DateTime checkInTimeFor(DateTime day) => _checkInTimestamps[day] ?? day;

  final int  geneticSeed;
  final bool streakFrozen;

  HabitTree({
    required this.id,
    required this.name,
    required this.color,
    required this.startDate,
    required this.lastReset,
    List<RelapseEvent>? relapses,
    int? geneticSeed,
    this.mode = HabitMode.abstain,
    Set<DateTime>? checkInDays,
    Set<DateTime>? nullDays,
    Map<DateTime, DateTime>? checkInTimestamps,
    this.streakFrozen = false,
  })  : _relapses    = relapses != null ? List<RelapseEvent>.of(relapses) : [],
  _checkInDays = checkInDays != null ? Set<DateTime>.of(checkInDays) : <DateTime>{},
  _nullDays    = nullDays    != null ? Set<DateTime>.of(nullDays)    : <DateTime>{},
  _checkInTimestamps = checkInTimestamps != null
    ? Map<DateTime, DateTime>.of(checkInTimestamps)
    : <DateTime, DateTime>{},
  geneticSeed  = geneticSeed ?? id.hashCode;

  int get checkInStreak {
    final allDays = <DateTime>{..._checkInDays, ..._nullDays}.toList()
    ..sort((a, b) => b.compareTo(a));

    if (allDays.isEmpty) return 0;

    final today    = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);

    if (!streakFrozen) {
      final gap = todayNorm.difference(allDays.first).inDays;
      if (gap > 1) return 0;
    }

    int streak = 1;
    for (int i = 1; i < allDays.length; i++) {
      final gap = allDays[i - 1].difference(allDays[i]).inDays;
      if (gap == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  bool get checkedInToday {
    final now  = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _checkInDays.contains(today) || _nullDays.contains(today);
  }

  int get daysElapsed => mode == HabitMode.abstain
  ? DateTime.now().difference(lastReset).inDays
  : checkInStreak;

  int         get totalDays   => DateTime.now().difference(startDate).inDays;
  GrowthStage get stage       => stageFromDays(daysElapsed);

  int get peakDays {
    if (mode == HabitMode.checkIn) {
      final allDays = <DateTime>{..._checkInDays, ..._nullDays}.toList()..sort();
      if (allDays.isEmpty) return 0;
      int maxRun = 1;
      int current = 1;
      for (int i = 1; i < allDays.length; i++) {
        if (allDays[i].difference(allDays[i - 1]).inDays == 1) {
          current++;
          if (current > maxRun) maxRun = current;
        } else {
          current = 1;
        }
      }
      return math.max(maxRun, checkInStreak);
    }
    return _relapses.isEmpty
    ? daysElapsed
    : math.max(daysElapsed, _relapses.map((e) => e.peakDays).reduce(math.max));
  }

  double get stageProgress {
    final d = daysElapsed;
    if (d <= 1)  return (d / 1).clamp(0.0, 1.0);
    if (d <= 7)  return ((d - 2) / 5.0).clamp(0.0, 1.0);
    if (d <= 30) return ((d - 8) / 22.0).clamp(0.0, 1.0);
    if (d <= 90) return ((d - 31) / 59.0).clamp(0.0, 1.0);
    return 1.0;
  }

  Set<DateTime> get relapseDays => _relapses
  .map((e) => DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day))
  .toSet();

  Map<String, dynamic> toMap() => {
    'id':          id,
    'name':        name,
    'color':       color.toARGB32(),
    'startDate':   startDate.toIso8601String(),
    'lastReset':   lastReset.toIso8601String(),
    'relapses':    _relapses.map((r) => r.toMap()).toList(),
    'geneticSeed': geneticSeed,
    'mode':         mode.index,
    'checkInDays':  _checkInDays.map((d) => d.toIso8601String()).toList(),
    'nullDays':     _nullDays.map((d) => d.toIso8601String()).toList(),
    'checkInTimestamps': _checkInTimestamps.map(
      (day, ts) => MapEntry(day.toIso8601String(), ts.toIso8601String()),
    ),
    'streakFrozen': streakFrozen,
  };

  String toJson() => jsonEncode(toMap());

  factory HabitTree.fromMap(Map<String, dynamic> m) => HabitTree(
    id:          m['id'] as String,
    name:        m['name'] as String,
    color:       Color(m['color'] as int),
    startDate:   DateTime.parse(m['startDate'] as String),
    lastReset:   DateTime.parse(m['lastReset'] as String),
    relapses: (m['relapses'] as List<dynamic>? ?? [])
    .map((r) => RelapseEvent.fromMap(r as Map<String, dynamic>))
    .toList(),
    geneticSeed: m['geneticSeed'] as int?,
    mode:         m['mode'] != null ? HabitMode.values[m['mode'] as int] : HabitMode.abstain,
    checkInDays:  (m['checkInDays'] as List<dynamic>?)
    ?.map((d) => DateTime.parse(d as String))
    .toSet(),
    nullDays:     (m['nullDays'] as List<dynamic>?)
    ?.map((d) => DateTime.parse(d as String))
    .toSet(),
    checkInTimestamps: (m['checkInTimestamps'] as Map<String, dynamic>?)
    ?.map((day, ts) => MapEntry(DateTime.parse(day), DateTime.parse(ts as String))),
    streakFrozen: m['streakFrozen'] as bool? ?? false,
  );

  factory HabitTree.fromJson(String s) =>
  HabitTree.fromMap(jsonDecode(s) as Map<String, dynamic>);

  HabitTree copyWith({
    String?             id,
    String?             name,
    Color?              color,
    DateTime?           startDate,
    DateTime?           lastReset,
    List<RelapseEvent>? relapses,
    int?                geneticSeed,
    HabitMode?          mode,
    Set<DateTime>?      checkInDays,
    Set<DateTime>?      nullDays,
    Map<DateTime, DateTime>? checkInTimestamps,
    bool?               streakFrozen,
  }) =>
  HabitTree(
    id:           id           ?? this.id,
    name:         name         ?? this.name,
    color:        color        ?? this.color,
    startDate:    startDate    ?? this.startDate,
    lastReset:    lastReset    ?? this.lastReset,
    relapses:     relapses     ?? List<RelapseEvent>.of(_relapses),
    geneticSeed:  geneticSeed  ?? this.geneticSeed,
    mode:         mode         ?? this.mode,
    checkInDays:  checkInDays  ?? Set<DateTime>.of(_checkInDays),
    nullDays:     nullDays     ?? Set<DateTime>.of(_nullDays),
    checkInTimestamps: checkInTimestamps ?? Map<DateTime, DateTime>.of(_checkInTimestamps),
    streakFrozen: streakFrozen ?? this.streakFrozen,
  );
}
