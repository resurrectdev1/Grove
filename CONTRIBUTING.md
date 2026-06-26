# Contributing to Grove

Thanks for your interest in contributing! Grove is free, open-source software built for everybody & any help is welcome, whether that's code, bug reports, or ideas.

---

## Reporting Bugs & Requesting Features

Found something broken? Have an idea? You can reach out however works best for you:

- **GitHub Issues** - preferred for bugs and feature requests so they're tracked
- **GitHub Discussions** - great for open-ended ideas or questions
- **Wherever** - if you find another way to reach me, that's fine too

When reporting a bug, try to include:
- Your Android version and device
- Steps to reproduce the issue
- What you expected vs. what actually happened
- Logs or screenshots if you have them

---

## Project Structure

A quick map of `lib/` so new code ends up in the right place:

| Folder        | Contains |
|----------------|----------|
| `models/`      | Plain data classes - `HabitTree`, `RelapseEvent`, the `GrowthStage`/`HabitMode` enums. No Flutter UI code here. |
| `painters/`    | `CustomPainter` implementations - currently just the fractal tree renderer. |
| `providers/`   | App state - `GroveModel` (habits, persistence) and `GroveSettings` (theme, layout, prefs), both `ChangeNotifier`s consumed via `provider`. |
| `screens/`     | Full-page routes - home screen, habit detail screen. |
| `services/`    | Platform/IO integrations - notifications, biometrics, the native widget bridge. |
| `theme/`       | `GroveTheme` and the color/layout enums. |
| `widgets/`     | Reusable UI pieces used within screens (cards, sheets, dialogs, calendar). |
| `l10n/`        | Generated localization (`.arb` sources, see the translations section below). |

If you're not sure where something goes, look at what it's most similar to and put it next to that.

## Contributing Code

1. **Open an issue first** for anything significant, it avoids duplicate work and lets us align before you invest time writing code
2. Fork the repo and create a branch from `main`
3. Make your changes, keep commits focused and readable
4. Test on a real device if possible, not just an emulator
5. Open a pull request with a clear description of what you changed and why

### Guidelines

- Follow the existing code style & when in doubt, match what's already there
- Keep pull requests scoped to one thing; big mixed PRs are hard to review
- Update the `CHANGELOG.md` under `[Unreleased]` with any user-facing changes
- Bump `pubspec.yaml` only if we've agreed on a version bump

### Code Style

