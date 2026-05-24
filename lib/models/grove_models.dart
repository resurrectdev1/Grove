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

  List<RelapseEvent> get relapses => _relapses;

  final int geneticSeed;

  HabitTree({
    required this.id,
    required this.name,
    required this.color,
    required this.startDate,
    required this.lastReset,
    List<RelapseEvent>? relapses,
    int? geneticSeed,
  })  : _relapses   = relapses != null ? List<RelapseEvent>.of(relapses) : [],
  geneticSeed = geneticSeed ?? id.hashCode;

  int         get daysElapsed => DateTime.now().difference(lastReset).inDays;
  int         get totalDays   => DateTime.now().difference(startDate).inDays;
  GrowthStage get stage       => stageFromDays(daysElapsed);

  int get peakDays => _relapses.isEmpty
  ? daysElapsed
  : math.max(daysElapsed, _relapses.map((e) => e.peakDays).reduce(math.max));

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
  }) =>
  HabitTree(
    id:          id          ?? this.id,
    name:        name        ?? this.name,
    color:       color       ?? this.color,
    startDate:   startDate   ?? this.startDate,
    lastReset:   lastReset   ?? this.lastReset,
    relapses:    relapses    ?? List<RelapseEvent>.of(_relapses),
    geneticSeed: geneticSeed ?? this.geneticSeed,
  );
}
