// ╔═══════════════════════════════════════════════════════════════╗
// ║ G R O V E v0.5.5                                              ║
// ║ – Experimental Android Widget suppourt                        ║
// ║ – Split apks for optimization and file sieze                  ║
// ║ – Preperation for fdroid release                              ║
// ║ – Preperation for izzyondroid release                         ║
// ║ - App signed by my private key for all release builds         ║
// ╚═══════════════════════════════════════════════════════════════╝
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:local_auth/local_auth.dart';
import 'widget_bridge.dart';

// ══════════════════════════════════════════════════════════════════════
// §0 SERVICES — Notifications & Biometrics
// ══════════════════════════════════════════════════════════════════════

class GroveNotifications {
  GroveNotifications._();
  static final GroveNotifications instance = GroveNotifications._();

  final _plugin = FlutterLocalNotificationsPlugin();
  static const _channelId   = 'grove_daily';
  static const _channelName = 'Daily Reminder';
  static const _notifId     = 0;

  Future<void> init() async {
    tz_data.initializeTimeZones();
    final offsetSeconds = DateTime.now().timeZoneOffset.inSeconds;
    final sign   = offsetSeconds >= 0 ? '+' : '-';
    final abs    = offsetSeconds.abs();
    final hh     = (abs ~/ 3600).toString().padLeft(2, '0');
    final mm     = ((abs % 3600) ~/ 60).toString().padLeft(2, '0');
    final tzName = 'Etc/GMT${sign == '+' ? '-' : '+'}${abs ~/ 3600}';
    debugPrint('Grove: using timezone offset UTC$sign$hh:$mm → $tzName');
    try {
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings     = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (_) {},
    );
  }

  Future<void> scheduleDailyReminder({TimeOfDay time = const TimeOfDay(hour: 20, minute: 0)}) async {
    await _plugin.cancelAll();

    final androidPlugin = _plugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();

    final exactAlarmGranted =
    await androidPlugin?.requestExactAlarmsPermission() ?? false;
    debugPrint('Grove: exact alarm permission granted: $exactAlarmGranted');

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId, _channelName,
        channelDescription: 'Daily Grove check-in reminder',
        importance: Importance.high,
        priority:   Priority.high,

        icon:       '@drawable/ic_grove_notif',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    final now    = tz.TZDateTime.now(tz.local);
    var   target = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (target.isBefore(now)) target = target.add(const Duration(days: 1));

    await _plugin.zonedSchedule(
      id:                      _notifId,
      title:                   'Your forest is waiting 🌲',
      body:                    'It has grown a lot since you last visited.',
      scheduledDate:           target,
      notificationDetails:     details,
      androidScheduleMode:     AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    debugPrint('Grove: notification scheduled for ${target.toLocal()}');
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}

class GroveBiometrics {
  GroveBiometrics._();
  static final GroveBiometrics instance = GroveBiometrics._();

  final _auth = LocalAuthentication();

  Future<bool> get isAvailable async {
    try {
      final canCheck   = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck && isSupported;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Unlock your Grove',
      );
    } catch (_) {
      return false;
    }
  }
}

// ══════════════════════════════════════════════════════════════════════
// §1 SETTINGS & THEME ENGINE
// ══════════════════════════════════════════════════════════════════════
enum GroveThemeMode { forestDark, amoledBlack, materialYou, whiteMinimal }
enum LayoutMode { verticalWheel, horizontalCarousel, compactGrid, compactList }

class GroveTheme {
  final GroveThemeMode mode;
  final ColorScheme? dynamicScheme;
  const GroveTheme({required this.mode, this.dynamicScheme});

  Color get bg {
    switch (mode) {
      case GroveThemeMode.forestDark:    return const Color(0xFF0A0F0B);
      case GroveThemeMode.amoledBlack:   return const Color(0xFF000000);
      case GroveThemeMode.whiteMinimal:  return const Color(0xFFF5F5F5);
      case GroveThemeMode.materialYou:   return dynamicScheme?.surface ?? const Color(0xFF0A0F0B);
    }
  }

  Color get surface {
    switch (mode) {
      case GroveThemeMode.forestDark:    return const Color(0xFF111A13);
      case GroveThemeMode.amoledBlack:   return const Color(0xFF0A0A0A);
      case GroveThemeMode.whiteMinimal:  return const Color(0xFFFFFFFF);
      case GroveThemeMode.materialYou:   return dynamicScheme?.surfaceContainerLow ?? const Color(0xFF111A13);
    }
  }

  Color get surfaceHigh {
    switch (mode) {
      case GroveThemeMode.forestDark:    return const Color(0xFF182117);
      case GroveThemeMode.amoledBlack:   return const Color(0xFF121212);
      case GroveThemeMode.whiteMinimal:  return const Color(0xFFE8E8E8);
      case GroveThemeMode.materialYou:   return dynamicScheme?.surfaceContainerHigh ?? const Color(0xFF182117);
    }
  }

  Color get cardBg {
    switch (mode) {
      case GroveThemeMode.forestDark:    return const Color(0xFF0E1610);
      case GroveThemeMode.amoledBlack:   return const Color(0xFF000000);
      case GroveThemeMode.whiteMinimal:  return const Color(0xFFFAFAFA);
      case GroveThemeMode.materialYou:   return dynamicScheme?.surfaceContainer ?? const Color(0xFF0E1610);
    }
  }

  Color get primary {
    switch (mode) {
      case GroveThemeMode.forestDark:    return const Color(0xFF4E8B5F);
      case GroveThemeMode.amoledBlack:   return const Color(0xFF4E8B5F);
      case GroveThemeMode.whiteMinimal:  return const Color(0xFF2E7D4E);
      case GroveThemeMode.materialYou:   return dynamicScheme?.primary ?? const Color(0xFF4E8B5F);
    }
  }

  Color get textPrimary {
    switch (mode) {
      case GroveThemeMode.forestDark:    return const Color(0xFFE0EBE0);
      case GroveThemeMode.amoledBlack:   return const Color(0xFFFFFFFF);
      case GroveThemeMode.whiteMinimal:  return const Color(0xFF1A1A1A);
      case GroveThemeMode.materialYou:   return dynamicScheme?.onSurface ?? const Color(0xFFE0EBE0);
    }
  }

  Color get textSecondary {
    switch (mode) {
      case GroveThemeMode.forestDark:    return const Color(0xFF8AA88C);
      case GroveThemeMode.amoledBlack:   return const Color(0xFFAAAAAA);
      case GroveThemeMode.whiteMinimal:  return const Color(0xFF666666);
      case GroveThemeMode.materialYou:   return dynamicScheme?.onSurfaceVariant ?? const Color(0xFF8AA88C);
    }
  }

  Color get textMuted {
    switch (mode) {
      case GroveThemeMode.forestDark:    return const Color(0xFF4A5E4C);
      case GroveThemeMode.amoledBlack:   return const Color(0xFF555555);
      case GroveThemeMode.whiteMinimal:  return const Color(0xFF999999);
      case GroveThemeMode.materialYou:   return dynamicScheme?.outline ?? const Color(0xFF4A5E4C);
    }
  }

  Brightness get brightness {
    switch (mode) {
      case GroveThemeMode.whiteMinimal: return Brightness.light;
      default: return Brightness.dark;
    }
  }

  static const mossGreen   = Color(0xFF4E8B5F);
  static const sageLight   = Color(0xFF7DB08A);
  static const barkBrown   = Color(0xFF7A5C3E);
  static const clayRed     = Color(0xFF9E4C3B);
  static const goldenLich  = Color(0xFFB8973A);
  static const dewWhite    = Color(0xFFD4E8D0);
  static const slateGrey   = Color(0xFF6B7A7D);
  static const streakGold  = Color(0xFFB8973A);

  static const List<Color> treePalette = [
    Color(0xFF4E8B5F), Color(0xFF42A5C8), Color(0xFF9E4C3B),
    Color(0xFFB8973A), Color(0xFF8B5E9E), Color(0xFF4E8B7A),
    Color(0xFFB87C3A), Color(0xFF9E3B6B),
  ];
}

class GroveSettings extends ChangeNotifier {
  GroveThemeMode _themeMode         = GroveThemeMode.forestDark;
  LayoutMode     _layoutMode        = LayoutMode.verticalWheel;
  ColorScheme?   _dynamicScheme;
  bool           _onboardingDone    = false;
  bool           _dailyNotification = false;
  bool           _biometricUnlock   = false;
  TimeOfDay      _notifTime         = const TimeOfDay(hour: 20, minute: 0);

  GroveThemeMode get themeMode         => _themeMode;
  LayoutMode     get layoutMode        => _layoutMode;
  bool           get onboardingDone    => _onboardingDone;
  bool           get dailyNotification => _dailyNotification;
  bool           get biometricUnlock   => _biometricUnlock;
  TimeOfDay      get notifTime         => _notifTime;
  GroveTheme     get theme             => GroveTheme(mode: _themeMode, dynamicScheme: _dynamicScheme);

  Future<void> init(ColorScheme? dynamicLight, ColorScheme? dynamicDark) async {
    final prefs       = await SharedPreferences.getInstance();
    final savedTheme  = prefs.getInt('theme_mode')   ?? 0;
    final savedLayout = prefs.getInt('layout_mode')  ?? 0;
    final savedHour   = prefs.getInt('notif_hour')   ?? 20;
    final savedMinute = prefs.getInt('notif_minute') ?? 0;
    _onboardingDone    = prefs.getBool('onboarding_done')    ?? false;
    _dailyNotification = prefs.getBool('daily_notification') ?? false;
    _biometricUnlock   = prefs.getBool('biometric_unlock')   ?? false;
    _notifTime         = TimeOfDay(hour: savedHour, minute: savedMinute);
    if (savedTheme  < GroveThemeMode.values.length) _themeMode  = GroveThemeMode.values[savedTheme];
    if (savedLayout < LayoutMode.values.length)     _layoutMode = LayoutMode.values[savedLayout];
    _dynamicScheme = dynamicDark;
    notifyListeners();
  }

  void applyDynamicColors(ColorScheme? light, ColorScheme? dark) {
    _dynamicScheme = dark ?? light;
    notifyListeners();
  }

  Future<void> setDailyNotification(bool value) async {
    _dailyNotification = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_notification', value);
    if (value) {
      await GroveNotifications.instance.scheduleDailyReminder(time: _notifTime);
    } else {
      await GroveNotifications.instance.cancelAll();
    }
    notifyListeners();
  }

  Future<void> setNotifTime(TimeOfDay time) async {
    _notifTime = time;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notif_hour',   time.hour);
    await prefs.setInt('notif_minute', time.minute);
    if (_dailyNotification) {
      await GroveNotifications.instance.scheduleDailyReminder(time: time);
    }
    notifyListeners();
  }

  Future<void> setBiometricUnlock(bool value) async {
    _biometricUnlock = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_unlock', value);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingDone = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    notifyListeners();
  }

  Future<void> setThemeMode(GroveThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
    notifyListeners();
  }

  Future<void> setLayoutMode(LayoutMode mode) async {
    _layoutMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('layout_mode', mode.index);
    notifyListeners();
  }
}

// ══════════════════════════════════════════════════════════════════════
// §2 DATA MODELS  (dormancy fields removed)
// ══════════════════════════════════════════════════════════════════════
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

GrowthStage _stageFromDays(int days) {
  if (days <= 1)  return GrowthStage.seed;
  if (days <= 7)  return GrowthStage.sprout;
  if (days <= 30) return GrowthStage.sapling;
  if (days <= 90) return GrowthStage.youngTree;
  return GrowthStage.groveTree;
}

String _stageLabel(GrowthStage s) => const {
  GrowthStage.seed:      'Seed',
  GrowthStage.sprout:    'Sprout',
  GrowthStage.sapling:   'Sapling',
  GrowthStage.youngTree: 'Young Tree',
  GrowthStage.groveTree: 'Grove Tree',
}[s]!;

String _stageTagline(GrowthStage s) => const {
  GrowthStage.seed:      'Every great forest starts here.',
  GrowthStage.sprout:    'Roots are forming beneath the surface.',
  GrowthStage.sapling:   'Growing stronger with every sunrise.',
  GrowthStage.youngTree: 'Your canopy is taking shape.',
  GrowthStage.groveTree: 'You have become the forest.',
}[s]!;

class HabitTree {
  final String   id;
  final String   name;
  final Color    color;
  final DateTime startDate;
  DateTime       lastReset;
  final List<RelapseEvent> relapses;
  final int      geneticSeed;
  final int?     debugDaysOverride;

  HabitTree({
    required this.id,
    required this.name,
    required this.color,
    required this.startDate,
    required this.lastReset,
    List<RelapseEvent>? relapses,
    int? geneticSeed,
    this.debugDaysOverride,
  }) : relapses    = relapses ?? [],
  geneticSeed = geneticSeed ?? id.hashCode;

