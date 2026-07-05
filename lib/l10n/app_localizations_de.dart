// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Grove';

  @override
  String get appTagline => 'G R O V E';

  @override
  String get plantATree => 'Einen Baum pflanzen';

  @override
  String get plantTree => 'Baum pflanzen';

  @override
  String get plantANewTree => 'Neuen Baum pflanzen';

  @override
  String get habitName => 'Gewohnheitsname';

  @override
  String get habitNameHint => 'z.B. Alkohol, Rauchen, Soziale Medien';

  @override
  String get trackingMode => 'TRACKING-MODUS';

  @override
  String get presetColors => 'VOREINGESTELLTE FARBEN';

  @override
  String get customHexCode => 'BENUTZERDEFINIERTER HEX-CODE';

  @override
  String get hexCode => 'Hex-Code';

  @override
  String get invalidHex => 'Ungültiger Hex-Code';

  @override
  String get abstain => 'Abstinenz';

  @override
  String get abstainSubtitle1 => 'Wächst täglich automatisch';

  @override
  String get abstainSubtitle2 => 'Tippen um Rückfall zu erfassen';

  @override
  String get checkIn => 'Einchecken';

  @override
  String get checkInSubtitle1 => 'Täglich einchecken um zu wachsen';

  @override
  String get checkInSubtitle2 => 'Wachstum basiert auf Check-ins';

  @override
  String get history => 'Verlauf';

  @override
  String daysSuffix(Object days) {
    return '${days}T';
  }

  @override
  String historyCount(Object count) {
    return 'Verlauf ($count)';
  }

  @override
  String get relapse => 'Rückfall';

  @override
  String get checkedIn => 'Eingecheckt';

  @override
  String get checkInAction => 'Einchecken';

  @override
  String dayStreak(int days) {
    return '$days-Tage-Serie';
  }

  @override
  String dayCount(int days) {
    return 'Tag $days';
  }

  @override
  String get alreadyCheckedInToday => 'Heute bereits eingecheckt ✓';

  @override
  String get tapBelowToCheckIn => 'Unten tippen zum Einchecken';

  @override
  String get giveHabitName => 'Gib deiner Gewohnheit einen Namen.';

  @override
  String get stageSeed => 'Samen';

  @override
  String get stageSprout => 'Keimling';

  @override
  String get stageSapling => 'Setzling';

  @override
  String get stageYoungTree => 'Junger Baum';

  @override
  String get stageGroveTree => 'Hainbaum';

  @override
  String get taglineSeed => 'Jeder große Wald beginnt hier.';

  @override
  String get taglineSprout => 'Wurzeln bilden sich unter der Oberfläche.';

  @override
  String get taglineSapling => 'Wird mit jedem Sonnenaufgang stärker.';

  @override
  String get taglineYoungTree => 'Dein Blätterdach nimmt Gestalt an.';

  @override
  String get taglineGroveTree => 'Du bist zum Wald geworden.';

  @override
  String get logARelapse => 'Rückfall protokollieren?';

  @override
  String get relapseMotivation => 'Du bist stärker als du denkst.';

  @override
  String get customTimestamp => 'BENUTZERDEFINIERTER ZEITSTEMPEL';

  @override
  String get loggedReason => 'PROTOKOLLIERTER GRUND (Optional)';

  @override
  String get loggedReasonHint =>
      'Stress, Angst, Burnout, Gruppendruck, Auslöser? usw.';

  @override
  String get confirmLog => 'Protokoll bestätigen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get onboarding0Title => 'Willkommen bei Grove 🌿';

  @override
  String get onboarding0Body =>
      'Ein privater Gewohnheitstracker, bei dem Bäume dein Wachstum darstellen. Je länger du abstinent bleibst oder eincheckst, desto lebendiger werden deine Bäume.';

  @override
  String get onboarding1Title => 'Einen Baum pflanzen';

  @override
  String get onboarding1Body =>
      'Tippe auf „Einen Baum pflanzen\", um eine Gewohnheit zu erstellen. Gib ihr einen Namen, wähle eine Farbe, und Grove erstellt einen einzigartigen Baum.';

  @override
  String get onboarding2Title => 'Sieh ihn wachsen';

  @override
  String get onboarding2Body =>
      'Jeder Tag hilft deinem Baum, durch fünf Wachstumsstufen zu reifen — vom winzigen Samen bis zum vollen Hainbaum mit schwankenden Ästen.';

  @override
  String get onboarding3Title => 'Rückfall protokollieren';

  @override
  String get onboarding3Body =>
      'Falls du strauchelst, erfasse es ehrlich. Grove verfolgt deine längsten Serien, dein Fortschritt wird nie gelöscht.';

  @override
  String get onboarding4Title => 'Dein Verlauf';

  @override
  String get onboarding4Body =>
      'Öffne einen Baum, um Kalender, Meilensteine, Serienhistorie und Einblicke in deine langfristige Konsistenz zu erkunden.';

  @override
  String get onboarding5Title => 'Vollständig privat';

  @override
  String get onboarding5Body =>
      'Alles bleibt auf deinem Gerät. Nichts wird jemals gesendet. Sichere oder verschiebe deinen Hain über Export / Import in den Einstellungen. Jetzt wachsen! 🌱';

  @override
  String get next => 'Weiter';

  @override
  String get back => 'Zurück';

  @override
  String get startGrowing => 'Anfangen zu wachsen 🌱';

  @override
  String get groveIsBare => 'Dein Hain ist kahl.';

  @override
  String get plantFirstTree => 'Pflanze deinen ersten Baum, um zu beginnen.';

  @override
  String get settingsHub => 'Einstellungen';

  @override
  String get layoutArchitecture => 'LAYOUT';

  @override
  String get renderThemes => 'DESIGNS';

  @override
  String get privacyNotifications => 'DATENSCHUTZ & BENACHRICHTIGUNGEN';

  @override
  String get dataManagement => 'DATENVERWALTUNG';

  @override
  String get reorderGrove => 'Hain neu anordnen';

  @override
  String get holdDragToReorder => 'Halten & ≡ ziehen zum Neuanordnen';

  @override
  String get layoutWheel => 'Rad';

  @override
  String get layoutCarousel => 'Karussell';

  @override
  String get layoutGrid => 'Raster';

  @override
  String get layoutList => 'Liste';

  @override
  String get themeForestDark => 'Walddunkel';

  @override
  String get themeAmoledBlack => 'AMOLED Schwarz';

  @override
  String get themeMaterialYou => 'Material You';

  @override
  String get themeWhiteMinimal => 'Weißes Minimal';

  @override
  String get milestoneNotifications => 'Meilenstein-Benachrichtigungen';

  @override
  String get milestoneNotificationsSubtitle =>
      'Benachrichtigt werden, wenn ein Baum eine neue Wachstumsstufe erreicht';

  @override
  String get biometricUnlock => 'Biometrische Entsperrung';

  @override
  String get biometricUnlockSubtitle =>
      'Fingerabdruck / PIN zum Öffnen von Grove erforderlich';

  @override
  String get exportGroveBackup => 'Grove-Sicherung exportieren';

  @override
  String get restoreGroveBackup => 'Grove aus Sicherung wiederherstellen';

  @override
  String get exportImportNote =>
      'Export speichert eine .json-Datei an einem Ort deiner Wahl.\nImportieren ersetzt deinen aktuellen Hain • zuerst sichern.';

  @override
  String get backupSaved => '✓ Sicherung gespeichert';

  @override
  String saveFailed(String error) {
    return 'Speichern fehlgeschlagen: $error';
  }

  @override
  String get couldNotReadFile =>
      'Die ausgewählte Datei konnte nicht gelesen werden.';

  @override
  String groveRestored(int count) {
    return '✓ Grove wiederhergestellt — $count Bäume geladen';
  }

  @override
  String get invalidBackup =>
      '✗ Ungültige Sicherung — stelle sicher, dass du die richtige Datei ausgewählt hast';

  @override
  String get language => 'SPRACHE';

  @override
  String get languageLabel => 'Sprache';

  @override
  String get links => 'LINKS';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => 'Quellcode & Beiträge';

  @override
  String get buyMeCoffee => 'Kauf mir einen Kaffee';

  @override
  String get buyMeCoffeeSubtitle => 'Entwicklung unterstützen';

  @override
  String get madeWith =>
      'Gemacht mit 🌿 • alle Daten bleiben auf deinem Gerät.';

  @override
  String get openSource => 'Open Source';

  @override
  String versionLabel(String version) {
    return 'v$version • Open Source';
  }

  @override
  String get groveDescription =>
      'Grove ist ein minimalistischer Gewohnheits- und Nüchternheitstracker, der dein Wachstum durch Bäume visualisiert. An jedem Tag, an dem du abstinent bleibst oder eincheckst, wächst dein Baum. Kostenlos und Open-Source.';

  @override
  String get groveLocked => 'Grove ist gesperrt';

  @override
  String get authenticateToContinue => 'Authentifizieren um fortzufahren';

  @override
  String get unlockGrove => 'Grove entsperren';

  @override
  String get currentStreak => 'Aktuelle Serie';

  @override
  String get peakRecord => 'Spitzenrekord';

  @override
  String get relapses => 'Rückfälle';

  @override
  String get checkIns => 'Check-ins';

  @override
  String get interactiveMonthlyLogs => 'Interaktive Monatsaufzeichnungen';

  @override
  String get swipeForEarlierMonths => '← wischen für frühere Monate';

  @override
  String get thisMonth => 'Diesen Monat';

  @override
  String get logDateBeforeTracking =>
      '← Datum vor Tracking-Beginn protokollieren';

  @override
  String get abstinentSinceStart => 'Keine Rückfälle verzeichnet.';

  @override
  String get timeSinceLastRelapse => 'Zeit seit letztem Rückfall';

  @override
  String get days => 'TAGE';

  @override
  String get hrs => 'STD';

  @override
  String get min => 'MIN';

  @override
  String get sec => 'SEK';

  @override
  String get checkedInToday => 'Heute eingecheckt';

  @override
  String get notCheckedInToday => 'Heute nicht eingecheckt';

  @override
  String get streak => 'SERIE';

  @override
  String get total => 'GESAMT';

  @override
  String get alreadyCheckedIn => 'Bereits eingecheckt';

  @override
  String get checkInToday => 'Heute einchecken';

  @override
  String get relapseSweepTimeline => 'Rückfall-Zeitleiste';

  @override
  String get checkInHistory => 'Check-in-Verlauf';

  @override
  String totalCount(int count) {
    return '$count gesamt';
  }

  @override
  String get noRelapsesRecorded => 'Keine Rückfälle erfasst. Wachse weiter.';

  @override
  String get noCheckInsYet => 'Noch keine Check-ins. Starte heute!';

  @override
  String get renameHabit => 'Gewohnheit umbenennen';

  @override
  String get changeColor => 'Farbe ändern';

  @override
  String get habitOptions => 'Gewohnheitsoptionen';

  @override
  String get save => 'Speichern';

  @override
  String get dangerZone => 'Gefahrenzone';

  @override
  String get deleteHabitPermanently => 'Gewohnheit dauerhaft löschen';

  @override
  String get deleteHabit => 'Gewohnheit löschen?';

  @override
  String deleteHabitConfirm(String name) {
    return 'Dadurch wird \"$name\" und der gesamte Verlauf dauerhaft gelöscht. Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get delete => 'Löschen';

  @override
  String get earlierThanLogs => 'Früher als deine Aufzeichnungen?';

  @override
  String trackingStarted(String date) {
    return 'Tracking begann am $date.\nWenn davor etwas passiert ist, kannst du es hier protokollieren.';
  }

  @override
  String get logEarlierDate => 'Früheres Datum protokollieren';

  @override
  String get extendsHistoryNote =>
      'Dies erweitert deinen Verlauf und berechnet Serien neu';

  @override
  String get logEarlierDateTitle => 'Früheres Datum protokollieren';

  @override
  String get beforeTrackingStarted => 'Vor Beginn des Trackings';

  @override
  String get extendHistoryInfo =>
      'Dies erweitert deinen Tracking-Verlauf und berechnet deine Spitzenserien neu.';

  @override
  String get date => 'DATUM';

  @override
  String get time => 'UHRZEIT';

  @override
  String get logAsRelapseOnDate =>
      'Als Rückfall an diesem Datum protokollieren';

  @override
  String get onlyExtendStartDate => 'Nur Startdatum erweitern (kein Rückfall)';

  @override
  String get whatHappenedHint => 'Was ist an dem Tag passiert…';

  @override
  String peakSweep(int days) {
    return 'Spitzenserie: $days Tage';
  }

  @override
  String get noReasonRecorded => 'Kein Grund protokolliert.';

  @override
  String notifSproutTitle(String name) {
    return '$name keimt! 🌱';
  }

  @override
  String get notifSproutBody =>
      'Die Wurzeln deines Baumes sind fertig gebildet. Wachse weiter.';

  @override
  String notifSaplingTitle(String name) {
    return '$name ist jetzt ein Setzling! 🌿';
  }

  @override
  String get notifSaplingBody =>
      'Dein Baum steht auf eigenen Beinen – sieh, wie weit du gekommen bist';

  @override
  String notifYoungTreeTitle(String name) {
    return '$name wächst! 🌳';
  }

  @override
  String get notifYoungTreeBody =>
      'Dein Blätterdach nimmt Gestalt an, unglaublich.';

  @override
  String notifGroveTreeTitle(String name) {
    return '$name ist ein Hainbaum! 🌲';
  }

  @override
  String get notifGroveTreeBody =>
      'Herzlichen Glückwunsch!!! Du bist zum Wald geworden.';

  @override
  String get saveGroveBackupDialog => 'Grove-Sicherung speichern';

  @override
  String get selectGroveBackupDialog => 'Grove-Sicherung auswählen';

  @override
  String get customAccentColor => 'Benutzerdefinierte Akzentfarbe';

  @override
  String get customAccentDefault => 'Standard-Grün';

  @override
  String get customAccentSubtitle =>
      'Auf Schaltflächen, Karten und Abzeichen angewendet';

  @override
  String get applyAccent => 'Akzent anwenden';

  @override
  String get resetAccentDefault => 'Auf Standard zurücksetzen';

  @override
  String get dailyReminderSetting => 'Tägliche Check-in-Erinnerung';

  @override
  String get dailyReminderSettingSubtitle =>
      'Ein Anstoß, in deinem Hain einzuchecken';

  @override
  String get tapToChange => 'Zum Ändern tippen';

  @override
  String get languageSection => 'SPRACHE';

  @override
  String get dailyReminderTitle => 'Zeit zum Einchecken 🌿';

  @override
  String get dailyReminderBody => 'Dein Hain wartet. Halte die Serie am Leben.';

  @override
  String get legendMissed => 'Verpasst';

  @override
  String get legendAbstained => 'Enthalten';

  @override
  String get legendCheckIn => 'Check-in';

  @override
  String get legendRelapse => 'Rückfall';

  @override
  String get legendExcused => 'Entschuldigt';

  @override
  String get relapseLoggedThisDay =>
      '⚠️ An diesem Tag wurde ein Rückfall protokolliert.';

  @override
  String get cleanRecord => '🌿 Sauberer Eintrag.';

  @override
  String get timeOverride => 'ZEIT ÜBERSCHREIBEN';

  @override
  String anchorTime(String time) {
    return 'Anker: $time';
  }

  @override
  String checkInTimeLabel(String time) {
    return 'Check-in-Zeit: $time';
  }

  @override
  String get editReason => 'GRUND BEARBEITEN';

  @override
  String get reasonOptional => 'GRUND (optional)';

  @override
  String get reasonHint =>
      'Stress, Angst, Erschöpfung, Gruppendruck, Auslöser? usw.';

  @override
  String get excusedStreakPreserved =>
      '❄️ Entschuldigt, deine Serie bleibt erhalten.';

  @override
  String get checkedInThisDay => '✅ An diesem Tag eingecheckt.';

  @override
  String get noCheckInRecorded => '🌿 Kein Check-in erfasst.';

  @override
  String get saveNewTime => 'Neue Zeit speichern';

  @override
  String get excuseThisDayInstead => 'Diesen Tag stattdessen entschuldigen';

  @override
  String get checkInInstead => 'Stattdessen einchecken';

  @override
  String get removeExcuse => 'Entschuldigung entfernen';

  @override
  String get updateLog => 'Eintrag aktualisieren';

  @override
  String get removeRelapseBtn => 'Rückfall entfernen';

  @override
  String get addRelapseHere => 'Rückfall hier hinzufügen';

  @override
  String get removeCheckIn => 'Check-in entfernen';

  @override
  String get checkInThisDay => 'An diesem Tag einchecken';

  @override
  String get editNote => 'NOTIZ BEARBEITEN';

  @override
  String get noteOptional => 'NOTIZ (optional)';

  @override
  String get noteHint =>
      'Wie lief dein Tag? Erfolge oder Notizen, die du festhalten möchtest...';

  @override
  String get streakFrozen => 'Serie eingefroren';

  @override
  String get freezeStreak => 'Serie einfrieren';
}
