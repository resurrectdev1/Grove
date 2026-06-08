import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:grove/models/grove_models.dart';

class GroveNotifications {
  GroveNotifications._();
  static final GroveNotifications instance = GroveNotifications._();

  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId   = 'grove_milestones';
  static const _channelName = 'Tree Milestones';
  static const _prefsKey    = 'grove_notified_milestones';

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

  Future<void> _fireNotification(HabitTree habit) async {
    final (title, body) = _copy(habit.name, habit.stage);

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

  (String, String) _copy(String name, GrowthStage stage) {
    switch (stage) {
      case GrowthStage.sprout:
        return (
          '$name is sprouting! 🌱',
          'Your first week is done. Roots are forming • keep going.',
        );
      case GrowthStage.sapling:
        return (
          '$name is a sapling now! 🌿',
          'One month strong. Your tree is standing on its own.',
        );
      case GrowthStage.youngTree:
        return (
          '$name is growing tall! 🌳',
          'Three months clean. Your canopy is taking shape • incredible.',
        );
      case GrowthStage.groveTree:
        return (
          '$name is a grove tree! 🌲',
          'You made it to 90 days and beyond. You have become the forest.',
        );
      case GrowthStage.seed:
        return ('', '');
    }
  }

  Future<void> clearHabitMilestones(String habitId) async {
    _notified.removeWhere((k) => k.startsWith('${habitId}_'));
    await _prefs?.setStringList(_prefsKey, _notified.toList());
  }
}
