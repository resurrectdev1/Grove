import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
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

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Grove'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'G R O V E'**
  String get appTagline;

  /// No description provided for @plantATree.
  ///
  /// In en, this message translates to:
  /// **'Plant a Tree'**
  String get plantATree;

  /// No description provided for @plantTree.
  ///
  /// In en, this message translates to:
  /// **'Plant Tree'**
  String get plantTree;

  /// No description provided for @plantANewTree.
  ///
  /// In en, this message translates to:
  /// **'Plant a New Tree'**
  String get plantANewTree;

  /// No description provided for @habitName.
  ///
  /// In en, this message translates to:
  /// **'Habit Name'**
  String get habitName;

  /// No description provided for @habitNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Alcohol, Smoking, Social media'**
  String get habitNameHint;

  /// No description provided for @trackingMode.
  ///
  /// In en, this message translates to:
  /// **'TRACKING MODE'**
  String get trackingMode;

  /// No description provided for @presetColors.
  ///
  /// In en, this message translates to:
  /// **'PRESET COLORS'**
  String get presetColors;

  /// No description provided for @customHexCode.
  ///
  /// In en, this message translates to:
  /// **'CUSTOM HEX CODE'**
  String get customHexCode;

  /// No description provided for @hexCode.
  ///
  /// In en, this message translates to:
  /// **'Hex Code'**
  String get hexCode;

  /// No description provided for @invalidHex.
  ///
  /// In en, this message translates to:
  /// **'Invalid hex'**
  String get invalidHex;

  /// No description provided for @abstain.
  ///
  /// In en, this message translates to:
  /// **'Abstain'**
  String get abstain;

  /// No description provided for @abstainSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Auto-grows daily'**
  String get abstainSubtitle1;

  /// No description provided for @abstainSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Tap to record a relapse'**
  String get abstainSubtitle2;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-In'**
  String get checkIn;

  /// No description provided for @checkInSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Check in daily to grow'**
  String get checkInSubtitle1;

  /// No description provided for @checkInSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Growth based on check-ins'**
  String get checkInSubtitle2;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @daysSuffix.
  ///
  /// In en, this message translates to:
  /// **'{days}d'**
  String daysSuffix(Object days);

  /// No description provided for @historyCount.
  ///
  /// In en, this message translates to:
  /// **'History ({count})'**
  String historyCount(Object count);

  /// No description provided for @relapse.
  ///
  /// In en, this message translates to:
  /// **'Relapse'**
  String get relapse;

  /// No description provided for @checkedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked In'**
  String get checkedIn;

  /// No description provided for @checkInAction.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get checkInAction;

  /// No description provided for @dayStreak.
  ///
  /// In en, this message translates to:
  /// **'{days}-day streak'**
  String dayStreak(int days);

  /// No description provided for @dayCount.
  ///
  /// In en, this message translates to:
  /// **'Day {days}'**
  String dayCount(int days);

  /// No description provided for @alreadyCheckedInToday.
  ///
  /// In en, this message translates to:
  /// **'Already checked in today ✓'**
  String get alreadyCheckedInToday;

  /// No description provided for @tapBelowToCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Tap below to check in'**
  String get tapBelowToCheckIn;

  /// No description provided for @giveHabitName.
  ///
  /// In en, this message translates to:
  /// **'Give your habit a name.'**
  String get giveHabitName;

  /// No description provided for @stageSeed.
  ///
  /// In en, this message translates to:
  /// **'Seed'**
  String get stageSeed;

  /// No description provided for @stageSprout.
  ///
  /// In en, this message translates to:
  /// **'Sprout'**
  String get stageSprout;

  /// No description provided for @stageSapling.
  ///
  /// In en, this message translates to:
  /// **'Sapling'**
  String get stageSapling;

  /// No description provided for @stageYoungTree.
  ///
  /// In en, this message translates to:
  /// **'Young Tree'**
  String get stageYoungTree;

  /// No description provided for @stageGroveTree.
  ///
  /// In en, this message translates to:
  /// **'Grove Tree'**
  String get stageGroveTree;

  /// No description provided for @taglineSeed.
  ///
  /// In en, this message translates to:
  /// **'Every great forest starts here.'**
  String get taglineSeed;

  /// No description provided for @taglineSprout.
  ///
  /// In en, this message translates to:
  /// **'Roots are forming beneath the surface.'**
  String get taglineSprout;

  /// No description provided for @taglineSapling.
  ///
  /// In en, this message translates to:
  /// **'Growing stronger with every sunrise.'**
  String get taglineSapling;

  /// No description provided for @taglineYoungTree.
  ///
  /// In en, this message translates to:
  /// **'Your canopy is taking shape.'**
  String get taglineYoungTree;

  /// No description provided for @taglineGroveTree.
  ///
  /// In en, this message translates to:
  /// **'You have become the forest.'**
  String get taglineGroveTree;

  /// No description provided for @logARelapse.
  ///
  /// In en, this message translates to:
  /// **'Log a Relapse?'**
  String get logARelapse;

  /// No description provided for @relapseMotivation.
  ///
  /// In en, this message translates to:
  /// **'You are stronger than you think.'**
  String get relapseMotivation;

  /// No description provided for @customTimestamp.
  ///
  /// In en, this message translates to:
  /// **'CUSTOM TIMESTAMP'**
  String get customTimestamp;

  /// No description provided for @loggedReason.
  ///
  /// In en, this message translates to:
  /// **'LOGGED REASON (Optional)'**
  String get loggedReason;

  /// No description provided for @loggedReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Stress, Anxiety, Burnout, Peer pressure, Trigger? etc...'**
  String get loggedReasonHint;

  /// No description provided for @confirmLog.
  ///
  /// In en, this message translates to:
  /// **'Confirm Log'**
  String get confirmLog;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @onboarding0Title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Grove 🌿'**
  String get onboarding0Title;

  /// No description provided for @onboarding0Body.
  ///
  /// In en, this message translates to:
  /// **'A private sobriety and habit tracker where trees represent your growth, the longer you abstain or check-in, the more vibrant and lush your trees become.'**
  String get onboarding0Body;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Plant a Tree'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Body.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Plant a Tree\" to create a habit. Give it a name, pick a colour, and Grove generates a unique tree just for it. Each one grows differently.'**
  String get onboarding1Body;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Watch It Grow'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In en, this message translates to:
  /// **'Every day helps your tree mature through five growth stages, from a tiny seed all the way to a full grove tree with swaying branches and leaves.'**
  String get onboarding2Body;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Log a Relapse'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In en, this message translates to:
  /// **'If you slip up, record it honestly. Grove tracks your longest streaks and history, so your progress is never erased.'**
  String get onboarding3Body;

  /// No description provided for @onboarding4Title.
  ///
  /// In en, this message translates to:
  /// **'Your History'**
  String get onboarding4Title;

  /// No description provided for @onboarding4Body.
  ///
  /// In en, this message translates to:
  /// **'Open any tree to explore calendars, milestones, streak history, relapse notes, and insights into your long-term consistency.'**
  String get onboarding4Body;

  /// No description provided for @onboarding5Title.
  ///
  /// In en, this message translates to:
  /// **'Fully Private'**
  String get onboarding5Title;

  /// No description provided for @onboarding5Body.
  ///
  /// In en, this message translates to:
  /// **'Everything stays on your device. Nothing is ever sent anywhere. Back up or move your grove anytime via Export / Import in Settings. Now go grow something worth keeping. 🌱'**
  String get onboarding5Body;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @startGrowing.
  ///
  /// In en, this message translates to:
  /// **'Start Growing 🌱'**
  String get startGrowing;

  /// No description provided for @groveIsBare.
  ///
  /// In en, this message translates to:
  /// **'Your grove is bare.'**
  String get groveIsBare;

  /// No description provided for @plantFirstTree.
  ///
  /// In en, this message translates to:
  /// **'Plant your first tree to begin.'**
  String get plantFirstTree;

  /// No description provided for @settingsHub.
  ///
  /// In en, this message translates to:
  /// **'Settings Hub'**
  String get settingsHub;

  /// No description provided for @layoutArchitecture.
  ///
  /// In en, this message translates to:
  /// **'LAYOUT ARCHITECTURE'**
  String get layoutArchitecture;

  /// No description provided for @renderThemes.
  ///
  /// In en, this message translates to:
  /// **'RENDER THEMES'**
  String get renderThemes;

  /// No description provided for @privacyNotifications.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY & NOTIFICATIONS'**
  String get privacyNotifications;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'DATA MANAGEMENT'**
  String get dataManagement;

  /// No description provided for @reorderGrove.
  ///
  /// In en, this message translates to:
  /// **'Reorder Grove'**
  String get reorderGrove;

  /// No description provided for @holdDragToReorder.
  ///
  /// In en, this message translates to:
  /// **'Hold & drag ≡ to reorder'**
  String get holdDragToReorder;

  /// No description provided for @layoutWheel.
  ///
  /// In en, this message translates to:
  /// **'Wheel'**
  String get layoutWheel;

  /// No description provided for @layoutCarousel.
  ///
  /// In en, this message translates to:
  /// **'Carousel'**
  String get layoutCarousel;

  /// No description provided for @layoutGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get layoutGrid;

  /// No description provided for @layoutList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get layoutList;

  /// No description provided for @themeForestDark.
  ///
  /// In en, this message translates to:
  /// **'Forest Dark'**
  String get themeForestDark;

  /// No description provided for @themeAmoledBlack.
  ///
  /// In en, this message translates to:
  /// **'AMOLED Black'**
  String get themeAmoledBlack;

  /// No description provided for @themeMaterialYou.
  ///
  /// In en, this message translates to:
  /// **'Material You'**
  String get themeMaterialYou;

  /// No description provided for @themeWhiteMinimal.
  ///
  /// In en, this message translates to:
  /// **'White Minimal'**
  String get themeWhiteMinimal;

  /// No description provided for @milestoneNotifications.
  ///
  /// In en, this message translates to:
  /// **'Milestone Notifications'**
  String get milestoneNotifications;

  /// No description provided for @milestoneNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified when a tree reaches a new growth stage'**
  String get milestoneNotificationsSubtitle;

  /// No description provided for @biometricUnlock.
  ///
  /// In en, this message translates to:
  /// **'Biometric Unlock'**
  String get biometricUnlock;

  /// No description provided for @biometricUnlockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require Fingerprint / Pin to open Grove'**
  String get biometricUnlockSubtitle;

  /// No description provided for @exportGroveBackup.
  ///
  /// In en, this message translates to:
  /// **'Export Grove Backup'**
  String get exportGroveBackup;

  /// No description provided for @restoreGroveBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore Grove from Backup'**
  String get restoreGroveBackup;

  /// No description provided for @exportImportNote.
  ///
  /// In en, this message translates to:
  /// **'Export saves a .json file to a location you choose.\nImporting will replace your current grove • export a backup first.'**
  String get exportImportNote;

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'✓ Backup saved'**
  String get backupSaved;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String saveFailed(String error);

  /// No description provided for @couldNotReadFile.
  ///
  /// In en, this message translates to:
  /// **'Could not read the selected file.'**
  String get couldNotReadFile;

  /// No description provided for @groveRestored.
  ///
  /// In en, this message translates to:
  /// **'✓ Grove restored — {count} trees loaded'**
  String groveRestored(int count);

  /// No description provided for @invalidBackup.
  ///
  /// In en, this message translates to:
  /// **'✗ Invalid backup — make sure you selected the right file'**
  String get invalidBackup;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get language;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @links.
  ///
  /// In en, this message translates to:
  /// **'LINKS'**
  String get links;

  /// No description provided for @github.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get github;

  /// No description provided for @githubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Source code & contributions'**
  String get githubSubtitle;

  /// No description provided for @buyMeCoffee.
  ///
  /// In en, this message translates to:
  /// **'Buy Me a Coffee'**
  String get buyMeCoffee;

  /// No description provided for @buyMeCoffeeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Support development'**
  String get buyMeCoffeeSubtitle;

  /// No description provided for @madeWith.
  ///
  /// In en, this message translates to:
  /// **'Made with 🌿 • all data stays on your device.'**
  String get madeWith;

  /// No description provided for @openSource.
  ///
  /// In en, this message translates to:
  /// **'Open Source'**
  String get openSource;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'v{version} • Open Source'**
  String versionLabel(String version);

  /// No description provided for @groveDescription.
  ///
  /// In en, this message translates to:
  /// **'Grove is a minimalist habit & sobriety tracker that visualizes your growth through trees. Every day you abstain or check-in, your tree grows. Built with love as a free, open-source tool.'**
  String get groveDescription;

  /// No description provided for @groveLocked.
  ///
  /// In en, this message translates to:
  /// **'Grove is locked'**
  String get groveLocked;

  /// No description provided for @authenticateToContinue.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to continue'**
  String get authenticateToContinue;

  /// No description provided for @unlockGrove.
  ///
  /// In en, this message translates to:
  /// **'Unlock Grove'**
  String get unlockGrove;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @peakRecord.
  ///
  /// In en, this message translates to:
  /// **'Peak Record'**
  String get peakRecord;

  /// No description provided for @relapses.
  ///
  /// In en, this message translates to:
  /// **'Relapses'**
  String get relapses;

  /// No description provided for @checkIns.
  ///
  /// In en, this message translates to:
  /// **'Check-ins'**
  String get checkIns;

  /// No description provided for @interactiveMonthlyLogs.
  ///
  /// In en, this message translates to:
  /// **'Interactive Monthly Logs'**
  String get interactiveMonthlyLogs;

  /// No description provided for @swipeForEarlierMonths.
  ///
  /// In en, this message translates to:
  /// **'Swipe ← for earlier months'**
  String get swipeForEarlierMonths;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @logDateBeforeTracking.
  ///
  /// In en, this message translates to:
  /// **'← Log a date before tracking started'**
  String get logDateBeforeTracking;

  /// No description provided for @abstinentSinceStart.
  ///
  /// In en, this message translates to:
  /// **'No relapses recorded.'**
  String get abstinentSinceStart;

  /// No description provided for @timeSinceLastRelapse.
  ///
  /// In en, this message translates to:
  /// **'Time since last relapse'**
  String get timeSinceLastRelapse;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'DAYS'**
  String get days;

  /// No description provided for @hrs.
  ///
  /// In en, this message translates to:
  /// **'HRS'**
  String get hrs;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'MIN'**
  String get min;

  /// No description provided for @sec.
  ///
  /// In en, this message translates to:
  /// **'SEC'**
  String get sec;

  /// No description provided for @checkedInToday.
  ///
  /// In en, this message translates to:
  /// **'Checked in today'**
  String get checkedInToday;

  /// No description provided for @notCheckedInToday.
  ///
  /// In en, this message translates to:
  /// **'Not checked in today'**
  String get notCheckedInToday;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'STREAK'**
  String get streak;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get total;

  /// No description provided for @alreadyCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Already Checked In'**
  String get alreadyCheckedIn;

  /// No description provided for @checkInToday.
  ///
  /// In en, this message translates to:
  /// **'Check In Today'**
  String get checkInToday;

  /// No description provided for @relapseSweepTimeline.
  ///
  /// In en, this message translates to:
  /// **'Relapse Timeline Sweep'**
  String get relapseSweepTimeline;

  /// No description provided for @checkInHistory.
  ///
  /// In en, this message translates to:
  /// **'Check-In History'**
  String get checkInHistory;

  /// No description provided for @totalCount.
  ///
  /// In en, this message translates to:
  /// **'{count} total'**
  String totalCount(int count);

  /// No description provided for @noRelapsesRecorded.
  ///
  /// In en, this message translates to:
  /// **'No relapses recorded. Keep growing.'**
  String get noRelapsesRecorded;

  /// No description provided for @noCheckInsYet.
  ///
  /// In en, this message translates to:
  /// **'No check-ins yet. Start today!'**
  String get noCheckInsYet;

  /// No description provided for @renameHabit.
  ///
  /// In en, this message translates to:
  /// **'Rename Habit'**
  String get renameHabit;

  /// No description provided for @habitOptions.
  ///
  /// In en, this message translates to:
  /// **'Habit options'**
  String get habitOptions;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @deleteHabitPermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete Habit Permanently'**
  String get deleteHabitPermanently;

  /// No description provided for @deleteHabit.
  ///
  /// In en, this message translates to:
  /// **'Delete Habit?'**
  String get deleteHabit;

  /// No description provided for @deleteHabitConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete \"{name}\" and all its history. This action cannot be undone.'**
  String deleteHabitConfirm(String name);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @earlierThanLogs.
  ///
  /// In en, this message translates to:
  /// **'Earlier than your logs?'**
  String get earlierThanLogs;

  /// No description provided for @trackingStarted.
  ///
  /// In en, this message translates to:
  /// **'Tracking started {date}.\nIf something happened before that, you can log it here.'**
  String trackingStarted(String date);

  /// No description provided for @logEarlierDate.
  ///
  /// In en, this message translates to:
  /// **'Log an Earlier Date'**
  String get logEarlierDate;

  /// No description provided for @extendsHistoryNote.
  ///
  /// In en, this message translates to:
  /// **'This extends your history and recalculates streaks'**
  String get extendsHistoryNote;

  /// No description provided for @logEarlierDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Earlier Date'**
  String get logEarlierDateTitle;

  /// No description provided for @beforeTrackingStarted.
  ///
  /// In en, this message translates to:
  /// **'Before tracking started'**
  String get beforeTrackingStarted;

  /// No description provided for @extendHistoryInfo.
  ///
  /// In en, this message translates to:
  /// **'This will extend your tracking history earlier and recalculate your peak streaks.'**
  String get extendHistoryInfo;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'DATE'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get time;

  /// No description provided for @logAsRelapseOnDate.
  ///
  /// In en, this message translates to:
  /// **'Log as Relapse on This Date'**
  String get logAsRelapseOnDate;

  /// No description provided for @onlyExtendStartDate.
  ///
  /// In en, this message translates to:
  /// **'Only Extend Start Date (No Relapse)'**
  String get onlyExtendStartDate;

  /// No description provided for @whatHappenedHint.
  ///
  /// In en, this message translates to:
  /// **'What happened that day…'**
  String get whatHappenedHint;

  /// No description provided for @peakSweep.
  ///
  /// In en, this message translates to:
  /// **'Peak Sweep: {days} days'**
  String peakSweep(int days);

  /// No description provided for @noReasonRecorded.
  ///
  /// In en, this message translates to:
  /// **'No reason recorded.'**
  String get noReasonRecorded;

  /// No description provided for @notifSproutTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} is sprouting! 🌱'**
  String notifSproutTitle(String name);

  /// No description provided for @notifSproutBody.
  ///
  /// In en, this message translates to:
  /// **'Your tree\'s roots are done forming. Keep growing.'**
  String get notifSproutBody;

  /// No description provided for @notifSaplingTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} is a sapling now! 🌿'**
  String notifSaplingTitle(String name);

  /// No description provided for @notifSaplingBody.
  ///
  /// In en, this message translates to:
  /// **'Your tree is standing on its own, look how much you have grown'**
  String get notifSaplingBody;

  /// No description provided for @notifYoungTreeTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} is growing tall! 🌳'**
  String notifYoungTreeTitle(String name);

  /// No description provided for @notifYoungTreeBody.
  ///
  /// In en, this message translates to:
  /// **'Your canopy is starting to take shape, incredible.'**
  String get notifYoungTreeBody;

  /// No description provided for @notifGroveTreeTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} is a grove tree! 🌲'**
  String notifGroveTreeTitle(String name);

  /// No description provided for @notifGroveTreeBody.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!!! You have become the forest.'**
  String get notifGroveTreeBody;

  /// No description provided for @saveGroveBackupDialog.
  ///
  /// In en, this message translates to:
  /// **'Save Grove Backup'**
  String get saveGroveBackupDialog;

  /// No description provided for @selectGroveBackupDialog.
  ///
  /// In en, this message translates to:
  /// **'Select Grove Backup'**
  String get selectGroveBackupDialog;

  /// No description provided for @customAccentColor.
  ///
  /// In en, this message translates to:
  /// **'Custom Accent'**
  String get customAccentColor;

  /// No description provided for @customAccentDefault.
  ///
  /// In en, this message translates to:
  /// **'Default green'**
  String get customAccentDefault;

  /// No description provided for @customAccentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Applied across buttons, cards, and badges'**
  String get customAccentSubtitle;

  /// No description provided for @applyAccent.
  ///
  /// In en, this message translates to:
  /// **'Apply Accent'**
  String get applyAccent;

  /// No description provided for @resetAccentDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get resetAccentDefault;

  /// No description provided for @dailyReminderSetting.
  ///
  /// In en, this message translates to:
  /// **'Daily Check-in Reminder'**
  String get dailyReminderSetting;

  /// No description provided for @dailyReminderSettingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A nudge to check-in on your forest'**
  String get dailyReminderSettingSubtitle;

  /// No description provided for @tapToChange.
  ///
  /// In en, this message translates to:
  /// **'Tap to change'**
  String get tapToChange;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get languageSection;

  /// No description provided for @dailyReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Time to check in 🌿'**
  String get dailyReminderTitle;

  /// No description provided for @dailyReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Your grove is waiting. Keep the streak alive.'**
  String get dailyReminderBody;

  /// No description provided for @legendMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get legendMissed;

  /// No description provided for @legendAbstained.
  ///
  /// In en, this message translates to:
  /// **'Abstained'**
  String get legendAbstained;

  /// No description provided for @legendCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get legendCheckIn;

  /// No description provided for @legendRelapse.
  ///
  /// In en, this message translates to:
  /// **'Relapse'**
  String get legendRelapse;

  /// No description provided for @legendExcused.
  ///
  /// In en, this message translates to:
  /// **'Excused'**
  String get legendExcused;

  /// No description provided for @relapseLoggedThisDay.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Relapse logged on this day.'**
  String get relapseLoggedThisDay;

  /// No description provided for @cleanRecord.
  ///
  /// In en, this message translates to:
  /// **'🌿 Clean record.'**
  String get cleanRecord;

  /// No description provided for @timeOverride.
  ///
  /// In en, this message translates to:
  /// **'TIME OVERRIDE'**
  String get timeOverride;

  /// No description provided for @anchorTime.
  ///
  /// In en, this message translates to:
  /// **'Anchor: {time}'**
  String anchorTime(String time);

  /// No description provided for @checkInTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-in time: {time}'**
  String checkInTimeLabel(String time);

  /// No description provided for @editReason.
  ///
  /// In en, this message translates to:
  /// **'EDIT REASON'**
  String get editReason;

  /// No description provided for @reasonOptional.
  ///
  /// In en, this message translates to:
  /// **'REASON (optional)'**
  String get reasonOptional;

  /// No description provided for @reasonHint.
  ///
  /// In en, this message translates to:
  /// **'Stress, Anxiety, Burnout, Peer pressure, Trigger? etc...'**
  String get reasonHint;

  /// No description provided for @excusedStreakPreserved.
  ///
  /// In en, this message translates to:
  /// **'❄️ Excused, your streak is preserved.'**
  String get excusedStreakPreserved;

  /// No description provided for @checkedInThisDay.
  ///
  /// In en, this message translates to:
  /// **'✅ Checked in on this day.'**
  String get checkedInThisDay;

  /// No description provided for @noCheckInRecorded.
  ///
  /// In en, this message translates to:
  /// **'🌿 No check-in recorded.'**
  String get noCheckInRecorded;

  /// No description provided for @saveNewTime.
  ///
  /// In en, this message translates to:
  /// **'Save New Time'**
  String get saveNewTime;

  /// No description provided for @excuseThisDayInstead.
  ///
  /// In en, this message translates to:
  /// **'Excuse this day instead'**
  String get excuseThisDayInstead;

  /// No description provided for @checkInInstead.
  ///
  /// In en, this message translates to:
  /// **'Check In Instead'**
  String get checkInInstead;

  /// No description provided for @removeExcuse.
  ///
  /// In en, this message translates to:
  /// **'Remove excuse'**
  String get removeExcuse;

  /// No description provided for @updateLog.
  ///
  /// In en, this message translates to:
  /// **'Update Log'**
  String get updateLog;

  /// No description provided for @removeRelapseBtn.
  ///
  /// In en, this message translates to:
  /// **'Remove Relapse'**
  String get removeRelapseBtn;

  /// No description provided for @addRelapseHere.
  ///
  /// In en, this message translates to:
  /// **'Add Relapse Here'**
  String get addRelapseHere;

  /// No description provided for @removeCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Remove Check-in'**
  String get removeCheckIn;

  /// No description provided for @checkInThisDay.
  ///
  /// In en, this message translates to:
  /// **'Check In This Day'**
  String get checkInThisDay;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'EDIT NOTE'**
  String get editNote;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'NOTE (optional)'**
  String get noteOptional;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'How did it go today? Any wins or notes to remember...'**
  String get noteHint;

  /// No description provided for @streakFrozen.
  ///
  /// In en, this message translates to:
  /// **'Streak frozen'**
  String get streakFrozen;

  /// No description provided for @freezeStreak.
  ///
  /// In en, this message translates to:
  /// **'Freeze streak'**
  String get freezeStreak;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'ja',
    'ko',
    'pt',
    'ur',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ur':
      return AppLocalizationsUr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