  int         get daysElapsed => debugDaysOverride ?? DateTime.now().difference(lastReset).inDays;
  int         get totalDays   => DateTime.now().difference(startDate).inDays;
  GrowthStage get stage       => _stageFromDays(daysElapsed);

  int get peakDays => relapses.isEmpty
  ? daysElapsed
  : math.max(daysElapsed, relapses.map((e) => e.peakDays).reduce(math.max));

  GrowthStage? get shadowStage {
    if (relapses.isEmpty) return null;
    if (daysElapsed < 8)  return null;
    final peak = relapses.first.peakDays;
    if (peak <= daysElapsed) return null;
    return _stageFromDays(peak);
  }

  double get stageProgress {
    final d = daysElapsed;
    if (d <= 1)  return (d / 1).clamp(0.0, 1.0);
    if (d <= 7)  return ((d - 2) / 5.0).clamp(0.0, 1.0);
    if (d <= 30) return ((d - 8) / 22.0).clamp(0.0, 1.0);
    if (d <= 90) return ((d - 31) / 59.0).clamp(0.0, 1.0);
    return 1.0;
  }

  Set<DateTime> get relapseDays => relapses
  .map((e) => DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day))
  .toSet();

  Map<String, dynamic> toMap() => {
    'id':          id,
    'name':        name,
    'color':       color.toARGB32(),
    'startDate':   startDate.toIso8601String(),
    'lastReset':   lastReset.toIso8601String(),
    'relapses':    relapses.map((r) => r.toMap()).toList(),
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

  HabitTree copyWith({int? debugDaysOverride}) => HabitTree(
    id:                id,
    name:              name,
    color:             color,
    startDate:         startDate,
    lastReset:         lastReset,
    relapses:          relapses,
    geneticSeed:       geneticSeed,
    debugDaysOverride: debugDaysOverride ?? this.debugDaysOverride,
  );
}

// ══════════════════════════════════════════════════════════════════════
// §3 GROVE MODEL
// ══════════════════════════════════════════════════════════════════════
class GroveModel extends ChangeNotifier {
  List<HabitTree> _habits = [];
  List<HabitTree> get habits => List.unmodifiable(_habits);

  SharedPreferences? _prefs;
  static const _idsKey = 'grove_v2_ids';

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _load();
    } catch (e) {
      debugPrint('GroveModel init error: $e');
    }
  }

  void _load() {
    if (_prefs == null) return;
    final ids = _prefs!.getStringList(_idsKey) ?? [];
    _habits = ids.map((id) {
      final json = _prefs!.getString(id);
      if (json == null) return null;
      try { return HabitTree.fromJson(json); }
      catch (e) { debugPrint('Failed to parse habit $id: $e'); return null; }
    }).whereType<HabitTree>().toList();
    notifyListeners();
  }

  Future<void> _persist() async {
    if (_prefs == null) return;
    try {
      await _prefs!.setStringList(_idsKey, _habits.map((h) => h.id).toList());
      for (final h in _habits) { await _prefs!.setString(h.id, h.toJson()); }
      await GroveWidgetBridge.instance.requestUpdate();
    } catch (e) { debugPrint('Persist error: $e'); }
  }

  void addHabit({required String name, required Color color, int? debugDays}) {
    final now = DateTime.now();
    _habits.add(HabitTree(
      id:                'habit_${now.millisecondsSinceEpoch}',
      name:              name,
      color:             color,
      startDate:         now,
      lastReset:         now,
      debugDaysOverride: debugDays,
    ));
    _persist();
    notifyListeners();
  }

  void recordCustomRelapse(String habitId, String reason, DateTime customDate) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1) return;
    final target = _habits[i];
    target.relapses.removeWhere((r) =>
    r.timestamp.year  == customDate.year  &&
    r.timestamp.month == customDate.month &&
    r.timestamp.day   == customDate.day);
    target.relapses.add(RelapseEvent(timestamp: customDate, reason: reason));
    target.relapses.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    target.lastReset = target.relapses.isNotEmpty
    ? target.relapses.first.timestamp
    : target.startDate;
    if (target.lastReset.isAfter(DateTime.now())) target.lastReset = DateTime.now();
    _sweepPeaks(target);
    _persist();
    notifyListeners();
  }

  void removeRelapseOnDate(String habitId, DateTime date) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1) return;
    final target = _habits[i];
    target.relapses.removeWhere((r) =>
    r.timestamp.year  == date.year  &&
    r.timestamp.month == date.month &&
    r.timestamp.day   == date.day);
    target.relapses.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    target.lastReset = target.relapses.isNotEmpty
    ? target.relapses.first.timestamp
    : target.startDate;
    if (target.lastReset.isAfter(DateTime.now())) target.lastReset = DateTime.now();
    _sweepPeaks(target);
    _persist();
    notifyListeners();
  }

  void updateStartDate(String habitId, DateTime newStart) {
    final i = _habits.indexWhere((h) => h.id == habitId);
    if (i == -1) return;
    final target = _habits[i];
    if (newStart.isAfter(target.startDate)) return;
    _habits[i] = HabitTree(
      id:          target.id,
      name:        target.name,
      color:       target.color,
      startDate:   newStart,
      lastReset:   target.lastReset,
      relapses:    target.relapses,
      geneticSeed: target.geneticSeed,
    );
    _sweepPeaks(_habits[i]);
    _persist();
    notifyListeners();
  }

  void _sweepPeaks(HabitTree target) {
    int absolutePeak      = 0;
    DateTime sweepPivot   = target.startDate;
    final chronological   = target.relapses.reversed.toList();
    final sweptRelapses   = <RelapseEvent>[];
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
    target.relapses..clear()..addAll(sweptRelapses);
  }

  void deleteHabit(String habitId) {
    _habits.removeWhere((h) => h.id == habitId);
    _prefs?.remove(habitId);
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
      } else { return false; }
      final imported = <HabitTree>[];
      for (final entry in entries) {
        if (entry is Map<String, dynamic>) imported.add(HabitTree.fromMap(entry));
      }
      if (imported.isEmpty) return false;
      _habits = imported;
      await _persist();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('JSON import failed: $e');
      return false;
    }
  }
}

// ══════════════════════════════════════════════════════════════════════
// §4 ENTRY POINT
// ══════════════════════════════════════════════════════════════════════
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await GroveNotifications.instance.init();

  final groveModel      = GroveModel();
  final settingsManager = GroveSettings();
  await groveModel.init();
  await settingsManager.init(null, null);

  if (settingsManager.dailyNotification) {
    await GroveNotifications.instance.scheduleDailyReminder(time: settingsManager.notifTime);
  }

  if (settingsManager.biometricUnlock) {
    final ok = await GroveBiometrics.instance.authenticate();
    if (!ok) {
      SystemNavigator.pop();
      return;
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: groveModel),
        ChangeNotifierProvider.value(value: settingsManager),
      ],
      child: const GroveApp(),
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════
// §5 ROOT APP
// ══════════════════════════════════════════════════════════════════════
class GroveApp extends StatelessWidget {
  const GroveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (lightDynamic != null || darkDynamic != null) {
            context.read<GroveSettings>().applyDynamicColors(lightDynamic, darkDynamic);
          }
        });
        return Consumer<GroveSettings>(
          builder: (_, settings, _) {
            final gt = settings.theme;
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor:                    Colors.transparent,
              statusBarIconBrightness:           gt.brightness == Brightness.light ? Brightness.dark : Brightness.light,
              systemNavigationBarColor:          gt.bg,
              systemNavigationBarIconBrightness: gt.brightness == Brightness.light ? Brightness.dark : Brightness.light,
            ));
            return MaterialApp(
              title:                    'Grove',
              debugShowCheckedModeBanner: false,
              theme:                    _buildTheme(gt),
              home:                     const GroveHomeScreen(),
            );
          },
        );
      },
    );
  }

  ThemeData _buildTheme(GroveTheme gt) {
    final cs = ColorScheme.fromSeed(
      seedColor:  gt.primary,
      brightness: gt.brightness,
    ).copyWith(
      surface:                 gt.surface,
      surfaceContainerHighest: gt.surfaceHigh,
      primary:                 gt.primary,
      secondary:               GroveTheme.barkBrown,
      error:                   GroveTheme.clayRed,
      onSurface:               gt.textPrimary,
      onPrimary:               gt.brightness == Brightness.light ? Colors.white : GroveTheme.dewWhite,
    );
    return ThemeData(
      useMaterial3:            true,
      brightness:              gt.brightness,
      colorScheme:             cs,
      scaffoldBackgroundColor: gt.bg,
      dialogTheme: DialogThemeData(
        backgroundColor: gt.surfaceHigh,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled:    true,
        fillColor: gt.surface,
        border:        OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: gt.textMuted)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: gt.textMuted)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: gt.primary, width: 1.5)),
        labelStyle: TextStyle(color: gt.textSecondary),
        hintStyle:  TextStyle(color: gt.textMuted),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// §6 HOME SCREEN
// ══════════════════════════════════════════════════════════════════════
class GroveHomeScreen extends StatefulWidget {
  const GroveHomeScreen({super.key});
  @override State<GroveHomeScreen> createState() => _GroveHomeScreenState();
}

class _GroveHomeScreenState extends State<GroveHomeScreen> {
  final _scrollCtrl = FixedExtentScrollController();
  late PageController _carouselCtrl;
  int _selectedIdx = 0;

