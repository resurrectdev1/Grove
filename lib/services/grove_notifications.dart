import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class GroveNotifications {
  GroveNotifications._();
  static final GroveNotifications instance = GroveNotifications._();

  final _plugin = FlutterLocalNotificationsPlugin();
  static const _channelId   = 'grove_daily';
  static const _channelName = 'Daily Reminder';
  static const _notifId     = 0;

  Future<void> init() async {
    tz_data.initializeTimeZones();

    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      debugPrint('Grove: device timezone → ${tzInfo.identifier}');
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
  }

  Future<void> scheduleDailyReminder({
    TimeOfDay time = const TimeOfDay(hour: 20, minute: 0),
  }) async {
    await _plugin.cancelAll();

    final androidPlugin = _plugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();

    final exactGranted = await androidPlugin?.requestExactAlarmsPermission() ?? false;
    debugPrint('Grove: exact alarm permission granted: $exactGranted');

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
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
    var   target = tz.TZDateTime(
      tz.local,
      now.year, now.month, now.day,
      time.hour, time.minute,
    );
    if (!target.isAfter(now)) target = target.add(const Duration(days: 1));

    await _plugin.zonedSchedule(
      id:                      _notifId,
      title:                   'Your forest is waiting 🌲',
      body:                    'It has grown since you last visited...',
      scheduledDate:           target,
      notificationDetails:     details,
      androidScheduleMode:     AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint('Grove: notification scheduled for ${target.toLocal()}');
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}
