import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grove/theme/grove_theme.dart';
import 'package:grove/services/grove_notifications.dart';

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