  @override
  void initState() {
    super.initState();
    _carouselCtrl = PageController(viewportFraction: 0.82);
    // Show onboarding once after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = context.read<GroveSettings>();
      if (!settings.onboardingDone) {
        _showOnboarding();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _carouselCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habits   = context.watch<GroveModel>().habits;
    final settings = context.watch<GroveSettings>();
    final theme    = settings.theme;

    return Scaffold(
      backgroundColor:        theme.bg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:       0,
        centerTitle:     true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon:      Icon(Icons.info_outline_rounded, color: theme.textSecondary, size: 20),
            onPressed: () => _showAboutSheet(context),
          ),
        ),
        title: Text(
          'G R O V E',
          style: TextStyle(
            color: theme.textSecondary, fontSize: 13,
            fontWeight: FontWeight.w400, letterSpacing: 8,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon:      Icon(Icons.settings_outlined, color: theme.textSecondary, size: 20),
              onPressed: () => _showSettingsHub(context),
            ),
          ),
        ],
      ),
      body: habits.isEmpty
      ? _emptyState(theme)
      : _buildLayoutEngine(habits, settings.layoutMode, theme),
      floatingActionButton:         _fab(context, theme),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ══════════════════════════════════════════════════════════════
  // ONBOARDING
  // ══════════════════════════════════════════════════════════════
  void _showOnboarding() {
    final settingsProvider = context.read<GroveSettings>();
    showModalBottomSheet(
      context:            context,
      backgroundColor:    Colors.transparent,
      isScrollControlled: true,
      useSafeArea:        true,
      isDismissible:      false,
      enableDrag:         false,
      builder: (_) => const OnboardingSheet(),
    ).then((_) {
      settingsProvider.completeOnboarding();
    });
  }

  // ══════════════════════════════════════════════════════════════
  // ABOUT SHEET
  // ══════════════════════════════════════════════════════════════
  void _showAboutSheet(BuildContext ctx) {
    final theme     = ctx.read<GroveSettings>().theme;
    final bottomPad = MediaQuery.of(ctx).padding.bottom;

    showModalBottomSheet(
      context:            ctx,
      backgroundColor:    theme.surfaceHigh,
      isScrollControlled: true,
      useSafeArea:        true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPad),
        child: Column(
          mainAxisSize:      MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color:        theme.textMuted.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Logo row
            Row(
              children: [
                SizedBox(
                  width: 52, height: 52,
                  child: CustomPaint(
                    painter: FractalTreePainter(
                      stage:       GrowthStage.youngTree,
                      baseColor:   theme.primary,
                      progress:    0.9,
                      windPhase:   0,
                      geneticSeed: 42,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Grove', style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800,
                      color: theme.textPrimary, letterSpacing: 1,
                    )),
                    Text('v0.5.5 • Open Source',
                         style: TextStyle(fontSize: 12, color: theme.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Grove is a mindful habit tracker that visualises your streaks as growing trees. '
            'Every day you stay clean, your tree grows. '
            'Built with love as a free, open-source tool.',
            style: TextStyle(fontSize: 13, color: theme.textSecondary, height: 1.6),
            ),
            const SizedBox(height: 24),
            Text('LINKS', style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700,
              color: theme.textMuted, letterSpacing: 1.0,
            )),
            const SizedBox(height: 12),
            // GitHub
            _AboutLinkTile(
              icon:        Icons.code_rounded,
              iconColor:   theme.textPrimary,
              label:       'GitHub',
              sublabel:    'Source code & contributions',
              url:         'https://github.com/resurrectdev1/Grove',
              theme:       theme,
            ),
            const SizedBox(height: 10),
            // Buy Me a Coffee link
            _AboutLinkTile(
              icon:        Icons.coffee_rounded,
              iconColor:   const Color(0xFFFFDD57),
              label:       'Buy Me a Coffee',
              sublabel:    'Support development',
              url:         'https://buymeacoffee.com/resurrect',
              theme:       theme,
            ),
            const SizedBox(height: 24),
            Text(
              'Made with 🌿 — all data stays on your device.',
              style:     TextStyle(fontSize: 10, color: theme.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // LAYOUT ENGINE (unchanged)
  // ══════════════════════════════════════════════════════════════
  Widget _buildLayoutEngine(List<HabitTree> habits, LayoutMode mode, GroveTheme theme) {
    switch (mode) {
      case LayoutMode.verticalWheel:      return _buildVerticalWheel(habits, theme);
      case LayoutMode.horizontalCarousel: return _buildHorizontalCarousel(habits, theme);
      case LayoutMode.compactGrid:        return _buildCompactGrid(habits, theme);
      case LayoutMode.compactList:        return _buildCompactList(habits, theme);
    }
  }

  Widget _buildVerticalWheel(List<HabitTree> habits, GroveTheme theme) => Stack(
    children: [
      ListWheelScrollView.useDelegate(
        controller:   _scrollCtrl,
        itemExtent:   390,
        diameterRatio: 2.4,
        perspective:  0.0025,
        physics:      const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (i) {
          setState(() => _selectedIdx = i);
          HapticFeedback.selectionClick();
        },
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: habits.length,
          builder:    (ctx, i) => HabitCard(
            habit:      habits[i],
            isSelected: i == _selectedIdx,
            layoutMode: LayoutMode.verticalWheel,
          ),
        ),
      ),
      _fade(theme, top: true),
      _fade(theme, top: false),
    ],
  );

  Widget _buildHorizontalCarousel(List<HabitTree> habits, GroveTheme theme) =>
  PageView.builder(
    controller:    _carouselCtrl,
    physics:       const BouncingScrollPhysics(),
    onPageChanged: (i) {
      setState(() => _selectedIdx = i);
      HapticFeedback.selectionClick();
    },
    itemCount:   habits.length,
    itemBuilder: (ctx, i) => AnimatedBuilder(
      animation: _carouselCtrl,
      builder:   (ctx, child) {
        double value = 1.0;
        if (_carouselCtrl.position.haveDimensions) {
          value = _carouselCtrl.page! - i;
          value = (1 - (value.abs() * 0.15)).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(height: Curves.easeOut.transform(value) * 440, child: child),
        );
      },
      child: HabitCard(
        habit:      habits[i],
        isSelected: i == _selectedIdx,
        layoutMode: LayoutMode.horizontalCarousel,
      ),
    ),
  );

  Widget _buildCompactGrid(List<HabitTree> habits, GroveTheme theme) => SafeArea(
    bottom: false,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics:  const BouncingScrollPhysics(),
        padding:  const EdgeInsets.only(top: 16, bottom: 120),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.72,
          crossAxisSpacing: 12, mainAxisSpacing: 12,
        ),
        itemCount:   habits.length,
        itemBuilder: (ctx, i) => HabitCard(
          habit:      habits[i],
          isSelected: true,
          layoutMode: LayoutMode.compactGrid,
        ),
      ),
    ),
  );

  Widget _buildCompactList(List<HabitTree> habits, GroveTheme theme) => SafeArea(
    bottom: false,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        physics:     const BouncingScrollPhysics(),
        padding:     const EdgeInsets.only(top: 16, bottom: 120),
        itemCount:   habits.length,
        itemBuilder: (ctx, i) => HabitCard(
          habit:      habits[i],
          isSelected: true,
          layoutMode: LayoutMode.compactList,
        ),
      ),
    ),
  );

  // ── Settings hub ──────────────────────────────────────────────
  void _showSettingsHub(BuildContext ctx) {
    final settings  = ctx.read<GroveSettings>();
    final model     = ctx.read<GroveModel>();
    final bottomPad = MediaQuery.of(ctx).padding.bottom;

    showModalBottomSheet(
      context:            ctx,
      backgroundColor:    settings.theme.surfaceHigh,
      isScrollControlled: true,
      useSafeArea:        true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPad),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize:      MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                    color:        settings.theme.textMuted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Settings Hub', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: settings.theme.textPrimary)),
                const SizedBox(height: 24),
                Text('LAYOUT ARCHITECTURE', style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  color: settings.theme.textSecondary, letterSpacing: 1.0)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _LayoutButton(label: 'Wheel',    icon: Icons.view_day,
                                    isSelected: settings.layoutMode == LayoutMode.verticalWheel, theme: settings.theme,
                                    onTap: () { settings.setLayoutMode(LayoutMode.verticalWheel); HapticFeedback.selectionClick(); Navigator.pop(ctx); }),
                                    const SizedBox(width: 8),
                                    _LayoutButton(label: 'Carousel', icon: Icons.view_carousel,
                                                  isSelected: settings.layoutMode == LayoutMode.horizontalCarousel, theme: settings.theme,
                                                  onTap: () { settings.setLayoutMode(LayoutMode.horizontalCarousel); HapticFeedback.selectionClick(); Navigator.pop(ctx); }),
                                                  const SizedBox(width: 8),
                                                  _LayoutButton(label: 'Grid',     icon: Icons.grid_view,
                                                                isSelected: settings.layoutMode == LayoutMode.compactGrid, theme: settings.theme,
                                                                onTap: () { settings.setLayoutMode(LayoutMode.compactGrid); HapticFeedback.selectionClick(); Navigator.pop(ctx); }),
                                                                const SizedBox(width: 8),
                                                                _LayoutButton(label: 'List',     icon: Icons.list,
                                                                              isSelected: settings.layoutMode == LayoutMode.compactList, theme: settings.theme,
                                                                              onTap: () { settings.setLayoutMode(LayoutMode.compactList); HapticFeedback.selectionClick(); Navigator.pop(ctx); }),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text('RENDER THEMES', style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    color: settings.theme.textSecondary, letterSpacing: 1.0)),
                    const SizedBox(height: 8),
                    RadioGroup<GroveThemeMode>(
                      groupValue: settings.themeMode,
                      onChanged: (val) {
                        if (val != null) settings.setThemeMode(val);
                        HapticFeedback.selectionClick();
                        Navigator.pop(ctx);
                      },
                      child: Column(
                      children: GroveThemeMode.values.map((mode) {
                        const labels = {
                          GroveThemeMode.forestDark:   'Forest Dark',
                          GroveThemeMode.amoledBlack:  'AMOLED Black',
                          GroveThemeMode.materialYou:  'Material You',
                          GroveThemeMode.whiteMinimal: 'White Minimal',
                        };
                        return RadioListTile<GroveThemeMode>(
                          value:          mode,
                          activeColor:    settings.theme.primary,
                          contentPadding: EdgeInsets.zero,
                          title: Text(labels[mode]!, style: TextStyle(color: settings.theme.textPrimary)),
                        );
                      }).toList(),
                    ),
                    ),
                    const Divider(height: 32),
                    Text('PRIVACY & NOTIFICATIONS', style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700,
                      color: settings.theme.textSecondary, letterSpacing: 1.0)),
                      const SizedBox(height: 4),
                      // Daily Reminder toggle
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Daily Reminder',
                                    style: TextStyle(color: settings.theme.textPrimary, fontSize: 14)),
                                    subtitle: Text('Nudge each day to keep your streak',
                                                   style: TextStyle(color: settings.theme.textMuted, fontSize: 11)),
                                                   activeThumbColor: settings.theme.primary,
                                     value:       settings.dailyNotification,
                                     onChanged: (val) async {
                                       HapticFeedback.selectionClick();
                                       await settings.setDailyNotification(val);
                                     },
                      ),
                      if (settings.dailyNotification)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(children: [
                            Icon(Icons.access_time_rounded, size: 16,
                                 color: settings.theme.textMuted),
                                 const SizedBox(width: 8),
                                 Text('Reminder time',
                                      style: TextStyle(fontSize: 13,
                                                       color: settings.theme.textSecondary)),
                                     const Spacer(),
                                     GestureDetector(
                                       onTap: () async {
                                         final picked = await showTimePicker(
                                           context: sheetCtx,
                                           initialTime: settings.notifTime,
                                         );
                                         if (picked != null) {
                                           HapticFeedback.selectionClick();
                                           await settings.setNotifTime(picked);
                                         }
                                       },
                                       child: Container(
                                         padding: const EdgeInsets.symmetric(
                                           horizontal: 14, vertical: 7),
                                           decoration: BoxDecoration(
                                             color: settings.theme.primary
                                             .withValues(alpha: 0.12),
                                             borderRadius: BorderRadius.circular(10),
                                             border: Border.all(
                                               color: settings.theme.primary
                                               .withValues(alpha: 0.3)),
                                           ),
                                           child: Text(
                                             settings.notifTime.format(sheetCtx),
                                             style: TextStyle(
                                               fontSize: 14,
                                               fontWeight: FontWeight.w600,
                                               color: settings.theme.primary),
                                           ),
                                       ),
                                     ),
                          ]),
                        ),
                        FutureBuilder<bool>(
                          future: GroveBiometrics.instance.isAvailable,
                          builder: (_, snap) {
                            final available = snap.data ?? false;
                            if (!available) return const SizedBox.shrink();
                            return SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Biometric Unlock',
                                          style: TextStyle(color: settings.theme.textPrimary, fontSize: 14)),
                                          subtitle: Text('Require fingerprint / Face ID to open Grove',
                                                         style: TextStyle(color: settings.theme.textMuted, fontSize: 11)),
                                                         activeThumbColor: settings.theme.primary,
                                                  value:       settings.biometricUnlock,
                                                  onChanged: (val) async {
                                                    HapticFeedback.selectionClick();
                                                    if (val) {
                                                      final ok = await GroveBiometrics.instance.authenticate();
                                                      if (!ok) return;
                                                    }
                                                    await settings.setBiometricUnlock(val);
                                                  },
                            );
                          },
                        ),
                        const Divider(height: 32),
                        Text('DATA MANAGEMENT', style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          color: settings.theme.textSecondary, letterSpacing: 1.0)),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () => _showExportSheet(ctx, model, settings),
                          icon:  const Icon(Icons.upload_outlined, size: 16),
                          label: const Text('Export Grove Backup'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: settings.theme.textPrimary,
                              side:    BorderSide(color: settings.theme.textMuted.withValues(alpha: 0.4)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape:   RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () => _showImportSheet(ctx, model, settings),
                          icon:  const Icon(Icons.download_outlined, size: 16),
                          label: const Text('Restore Grove from Backup'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: settings.theme.textPrimary,
                              side:    BorderSide(color: settings.theme.textMuted.withValues(alpha: 0.4)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape:   RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Exports all trees, relapse history, and streak records.\nImporting will replace your current grove — back up first.',
                          style:     TextStyle(fontSize: 10, color: settings.theme.textMuted, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExportSheet(BuildContext ctx, GroveModel model, GroveSettings settings) {
    final json   = model.exportJson();
    final theme  = settings.theme;
    final copied = ValueNotifier<bool>(false);

    showModalBottomSheet(
      context: ctx, backgroundColor: theme.surfaceHigh,
      isScrollControlled: true, useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(sheetCtx).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(width: 36, height: 4,
                                    decoration: BoxDecoration(color: theme.textMuted.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)))),
                                    const SizedBox(height: 20),
                                    Row(children: [
                                      Container(width: 40, height: 40,
                                                decoration: BoxDecoration(color: theme.primary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                                                child: Icon(Icons.upload_outlined, color: theme.primary, size: 20)),
                                                const SizedBox(width: 12),
                                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  Text('Grove Backup', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: theme.textPrimary)),
                                                  Text('${model.habits.length} tree${model.habits.length != 1 ? 's' : ''} · ${DateFormat('MMM d, yyyy').format(DateTime.now())}',
                                                  style: TextStyle(fontSize: 12, color: theme.textSecondary)),
                                                ])),
                                    ]),
                      const SizedBox(height: 20),
                      Container(
                        height: 140, padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: theme.textMuted.withValues(alpha: 0.2))),
                        child: SingleChildScrollView(child: SelectableText(json,
                                                                           style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: theme.textSecondary, height: 1.5))),
                      ),
                      const SizedBox(height: 8),
                      Text('${json.length} characters · Select all to copy manually',
                           style: TextStyle(fontSize: 10, color: theme.textMuted), textAlign: TextAlign.center),
                           const SizedBox(height: 20),
                           ValueListenableBuilder<bool>(
                             valueListenable: copied,
                             builder: (_, isCopied, _) => FilledButton.icon(
                               onPressed: () async {
                                 await Clipboard.setData(ClipboardData(text: json));
                                 copied.value = true;
                                 HapticFeedback.lightImpact();
                                 Future.delayed(const Duration(seconds: 3), () => copied.value = false);
                               },
                               icon:  Icon(isCopied ? Icons.check_rounded : Icons.copy_rounded, size: 18),
                               label: Text(isCopied ? 'Copied to Clipboard!' : 'Copy to Clipboard',
                                           style: const TextStyle(fontWeight: FontWeight.w600)),
                                           style: FilledButton.styleFrom(
                                             backgroundColor: isCopied ? GroveTheme.mossGreen : theme.primary,
                                             minimumSize: const Size.fromHeight(52),
                                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                           ),
                             ),
                           ),
          ],
        ),
      ),
    );
  }

  void _showImportSheet(BuildContext ctx, GroveModel model, GroveSettings settings) {
    final theme      = settings.theme;
    final controller = TextEditingController();
    final isPasting  = ValueNotifier<bool>(false);

    showModalBottomSheet(
      context: ctx, backgroundColor: theme.surfaceHigh,
      isScrollControlled: true, useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24,
                                     24 + math.max(MediaQuery.of(sheetCtx).viewInsets.bottom, MediaQuery.of(sheetCtx).padding.bottom)),
                                     child: Column(
                                       mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch,
                                       children: [
                                         Center(child: Container(width: 36, height: 4,
                                                                 decoration: BoxDecoration(color: theme.textMuted.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)))),
                                                                 const SizedBox(height: 20),
                                                                 Row(children: [
                                                                   Container(width: 40, height: 40,
                                                                             decoration: BoxDecoration(color: GroveTheme.barkBrown.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                                                                             child: const Icon(Icons.download_outlined, color: GroveTheme.barkBrown, size: 20)),
                                                                             const SizedBox(width: 12),
                                                                             Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                               Text('Restore Grove', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: theme.textPrimary)),
                                                                               Text('Paste your JSON backup below', style: TextStyle(fontSize: 12, color: theme.textSecondary)),
                                                                             ])),
                                                                 ]),
                                                   const SizedBox(height: 16),
                                                   Container(
                                                     padding: const EdgeInsets.all(12),
                                                     decoration: BoxDecoration(color: GroveTheme.clayRed.withValues(alpha: 0.08),
                                                     borderRadius: BorderRadius.circular(12),
                                                     border: Border.all(color: GroveTheme.clayRed.withValues(alpha: 0.25))),
                                                     child: Row(children: [
                                                       const Icon(Icons.warning_amber_rounded, size: 16, color: GroveTheme.clayRed),
                                                       const SizedBox(width: 8),
                                                       Expanded(child: Text('This will replace your current grove. Export a backup first if needed.',
                                                                            style: TextStyle(fontSize: 11, color: theme.textSecondary, height: 1.4))),
                                                     ]),
                                                   ),
                                                   const SizedBox(height: 16),
                                                   OutlinedButton.icon(
                                                     onPressed: () async {
                                                       final data = await Clipboard.getData('text/plain');
                                                       if (data?.text != null) { controller.text = data!.text!; isPasting.value = true; HapticFeedback.selectionClick(); }
                                                     },
                                                     icon: const Icon(Icons.content_paste_rounded, size: 16),
                                                     label: const Text('Paste from Clipboard'),
                                                     style: OutlinedButton.styleFrom(
                                                       foregroundColor: theme.primary,
                                                         side: BorderSide(color: theme.primary.withValues(alpha: 0.5)),
                                                         padding: const EdgeInsets.symmetric(vertical: 12),
                                                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                     ),
                                                   ),
                                                   const SizedBox(height: 12),
                                                   ValueListenableBuilder<bool>(
                                                     valueListenable: isPasting,
                                                     builder: (_, hasPasted, _) => TextField(
                                                       controller: controller, minLines: hasPasted ? 4 : 2, maxLines: hasPasted ? 6 : 4,
                                                       style: TextStyle(color: theme.textPrimary, fontSize: 12, fontFamily: 'monospace'),
                                                       onChanged: (_) { if (!isPasting.value) isPasting.value = controller.text.isNotEmpty; },
                                                       decoration: InputDecoration(
                                                         hintText: 'Or type / paste your Grove JSON backup here…',
                                                         hintStyle: TextStyle(color: theme.textMuted, fontSize: 12),
                                                         contentPadding: const EdgeInsets.all(12),
                                                       ),
                                                     ),
                                                   ),
                                                   const SizedBox(height: 20),
                                                   FilledButton.icon(
                                                     onPressed: () async {
                                                       if (controller.text.trim().isEmpty) {
                                                         ScaffoldMessenger.of(sheetCtx).showSnackBar(const SnackBar(
                                                           content: Text('Nothing to import — paste your JSON first'),
                                                           backgroundColor: GroveTheme.clayRed, behavior: SnackBarBehavior.floating));
                                                         return;
                                                       }
                                                       final success = await model.importFromJson(controller.text);
                                                       controller.dispose();
                                                       if (!sheetCtx.mounted) return;
                                                       Navigator.pop(sheetCtx); Navigator.pop(sheetCtx);
                                                       if (ctx.mounted) {
                                                         ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                                                           content: Text(success
                                                           ? '✓ Grove restored — ${model.habits.length} trees loaded'
                                                           : '✗ Invalid backup — check the JSON and try again'),
                                                           backgroundColor: success ? theme.primary : GroveTheme.clayRed,
                                                           behavior: SnackBarBehavior.floating));
                                                       }
                                                     },
                                                     icon:  const Icon(Icons.restore_rounded, size: 18),
                                                     label: const Text('Restore Grove', style: TextStyle(fontWeight: FontWeight.w600)),
                                                     style: FilledButton.styleFrom(
                                                       backgroundColor: GroveTheme.barkBrown,
                                                       minimumSize: const Size.fromHeight(52),
                                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                     ),
                                                   ),
                                       ],
                                     ),
      ),
    );
  }

  Widget _emptyState(GroveTheme theme) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 110, height: 110,
          child: CustomPaint(
            painter: FractalTreePainter(
              stage: GrowthStage.sprout, baseColor: theme.textMuted,
              progress: 0.6, windPhase: 0, geneticSeed: 0, daysElapsed: 4,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text('Your grove is bare.',
             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300,
                              color: theme.textMuted, letterSpacing: 0.5)),
                              const SizedBox(height: 8),
                              Text('Plant your first tree to begin.',
                                   style: TextStyle(fontSize: 13, color: theme.textMuted)),
                                   const SizedBox(height: 120),
      ],
    ),
  );

  Widget _fade(GroveTheme theme, {required bool top}) => Positioned(
    top: top ? 0 : null, bottom: top ? null : 0, left: 0, right: 0, height: 130,
    child: IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin:  top ? Alignment.topCenter    : Alignment.bottomCenter,
            end:    top ? Alignment.bottomCenter : Alignment.topCenter,
            colors: [theme.bg, theme.bg.withValues(alpha: 0)],
          ),
        ),
      ),
    ),
  );

  Widget _fab(BuildContext context, GroveTheme theme) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: FloatingActionButton.extended(
      onPressed: () => showModalBottomSheet(
        context: context, isScrollControlled: true,
        backgroundColor: theme.surfaceHigh, useSafeArea: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        builder: (_) => const AddHabitSheet(),
      ),
      backgroundColor: theme.primary,
      foregroundColor: theme.brightness == Brightness.light ? Colors.white : GroveTheme.dewWhite,
        icon:  const Icon(Icons.forest_rounded),
        label: const Text('Plant a Tree', style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════
// §6a ABOUT — link tile helper
// ══════════════════════════════════════════════════════════════════════
class _AboutLinkTile extends StatelessWidget {
  final IconData icon;
  final Color    iconColor;
  final String   label;
  final String   sublabel;
  final String   url;
  final GroveTheme theme;

  const _AboutLinkTile({
    required this.icon, required this.iconColor,
    required this.label, required this.sublabel,
    required this.url, required this.theme,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color:        theme.surface,
          borderRadius: BorderRadius.circular(14),
          border:       Border.all(color: theme.textMuted.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color:        iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: theme.textPrimary)),
                    Text(sublabel, style: TextStyle(fontSize: 11, color: theme.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.open_in_new_rounded, size: 16, color: theme.textMuted),
          ],
        ),
      ),
    ),
  );
}

