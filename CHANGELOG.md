# Changelog

All notable changes to Grove are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

> Changes staged for the next release go here. Move them down when you cut a tag.

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
