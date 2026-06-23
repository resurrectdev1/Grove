// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Grove';

  @override
  String get appTagline => 'G R O V E';

  @override
  String get plantATree => 'Plant a Tree';

  @override
  String get plantTree => 'Plant Tree';

  @override
  String get plantANewTree => 'Plant a New Tree';

  @override
  String get habitName => 'Habit Name';

  @override
  String get habitNameHint => 'e.g. Alcohol, Smoking, Social media';

  @override
  String get trackingMode => 'TRACKING MODE';

  @override
  String get presetColors => 'PRESET COLORS';

  @override
  String get customHexCode => 'CUSTOM HEX CODE';

  @override
  String get hexCode => 'Hex Code';

  @override
  String get invalidHex => 'Invalid hex';

  @override
  String get abstain => 'Abstain';

  @override
  String get abstainSubtitle1 => 'Auto-grows daily';

  @override
  String get abstainSubtitle2 => 'Tap to record a relapse';

  @override
  String get checkIn => 'Check-In';

  @override
  String get checkInSubtitle1 => 'Check in daily to grow';

  @override
  String get checkInSubtitle2 => 'Growth based on check-ins';

  @override
  String get history => 'History';

  @override
  String daysSuffix(Object days) {
    return '${days}d';
  }

  @override
  String historyCount(Object count) {
    return 'History ($count)';
  }

  @override
  String get relapse => 'Relapse';

  @override
  String get checkedIn => 'Checked In';

  @override
  String get checkInAction => 'Check In';

  @override
  String dayStreak(int days) {
    return '$days-day streak';
  }

  @override
  String dayCount(int days) {
    return 'Day $days';
  }

  @override
  String get alreadyCheckedInToday => 'Already checked in today ✓';

  @override
  String get tapBelowToCheckIn => 'Tap below to check in';

  @override
  String get giveHabitName => 'Give your habit a name.';

  @override
  String get stageSeed => 'Seed';

  @override
  String get stageSprout => 'Sprout';

  @override
  String get stageSapling => 'Sapling';

  @override
  String get stageYoungTree => 'Young Tree';

  @override
  String get stageGroveTree => 'Grove Tree';

  @override
  String get taglineSeed => 'Every great forest starts here.';

  @override
  String get taglineSprout => 'Roots are forming beneath the surface.';

  @override
  String get taglineSapling => 'Growing stronger with every sunrise.';

  @override
  String get taglineYoungTree => 'Your canopy is taking shape.';

  @override
  String get taglineGroveTree => 'You have become the forest.';

  @override
  String get logARelapse => 'Log a Relapse?';

  @override
  String get relapseMotivation => 'You are stronger than you think.';

  @override
  String get customTimestamp => 'CUSTOM TIMESTAMP';

  @override
  String get loggedReason => 'LOGGED REASON (Optional)';

  @override
  String get loggedReasonHint => 'Stress, Anxiety, Burnout, Peer pressure, Trigger? etc...';

  @override
  String get confirmLog => 'Confirm Log';

  @override
  String get cancel => 'Cancel';

  @override
  String get onboarding0Title => 'Welcome to Grove 🌿';

  @override
  String get onboarding0Body => 'A private sobriety and habit tracker where trees represent your growth, the longer you stay clean, the more vibrant and lush your trees become.';

  @override
  String get onboarding1Title => 'Plant a Tree';

  @override
  String get onboarding1Body => 'Tap \"Plant a Tree\" to create a habit. Give it a name, pick a colour, and Grove generates a unique tree just for it. Each one grows differently.';

  @override
  String get onboarding2Title => 'Watch It Grow';

  @override
  String get onboarding2Body => 'Every day clean helps your tree mature through five growth stages. from a tiny seed all the way to a full grove tree with swaying branches and leaves.';

  @override
  String get onboarding3Title => 'Log a Relapse';

  @override
  String get onboarding3Body => 'If you slip up, record it honestly. Grove tracks your longest streaks and history, so your progress is never erased.';

  @override
  String get onboarding4Title => 'Your History';

  @override
  String get onboarding4Body => 'Open any tree to explore calendars, milestones, streak history, relapse notes, and insights into your long-term consistency.';

  @override
  String get onboarding5Title => 'Fully Private';

  @override
  String get onboarding5Body => 'Everything stays on your device. Nothing is ever sent anywhere. Back up or move your grove anytime via Export / Import in Settings. Now go grow something worth keeping. 🌱';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get startGrowing => 'Start Growing 🌱';

  @override
  String get groveIsBare => 'Your grove is bare.';

  @override
  String get plantFirstTree => 'Plant your first tree to begin.';

  @override
  String get settingsHub => 'Settings Hub';

  @override
  String get layoutArchitecture => 'LAYOUT ARCHITECTURE';

  @override
  String get renderThemes => 'RENDER THEMES';

  @override
  String get privacyNotifications => 'PRIVACY & NOTIFICATIONS';

  @override
  String get dataManagement => 'DATA MANAGEMENT';

  @override
  String get reorderGrove => 'Reorder Grove';

  @override
  String get holdDragToReorder => 'Hold & drag ≡ to reorder';

  @override
  String get layoutWheel => 'Wheel';

  @override
  String get layoutCarousel => 'Carousel';

  @override
  String get layoutGrid => 'Grid';

  @override
  String get layoutList => 'List';

  @override
  String get themeForestDark => 'Forest Dark';

  @override
  String get themeAmoledBlack => 'AMOLED Black';

  @override
  String get themeMaterialYou => 'Material You';

  @override
  String get themeWhiteMinimal => 'White Minimal';

  @override
  String get milestoneNotifications => 'Milestone Notifications';

  @override
  String get milestoneNotificationsSubtitle => 'Get notified when a tree reaches a new growth stage';

  @override
  String get biometricUnlock => 'Biometric Unlock';

  @override
  String get biometricUnlockSubtitle => 'Require Fingerprint / Pin to open Grove';

  @override
  String get exportGroveBackup => 'Export Grove Backup';

  @override
  String get restoreGroveBackup => 'Restore Grove from Backup';

  @override
  String get exportImportNote => 'Export saves a .json file to a location you choose.\nImporting will replace your current grove • export a backup first.';

  @override
  String get backupSaved => '✓ Backup saved';

  @override
  String saveFailed(String error) {
    return 'Save failed: $error';
  }

  @override
  String get couldNotReadFile => 'Could not read the selected file.';

  @override
  String groveRestored(int count) {
    return '✓ Grove restored — $count trees loaded';
  }

  @override
  String get invalidBackup => '✗ Invalid backup — make sure you selected the right file';

  @override
  String get language => 'LANGUAGE';

  @override
  String get languageLabel => 'Language';

  @override
  String get links => 'LINKS';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => 'Source code & contributions';

  @override
  String get buyMeCoffee => 'Buy Me a Coffee';

  @override
  String get buyMeCoffeeSubtitle => 'Support development';

  @override
  String get madeWith => 'Made with 🌿 • all data stays on your device.';

  @override
  String get openSource => 'Open Source';

  @override
  String versionLabel(String version) {
    return 'v$version • Open Source';
  }

  @override
  String get groveDescription => 'Grove is a minimalistic habit tracker that visualises your growth through trees. Every day you stay clean, your tree grows. Built with love as a free, open-source tool.';

  @override
  String get groveLocked => 'Grove is locked';

  @override
  String get authenticateToContinue => 'Authenticate to continue';

  @override
  String get unlockGrove => 'Unlock Grove';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get peakRecord => 'Peak Record';

  @override
  String get relapses => 'Relapses';

  @override
  String get checkIns => 'Check-ins';

  @override
  String get interactiveMonthlyLogs => 'Interactive Monthly Logs';

  @override
  String get swipeForEarlierMonths => 'Swipe ← for earlier months';

  @override
  String get thisMonth => 'This month';

  @override
  String get logDateBeforeTracking => '← Log a date before tracking started';

  @override
  String get cleanSinceStart => 'Clean since start';

  @override
  String get timeSinceLastRelapse => 'Time since last relapse';

  @override
  String get days => 'DAYS';

  @override
  String get hrs => 'HRS';

  @override
  String get min => 'MIN';

  @override
  String get sec => 'SEC';

  @override
  String get checkedInToday => 'Checked in today';

  @override
  String get notCheckedInToday => 'Not checked in today';

  @override
  String get streak => 'STREAK';

  @override
  String get total => 'TOTAL';

  @override
  String get alreadyCheckedIn => 'Already Checked In';

  @override
  String get checkInToday => 'Check In Today';

  @override
  String get relapseSweepTimeline => 'Relapse Timeline Sweep';

  @override
  String get checkInHistory => 'Check-In History';

  @override
  String totalCount(int count) {
    return '$count total';
  }

  @override
  String get noRelapsesRecorded => 'No relapses recorded. Keep growing.';

  @override
  String get noCheckInsYet => 'No check-ins yet. Start today!';

  @override
  String get renameHabit => 'Rename Habit';

  @override
  String get save => 'Save';

  @override
  String get dangerZone => 'Danger Zone';

  @override
  String get deleteHabitPermanently => 'Delete Habit Permanently';

  @override
  String get deleteHabit => 'Delete Habit?';

  @override
  String deleteHabitConfirm(String name) {
    return 'This will permanently delete \"$name\" and all its history. This action cannot be undone.';
  }

  @override
  String get delete => 'Delete';

  @override
  String get earlierThanLogs => 'Earlier than your logs?';

  @override
  String trackingStarted(String date) {
    return 'Tracking started $date.\nIf something happened before that, you can log it here.';
  }

  @override
  String get logEarlierDate => 'Log an Earlier Date';

  @override
  String get extendsHistoryNote => 'This extends your history and recalculates streaks';

  @override
  String get logEarlierDateTitle => 'Log Earlier Date';

  @override
  String get beforeTrackingStarted => 'Before tracking started';

  @override
  String get extendHistoryInfo => 'This will extend your tracking history earlier and recalculate your peak streaks.';

  @override
  String get date => 'DATE';

  @override
  String get time => 'TIME';

  @override
  String get logAsRelapseOnDate => 'Log as Relapse on This Date';

  @override
  String get onlyExtendStartDate => 'Only Extend Start Date (No Relapse)';

  @override
  String get whatHappenedHint => 'What happened that day…';

  @override
  String peakSweep(int days) {
    return 'Peak Sweep: $days days';
  }

  @override
  String get noReasonRecorded => 'No reason recorded.';

  @override
  String notifSproutTitle(String name) {
    return '$name is sprouting! 🌱';
  }

  @override
  String get notifSproutBody => 'Your tree\'s roots are done forming. Keep growing.';

  @override
  String notifSaplingTitle(String name) {
    return '$name is a sapling now! 🌿';
  }

  @override
  String get notifSaplingBody => 'Your tree is standing on its own, look how much you have grown';

  @override
  String notifYoungTreeTitle(String name) {
    return '$name is growing tall! 🌳';
  }

  @override
  String get notifYoungTreeBody => 'Your canopy is starting to take shape, incredible.';

  @override
  String notifGroveTreeTitle(String name) {
    return '$name is a grove tree! 🌲';
  }

  @override
  String get notifGroveTreeBody => 'Congratulations!!! You have become the forest.';

  @override
  String get saveGroveBackupDialog => 'Save Grove Backup';

  @override
  String get selectGroveBackupDialog => 'Select Grove Backup';

  @override
  String get customAccentColor => 'Custom Accent';

  @override
  String get customAccentDefault => 'Default green';

  @override
  String get customAccentSubtitle => 'Applied across buttons, cards, and badges';

  @override
  String get applyAccent => 'Apply Accent';

  @override
  String get resetAccentDefault => 'Reset to default';

  @override
  String get dailyReminderSetting => 'Daily Check-in Reminder';

  @override
  String get dailyReminderSettingSubtitle => 'A nudge to check-in on your forest';

  @override
  String get tapToChange => 'Tap to change';

  @override
  String get languageSection => 'LANGUAGE';
}