class _LayoutButton extends StatelessWidget {
  final String label; final IconData icon; final bool isSelected;
  final VoidCallback onTap; final GroveTheme theme;
  const _LayoutButton({required this.label, required this.icon, required this.isSelected, required this.onTap, required this.theme});

  @override
  Widget build(BuildContext context) => Expanded(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:  const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:        isSelected ? theme.primary : theme.surface,
            borderRadius: BorderRadius.circular(12),
            border:       Border.all(color: isSelected ? theme.primary : theme.textMuted.withValues(alpha: 0.3)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : theme.textSecondary),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                                         color: isSelected ? Colors.white : theme.textPrimary)),
          ]),
        ),
      ),
    ),
  );
}

// ════════════════════════════════════════════════════════════════════
// §7 HABIT CARD  (dormancy icons removed)
// ════════════════════════════════════════════════════════════════════
class HabitCard extends StatefulWidget {
  final HabitTree  habit;
  final bool       isSelected;
  final LayoutMode layoutMode;
  const HabitCard({super.key, required this.habit, required this.isSelected, required this.layoutMode});
  @override State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  double _dragOffset = 0;
  bool   _isPruning  = false;

  @override
  Widget build(BuildContext context) {
    final model        = context.read<GroveModel>();
    final settings     = context.watch<GroveSettings>();
    final theme        = settings.theme;
    final days         = widget.habit.daysElapsed;
    final stage        = widget.habit.stage;
    final relapseCount = widget.habit.relapses.length;
    final isCompact    = widget.layoutMode == LayoutMode.compactGrid;
    final isList       = widget.layoutMode == LayoutMode.compactList;

    final dissolveOpacity = 1.0 - (_dragOffset.abs() / 300).clamp(0.0, 1.0);
    final dissolveScale   = 1.0 - (_dragOffset.abs() / 600).clamp(0.0, 0.3);

    if (isList) {
      return GestureDetector(
        onLongPressStart:      (_) => setState(() => _isPruning = true),
        onLongPressMoveUpdate: _isPruning ? (d) => setState(() => _dragOffset = d.offsetFromOrigin.dx) : null,
        onLongPressEnd: (_) {
          if (_dragOffset.abs() > 200) { model.deleteHabit(widget.habit.id); HapticFeedback.heavyImpact(); }
          setState(() { _isPruning = false; _dragOffset = 0; });
        },
        child: Opacity(
          opacity: 1.0 - (_dragOffset.abs() / 300).clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.cardBg, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: widget.habit.color.withValues(alpha: 0.3)),
              ),
              child: Row(children: [
                GestureDetector(
                  onTap: () => _goDetail(context),
                  child: SizedBox(width: 60, height: 60, child: AnimatedTreeWidget(habit: widget.habit)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.habit.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: theme.textPrimary)),
                       const SizedBox(height: 4),
                       Row(children: [
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                           decoration: BoxDecoration(
                             color: widget.habit.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                             child: Text(_stageLabel(stage),
                             style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: widget.habit.color)),
                         ),
                         const SizedBox(width: 6),
                         Text('Day $days', style: TextStyle(fontSize: 12, color: theme.textSecondary)),
                       ]),
                ])),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showRelapseDialog(context, model),
                  child: const Icon(Icons.refresh_rounded, size: 20, color: GroveTheme.clayRed),
                ),
              ]),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onLongPressStart:      (_) => setState(() => _isPruning = true),
      onLongPressMoveUpdate: _isPruning ? (d) => setState(() => _dragOffset = d.offsetFromOrigin.dx) : null,
      onLongPressEnd: (_) {
        if (_dragOffset.abs() > 200) { model.deleteHabit(widget.habit.id); HapticFeedback.heavyImpact(); }
        setState(() { _isPruning = false; _dragOffset = 0; });
      },
      child: Opacity(
        opacity: dissolveOpacity,
        child: Transform.scale(
          scale: dissolveScale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic,
            margin:   isCompact ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
            padding:  EdgeInsets.all(isCompact ? 12 : 0),
            decoration: BoxDecoration(
              color:        theme.cardBg,
              borderRadius: BorderRadius.circular(isCompact ? 22 : 28),
              border: Border.all(
                color: widget.isSelected ? widget.habit.color.withValues(alpha: 0.45) : theme.surfaceHigh,
                width: widget.isSelected ? 1.5 : 1.0,
              ),
              boxShadow: widget.isSelected && !isCompact
              ? [BoxShadow(color: widget.habit.color.withValues(alpha: 0.18), blurRadius: 32, spreadRadius: 2)]
              : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _goDetail(context),
                  child: Hero(
                    tag: 'tree_${widget.habit.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width:  isCompact ? 100 : 175,
                        height: isCompact ? 100 : 175,
                        child:  AnimatedTreeWidget(habit: widget.habit),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isCompact ? 8 : 10),
                Text(widget.habit.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                     style: TextStyle(fontSize: isCompact ? 15 : 22, fontWeight: FontWeight.w700,
                                      color: theme.textPrimary, letterSpacing: 0.3)),
                          SizedBox(height: isCompact ? 4 : 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!isCompact) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: widget.habit.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                                    child: Text(_stageLabel(stage), style: TextStyle(
                                      fontSize: 11, fontWeight: FontWeight.w600, color: widget.habit.color, letterSpacing: 0.8)),
                                ),
                              const SizedBox(width: 8),
                              ],
                              Text('Day $days', style: TextStyle(
                                fontSize:   isCompact ? 11 : 13,
                                fontWeight: isCompact ? FontWeight.w600 : FontWeight.normal,
                                color:      theme.textSecondary)),
                            ],
                          ),
                          if (!isCompact) ...[
                            const SizedBox(height: 4),
                            Text(_stageTagline(stage),
                            style: TextStyle(fontSize: 11, color: theme.textMuted, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _OutlineAction(icon: Icons.calendar_month_outlined,
                                             label: 'History${relapseCount > 0 ? ' ($relapseCount)' : ''}',
                                             color: theme.textSecondary, onTap: () => _goDetail(context)),
                                             const SizedBox(width: 10),
                                             _OutlineAction(icon: Icons.refresh_rounded, label: 'Relapse',
                                                            color: GroveTheme.clayRed, onTap: () => _showRelapseDialog(context, model)),
                            ],
                          ),
                          ] else ...[
                            const SizedBox(height: 12),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                              IconButton(icon: Icon(Icons.calendar_month_outlined, size: 16, color: theme.textSecondary),
                              onPressed: () => _goDetail(context), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                              IconButton(icon: const Icon(Icons.refresh_rounded, size: 16, color: GroveTheme.clayRed),
                              onPressed: () => _showRelapseDialog(context, model), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                            ]),
                          ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goDetail(BuildContext ctx) => Navigator.push(ctx,
  PageRouteBuilder(
    pageBuilder: (_, anim, _) => FadeTransition(opacity: anim, child: HabitDetailScreen(habitId: widget.habit.id)),
    transitionDuration: const Duration(milliseconds: 400),
  ),
  );

  void _showRelapseDialog(BuildContext ctx, GroveModel model) => showDialog(
    context: ctx,
    builder: (_) => RelapseDialog(
      habitName: widget.habit.name,
      onCustomRelapseConfirm: (reason, date) {
        model.recordCustomRelapse(widget.habit.id, reason, date);
        HapticFeedback.mediumImpact();
      },
    ),
  );
}

