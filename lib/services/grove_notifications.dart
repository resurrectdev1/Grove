import 'dart:ui' show Locale, PlatformDispatcher;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:grove/models/grove_models.dart';
import 'package:grove/l10n/app_localizations.dart';

class GroveNotifications {
  GroveNotifications._();
  static final GroveNotifications instance = GroveNotifications._();

  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId        = 'grove_milestones';
  static const _channelName      = 'Tree Milestones';
  static const _prefsKey         = 'grove_notified_milestones';
  static const _dailyChannelId   = 'grove_daily_reminder';
  static const _dailyChannelName = 'Daily Check-in Reminder';
  static const _dailyNotifId     = 99999;

  int _notifId(String habitId) => habitId.hashCode.abs() % 100000;

  Set<String> _notified = {};
  SharedPreferences? _prefs;

  Future<void> init() async {
    tz_data.initializeTimeZones();

    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
    } catch (e) {
      debugPrint('Grove: timezone lookup failed ($e), falling back to UTC');
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

    _prefs   = await SharedPreferences.getInstance();
    _notified = (_prefs!.getStringList(_prefsKey) ?? []).toSet();
  }

  Future<void> requestPermissions() async {
    final androidPlugin = _plugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    final iosPlugin = _plugin
    .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> checkAndNotifyMilestones(List<HabitTree> habits) async {
    for (final habit in habits) {
      if (habit.stage == GrowthStage.seed) continue;

      final key = '${habit.id}_${habit.stage.index}';
      if (_notified.contains(key)) continue;

      await _fireNotification(habit);
      _notified.add(key);
    }
    await _prefs?.setStringList(_prefsKey, _notified.toList());
  }

  Future<void> markStagesSeen(List<HabitTree> habits) async {
    for (final habit in habits) {
      if (habit.stage == GrowthStage.seed) continue;
      _notified.add('${habit.id}_${habit.stage.index}');
    }
    await _prefs?.setStringList(_prefsKey, _notified.toList());
  }

  Future<void> _fireNotification(HabitTree habit) async {
    final (title, body) = await _copy(habit.name, habit.stage);

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Celebrate your tree growth milestones',
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

    await _plugin.show(
      id:                  _notifId(habit.id + habit.stage.index.toString()),
      title:               title,
      body:                body,
      notificationDetails: details,
    );

    debugPrint('Grove milestone: [${habit.name}] reached ${habit.stage.name}');
  }

  Future<Locale> _resolveLocale() async {
    final tag = _prefs?.getString('locale_language_tag');
    if (tag != null && tag.isNotEmpty) {
      final parts = tag.split('_');
      final locale = parts.length >= 2 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
      if (AppLocalizations.supportedLocales.contains(locale)) {
        return locale;
      }
    }
    final deviceLocale = PlatformDispatcher.instance.locale;
    for (final s in AppLocalizations.supportedLocales) {
      if (s.languageCode == deviceLocale.languageCode &&
        s.countryCode  == deviceLocale.countryCode) {
        return s;
      }
    }
    for (final s in AppLocalizations.supportedLocales) {
      if (s.languageCode == deviceLocale.languageCode) return s;
    }
    return const Locale('en');
  }

  Future<(String, String)> _copy(String name, GrowthStage stage) async {
    final locale = await _resolveLocale();
    final l10n   = await AppLocalizations.delegate.load(locale);

    switch (stage) {
      case GrowthStage.sprout:
        return (l10n.notifSproutTitle(name), l10n.notifSproutBody);
      case GrowthStage.sapling:
        return (l10n.notifSaplingTitle(name), l10n.notifSaplingBody);
      case GrowthStage.youngTree:
        return (l10n.notifYoungTreeTitle(name), l10n.notifYoungTreeBody);
      case GrowthStage.groveTree:
        return (l10n.notifGroveTreeTitle(name), l10n.notifGroveTreeBody);
      case GrowthStage.seed:
        return ('', '');
    }
  }

  Future<void> scheduleDailyReminder(TimeOfDay time) async {
    try {
      final locale = await _resolveLocale();
      final l10n   = await AppLocalizations.delegate.load(locale);

      await _plugin.cancel(id: _dailyNotifId);

      final now      = tz.TZDateTime.now(tz.local);
      var   scheduled = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute,
      );
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          _dailyChannelId,
          _dailyChannelName,
          channelDescription: 'Daily reminder to check in on your habits',
          importance: Importance.high,
          priority:   Priority.high,
          icon:       '@drawable/ic_grove_notif',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      );

      await _plugin.zonedSchedule(
        id: _dailyNotifId,
        title: l10n.dailyReminderSetting,
        body: l10n.dailyReminderSettingSubtitle,
        scheduledDate: scheduled,
        notificationDetails: details,
        androidScheduleMode:      AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents:  DateTimeComponents.time,
      );

      debugPrint('Grove: daily reminder scheduled at ${time.hour}:${time.minute.toString().padLeft(2, '0')}');
    } catch (e) {
      debugPrint('Grove: scheduleDailyReminder error: $e');
    }
  }

  Future<void> cancelDailyReminder() async {
    try {
      await _plugin.cancel(id: _dailyNotifId);
      debugPrint('Grove: daily reminder cancelled');
    } catch (e) {
      debugPrint('Grove: cancelDailyReminder error: $e');
    }
  }

  Future<void> clearHabitMilestones(String habitId) async {
    _notified.removeWhere((k) => k.startsWith('${habitId}_'));
    await _prefs?.setStringList(_prefsKey, _notified.toList());
  }
}
