// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Grove';

  @override
  String get appTagline => 'G R O V E';

  @override
  String get plantATree => 'Pianta un albero';

  @override
  String get plantTree => 'Pianta albero';

  @override
  String get plantANewTree => 'Pianta un nuovo albero';

  @override
  String get habitName => 'Nome dell\'abitudine';

  @override
  String get habitNameHint => 'Es. Alcol, Fumo, Social media';

  @override
  String get trackingMode => 'MODALITÀ DI TRACCIAMENTO';

  @override
  String get presetColors => 'COLORI PREDEFINITI';

  @override
  String get customHexCode => 'CODICE HEX PERSONALIZZATO';

  @override
  String get hexCode => 'Codice Hex';

  @override
  String get invalidHex => 'Hex non valido';

  @override
  String get abstain => 'Astinenza';

  @override
  String get abstainSubtitle1 => 'Cresce automaticamente ogni giorno';

  @override
  String get abstainSubtitle2 => 'Tocca per registrare una ricaduta';

  @override
  String get checkIn => 'Check-in';

  @override
  String get checkInSubtitle1 => 'Fai il check-in quotidiano per crescere';

  @override
  String get checkInSubtitle2 => 'Crescita basata sui check-in';

  @override
  String get history => 'Cronologia';

  @override
  String daysSuffix(Object days) {
    return '${days}g';
  }

  @override
  String historyCount(Object count) {
    return 'Cronologia ($count)';
  }

  @override
  String get relapse => 'Ricaduta';

  @override
  String get checkedIn => 'Check-in effettuato';

  @override
  String get checkInAction => 'Check-in';

  @override
  String dayStreak(int days) {
    return 'Serie di $days giorni';
  }

  @override
  String dayCount(int days) {
    return 'Giorno $days';
  }

  @override
  String get alreadyCheckedInToday => 'Check-in già effettuato oggi ✓';

  @override
  String get tapBelowToCheckIn => 'Tocca qui sotto per fare il check-in';

  @override
  String get giveHabitName => 'Dai un nome alla tua abitudine.';

  @override
  String get stageSeed => 'Seme';

  @override
  String get stageSprout => 'Germoglio';

  @override
  String get stageSapling => 'Alberello';

  @override
  String get stageYoungTree => 'Albero giovane';

  @override
  String get stageGroveTree => 'Albero del bosco';

  @override
  String get taglineSeed => 'Ogni grande foresta inizia qui.';

  @override
  String get taglineSprout =>
      'Le radici si stanno formando sotto la superficie.';

  @override
  String get taglineSapling => 'Sempre più forte a ogni alba.';

  @override
  String get taglineYoungTree => 'La tua chioma sta prendendo forma.';

  @override
  String get taglineGroveTree => 'Sei diventato la foresta.';

  @override
  String get logARelapse => 'Registra una ricaduta?';

  @override
  String get relapseMotivation => 'Sei più forte di quanto pensi.';

  @override
  String get customTimestamp => 'TIMESTAMP PERSONALIZZATO';

  @override
  String get loggedReason => 'MOTIVO REGISTRATO (Facoltativo)';

  @override
  String get loggedReasonHint =>
      'Stress, Ansia, Burnout, Pressione dei pari, Trigger? ecc.';

  @override
  String get confirmLog => 'Conferma registro';

  @override
  String get cancel => 'Annulla';

  @override
  String get onboarding0Title => 'Benvenuto in Grove 🌿';

  @override
  String get onboarding0Body =>
      'Un tracker delle abitudini privato dove gli alberi rappresentano la tua crescita. Più a lungo ti astieni o registri, più i tuoi alberi diventano rigogliosi.';

  @override
  String get onboarding1Title => 'Pianta un albero';

  @override
  String get onboarding1Body =>
      'Tocca \"Pianta un albero\" per creare un\'abitudine. Dagli un nome, scegli un colore e Grove genera un albero unico per essa.';

  @override
  String get onboarding2Title => 'Guardalo crescere';

  @override
  String get onboarding2Body =>
      'Ogni giorno aiuta il tuo albero a maturare attraverso cinque stadi di crescita, da un piccolo seme fino a un albero del bosco con rami e foglie che ondeggiano.';

  @override
  String get onboarding3Title => 'Registra una ricaduta';

  @override
  String get onboarding3Body =>
      'Se sbagli, registralo onestamente. Grove tiene traccia delle tue serie più lunghe e della cronologia, i progressi non vengono mai cancellati.';

  @override
  String get onboarding4Title => 'La tua cronologia';

  @override
  String get onboarding4Body =>
      'Apri qualsiasi albero per esplorare calendari, traguardi, cronologia delle serie e approfondimenti sulla tua coerenza a lungo termine.';

  @override
  String get onboarding5Title => 'Completamente privato';

  @override
  String get onboarding5Body =>
      'Tutto rimane sul tuo dispositivo. Niente viene mai inviato. Esegui il backup o sposta il tuo bosco tramite Esporta / Importa nelle Impostazioni. Ora vai a far crescere qualcosa! 🌱';

  @override
  String get next => 'Avanti';

  @override
  String get back => 'Indietro';

  @override
  String get startGrowing => 'Inizia a crescere 🌱';

  @override
  String get groveIsBare => 'Il tuo bosco è vuoto.';

  @override
  String get plantFirstTree => 'Pianta il tuo primo albero per iniziare.';

  @override
  String get settingsHub => 'Impostazioni';

  @override
  String get layoutArchitecture => 'LAYOUT';

  @override
  String get renderThemes => 'TEMI';

  @override
  String get privacyNotifications => 'PRIVACY E NOTIFICHE';

  @override
  String get dataManagement => 'GESTIONE DATI';

  @override
  String get reorderGrove => 'Riordina bosco';

  @override
  String get holdDragToReorder => 'Tieni premuto e trascina ≡ per riordinare';

  @override
  String get layoutWheel => 'Ruota';

  @override
  String get layoutCarousel => 'Carosello';

  @override
  String get layoutGrid => 'Griglia';

  @override
  String get layoutList => 'Lista';

  @override
  String get themeForestDark => 'Foresta Scura';

  @override
  String get themeAmoledBlack => 'AMOLED Nero';

  @override
  String get themeMaterialYou => 'Material You';

  @override
  String get themeWhiteMinimal => 'Bianco Minimale';

  @override
  String get milestoneNotifications => 'Notifiche traguardi';

  @override
  String get milestoneNotificationsSubtitle =>
      'Ricevi una notifica quando un albero raggiunge un nuovo stadio di crescita';

  @override
  String get biometricUnlock => 'Sblocco biometrico';

  @override
  String get biometricUnlockSubtitle =>
      'Richiede impronta digitale / PIN per aprire Grove';

  @override
  String get exportGroveBackup => 'Esporta backup Grove';

  @override
  String get restoreGroveBackup => 'Ripristina Grove dal backup';

  @override
  String get exportImportNote =>
      'L\'esportazione salva un file .json in una posizione a tua scelta.\nL\'importazione sostituirà il tuo bosco attuale • esporta prima un backup.';

  @override
  String get backupSaved => '✓ Backup salvato';

  @override
  String saveFailed(String error) {
    return 'Salvataggio fallito: $error';
  }

  @override
  String get couldNotReadFile => 'Impossibile leggere il file selezionato.';

  @override
  String groveRestored(int count) {
    return '✓ Grove ripristinato — $count alberi caricati';
  }

  @override
  String get invalidBackup =>
      '✗ Backup non valido — assicurati di aver selezionato il file corretto';

  @override
  String get language => 'LINGUA';

  @override
  String get languageLabel => 'Lingua';

  @override
  String get links => 'LINK';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => 'Codice sorgente e contributi';

  @override
  String get buyMeCoffee => 'Offrimi un caffè';

  @override
  String get buyMeCoffeeSubtitle => 'Supporta lo sviluppo';

  @override
  String get needHelp => 'Hai bisogno di parlare con qualcuno?';

  @override
  String get needHelpSubtitle => 'È disponibile supporto gratuito e riservato';

  @override
  String get madeWith =>
      'Fatto con 🌿 • tutti i dati rimangono sul tuo dispositivo.';

  @override
  String get openSource => 'Open Source';

  @override
  String versionLabel(String version) {
    return 'v$version • Open Source';
  }

  @override
  String get groveDescription =>
      'Grove è un tracker delle abitudini e della sobrietà minimalista che visualizza la tua crescita attraverso alberi. Ogni giorno in cui ti astieni o registri, il tuo albero cresce. Gratuito e open source.';

  @override
  String get groveLocked => 'Grove è bloccato';

  @override
  String get authenticateToContinue => 'Autenticati per continuare';

  @override
  String get unlockGrove => 'Sblocca Grove';

  @override
  String get currentStreak => 'Serie attuale';

  @override
  String get peakRecord => 'Record massimo';

  @override
  String get relapses => 'Ricadute';

  @override
  String get checkIns => 'Check-in';

  @override
  String get interactiveMonthlyLogs => 'Registri mensili interattivi';

  @override
  String get swipeForEarlierMonths => 'Scorri ← per i mesi precedenti';

  @override
  String get thisMonth => 'Questo mese';

  @override
  String get logDateBeforeTracking =>
      '← Registra una data prima dell\'inizio del tracciamento';

  @override
  String get abstinentSinceStart => 'Nessuna ricaduta registrata.';

  @override
  String get timeSinceLastRelapse => 'Tempo dall\'ultima ricaduta';

  @override
  String get days => 'GIORNI';

  @override
  String get hrs => 'ORE';

  @override
  String get min => 'MIN';

  @override
  String get sec => 'S';

  @override
  String get checkedInToday => 'Check-in effettuato oggi';

  @override
  String get notCheckedInToday => 'Nessun check-in oggi';

  @override
  String get streak => 'SERIE';

  @override
  String get total => 'TOTALE';

  @override
  String get alreadyCheckedIn => 'Check-in già effettuato';

  @override
  String get checkInToday => 'Check-in oggi';

  @override
  String get relapseSweepTimeline => 'Linea temporale ricadute';

  @override
  String get checkInHistory => 'Cronologia check-in';

  @override
  String totalCount(int count) {
    return '$count in totale';
  }

  @override
  String get noRelapsesRecorded =>
      'Nessuna ricaduta registrata. Continua a crescere.';

  @override
  String get noCheckInsYet => 'Ancora nessun check-in. Inizia oggi!';

  @override
  String get renameHabit => 'Rinomina abitudine';

  @override
  String get changeColor => 'Cambia colore';

  @override
  String get rerollTreeShape => 'Rigenera forma dell\'albero';

  @override
  String get rerollTreeShapeConfirm =>
      'Questo genererà una nuova forma casuale per questo albero. La tua serie e la cronologia non cambieranno.';

  @override
  String get habitOptions => 'Opzioni abitudine';

  @override
  String get save => 'Salva';

  @override
  String get dangerZone => 'Zona pericolosa';

  @override
  String get deleteHabitPermanently => 'Elimina abitudine definitivamente';

  @override
  String get deleteHabit => 'Eliminare l\'abitudine?';

  @override
  String deleteHabitConfirm(String name) {
    return 'Questa azione eliminerà definitivamente \"$name\" e tutta la sua cronologia. Non può essere annullata.';
  }

  @override
  String get delete => 'Elimina';

  @override
  String get earlierThanLogs => 'Prima dei tuoi registri?';

  @override
  String trackingStarted(String date) {
    return 'Tracciamento iniziato il $date.\nSe è successo qualcosa prima, puoi registrarlo qui.';
  }

  @override
  String get logEarlierDate => 'Registra una data precedente';

  @override
  String get extendsHistoryNote =>
      'Questo estende la tua cronologia e ricalcola le serie';

  @override
  String get logEarlierDateTitle => 'Registra data precedente';

  @override
  String get beforeTrackingStarted => 'Prima dell\'inizio del tracciamento';

  @override
  String get extendHistoryInfo =>
      'Questo estenderà la tua cronologia di tracciamento e ricalcolerà le tue serie record.';

  @override
  String get date => 'DATA';

  @override
  String get time => 'ORA';

  @override
  String get logAsRelapseOnDate => 'Registra come ricaduta in questa data';

  @override
  String get onlyExtendStartDate =>
      'Solo estendi la data di inizio (nessuna ricaduta)';

  @override
  String get whatHappenedHint => 'Cosa è successo quel giorno…';

  @override
  String peakSweep(int days) {
    return 'Serie massima: $days giorni';
  }

  @override
  String get noReasonRecorded => 'Nessun motivo registrato.';

  @override
  String notifSproutTitle(String name) {
    return '$name sta germogliando! 🌱';
  }

  @override
  String get notifSproutBody =>
      'Le radici del tuo albero hanno finito di formarsi. Continua a crescere.';

  @override
  String notifSaplingTitle(String name) {
    return '$name è un alberello ora! 🌿';
  }

  @override
  String get notifSaplingBody =>
      'Il tuo albero regge da solo, guarda quanto sei cresciuto';

  @override
  String notifYoungTreeTitle(String name) {
    return '$name sta crescendo! 🌳';
  }

  @override
  String get notifYoungTreeBody =>
      'La tua chioma sta iniziando a prendere forma, incredibile.';

  @override
  String notifGroveTreeTitle(String name) {
    return '$name è un albero del bosco! 🌲';
  }

  @override
  String get notifGroveTreeBody =>
      'Congratulazioni!!! Sei diventato la foresta.';

  @override
  String get saveGroveBackupDialog => 'Salva backup Grove';

  @override
  String get selectGroveBackupDialog => 'Seleziona backup Grove';

  @override
  String get customAccentColor => 'Colore evidenziazione personalizzato';

  @override
  String get customAccentDefault => 'Verde predefinito';

  @override
  String get customAccentSubtitle => 'Applicato a pulsanti, schede e badge';

  @override
  String get applyAccent => 'Applica evidenziazione';

  @override
  String get resetAccentDefault => 'Ripristina predefinito';

  @override
  String get dailyReminderSetting => 'Promemoria check-in giornaliero';

  @override
  String get dailyReminderSettingSubtitle =>
      'Un promemoria per fare il check-in nel tuo bosco';

  @override
  String get tapToChange => 'Tocca per modificare';

  @override
  String get languageSection => 'LINGUA';

  @override
  String get dailyReminderTitle => 'È ora del check-in 🌿';

  @override
  String get dailyReminderBody =>
      'Il tuo bosco ti aspetta. Mantieni la serie viva.';

  @override
  String get legendMissed => 'Mancato';

  @override
  String get legendAbstained => 'Astenuto';

  @override
  String get legendCheckIn => 'Check-in';

  @override
  String get legendRelapse => 'Ricaduta';

  @override
  String get legendExcused => 'Scusato';

  @override
  String get relapseLoggedThisDay => '⚠️ Ricaduta registrata in questo giorno.';

  @override
  String get cleanRecord => '🌿 Registro pulito.';

  @override
  String get timeOverride => 'MODIFICA ORARIO';

  @override
  String anchorTime(String time) {
    return 'Ancoraggio: $time';
  }

  @override
  String checkInTimeLabel(String time) {
    return 'Orario di check-in: $time';
  }

  @override
  String get editReason => 'MODIFICA MOTIVO';

  @override
  String get reasonOptional => 'MOTIVO (facoltativo)';

  @override
  String get reasonHint =>
      'Stress, ansia, burnout, pressione sociale, fattore scatenante? ecc.';

  @override
  String get excusedStreakPreserved => '❄️ Scusato, la tua serie è preservata.';

  @override
  String get checkedInThisDay => '✅ Check-in effettuato in questo giorno.';

  @override
  String get noCheckInRecorded => '🌿 Nessun check-in registrato.';

  @override
  String get saveNewTime => 'Salva nuovo orario';

  @override
  String get excuseThisDayInstead => 'Scusa questo giorno invece';

  @override
  String get checkInInstead => 'Fai check-in invece';

  @override
  String get removeExcuse => 'Rimuovi scusa';

  @override
  String get updateLog => 'Aggiorna registro';

  @override
  String get removeRelapseBtn => 'Rimuovi ricaduta';

  @override
  String get addRelapseHere => 'Aggiungi ricaduta qui';

  @override
  String get removeCheckIn => 'Rimuovi check-in';

  @override
  String get checkInThisDay => 'Fai check-in per questo giorno';

  @override
  String get editNote => 'MODIFICA NOTA';

  @override
  String get noteOptional => 'NOTA (facoltativo)';

  @override
  String get noteHint => 'Com\'è andata oggi? Successi o note da ricordare...';

  @override
  String get streakFrozen => 'Serie congelata';

  @override
  String get freezeStreak => 'Congela la serie';

  @override
  String get excusedDaysCount => 'I giorni giustificati contano';

  @override
  String get excuseStreakToggle => 'Conta i giorni giustificati';
}