class _OutlineAction extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _OutlineAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(border: Border.all(color: color.withValues(alpha: 0.35)), borderRadius: BorderRadius.circular(22)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color), const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
      ]),
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════
// §8 ANIMATED TREE ENGINE  (dormancy removed)
// ══════════════════════════════════════════════════════════════════════
class AnimatedTreeWidget extends StatefulWidget {
  final HabitTree habit;
  const AnimatedTreeWidget({super.key, required this.habit});
  @override State<AnimatedTreeWidget> createState() => _AnimatedTreeWidgetState();
}

class _AnimatedTreeWidgetState extends State<AnimatedTreeWidget>
with SingleTickerProviderStateMixin {
  late AnimationController _windController;

  @override
  void initState() {
    super.initState();
    _windController = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
  }

  @override
  void dispose() { _windController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _windController,
    builder: (_, _) => CustomPaint(
      painter: FractalTreePainter(
        stage:       widget.habit.stage,
        baseColor:   widget.habit.color,
        progress:    widget.habit.stageProgress,
        windPhase:   _windController.value * 2 * math.pi,
        daysElapsed: widget.habit.daysElapsed,
        geneticSeed: widget.habit.geneticSeed,
        shadowStage: widget.habit.shadowStage,
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────
// FractalTreePainter  (dormancy parameters removed)
// ─────────────────────────────────────────────────────────────────────
class FractalTreePainter extends CustomPainter {
  final GrowthStage  stage;
  final Color        baseColor;
  final double       progress;
  final double       windPhase;
  final int          daysElapsed;
  final int          geneticSeed;
  final GrowthStage? shadowStage;

  const FractalTreePainter({
    required this.stage,
    required this.baseColor,
    required this.progress,
    this.windPhase    = 0,
    this.daysElapsed  = 0,
    this.geneticSeed  = 0,
    this.shadowStage,
  });

  int get _maxDepth {
    switch (stage) {
      case GrowthStage.seed:      return 0;
      case GrowthStage.sprout:    return 2;
      case GrowthStage.sapling:   return 3;
      case GrowthStage.youngTree: return 4;
      case GrowthStage.groveTree: return 5;
    }
  }

  int get _shadowDepth {
    if (shadowStage == null) return 0;
    switch (shadowStage!) {
      case GrowthStage.seed:      return 0;
      case GrowthStage.sprout:    return 2;
      case GrowthStage.sapling:   return 3;
      case GrowthStage.youngTree: return 4;
      case GrowthStage.groveTree: return 5;
    }
  }

  double get _leafDensity {
    if (daysElapsed <= 20) return 0.0;
    if (daysElapsed <= 50) return ((daysElapsed - 20) / 30.0).clamp(0.0, 1.0);
    return 1.0;
  }

  Color get _activeColor => baseColor;

  Color get _barkColor {
    final hsl = HSLColor.fromColor(_activeColor);
    return hsl.withLightness((hsl.lightness * 0.45).clamp(0.0, 1.0))
    .withSaturation((hsl.saturation * 0.6).clamp(0.0, 1.0))
    .toColor();
  }

  Color get _leafColor {
    final hsl = HSLColor.fromColor(_activeColor);
    return hsl.withLightness((hsl.lightness * 1.15).clamp(0.0, 1.0))
    .withSaturation((hsl.saturation * 1.2).clamp(0.0, 1.0))
    .toColor();
  }

  Color get _leafHighlight {
    final hsl = HSLColor.fromColor(_activeColor);
    return hsl.withLightness((hsl.lightness * 1.40).clamp(0.0, 1.0))
    .withSaturation((hsl.saturation * 0.8).clamp(0.0, 1.0))
    .toColor();
  }

  double _genetic(String key) {
    final hash = ((geneticSeed.abs() + key.hashCode.abs()) % 1000);
    return (hash / 1000.0) * 0.2 - 0.1;
  }

  double _geneticPositive(String key, {double scale = 1.0}) {
    final hash = ((geneticSeed.abs() + key.hashCode.abs()) % 1000);
    return (hash / 1000.0) * scale;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (stage == GrowthStage.groveTree || (stage == GrowthStage.youngTree && progress > 0.6)) {
      _drawAmbientSpores(canvas, size);
    }
    if (shadowStage != null && _shadowDepth > _maxDepth) {
      _drawTree(canvas: canvas, size: size,
                color: GroveTheme.slateGrey.withValues(alpha: 0.08), maxDepth: _shadowDepth, isShadow: true);
    }
    if (stage == GrowthStage.seed) { _drawSeed(canvas, size); return; }
    _drawTree(canvas: canvas, size: size, color: _activeColor, maxDepth: _maxDepth, isShadow: false);
  }

  void _drawAmbientSpores(Canvas canvas, Size size) {
    final sporeCount = 8 + (geneticSeed.abs() % 8);
    final paint      = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < sporeCount; i++) {
      final seedOffset = ((geneticSeed.abs() + i * 53) % 100);
      final speed      = 0.4 + (seedOffset % 6) * 0.18;
      final basePhase  = (windPhase * speed + seedOffset * 0.063) % (math.pi * 2);
      final rawY       = (1.0 - basePhase / (math.pi * 2)) * size.height;
      final xDrift     = math.sin(basePhase * 1.7 + seedOffset * 0.1) * 22.0;
      final x          = size.width * 0.15 + (seedOffset / 100.0) * size.width * 0.7 + xDrift;
      final fadeY      = math.sin((rawY / size.height).clamp(0.0, 1.0) * math.pi);
      final opacity    = (0.35 * fadeY).clamp(0.0, 1.0);
      final radius     = 1.2 + (seedOffset % 3) * 0.5;
      paint.color = GroveTheme.goldenLich.withValues(alpha: opacity);
      canvas.drawCircle(Offset(x, rawY), radius, paint);
      paint.color = GroveTheme.goldenLich.withValues(alpha: opacity * 0.3);
      canvas.drawCircle(Offset(x, rawY), radius * 2.5, paint);
    }
  }

  void _drawTree({required Canvas canvas, required Size size,
    required Color color, required int maxDepth, required bool isShadow}) {
    final gx       = size.width  * 0.5;
    final gy       = size.height * 0.93;
    final trunkLen = size.height * _lerpD(0.28, 0.44, progress);
    final spread   = _lerpD(0.30, 0.52, progress) * (1.0 + _genetic('spread'));
    final lenRatio = _lerpD(0.66, 0.73, progress) * (1.0 + _genetic('ratio'));
    final trunkW   = _lerpD(5.0, 9.0, progress);

    if (!isShadow && maxDepth >= 2) {
      _drawRootFlare(canvas, Offset(gx, gy), trunkW, color);
    }
    _drawBranch(
      canvas: canvas, start: Offset(gx, gy),
      angle: -math.pi / 2, length: trunkLen, depth: maxDepth, maxDepth: maxDepth,
      spreadAngle: spread, lengthRatio: lenRatio, strokeWidth: trunkW,
      depthFromTip: maxDepth, color: color, isShadow: isShadow, isMainTrunk: true,
    );
    }

    void _drawRootFlare(Canvas canvas, Offset base, double trunkWidth, Color color) {
      final barkC  = _barkColor;
      final flareR = trunkWidth * 1.8;
      canvas.drawOval(
        Rect.fromCenter(center: base.translate(0, 3), width: flareR * 3.2, height: flareR * 0.9),
        Paint()..color = Colors.black.withValues(alpha: 0.18)..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      canvas.drawOval(
        Rect.fromCenter(center: base, width: flareR * 2.4, height: flareR * 1.1),
        Paint()..color = barkC.withValues(alpha: 0.85)..style = PaintingStyle.fill,
      );
      final linePaint = Paint()..color = _activeColor.withValues(alpha: 0.25)..strokeWidth = 0.8
      ..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
      for (int i = 0; i < 3; i++) {
        final ox = (i - 1) * flareR * 0.55;
        canvas.drawLine(Offset(base.dx + ox, base.dy - flareR * 0.2),
        Offset(base.dx + ox * 1.4, base.dy + flareR * 0.3), linePaint);
      }
    }

    void _drawBranch({
      required Canvas canvas, required Offset start,
      required double angle, required double length,
      required int depth, required int maxDepth,
      required double spreadAngle, required double lengthRatio,
      required double strokeWidth, required int depthFromTip,
      required Color color, required bool isShadow, bool isMainTrunk = false,
    }) {
      double windOffset = 0;
      if (!isShadow && depthFromTip <= 3 && windPhase > 0) {
        final windStrength = (1.0 - depthFromTip / 4.0) * 0.045;
        windOffset = math.sin(windPhase + depthFromTip * 0.9 + _genetic('wind') * math.pi) * windStrength;
      }
      final adjustedAngle = angle + windOffset + _genetic('angle_$depth') * 0.13;
      final tip = Offset(
        start.dx + length * math.cos(adjustedAngle),
        start.dy + length * math.sin(adjustedAngle),
      );
      final depthRatio    = maxDepth > 0 ? depth / maxDepth : 1.0;
      final branchOpacity = _lerpD(0.60, 0.98, depthRatio);
      final barkC         = _barkColor;

      if (!isShadow) {
        if (strokeWidth > 1.5) {
          canvas.drawLine(start, tip, Paint()
          ..color = barkC.withValues(alpha: branchOpacity * 0.55)
          ..strokeWidth = strokeWidth..strokeCap = StrokeCap.round..style = PaintingStyle.stroke);
          canvas.drawLine(start, tip, Paint()
          ..color = color.withValues(alpha: branchOpacity * 0.80)
          ..strokeWidth = strokeWidth * 0.70..strokeCap = StrokeCap.round..style = PaintingStyle.stroke);
          canvas.drawLine(
            start.translate(math.cos(adjustedAngle + math.pi / 2) * strokeWidth * 0.18,
            math.sin(adjustedAngle + math.pi / 2) * strokeWidth * 0.18),
            tip.translate(  math.cos(adjustedAngle + math.pi / 2) * strokeWidth * 0.10,
            math.sin(adjustedAngle + math.pi / 2) * strokeWidth * 0.10),
            Paint()..color = color.withValues(alpha: branchOpacity * 0.35)
            ..strokeWidth = strokeWidth * 0.22..strokeCap = StrokeCap.round..style = PaintingStyle.stroke,
          );
          if (strokeWidth > 3.5) _drawBarkNicks(canvas, start, tip, strokeWidth, color, branchOpacity);
        } else {
          canvas.drawLine(start, tip, Paint()
          ..color = color.withValues(alpha: branchOpacity)
          ..strokeWidth = strokeWidth..strokeCap = StrokeCap.round..style = PaintingStyle.stroke);
        }
      } else {
        canvas.drawLine(start, tip, Paint()
        ..color = color.withValues(alpha: branchOpacity)
        ..strokeWidth = strokeWidth..strokeCap = StrokeCap.round..style = PaintingStyle.stroke);
      }

      if (depth == 0) {
        if (!isShadow) _drawLeafCluster(canvas, tip, length, adjustedAngle, color);
        return;
      }

      final childLen   = length * lengthRatio * (1.0 + _genetic('len_$depth') * 0.5);
      final childWidth = strokeWidth * 0.62;
      final asym       = 0.04 + _genetic('asym') * 0.025;

      _drawBranch(canvas: canvas, start: tip, angle: adjustedAngle - spreadAngle,
                  length: childLen * (1.0 - asym), depth: depth - 1, maxDepth: maxDepth,
                  spreadAngle: spreadAngle * 0.90, lengthRatio: lengthRatio, strokeWidth: childWidth,
                  depthFromTip: depthFromTip - 1, color: color, isShadow: isShadow);
      _drawBranch(canvas: canvas, start: tip, angle: adjustedAngle + spreadAngle,
                  length: childLen * (1.0 + asym), depth: depth - 1, maxDepth: maxDepth,
                  spreadAngle: spreadAngle * 0.90, lengthRatio: lengthRatio, strokeWidth: childWidth,
                  depthFromTip: depthFromTip - 1, color: color, isShadow: isShadow);

      if (maxDepth >= 4 && depth == maxDepth - 1) {
        _drawBranch(canvas: canvas, start: tip, angle: adjustedAngle + _genetic('mid_$depth') * 0.3,
        length: childLen * 0.75, depth: depth - 2, maxDepth: maxDepth,
        spreadAngle: spreadAngle * 0.82, lengthRatio: lengthRatio, strokeWidth: childWidth * 0.75,
        depthFromTip: depthFromTip - 2, color: color, isShadow: isShadow);
      }
    }

    void _drawBarkNicks(Canvas canvas, Offset start, Offset tip,
                        double strokeWidth, Color color, double opacity) {
      final nickCount = 2 + (strokeWidth / 3).floor();
      final nickPaint = Paint()
      ..color = _barkColor.withValues(alpha: opacity * 0.45)
      ..strokeWidth = 0.7..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
      final dx = tip.dx - start.dx; final dy = tip.dy - start.dy;
      final len = math.sqrt(dx * dx + dy * dy);
      if (len < 1) return;
      final nx = -dy / len; final ny = dx / len;
      for (int k = 1; k <= nickCount; k++) {
        final t = k / (nickCount + 1.0);
        final px = start.dx + dx * t; final py = start.dy + dy * t;
        final half = strokeWidth * 0.30 * (0.7 + _geneticPositive('nick_$k'));
        canvas.drawLine(Offset(px + nx * half, py + ny * half), Offset(px - nx * half, py - ny * half), nickPaint);
      }
                        }

                        void _drawLeafCluster(Canvas canvas, Offset tip, double branchLength,
                                              double branchAngle, Color color) {
                          if (_leafDensity <= 0 && daysElapsed < 8) return;
                          final lc   = _leafColor; final lh = _leafHighlight;
                          final base = branchLength * 0.50;
                          final leafCount = 3 + (_leafDensity * 5).floor();
                          final rng       = math.Random(geneticSeed + tip.dx.toInt() + tip.dy.toInt());
                          for (int i = 0; i < leafCount; i++) {
                            final angleOff  = (rng.nextDouble() - 0.5) * 2.2;
                            final distOff   = rng.nextDouble() * base * 0.75;
                            final leafAngle = branchAngle + angleOff;
                            final lx = tip.dx + math.cos(leafAngle) * distOff;
                            final ly = tip.dy + math.sin(leafAngle) * distOff;
                            // Stage-aware size boost — sprout/sapling get proportionally
                            // larger leaves; mature trees are already full so it fades.
                            final stageSizeBoost = switch (stage) {
                              GrowthStage.sprout    => 0.55,
                              GrowthStage.sapling   => 0.40,
                              GrowthStage.youngTree => 0.22,
                              GrowthStage.groveTree => 0.10,
                              _                     => 0.30,
                            };
                            final leafSize  = base * (stageSizeBoost + rng.nextDouble() * 0.26 + _leafDensity * 0.12);
                            final rotation  = branchAngle + angleOff * 0.6 + rng.nextDouble() * 0.4;
                            final distFactor = 1.0 - (distOff / (base * 0.75)).clamp(0.0, 0.5);
                            final leafOpacity = (0.55 + _leafDensity * 0.35) * distFactor;
                            _drawSingleLeaf(canvas, Offset(lx, ly), leafSize, rotation, lc, lh, leafOpacity);
                          }
                          if (_leafDensity > 0.55) _drawLeafFlecks(canvas, tip, base, color);
                                              }

                                              void _drawSingleLeaf(Canvas canvas, Offset center, double size, double angle,
                                                                   Color leafCol, Color highlight, double opacity) {
                                                canvas.save();
                                                canvas.translate(center.dx, center.dy);
                                                canvas.rotate(angle);

                                                final leafPath = Path();
                                                leafPath.moveTo(0, -size);
                                                leafPath.cubicTo(size * 0.55, -size * 0.55, size * 0.62, size * 0.35, 0, size * 0.45);
                                                leafPath.cubicTo(-size * 0.62, size * 0.35, -size * 0.55, -size * 0.55, 0, -size);
                                                leafPath.close();

                                                canvas.drawPath(leafPath, Paint()..color = leafCol.withValues(alpha: opacity)..style = PaintingStyle.fill);

                                                final highlightPath = Path();
                                                highlightPath.moveTo(0, -size);
                                                highlightPath.cubicTo(size * 0.28, -size * 0.55, size * 0.22, -size * 0.05, 0, -size * 0.05);
                                                highlightPath.cubicTo(-size * 0.22, -size * 0.05, -size * 0.28, -size * 0.55, 0, -size);
                                                highlightPath.close();
                                                canvas.drawPath(highlightPath, Paint()..color = highlight.withValues(alpha: opacity * 0.28)..style = PaintingStyle.fill);

                                                canvas.drawLine(Offset(0, -size * 0.85), Offset(0, size * 0.35),
                                                Paint()..color = leafCol.withValues(alpha: opacity * 0.55)..strokeWidth = size * 0.07
                                                ..strokeCap = StrokeCap.round..style = PaintingStyle.stroke);

                                                final veinPaint = Paint()..color = leafCol.withValues(alpha: opacity * 0.30)
                                                ..strokeWidth = size * 0.04..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
                                                for (final veinT in [0.25, 0.55]) {
                                                  final vy = -size * (0.85 - veinT * 1.2); final vx = size * 0.42 * veinT;
                                                  canvas.drawLine(Offset(0, vy), Offset( vx, vy + size * 0.18), veinPaint);
                                                  canvas.drawLine(Offset(0, vy), Offset(-vx, vy + size * 0.18), veinPaint);
                                                }
                                                canvas.drawPath(leafPath, Paint()..color = leafCol.withValues(alpha: opacity * 0.40)
                                                ..strokeWidth = size * 0.055..style = PaintingStyle.stroke);
                                                canvas.restore();
                                                                   }

                                                                   void _drawLeafFlecks(Canvas canvas, Offset tip, double radius, Color color) {
                                                                     final fleckCount = (3 + _leafDensity * 4).floor();
                                                                     final paint      = Paint()..style = PaintingStyle.fill;
                                                                     final rng        = math.Random(geneticSeed + tip.dx.toInt() * 7);
                                                                     for (int i = 0; i < fleckCount; i++) {
                                                                       final a = rng.nextDouble() * math.pi * 2; final d = rng.nextDouble() * radius * 0.85;
                                                                       final fx = tip.dx + math.cos(a) * d; final fy = tip.dy + math.sin(a) * d;
                                                                       final fr = 1.0 + rng.nextDouble() * 1.2;
                                                                       paint.color = GroveTheme.goldenLich.withValues(alpha: 0.50 + _leafDensity * 0.35);
                                                                       canvas.drawCircle(Offset(fx, fy), fr, paint);
                                                                     }
                                                                   }

                                                                   void _drawSeed(Canvas canvas, Size size) {
                                                                     final cx = size.width * 0.5; final cy = size.height * 0.68;
                                                                     final r  = size.width * 0.13 * (0.35 + progress * 0.65);
                                                                     final ac = _activeColor; final bc = _barkColor;

                                                                     canvas.drawOval(
                                                                       Rect.fromCenter(center: Offset(cx, cy + r * 0.65), width: r * 3.0, height: r * 0.7),
                                                                       Paint()..color = Colors.black.withValues(alpha: 0.15)..style = PaintingStyle.fill
                                                                       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
                                                                     );

                                                                     final seedPath = Path();
                                                                     seedPath.moveTo(cx, cy - r * 0.95);
                                                                     seedPath.cubicTo(cx + r * 0.85, cy - r * 0.55, cx + r * 0.90, cy + r * 0.40, cx, cy + r * 0.60);
                                                                     seedPath.cubicTo(cx - r * 0.90, cy + r * 0.40, cx - r * 0.85, cy - r * 0.55, cx, cy - r * 0.95);
                                                                     seedPath.close();

                                                                     canvas.drawPath(seedPath, Paint()..color = ac.withValues(alpha: 0.75)..style = PaintingStyle.fill);

                                                                     final sheenPath = Path();
                                                                     sheenPath.moveTo(cx, cy - r * 0.90);
                                                                     sheenPath.cubicTo(cx + r * 0.30, cy - r * 0.70, cx + r * 0.28, cy - r * 0.10, cx, cy - r * 0.05);
                                                                     sheenPath.cubicTo(cx - r * 0.28, cy - r * 0.10, cx - r * 0.30, cy - r * 0.70, cx, cy - r * 0.90);
                                                                     sheenPath.close();
                                                                     canvas.drawPath(sheenPath, Paint()..color = ac.withValues(alpha: 0.30)..style = PaintingStyle.fill);

                                                                     canvas.drawPath(seedPath, Paint()..color = bc.withValues(alpha: 0.70)..strokeWidth = r * 0.10..style = PaintingStyle.stroke);
                                                                     canvas.drawLine(Offset(cx, cy - r * 0.80), Offset(cx, cy + r * 0.50),
                                                                     Paint()..color = bc.withValues(alpha: 0.50)..strokeWidth = r * 0.06..strokeCap = StrokeCap.round..style = PaintingStyle.stroke);

                                                                     if (progress > 0.2) {
                                                                       final rootOpacity = ((progress - 0.2) / 0.8).clamp(0.0, 0.5);
                                                                       final rootPaint   = Paint()..color = bc.withValues(alpha: rootOpacity)..strokeWidth = r * 0.09
                                                                       ..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
                                                                       for (int i = 0; i < 4; i++) {
                                                                         final baseAngle = (math.pi * 0.15) + (i - 1.5) * 0.45;
                                                                         final rootLen   = r * (0.55 + progress * 0.55 + _genetic('root_$i') * 0.2);
                                                                         final midX = cx + math.cos(math.pi / 2 + baseAngle * 0.4) * r * 0.3;
                                                                         final midY = cy + r * 0.55 + r * 0.3;
                                                                         final endX = cx + math.cos(math.pi / 2 + baseAngle) * rootLen;
                                                                         final endY = cy + r * 0.55 + rootLen * 0.65;
                                                                         final rootPath = Path()..moveTo(cx, cy + r * 0.55)..quadraticBezierTo(midX, midY, endX, endY);
                                                                         canvas.drawPath(rootPath, rootPaint);
                                                                       }
                                                                     }

                                                                     if (progress > 0.3) {
                                                                       final sproutH  = size.height * 0.22 * ((progress - 0.3) / 0.7);
                                                                       final sproutY0 = cy - r * 0.90;
                                                                       final sproutY1 = sproutY0 - sproutH;
                                                                       final stemPath = Path()..moveTo(cx, sproutY0)
                                                                       ..quadraticBezierTo(cx + r * 0.18, sproutY0 - sproutH * 0.5, cx, sproutY1);
                                                                       canvas.drawPath(stemPath, Paint()..color = ac.withValues(alpha: 0.85)..strokeWidth = r * 0.14
                                                                       ..strokeCap = StrokeCap.round..style = PaintingStyle.stroke);
                                                                       if (progress > 0.5) {
                                                                         final leafGrow = ((progress - 0.5) / 0.5).clamp(0.0, 1.0);
                                                                         final leafSz   = r * 0.45 * leafGrow;
                                                                         _drawSingleLeaf(canvas, Offset(cx - leafSz * 0.8, sproutY1 + leafSz * 0.3),
                                                                         leafSz, -math.pi * 0.35, _leafColor, _leafHighlight, 0.80 * leafGrow);
                                                                         _drawSingleLeaf(canvas, Offset(cx + leafSz * 0.8, sproutY1 + leafSz * 0.3),
                                                                         leafSz,  math.pi * 0.35, _leafColor, _leafHighlight, 0.80 * leafGrow);
                                                                       }
                                                                     }
                                                                   }

                                                                   static double _lerpD(double a, double b, double t) => a + (b - a) * t;

                                                                   @override
                                                                   bool shouldRepaint(FractalTreePainter old) =>
                                                                   old.stage       != stage       || old.baseColor != baseColor ||
                                                                   old.progress    != progress    || old.windPhase != windPhase ||
                                                                   old.daysElapsed != daysElapsed || old.geneticSeed != geneticSeed ||
                                                                   old.shadowStage != shadowStage;
}

// ══════════════════════════════════════════════════════════════════════
// §8a ONBOARDING SHEET
// ══════════════════════════════════════════════════════════════════════
class OnboardingSheet extends StatefulWidget {
  const OnboardingSheet({super.key});
  @override State<OnboardingSheet> createState() => _OnboardingSheetState();
}

class _OnboardingSheetState extends State<OnboardingSheet> {
  int _page = 0;

  static const _steps = [
    _OnboardingStep(
      icon:       Icons.waving_hand_rounded,
      title:      'Welcome to Grove 🌿',
      body:       'Yo! Grove is a mindful, minimalistic habit tracker that turns your clean streaks into living, growing, animated trees. '
    'No secret tricks or gimmicks; just a beautiful & private record of your progress.',
    treeStage:  GrowthStage.seed,
    treeColor:  GroveTheme.mossGreen,
    ),
    _OnboardingStep(
      icon:       Icons.forest_rounded,
      title:      'Plant a Tree',
      body:       'Tap "Plant a Tree" to create a new habit. Give it a name (Alcohol, Smoking, Social Media; '
    'anything you want to track) then pick a colour. Each habit grows its own unique tree and has a special identifer.',
    treeStage:  GrowthStage.sprout,
    treeColor:  GroveTheme.mossGreen,
    ),
    _OnboardingStep(
      icon:       Icons.show_chart_rounded,
      title:      'Watch It Grow',
      body:       'Your tree evolves through five stages: Seed → Sprout → Sapling → Young Tree → Grove Tree. '
    'The longer you maintain your streak, the fuller and more complex your tree grows.',
    treeStage:  GrowthStage.youngTree,
    treeColor:  GroveTheme.mossGreen,
    ),
    _OnboardingStep(
      icon:       Icons.refresh_rounded,
      title:      'Log a Relapse',
      body:       'Slipped up? That\'s okay. Tap "Relapse" to log what happened. '
    'Grove records your peak streak so that way, your best efforts are not forgotten.',
    treeStage:  GrowthStage.sapling,
    treeColor:  GroveTheme.clayRed,
    ),
    _OnboardingStep(
      icon:       Icons.calendar_month_outlined,
      title:      'Your History',
      body:       'Tap a tree to open its detail page; you\'ll find a live countdown, an interactive monthly calendar, '
    'and a full timeline of every relapse with reasons and peak sweeps.',
    treeStage:  GrowthStage.groveTree,
    treeColor:  GroveTheme.mossGreen,
    ),
    _OnboardingStep(
      icon:       Icons.lock_outline_rounded,
      title:      'Fully Private',
      body:       'All your data lives only on this device. Nothing is ever sent anywhere. '
    'Use Export / Import in Settings to back up or move between devices. '
    'Ready? Let\'s start growing.',
    treeStage:  GrowthStage.groveTree,
    treeColor:  GroveTheme.mossGreen,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme     = context.watch<GroveSettings>().theme;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final step      = _steps[_page];
    final isLast    = _page == _steps.length - 1;

    return Container(
      decoration: BoxDecoration(
        color:        theme.surfaceHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(28, 28, 28, 28 + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
              color:        theme.textMuted.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),
          if (_page != 0) ...[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
              child: SizedBox(
                key: ValueKey(_page),
                width: 120, height: 120,
                child: AnimatedTreeWidget(
                  habit: HabitTree(
                    id:          'onboarding_preview_$_page',
                    name:        'preview',
                    color:       step.treeColor,
                    startDate:   DateTime.now().subtract(Duration(days: _treeDaysForStage(step.treeStage))),
                    lastReset:   DateTime.now().subtract(Duration(days: _treeDaysForStage(step.treeStage))),
                    geneticSeed: _page * 137,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ] else
          const SizedBox(height: 8),
          // Title
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              step.title,
              key:       ValueKey('title_$_page'),
              style:     TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: theme.textPrimary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          // Body
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              step.body,
              key:       ValueKey('body_$_page'),
              style:     TextStyle(fontSize: 14, color: theme.textSecondary, height: 1.65),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 28),
          // Page dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_steps.length, (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin:   const EdgeInsets.symmetric(horizontal: 3),
              width:    i == _page ? 18 : 6, height: 6,
              decoration: BoxDecoration(
                color:        i == _page ? theme.primary : theme.textMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(3),
              ),
            )),
          ),
          const SizedBox(height: 24),
          // Button row
          Row(
            children: [
              if (_page > 0) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _page--),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.textSecondary,
                        side:            BorderSide(color: theme.textMuted.withValues(alpha: 0.4)),
                        minimumSize:     const Size.fromHeight(50),
                        shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Back'),
                  ),
                ),
              const SizedBox(width: 12),
              ],
              Expanded(
                flex: _page > 0 ? 2 : 1,
                child: FilledButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    if (isLast) {
                      Navigator.pop(context);
                    } else {
                      setState(() => _page++);
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: isLast ? GroveTheme.mossGreen : theme.primary,
                    minimumSize:     const Size.fromHeight(50),
                    shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    isLast ? 'Start Growing 🌱' : 'Next',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _treeDaysForStage(GrowthStage s) {
    switch (s) {
      case GrowthStage.seed:      return 0;
      case GrowthStage.sprout:    return 4;
      case GrowthStage.sapling:   return 15;
      case GrowthStage.youngTree: return 60;
      case GrowthStage.groveTree: return 120;
    }
  }
}

class _OnboardingStep {
  final IconData    icon;
  final String      title;
  final String      body;
  final GrowthStage treeStage;
  final Color       treeColor;
  const _OnboardingStep({
    required this.icon, required this.title, required this.body,
    required this.treeStage, required this.treeColor,
  });
}

// ══════════════════════════════════════════════════════════════════════
// §9 HABIT DETAIL SCREEN  (dormancy removed)
// ══════════════════════════════════════════════════════════════════════
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
    _timeSinceRelapse = DateTime.now().difference(habit.lastReset);

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
            (_, i) => _RelapseEventTile(event: habit.relapses[i], index: i),
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
                        _TimeUnit(value: days,    label: 'DAYS', color: habit.color),
                        _TimeDivider(color: theme.textMuted),
                        _TimeUnit(value: hours,   label: 'HRS',  color: habit.color),
                        _TimeDivider(color: theme.textMuted),
                        _TimeUnit(value: minutes, label: 'MIN',  color: habit.color),
                        _TimeDivider(color: theme.textMuted),
                        _TimeUnit(value: seconds, label: 'SEC',  color: habit.color),
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
      _StatChip(label: 'Current Streak', value: '${habit.daysElapsed}d', color: habit.color),
      const SizedBox(width: 10),
      _StatChip(label: 'Peak Record',    value: '${habit.peakDays}d',    color: GroveTheme.streakGold),
      const SizedBox(width: 10),
      _StatChip(label: 'Relapses',       value: '${habit.relapses.length}', color: GroveTheme.clayRed),
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
                return _EarlierDateSentinel(habit: habit, theme: theme,
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
                                          HapticFeedback.mediumImpact(); reasonCtrl.dispose(); Navigator.pop(sheetCtx);
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
                                HapticFeedback.lightImpact(); reasonCtrl.dispose(); Navigator.pop(sheetCtx);
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

// ── Time unit widgets ──────────────────────────────────────────────────
class _TimeUnit extends StatelessWidget {
  final int value; final String label; final Color color;
  const _TimeUnit({required this.value, required this.label, required this.color});

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

class _TimeDivider extends StatelessWidget {
  final Color color;
  const _TimeDivider({required this.color});
  @override
  Widget build(BuildContext context) =>
  Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: color));
}

class _EarlierDateSentinel extends StatelessWidget {
  final HabitTree habit; final GroveTheme theme; final VoidCallback onLogEarlierDate;
  const _EarlierDateSentinel({required this.habit, required this.theme, required this.onLogEarlierDate});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(20),
    border: Border.all(color: theme.primary.withValues(alpha: 0.25), width: 1.5)),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 56, height: 56,
                decoration: BoxDecoration(color: theme.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
                child: Icon(Icons.history_rounded, color: theme.primary, size: 28)),
                const SizedBox(height: 16),
                Text('Earlier than your logs?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: theme.textPrimary), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Tracking started ${DateFormat('MMM d, yyyy').format(habit.startDate)}.\nIf something happened before that, you can log it here.',
                style: TextStyle(fontSize: 12, color: theme.textSecondary, height: 1.5), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: onLogEarlierDate,
                  icon:  const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Log an Earlier Date', style: TextStyle(fontWeight: FontWeight.w600)),
                  style: FilledButton.styleFrom(backgroundColor: theme.primary,
                                                minimumSize: const Size(double.infinity, 50),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                ),
                const SizedBox(height: 12),
                Text('This extends your history and recalculates streaks',
                     style: TextStyle(fontSize: 10, color: theme.textMuted), textAlign: TextAlign.center),
    ]),
  );
}

class _StatChip extends StatelessWidget {
  final String label, value; final Color color;
  const _StatChip({required this.label, required this.value, required this.color});

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

class _RelapseEventTile extends StatelessWidget {
  final RelapseEvent event; final int index;
  const _RelapseEventTile({required this.event, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme   = context.watch<GroveSettings>().theme;
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
                      Text('Peak Sweep: ${event.peakDays} days',
                           style: const TextStyle(fontSize: 10, color: GroveTheme.streakGold, fontWeight: FontWeight.w500)),
                    ],
                    if (event.reason.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text('"${event.reason}"',
                           style: TextStyle(fontSize: 13, color: theme.textSecondary, fontStyle: FontStyle.italic, height: 1.4)),
                    ] else ...[
                      const SizedBox(height: 4),
                      Text('No reason recorded.', style: TextStyle(fontSize: 12, color: theme.textMuted)),
                    ],
                  ])),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
// §10 ADD HABIT SHEET  (unchanged)
// ══════════════════════════════════════════════════════════════════════
class AddHabitSheet extends StatefulWidget {
  const AddHabitSheet({super.key});
  @override State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  final _nameCtrl = TextEditingController();
  final _hexCtrl  = TextEditingController();
  Color _color         = GroveTheme.treePalette[0];
  bool  _showDebugInfo = false;
  bool  _validHex      = true;

  @override
  void initState() { super.initState(); _hexCtrl.text = _colorToHex(_color); }

  @override
  void dispose() { _nameCtrl.dispose(); _hexCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final theme     = context.watch<GroveSettings>().theme;
    final bottomPad = math.max(MediaQuery.of(context).viewInsets.bottom, MediaQuery.of(context).padding.bottom);

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomPad),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(child: Container(width: 36, height: 4,
                                                decoration: BoxDecoration(color: theme.textMuted.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)))),
                                                const SizedBox(height: 20),
                                                Center(child: SizedBox(width: 90, height: 90,
                                                                       child: CustomPaint(painter: FractalTreePainter(
                                                                         stage: GrowthStage.sprout, baseColor: _color, progress: 0.75, windPhase: 0, geneticSeed: 0)))),
                      const SizedBox(height: 14),
                      Text('Plant a New Tree', textAlign: TextAlign.center,
                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: theme.textPrimary)),
                           const SizedBox(height: 20),
                           TextField(
                             controller: _nameCtrl, autofocus: true,
                             textCapitalization: TextCapitalization.words,
                             style: TextStyle(color: theme.textPrimary),
                             onChanged: _checkDebugMode,
                             decoration: InputDecoration(
                               labelText: 'Habit Name', hintText: 'e.g. Alcohol, Smoking, Social media',
                               prefixIcon: Icon(Icons.edit_outlined, size: 18, color: theme.textMuted)),
                           ),
                      if (_showDebugInfo) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: GroveTheme.streakGold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12), border: Border.all(color: GroveTheme.streakGold.withValues(alpha: 0.3))),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Row(children: [
                              Icon(Icons.bug_report, size: 16, color: GroveTheme.streakGold), SizedBox(width: 8),
                              Text('DEBUG ENGINE OVERRIDE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GroveTheme.streakGold, letterSpacing: 1.0)),
                            ]),
                            const SizedBox(height: 8),
                            Text(_getDebugMessage(), style: TextStyle(fontSize: 11, color: theme.textSecondary, height: 1.4)),
                          ]),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Text('PRESET COLORS', style: TextStyle(fontSize: 11, color: theme.textSecondary, letterSpacing: 1.0)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12, runSpacing: 12,
                        children: GroveTheme.treePalette.map((c) {
                          final sel = c == _color;
                          return GestureDetector(
                            onTap: () => setState(() { _color = c; _hexCtrl.text = _colorToHex(c); _validHex = true; }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200), width: 38, height: 38,
                              decoration: BoxDecoration(color: c, shape: BoxShape.circle,
                                                        border: Border.all(color: sel ? GroveTheme.dewWhite : Colors.transparent, width: 2.5),
                                                        boxShadow: sel ? [BoxShadow(color: c.withValues(alpha: 0.6), blurRadius: 10)] : []),
                                                        child: sel ? const Icon(Icons.check, color: Colors.white, size: 18) : null),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Text('CUSTOM HEX CODE', style: TextStyle(fontSize: 11, color: theme.textSecondary, letterSpacing: 1.0)),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(child: TextField(
                          controller: _hexCtrl, textCapitalization: TextCapitalization.characters,
                          style: TextStyle(color: theme.textPrimary), onChanged: _updateFromHexInput, maxLength: 6,
                          decoration: InputDecoration(
                            labelText: 'Hex Code', prefixText: '#',
                            prefixStyle: TextStyle(color: theme.textSecondary),
                            hintText: '4E8B5F',
                            prefixIcon: Icon(Icons.palette_outlined, size: 18, color: theme.textMuted),
                            errorText: _validHex ? null : 'Invalid hex', counterText: ''),
                        )),
                        const SizedBox(width: 12),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200), width: 56, height: 56,
                          decoration: BoxDecoration(color: _color, shape: BoxShape.circle,
                                                    border: Border.all(color: theme.textMuted.withValues(alpha: 0.3), width: 2),
                                                    boxShadow: [BoxShadow(color: _color.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 2))]),
                        ),
                      ]),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _plant,
                        icon:  const Icon(Icons.forest_rounded, size: 18),
                        label: Text(_showDebugInfo ? 'Plant Debug Override' : 'Plant Tree',
                                    style: const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: _showDebugInfo ? GroveTheme.streakGold : _color,
                                      foregroundColor: theme.brightness == Brightness.light ? Colors.white : GroveTheme.dewWhite,
                                        minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      ),
                      ],
        ),
      ),
    );
  }

  void _updateFromHexInput(String value) {
    if (value.isEmpty) return;
    try {
      final hex = value.replaceFirst('#', '');
      if (hex.length != 6) { setState(() => _validHex = false); return; }
      final color = Color(int.parse('FF$hex', radix: 16));
      setState(() { _validHex = true; _color = color; });
    } catch (_) { setState(() => _validHex = false); }
  }

  String _colorToHex(Color color) {
    final argb = color.toARGB32();
    return argb.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();
  }

  void _checkDebugMode(String value) {
    final isDebug = value.toLowerCase().startsWith('debug');
    if (isDebug != _showDebugInfo) {
      setState(() => _showDebugInfo = isDebug);
      if (isDebug) HapticFeedback.lightImpact();
    }
  }

  String _getDebugMessage() {
    final input = _nameCtrl.text.toLowerCase();
    if (input.contains('debug1') || input.contains('debug 1')) return '🌱 SEED STAGE\nDay 0-1 • Germination Phase';
    if (input.contains('debug2') || input.contains('debug 2')) return '🌿 SPROUT STAGE\nDay 2-7 • Root Formation';
    if (input.contains('debug3') || input.contains('debug 3')) return '🌳 SAPLING STAGE\nDay 8-30 • Deep Axis Spread';
    if (input.contains('debug4') || input.contains('debug 4')) return '🌲 YOUNG TREE STAGE\nDay 31-90 • Canopy Sprawl';
    if (input.contains('debug5') || input.contains('debug 5')) return '🌲 GROVE TREE STAGE\nDay 91+ • Fractal Horizon';
    if (input.contains('debugleaf')   || input.contains('debug leaf'))   return '🍂 LEAF MATRIX OVERRIDE\nDay 45 • Dense spore mapping';
    if (input.contains('debugshadow') || input.contains('debug shadow')) return '👻 SHADOW ARCHIVAL ENGINE\nTriggers peak ghost background';
    return 'Keywords: Debug1–5 • DebugLeaf • DebugShadow';
  }

  int? _getDebugDays() {
    final input = _nameCtrl.text.toLowerCase();
    if (input.contains('debug1') || input.contains('debug 1')) return 0;
    if (input.contains('debug2') || input.contains('debug 2')) return 4;
    if (input.contains('debug3') || input.contains('debug 3')) return 15;
    if (input.contains('debug4') || input.contains('debug 4')) return 60;
    if (input.contains('debug5') || input.contains('debug 5')) return 120;
    if (input.contains('debugleaf')   || input.contains('debug leaf'))   return 45;
    if (input.contains('debugshadow') || input.contains('debug shadow')) return 5;
    return null;
  }

  void _plant() {
    final name      = _nameCtrl.text.trim();
    final debugDays = _getDebugDays();
    if (!_showDebugInfo && name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Give your habit a name.')));
      return;
    }
    final habitName = _showDebugInfo
    ? 'DEBUG: ${_getDebugMessage().split('\n')[0].replaceAll(RegExp(r'[🌱🌿🌳🌲🍂👻]'), '').trim()}'
    : name;
    context.read<GroveModel>().addHabit(name: habitName, color: _color, debugDays: debugDays);
    HapticFeedback.lightImpact();
    Navigator.pop(context);
  }
}

