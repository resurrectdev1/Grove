import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grove/theme/grove_theme.dart';
import 'package:grove/services/grove_notifications.dart';

class GroveSettings extends ChangeNotifier {
  GroveThemeMode _themeMode = GroveThemeMode.forestDark;
  LayoutMode _layoutMode = LayoutMode.verticalWheel;
  bool _materialYou = false;
  ColorScheme? _dynamicLight;
  ColorScheme? _dynamicDark;
  bool _onboardingDone = false;
  bool _biometricUnlock = false;
  bool _milestoneNotifications = false;
  bool _dailyReminder = false;
  TimeOfDay? _dailyReminderTime;
  Color? _customAccent;
  Locale? _locale;

  SharedPreferences? _prefs;

  GroveThemeMode get themeMode => _themeMode;
  bool get materialYou => _materialYou;
  bool get hasDynamicColors => _dynamicLight != null || _dynamicDark != null;
  LayoutMode get layoutMode => _layoutMode;
  bool get onboardingDone => _onboardingDone;
  bool get biometricUnlock => _biometricUnlock;
  bool get milestoneNotifications => _milestoneNotifications;
  bool get dailyReminder => _dailyReminder;
  TimeOfDay? get dailyReminderTime => _dailyReminderTime;
  Color? get customAccent => _customAccent;
  GroveTheme get theme => GroveTheme(
    mode: _themeMode,
    materialYou: _materialYou,
    dynamicLight: _dynamicLight,
    dynamicDark: _dynamicDark,
    customAccent: _customAccent,
  );

  Locale? get locale => _locale;

  Future<void> init(ColorScheme? dynamicLight, ColorScheme? dynamicDark) async {
    _prefs = await SharedPreferences.getInstance();

    final savedLayout = _prefs!.getInt('layout_mode') ?? 0;
    _onboardingDone = _prefs!.getBool('onboarding_done') ?? false;
    _biometricUnlock = _prefs!.getBool('biometric_unlock') ?? false;
    _milestoneNotifications =
        _prefs!.getBool('milestone_notifications') ?? false;
    _dailyReminder = _prefs!.getBool('daily_reminder') ?? false;

    final reminderHour = _prefs!.getInt('daily_reminder_hour');
    final reminderMinute = _prefs!.getInt('daily_reminder_minute');
    if (reminderHour != null && reminderMinute != null) {
      _dailyReminderTime = TimeOfDay(
        hour: reminderHour,
        minute: reminderMinute,
      );
    }

    final accentInt = _prefs!.getInt('custom_accent');
    if (accentInt != null) _customAccent = Color(accentInt);

    final savedBase = _prefs!.getInt('theme_base');
    if (savedBase != null) {
      if (savedBase >= 0 && savedBase < GroveThemeMode.values.length) {
        _themeMode = GroveThemeMode.values[savedBase];
      }
      _materialYou = _prefs!.getBool('material_you') ?? false;
    } else {
      switch (_prefs!.getInt('theme_mode') ?? 0) {
        case 1:
          _themeMode = GroveThemeMode.amoledBlack;
        case 2:
          _themeMode = GroveThemeMode.forestDark;
          _materialYou = true;
        case 3:
          _themeMode = GroveThemeMode.whiteMinimal;
        default:
          _themeMode = GroveThemeMode.forestDark;
      }
    }
    if (savedLayout < LayoutMode.values.length) {
      _layoutMode = LayoutMode.values[savedLayout];
    }

    final savedLangTag = _prefs!.getString('locale_language_tag');
    if (savedLangTag != null && savedLangTag.isNotEmpty) {
      final parts = savedLangTag.split('_');
      _locale = parts.length >= 2
          ? Locale(parts[0], parts[1])
          : Locale(parts[0]);
    }

    _dynamicLight = dynamicLight;
    _dynamicDark = dynamicDark;
    notifyListeners();
  }

  void applyDynamicColors(ColorScheme? light, ColorScheme? dark) {
    _dynamicLight = light;
    _dynamicDark = dark;
    notifyListeners();
  }

  Future<void> setMilestoneNotifications(bool value) async {
    _milestoneNotifications = value;
    await _prefs?.setBool('milestone_notifications', value);
    if (value) {
      await GroveNotifications.instance.requestPermissions();
    }
    notifyListeners();
  }

  Future<void> setBiometricUnlock(bool value) async {
    _biometricUnlock = value;
    await _prefs?.setBool('biometric_unlock', value);
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingDone = true;
    await _prefs?.setBool('onboarding_done', true);
    notifyListeners();
  }

  Future<void> setThemeMode(GroveThemeMode mode) async {
    _themeMode = mode;
    await _prefs?.setInt('theme_base', mode.index);
    await _prefs?.setBool('material_you', _materialYou);
    notifyListeners();
  }

  Future<void> setMaterialYou(bool value) async {
    _materialYou = value;
    await _prefs?.setBool('material_you', value);
    await _prefs?.setInt('theme_base', _themeMode.index);
    notifyListeners();
  }

  Future<void> setLayoutMode(LayoutMode mode) async {
    _layoutMode = mode;
    await _prefs?.setInt('layout_mode', mode.index);
    notifyListeners();
  }

  Future<void> setCustomAccent(Color? color) async {
    _customAccent = color;
    if (color == null) {
      await _prefs?.remove('custom_accent');
    } else {
      await _prefs?.setInt('custom_accent', color.toARGB32());
    }
    notifyListeners();
  }

  Future<void> setDailyReminder(bool enabled, TimeOfDay? time) async {
    _dailyReminder = enabled;
    _dailyReminderTime = enabled ? time : null;
    await _prefs?.setBool('daily_reminder', enabled);
    if (enabled && time != null) {
      await _prefs?.setInt('daily_reminder_hour', time.hour);
      await _prefs?.setInt('daily_reminder_minute', time.minute);
      await GroveNotifications.instance.requestPermissions();
      await GroveNotifications.instance.scheduleDailyReminder(time);
    } else {
      await _prefs?.remove('daily_reminder_hour');
      await _prefs?.remove('daily_reminder_minute');
      await GroveNotifications.instance.cancelDailyReminder();
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    if (locale == null) {
      await _prefs?.remove('locale_language_tag');
    } else {
      final tag = locale.countryCode != null
          ? '${locale.languageCode}_${locale.countryCode}'
          : locale.languageCode;
      await _prefs?.setString('locale_language_tag', tag);
    }
    notifyListeners();
  }
}
