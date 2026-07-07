import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grove/models/grove_models.dart';
import 'package:grove/services/grove_notifications.dart';
import 'package:grove/services/widget_bridge.dart';

class GroveModel extends ChangeNotifier with WidgetsBindingObserver {
  List<HabitTree> _habits = [];
  List<HabitTree> get habits => List.unmodifiable(_habits);

  SharedPreferences? _prefs;
  static const _idsKey = 'grove_v2_ids';

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _load();
      WidgetsBinding.instance.addObserver(this);
    } catch (e) {
      debugPrint('GroveModel init error: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _reloadFromPrefs();
    }
  }

  Future<void> _reloadFromPrefs() async {
    if (_prefs == null) return;
    await _prefs!.reload();
    _load();
  }

  void _load() {
    if (_prefs == null) return;
    final ids = _prefs!.getStringList(_idsKey) ?? [];
    _habits = ids.map((id) {
      final json = _prefs!.getString(id);
      if (json == null) return null;
      try {
        return HabitTree.fromJson(json);
      } catch (e) {
        debugPrint('Failed to parse habit $id: $e');
        return null;
      }
    }).whereType<HabitTree>().toList();
    notifyListeners();
  }

  Future<void> _persist({bool skipNotifications = false}) async {
    if (_prefs == null) return;
    try {
      await _prefs!.setStringList(_idsKey, _habits.map((h) => h.id).toList());
      for (final h in _habits) {
        await _prefs!.setString(h.id, h.toJson());
      }
      await GroveWidgetBridge.instance.renderAndUpdate(_habits);
      if (!skipNotifications) {
        final enabled = _prefs?.getBool('milestone_notifications') ?? false;
        if (enabled) {
          await GroveNotifications.instance.checkAndNotifyMilestones(_habits);
        }
      }
    } catch (e) {
      debugPrint('Persist error: $e');
    }
  }

  void addHabit({required String name, required Color color, HabitMode mode = HabitMode.abstain}) {
    final now = DateTime.now();
    _habits.add(HabitTree(
      id:        'habit_${now.millisecondsSinceEpoch}',
      name:      name,
      color:     color,
      startDate: now,
      lastReset: now,
      mode:      mode,
    ));
    _persist();
    notifyListeners();
  }

  void toggleCheckIn(String habitId, {DateTime? date, TimeOfDay? overrideTime}) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1 || _habits[i].mode != HabitMode.checkIn) return;

    final now = DateTime.now();
    final targetDay = date ?? now;
    final today = DateTime(targetDay.year, targetDay.month, targetDay.day);

    final recordedTimestamp = overrideTime != null
    ? DateTime(today.year, today.month, today.day, overrideTime.hour, overrideTime.minute)
    : DateTime(today.year, today.month, today.day, now.hour, now.minute, now.second, now.millisecond);

    final original = _habits[i];
    final updatedDays = Set<DateTime>.of(original.checkInDays);
    final updatedTimestamps = Map<DateTime, DateTime>.of(original.checkInTimestamps);
    final updatedNullDays = Set<DateTime>.of(original.nullDays);

    if (updatedDays.contains(today)) {
      updatedDays.remove(today);
      updatedTimestamps.remove(today);
    } else {
      updatedNullDays.remove(today);
      updatedDays.add(today);
      updatedTimestamps[today] = recordedTimestamp;
    }

    _habits[i] = original.copyWith(
      checkInDays: updatedDays,
      checkInTimestamps: updatedTimestamps,
      nullDays: updatedNullDays,
    );
    _persist();
    notifyListeners();
  }

  void setCheckInTime(String habitId, DateTime date, TimeOfDay overrideTime) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1 || _habits[i].mode != HabitMode.checkIn) return;

    final today = DateTime(date.year, date.month, date.day);
    final recordedTimestamp = DateTime(today.year, today.month, today.day, overrideTime.hour, overrideTime.minute);

    final original = _habits[i];
    final updatedDays = Set<DateTime>.of(original.checkInDays)..add(today);
    final updatedNullDays = Set<DateTime>.of(original.nullDays)..remove(today);
    final updatedTimestamps = Map<DateTime, DateTime>.of(original.checkInTimestamps);
    updatedTimestamps[today] = recordedTimestamp;

    _habits[i] = original.copyWith(
      checkInDays: updatedDays,
      nullDays: updatedNullDays,
      checkInTimestamps: updatedTimestamps,
    );
    _persist();
    notifyListeners();
  }

  void setCheckInTimeAndNote(String habitId, DateTime date, TimeOfDay overrideTime, String note) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1 || _habits[i].mode != HabitMode.checkIn) return;

    final today = DateTime(date.year, date.month, date.day);
    final recordedTimestamp = DateTime(today.year, today.month, today.day, overrideTime.hour, overrideTime.minute);

    final original = _habits[i];
    final updatedDays = Set<DateTime>.of(original.checkInDays)..add(today);
    final updatedNullDays = Set<DateTime>.of(original.nullDays)..remove(today);
    final updatedTimestamps = Map<DateTime, DateTime>.of(original.checkInTimestamps);
    updatedTimestamps[today] = recordedTimestamp;

    final updatedNotes = Map<DateTime, String>.of(original.checkInNotes);
    final trimmedNote = note.trim();
    if (trimmedNote.isEmpty) {
      updatedNotes.remove(today);
    } else {
      updatedNotes[today] = trimmedNote;
    }

    _habits[i] = original.copyWith(
      checkInDays: updatedDays,
      nullDays: updatedNullDays,
      checkInTimestamps: updatedTimestamps,
      checkInNotes: updatedNotes,
    );
    _persist();
    notifyListeners();
  }

  void removeCheckInOnDate(String habitId, DateTime date) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1 || _habits[i].mode != HabitMode.checkIn) return;

    final target = _habits[i];
    final cleanedDate = DateTime(date.year, date.month, date.day);
    if (!target.checkInDays.contains(cleanedDate)) return;

    final updatedDays = Set<DateTime>.of(target.checkInDays)..remove(cleanedDate);
    final updatedTimestamps = Map<DateTime, DateTime>.of(target.checkInTimestamps)..remove(cleanedDate);
    final updatedNotes = Map<DateTime, String>.of(target.checkInNotes)..remove(cleanedDate);
    _habits[i] = target.copyWith(
      checkInDays: updatedDays,
      checkInTimestamps: updatedTimestamps,
      checkInNotes: updatedNotes,
    );
    _persist();
    notifyListeners();
  }

  void recordCustomRelapse(String habitId, String reason, DateTime customDate) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1) return;

    final original = _habits[i];
    final updatedRelapses = List<RelapseEvent>.of(original.relapses)
    ..removeWhere((r) =>
    r.timestamp.year  == customDate.year  &&
    r.timestamp.month == customDate.month &&
    r.timestamp.day   == customDate.day)
    ..add(RelapseEvent(timestamp: customDate, reason: reason))
    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    DateTime newLastReset = updatedRelapses.isNotEmpty
    ? updatedRelapses.first.timestamp
    : original.startDate;
    if (newLastReset.isAfter(DateTime.now())) newLastReset = DateTime.now();

    final updated = original.copyWith(
      relapses:  updatedRelapses,
      lastReset: newLastReset,
    );
    _habits[i] = _sweepPeaks(updated);
    _persist();
    notifyListeners();
  }

  void removeRelapseOnDate(String habitId, DateTime date) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1) return;

    final original = _habits[i];
    final updatedRelapses = List<RelapseEvent>.of(original.relapses)
    ..removeWhere((r) =>
    r.timestamp.year  == date.year  &&
    r.timestamp.month == date.month &&
    r.timestamp.day   == date.day)
    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    DateTime newLastReset = updatedRelapses.isNotEmpty
    ? updatedRelapses.first.timestamp
    : original.startDate;
    if (newLastReset.isAfter(DateTime.now())) newLastReset = DateTime.now();

    final updated = original.copyWith(
      relapses:  updatedRelapses,
      lastReset: newLastReset,
    );
    _habits[i] = _sweepPeaks(updated);
    _persist();
    notifyListeners();
  }

  void updateStartDate(String habitId, DateTime newStart) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1) return;
    final target = _habits[i];
    if (newStart.isAfter(target.startDate)) return;

    final updated = target.copyWith(startDate: newStart);
    _habits[i] = _sweepPeaks(updated);
    _persist();
    notifyListeners();
  }

  HabitTree _sweepPeaks(HabitTree target) {
    int absolutePeak    = 0;
    DateTime sweepPivot = target.startDate;

    final chronological = target.relapses.reversed.toList();
    final sweptRelapses = <RelapseEvent>[];

    for (final event in chronological) {
      final validSpan = event.timestamp.difference(sweepPivot).inDays;
      if (validSpan > absolutePeak) absolutePeak = validSpan;
      sweptRelapses.insert(0, RelapseEvent(
        timestamp: event.timestamp,
        reason:    event.reason,
        peakDays:  absolutePeak,
      ));
      sweepPivot = event.timestamp;
    }

    return target.copyWith(relapses: sweptRelapses);
  }

  void toggleNullDay(String habitId, DateTime date) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1 || _habits[i].mode != HabitMode.checkIn) return;

    final target    = _habits[i];
    final day       = DateTime(date.year, date.month, date.day);
    final updatedNullDays  = Set<DateTime>.of(target.nullDays);
    final updatedNotes     = Map<DateTime, String>.of(target.checkInNotes);
    final updatedCheckIns  = Set<DateTime>.of(target.checkInDays);
    final updatedTimestamps = Map<DateTime, DateTime>.of(target.checkInTimestamps);

    if (updatedNullDays.contains(day)) {
      updatedNullDays.remove(day);
      updatedNotes.remove(day);
    } else {
      updatedNullDays.add(day);
      updatedCheckIns.remove(day);
      updatedTimestamps.remove(day);
      updatedNotes.remove(day);
    }

    _habits[i] = target.copyWith(
      nullDays: updatedNullDays,
      checkInNotes: updatedNotes,
      checkInDays: updatedCheckIns,
      checkInTimestamps: updatedTimestamps,
    );
    _persist();
    notifyListeners();
  }

  void setNullDayNote(String habitId, DateTime date, String note) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1 || _habits[i].mode != HabitMode.checkIn) return;

    final target = _habits[i];
    final day    = DateTime(date.year, date.month, date.day);
    if (!target.nullDays.contains(day)) return;

    final updatedNotes = Map<DateTime, String>.of(target.checkInNotes);
    final trimmedNote  = note.trim();
    if (trimmedNote.isEmpty) {
      updatedNotes.remove(day);
    } else {
      updatedNotes[day] = trimmedNote;
    }

    _habits[i] = target.copyWith(checkInNotes: updatedNotes);
    _persist();
    notifyListeners();
  }

  void toggleStreakFreeze(String habitId) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1) return;
    _habits[i] = _habits[i].copyWith(streakFrozen: !_habits[i].streakFrozen);
    _persist();
    notifyListeners();
  }

  void toggleExcusedDaysCountTowardsStreak(String habitId) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1) return;
    _habits[i] = _habits[i].copyWith(
      excusedDaysCountTowardsStreak: !_habits[i].excusedDaysCountTowardsStreak,
    );
    _persist();
    notifyListeners();
  }

  void renameHabit(String habitId, String newName) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1) return;
    _habits[i] = _habits[i].copyWith(name: newName);
    _persist();
    notifyListeners();
  }

  void updateHabitColor(String habitId, Color color) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1) return;
    _habits[i] = _habits[i].copyWith(color: color);
    _persist();
    notifyListeners();
  }

  void reorderHabits(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    final item = _habits.removeAt(oldIndex);
    _habits.insert(newIndex, item);
    _persist();
    notifyListeners();
  }

  void deleteHabit(String habitId) {
    _habits.removeWhere((h) => h.id == habitId);
    _prefs?.remove(habitId);
    GroveNotifications.instance.clearHabitMilestones(habitId);
    _persist();
    notifyListeners();
  }

  void restoreHabit(HabitTree habit) {
    if (_habits.any((h) => h.id == habit.id)) return;
    _habits.add(habit);
    _persist();
    notifyListeners();
  }

  HabitTree? habitById(String id) =>
  _habits.cast<HabitTree?>().firstWhere((h) => h?.id == id, orElse: () => null);

  String exportJson() {
    final payload = {
      'schemaVersion': 1,
      'exportedAt':    DateTime.now().toIso8601String(),
      'treeCount':     _habits.length,
      'trees':         _habits.map((h) => h.toMap()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  Future<bool> importFromJson(String raw) async {
    try {
      if (raw.trim().isEmpty) return false;
      final decoded = jsonDecode(raw);
      final List<dynamic> entries;
      if (decoded is Map<String, dynamic> && decoded['trees'] is List) {
        entries = decoded['trees'] as List<dynamic>;
      } else if (decoded is List) {
        entries = decoded;
      } else {
        return false;
      }
      final imported = <HabitTree>[];
      for (final entry in entries) {
        if (entry is Map<String, dynamic>) imported.add(HabitTree.fromMap(entry));
      }
      if (imported.isEmpty) return false;
      _habits = imported;
      await _persist(skipNotifications: true);
      await GroveNotifications.instance.markStagesSeen(_habits);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('JSON import failed: $e');
      return false;
    }
  }
}