// ══════════════════════════════════════════════════════════════════════
// §11 RELAPSE DIALOG
// ══════════════════════════════════════════════════════════════════════
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
                                    TextButton(onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel', style: TextStyle(color: theme.textSecondary))),
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

// ══════════════════════════════════════════════════════════════════════
// §12 MONTHLY CALENDAR  (unchanged)
// ══════════════════════════════════════════════════════════════════════
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
    final totalCells     = startOffset + daysInMonth;
    final numWeeks       = (totalCells / 7).ceil();

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
                                         return const Expanded(child: SizedBox());
                                       }
                                       final day        = cellIndex - startOffset + 1;
                                       final cellDate   = DateTime(targetMonth.year, targetMonth.month, day);
                                       final today      = DateTime(now.year, now.month, now.day);
                                       final isToday    = cellDate == today;
                                       final isFuture   = cellDate.isAfter(today);
                                       final hasRelapse = habit.relapseDays.contains(cellDate);

                                       final cellColor = isFuture
                                       ? theme.surfaceHigh.withValues(alpha: 0.3)
                                       : hasRelapse ? GroveTheme.clayRed.withValues(alpha: 0.7) : theme.surfaceHigh;

                                       return Expanded(
                                         child: GestureDetector(
                                           onTap: isFuture ? null : () {
                                             HapticFeedback.selectionClick();
                                             _showCellManager(context, cellDate, hasRelapse, model, theme);
                                           },
                                           child: Container(
                                             margin: const EdgeInsets.all(2),
                                             decoration: BoxDecoration(color: cellColor, borderRadius: BorderRadius.circular(8),
                                             border: isToday ? Border.all(color: habit.color, width: 2) : null),
                                             alignment: Alignment.center,
                                             child: Text('$day', style: TextStyle(
                                               fontSize: 11, fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                                               color: hasRelapse ? GroveTheme.dewWhite : isFuture
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
                      _legendDot(GroveTheme.clayRed.withValues(alpha: 0.7)), const SizedBox(width: 5),
                      Text('Relapse', style: TextStyle(fontSize: 9, color: theme.textMuted)),
                    ]),
      ]),
    );
  }

  void _showCellManager(BuildContext ctx, DateTime targetDate, bool hasRelapse,
                        GroveModel model, GroveTheme theme) {
    final reasonCtrl     = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();
    final matches = habit.relapses.where((r) =>
    r.timestamp.year  == targetDate.year  &&
    r.timestamp.month == targetDate.month &&
    r.timestamp.day   == targetDate.day).toList();
    if (matches.isNotEmpty) {
      reasonCtrl.text = matches.first.reason;
      selectedTime    = TimeOfDay.fromDateTime(matches.first.timestamp);
    }

    showModalBottomSheet(
      context: ctx, backgroundColor: theme.surfaceHigh,
      isScrollControlled: true, useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (builderCtx, setSheetState) {
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
                                                      Text(DateFormat('EEEE, MMMM d, yyyy').format(targetDate),
                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: theme.textPrimary)),
                                                      const SizedBox(height: 6),
                                                      Text(hasRelapse ? '⚠️ Relapse logged on this day.' : '🌿 Clean record.',
                                                           style: TextStyle(fontSize: 12,
                                                                            color: hasRelapse ? GroveTheme.clayRed : theme.textSecondary,
                                                                            fontWeight: FontWeight.w600)),
                            const SizedBox(height: 20),
                            Text('TIME OVERRIDE',
                                 style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                                 const SizedBox(height: 8),
                                 OutlinedButton.icon(
                                   onPressed: () async {
                                     final picked = await showTimePicker(context: builderCtx, initialTime: selectedTime);
                                     if (picked != null) setSheetState(() => selectedTime = picked);
                                   },
                                   icon: const Icon(Icons.access_time, size: 14),
                                   label: Text('Anchor: ${selectedTime.format(builderCtx)}', style: const TextStyle(fontSize: 13)),
                                   style: OutlinedButton.styleFrom(foregroundColor: theme.textPrimary, padding: const EdgeInsets.symmetric(vertical: 12)),
                                 ),
                            const SizedBox(height: 16),
                            Text(hasRelapse ? 'EDIT REASON' : 'REASON (optional)',
                            style: TextStyle(color: theme.textMuted, fontSize: 11, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            TextField(controller: reasonCtrl, maxLines: 3,
                                      style: TextStyle(color: theme.textPrimary, fontSize: 14),
                                      decoration: const InputDecoration(
                                        hintText: 'Stress, Anxiety, Burnout, Peer pressure, Trigger? etc...',
                                        contentPadding: EdgeInsets.all(12))),
                                        const SizedBox(height: 24),
                                        if (hasRelapse) ...[
                                          FilledButton.icon(
                                            onPressed: () {
                                              final ts = DateTime(targetDate.year, targetDate.month, targetDate.day, selectedTime.hour, selectedTime.minute);
                                              model.recordCustomRelapse(habit.id, reasonCtrl.text.trim(), ts);
                                              HapticFeedback.lightImpact(); Navigator.pop(sheetCtx);
                                            },
                                            icon: const Icon(Icons.check, size: 16), label: const Text('Update Log'),
                                            style: FilledButton.styleFrom(backgroundColor: habit.color, foregroundColor: Colors.white,
                                                                          minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                          ),
                            const SizedBox(height: 10),
                            OutlinedButton.icon(
                              onPressed: () {
                                model.removeRelapseOnDate(habit.id, targetDate);
                                HapticFeedback.lightImpact(); Navigator.pop(sheetCtx);
                              },
                              icon: const Icon(Icons.clear, size: 16), label: const Text('Remove Relapse'),
                              style: OutlinedButton.styleFrom(foregroundColor: GroveTheme.clayRed,
                                                              side: BorderSide(color: GroveTheme.clayRed.withValues(alpha: 0.4)),
                                                              minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            ),
                                        ] else ...[
                                          FilledButton.icon(
                                            onPressed: () {
                                              final ts = DateTime(targetDate.year, targetDate.month, targetDate.day, selectedTime.hour, selectedTime.minute);
                                              model.recordCustomRelapse(habit.id, reasonCtrl.text.trim(), ts);
                                              HapticFeedback.lightImpact(); Navigator.pop(sheetCtx);
                                            },
                                            icon: const Icon(Icons.add, size: 16), label: const Text('Add Relapse Here'),
                                            style: FilledButton.styleFrom(backgroundColor: GroveTheme.clayRed, foregroundColor: Colors.white,
                                                                          minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                          ),
                                        ],
                            ],
              ),
            ),
          );
        },
      ),
    );
                        }

                        Widget _legendDot(Color c) => Container(
                          width: 10, height: 10,
                          decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3)));
}