- State management is `provider` + `ChangeNotifier`. Read app state with `context.watch<T>()` when the widget should rebuild on change, or `context.read<T>()` for one-off actions (e.g. inside a button's `onPressed`).
- Theming always goes through `GroveSettings.theme` (a `GroveTheme`) please don't hardcode colors that should adapt to the active theme mode. Reuse the named constants on `GroveTheme` (`mossGreen`, `clayRed`, etc.) for non-theme-dependent accents.
- All user-facing strings go through `AppLocalizations.of(context)!`. Don't hardcode UI text, even for small or "obviously temporary" strings instead see the translations section below for adding the corresponding `.arb` entries.
- Data models (`HabitTree`, `RelapseEvent`) are immutable; updates go through `copyWith(...)`, never by mutating fields directly.
- In `services/`, failures are caught and logged with `debugPrint` rather than thrown & these run in contexts (platform channels, background callbacks) where an uncaught exception is worse than a silently skipped feature. Match that pattern rather than letting new service code throw.

### Architecture Notes

A couple of spots that are easy to break without realizing it:

- **Peak Sweep recompute (`GroveModel._sweepPeaks`)**: any mutation that changes a habit's relapse history or start date (recording/removing a relapse, editing the start date) needs to flow through `_sweepPeaks` afterward so `RelapseEvent.peakDays` stays correct. If you add a new way to mutate relapse data, route it through this rather than recomputing peaks ad hoc.
- **Widget bridge (`services/widget_bridge.dart`)**: `GroveWidgetBridge` talks to native code over a `MethodChannel` to update Android home-screen widgets. Outside of a real device/emulator (tests, etc.) the native side doesn't exist, so calls no-op via a caught `MissingPluginException` rather than failing. Don't remove that catch or assume the channel call always succeeds.
- **`HabitMode` branching**: habits are either `HabitMode.abstain` (streak resets on relapse) or `HabitMode.checkIn` (streak built from daily check-ins). These two modes branch separately in `grove_models.dart`, `grove_model.dart`, and `habit_card.dart`. If you add a feature touching streaks, stages, or stats, check that it makes sense — and is implemented — for both modes, not just the one you tested with.

### Privacy & Telemetry Checklist

Before opening a PR, double check:

- [ ] No new dependency added to `pubspec.yaml` makes network calls, phones home, or includes analytics/crash-reporting SDKs
- [ ] No new persistence mechanism introduced, `shared_preferences` is the only storage layer Grove uses today. If your feature seems to need a database or cloud sync, open an issue to discuss it first rather than building it into a PR
- [ ] Nothing added requires an internet connection for core functionality to keep working offline

### What's welcome

- Bug fixes
- Performance improvements
- Accessibility improvements
- New features that fit Grove's theme (habit/sobriety tracking, the fractal tree system, etc)
- New language translations
- Improvements to existing translations

### What to check first

- There's no open issue or PR already covering your change
- The change aligns with Grove's philosophy: offline-first, no tracking, no ads

---

## Project Philosophy

Grove is FOSS software built for people, not profit. Contributions should respect that:

- No telemetry, analytics, or data collection of any kind
- No external dependencies that phone home
- Privacy is non-negotiable

---

## Adding or Updating Translations

Grove welcomes translation contributions. If you'd like to add support for a new language or improve an existing translation, follow these steps:

### Adding a New Language

1. Locate the localization files in `lib/l10n/`

2. Copy `app_en.arb` and rename it using the appropriate language code, for example:

   * `app_es.arb` for Spanish
   * `app_fr.arb` for French
   * `app_de.arb` for German

3. Translate all string values while keeping:

   * Placeholder names unchanged (`{count}`, `{name}`, etc.)
   * Metadata entries (`@key`) intact
   * Formatting and punctuation consistent where appropriate

4. Register the new locale in two places... an `.arb` file alone isn't enough to make a language selectable in the app:

   * **`lib/app.dart`** add it to the `_supportedLocales` list on `GroveApp`:

     ```dart
     static const _supportedLocales = [
       Locale('en'),
       // ...existing locales...
       Locale('xx'), // your new locale
     ];
     ```

   * **`lib/screens/home_screen.dart`** add an entry to the `_languageOptions` map so it shows up in the in-app language picker, using a flag emoji and the language's native name (matching the existing style):

     ```dart
     static const _languageOptions = <String, Locale?>{
       // ...existing entries...
       '🇽🇽  Native Name': Locale('xx'),
     };
     ```

   If your language needs a country code to disambiguate (like `zh_TW`), pass it as the second `Locale()` argument in both places, e.g. `Locale('zh', 'TW')`.

5. Generate localization files:

```bash
flutter gen-l10n
```

6. Run the app and verify:

   * The language appears correctly when selected
   * Text fits within the UI
   * No untranslated strings remain

### Updating Existing Translations

* Keep translations natural and contextually accurate rather than translating word-for-word.
* Maintain consistency with existing terminology throughout the app.
* Test any modified translations before submitting a pull request.

### Translation Guidelines

* Use clear, natural language.
* Avoid machine-generated translations without review.
* Preserve placeholders and variables exactly as written.
* Keep accessibility and readability in mind.

If you're unsure about a translation, feel free to open a discussion before submitting a pull request.

## Development Setup

Grove pins an exact Flutter version in `pubspec.yaml` (currently `3.41.2`, see the `environment:` block) rather than a range. This isn't a typo, it keeps everyone's generated code (`flutter gen-l10n`, build output) consistent and avoids "works on my machine" issues from contributors on a different Flutter version. Please match it rather than using whatever Flutter you already have installed, especially before reporting a build issue.

1. Check your installed version: `flutter --version`. If it doesn't match the version pinned in `pubspec.yaml`, you have a couple of options:

   * **[FVM](https://fvm.app/) (recommended)** it lets you install and switch between Flutter versions per-project without touching your global install:

     ```bash
     dart pub global activate fvm
     fvm install 3.41.2
     fvm use 3.41.2
     fvm flutter pub get
     fvm flutter run
     ```

   * **Manual install** clone the Flutter SDK and check out the matching tag/commit for that version, then add it to your `PATH` (or point your IDE's Flutter SDK path at it) instead of your existing install.

2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/Grove.git`
3. Install dependencies: `flutter pub get` (or `fvm flutter pub get` if using FVM)
4. Run on a connected device or emulator: `flutter run` (or `fvm flutter run`)

If `pubspec.yaml`'s pinned version is ever bumped, that'll be called out in the PR that does it - if you maintain a fork or long-running branch, it's worth re-checking this section after pulling `main`.

---

## License

By contributing, you agree that your contributions will be licensed under the same [GPL-3.0 License](LICENSE) that covers this project.
