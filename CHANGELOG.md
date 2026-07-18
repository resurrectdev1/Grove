# Changelog

All notable changes to Grove are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

> Changes staged for the next release go here. Move them down when you cut a tag.

### Added

* Custom auto backups (to be worked on)
* Shareable trees snapshot/animated gif (to be worked on)
* Option to export tree to .csv (to be worked on)
* Banner in releases section for better RSS reader support
* App live demo at https://resurrectdev1.github.io/Grove/

### Changed

* Github workflow file to include formatting and analysis
* Formatted all code with flutter format

### Fixed

* Code cleanup (e.g. `curly_braces_in_flow_control_structures` and other analyzer warnings)

---

## [0.7.4] - 2026-07-09

### Added

* Option to change habit color via three dot menu or within the detailed habit view by clicking on the colored dot at the top right of the screen
* Add findahelpline.com link in information tab
* Notes for Check-In Mode, so you can jot down how a check-in or excused day went
* Option to let excused days count or not twoards your streak in the three dot menu (check-in mode only)

### Changed

* Made colored dot in top right of detailed habit view bigger
* Default color when making new habit to green instead of brown
* More room for trees in grid view

### Fixed

* Grid view not having tree stage next to current day
* Calendar widget not showing excused days for check-in mode habits
* Check-in mode widget trees showing 1 when checked in and 0 when not instead of days of habit tree

---

## [0.7.2] - 2026-07-03

### Added

* Full localization of the interactive monthly calendar, including locale-aware weekday headers
* ~~Notes for Check-In Mode, so you can jot down how a check-in or excused day went~~
* Excused days now appear in the Check-In history list, marked with a frost icon
* New ⋮ three-dot menu in habit cards for all views allowing you to rename and delete habits
* New preset colors: Indigo, Olive, Slate, Terracota, Dusty rose, Amber brown

### Changed

* Check-In Mode trees now show their growth stage (Seed, Sprout, Sapling, etc.) alongside the day count, matching Abstinence Mode, instead of a redundant day-streak label
* Rearranged preset colors in rainbow order

### Fixed

* Fixed a bug where excusing a day that already had a check-in could leave the day in a broken combined state
* Fixed check-in buttons not working on excused days in the habit detail view and home screen
* Fixed 1x1 check-in widget breaking when using it on a allready excused day
* Fixed l10n typo from |10n to l10n
* Fixed Daily check-in reminder not prompting notification permissons upon first toggle
* Added Calendar view button to list view (layout archetecture)

---

## [0.7.0] - 2026-07-01

### Added

* Customizable check-in times for Check-In Mode, matching Abstinence Mode

### Changed

* Moved the streak freeze toggle below the interactive monthly calendar
* Updated terminology across the app to be more inclusive, shifting from "clean" to "abstain" in multiple places
* Improved the UX/UI for the interactive monthly calendar within Check-In Mode
* Upgraded Flutter dependencies

### Fixed

* Fixed an issue in Check-In Mode where excused days were not correctly factored into your streak
* Fixed a bug where the check-in time defaulted to 12:00
* Fixed a layout issue by removing a redundant duplicate pill underneath the streak, peak, and check-in pills in the detailed habit view

---

## [0.6.8] - 2026-06-26

### Added

* Streak freeze toggle for Check-In Mode, letting you freeze a habit's streak
* Excused days for Check-In Mode, so rest days, vacations, and similar don't break your streak
* New tree growth animations
* Revamped designs for the Day 0 seed and Day 1 sprout

### Changed

- Polished all translations further for accuracy
- App icon in the info tab made larger
- Code cleanup (e.g. `curly_braces_in_flow_control_structures` and empty catches)

### Fixed

- Fixed a typo in the Check-In Mode interactive monthly calendar, "clean" corrected to "missed"

---

## [0.6.6] - 2026-06-22

### Added

* New 1×1 Check-In widget, created with help from @ADAIBLOG
* Custom hex colour theme picker for greater personalisation
* New daily Check-In reminder notification
* Localization support for German, Hindi, Italian, Japanese, Korean, Portuguese, Urdu, and Vietnamese

### Changed

- Language setting now has its own dedicated section instead of being grouped under Privacy & Notifications
- Localization screen updated to be scrollable
- Upgraded Flutter dependencies

### Fixed

- Fixed a French localization issue where `swipeForEarlierMonths` could cause a pixel overflow
- Performance optimisations and a range of smaller bug fixes


---

## [0.6.4] - 2026-06-19

### Added
- New Check-In Mode, created with help from @ADAIBLOG
- Home screen widget support for Check-In Mode
- Localization support for Chinese (Simplified), Chinese (Traditional), Spanish, French, and Arabic

### Changed
- Notification text made more clear and consistent to match tree growth milestone

### Fixed
- Fixed a bug that stopped notifications from firing rapidly upon being restored correctly
- Performance optimisations and a range of smaller bug fixes

---

## [0.6.2] - 2026-06-08

### Added
- App version in the info tab now reads automatically from the package metadata instead of being hardcoded
- Allow renaming habits from the habit detail screen
- Allow rearranging trees from the settings hub

### Changed
- Notifications revamped to fire on tree growth milestones (Seed → Sprout → Sapling → Young Tree → Grove Tree) instead of a daily open-the-app reminder
- Upgraded Flutter dependencies

### Fixed
- Backup filename no longer appends `(1)` when a file with the same name exists — the export now includes a specific timestamp to guarantee a unique name
- Removed the vestigial swipe-to-delete gesture on habits that was left over from an earlier version

---

## [0.6.0] - 2026-05-29

### Added
- New fractal tree ID system that generates more variety and visible differences between trees
- Improved fractal tree particles, animations, and branch structure
- App icon now shown in the information section

### Changed
- App text made more consistent throughout
- Improved onboarding screen for clarity
- Backup now exports to a user-chosen local path as a `.json` file instead of a fixed location

### Fixed
- Biometric auth no longer prompts twice when first enabling the toggle
- Calendar widget display corrected

---

## [0.5.8] - 2026-05-22

### Added
- Snack bar with undo action shown when a habit is accidentally deleted

### Changed
- Notifications now use the `flutter_timezone` plugin for timezone resolution instead of custom logic
- Improved home screen widget logic and integration
- Better cache and editing logic throughout

### Fixed
- Fractal tree in the habit sheet no longer gets cropped on larger growth stages
- Performance optimisations and a range of smaller bug fixes

---

<!--
HOW TO MAINTAIN THIS FILE

When you're ready to cut a new release:

1. Rename [Unreleased] to the new version and today's date, e.g.:
   ## [0.7.0] - 2026-07-15

2. Add a fresh empty [Unreleased] section at the top.

3. Use these section headers (only include the ones that apply):
   ### Added      — new features
   ### Changed    — changes to existing behaviour
   ### Deprecated — features to be removed in a future release
   ### Removed    — removed features
   ### Fixed      — bug fixes
   ### Security   — security-related changes

4. Keep entries short and user-facing. Write for someone reading the F-Droid
   update description, not for another developer reading the diff.

5. Commit the CHANGELOG update in the same commit as the pubspec version bump.
-->
