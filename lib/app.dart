import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:provider/provider.dart';
import 'package:grove/l10n/app_localizations.dart';
import 'package:grove/providers/grove_settings.dart';
import 'package:grove/services/grove_biometrics.dart';
import 'package:grove/theme/grove_theme.dart';
import 'package:grove/screens/home_screen.dart';

class GroveApp extends StatelessWidget {
  const GroveApp({super.key});
  static const _supportedLocales = [
    Locale('en'),
    Locale('ar'),
    Locale('de'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (lightDynamic != null || darkDynamic != null) {
            context.read<GroveSettings>().applyDynamicColors(
              lightDynamic,
              darkDynamic,
            );
          }
        });
        return Consumer<GroveSettings>(
          builder: (_, settings, _) {
            final gt = settings.theme;
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: gt.brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
                systemNavigationBarColor: gt.bg,
                systemNavigationBarIconBrightness:
                    gt.brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
              ),
            );
            return MaterialApp(
              title: 'Grove',
              debugShowCheckedModeBanner: false,
              theme: _buildTheme(gt),
              locale: settings.locale,
              supportedLocales: _supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (deviceLocale, supported) {
                if (deviceLocale == null) {
                  return const Locale('en');
                }
                for (final s in supported) {
                  if (s.languageCode == deviceLocale.languageCode &&
                      s.countryCode == deviceLocale.countryCode) {
                    return s;
                  }
                }
                for (final s in supported) {
                  if (s.languageCode == deviceLocale.languageCode) return s;
                }
                return const Locale('en');
              },

              home: settings.biometricUnlock
                  ? const _BiometricGate(
                      key: ValueKey('biometric_gate'),
                      child: GroveHomeScreen(),
                    )
                  : const GroveHomeScreen(),
            );
          },
        );
      },
    );
  }

  ThemeData _buildTheme(GroveTheme gt) {
    final cs =
        ColorScheme.fromSeed(
          seedColor: gt.primary,
          brightness: gt.brightness,
        ).copyWith(
          surface: gt.surface,
          surfaceContainerHighest: gt.surfaceHigh,
          primary: gt.primary,
          secondary: GroveTheme.barkBrown,
          error: GroveTheme.clayRed,
          onSurface: gt.textPrimary,
          onPrimary: gt.brightness == Brightness.light
              ? Colors.white
              : GroveTheme.dewWhite,
        );
    return ThemeData(
      useMaterial3: true,
      brightness: gt.brightness,
      colorScheme: cs,
      scaffoldBackgroundColor: gt.bg,
      dialogTheme: DialogThemeData(
        backgroundColor: gt.surfaceHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: gt.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: gt.textMuted),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: gt.textMuted),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: gt.primary, width: 1.5),
        ),
        labelStyle: TextStyle(color: gt.textSecondary),
        hintStyle: TextStyle(color: gt.textMuted),
      ),
    );
  }
}

class _BiometricGate extends StatefulWidget {
  final Widget child;
  const _BiometricGate({super.key, required this.child});

  @override
  State<_BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends State<_BiometricGate>
    with WidgetsBindingObserver {
  bool _unlocked = false;
  bool _attempting = false;
  bool _userDismissed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _prompt();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_unlocked && !_userDismissed) {
      _prompt();
    }
  }

  Future<void> _prompt() async {
    if (_attempting) return;
    setState(() {
      _attempting = true;
      _userDismissed = false;
    });
    final ok = await GroveBiometrics.instance.authenticate();
    if (mounted) {
      setState(() {
        _unlocked = ok;
        _attempting = false;
        _userDismissed = !ok;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<GroveSettings>().theme;
    final l10n = AppLocalizations.of(context);
    if (_unlocked) return widget.child;

    return Scaffold(
      backgroundColor: theme.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline_rounded, size: 56, color: theme.textMuted),
            const SizedBox(height: 24),
            Text(
              l10n.groveLocked,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.authenticateToContinue,
              style: TextStyle(fontSize: 13, color: theme.textSecondary),
            ),
            const SizedBox(height: 36),
            FilledButton.icon(
              onPressed: _attempting
                  ? null
                  : () {
                      setState(() => _userDismissed = false);
                      _prompt();
                    },
              icon: const Icon(Icons.fingerprint_rounded),
              label: Text(l10n.unlockGrove),
              style: FilledButton.styleFrom(
                backgroundColor: theme.primary,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
