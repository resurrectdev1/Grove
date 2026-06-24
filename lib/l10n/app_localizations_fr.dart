// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Grove';

  @override
  String get appTagline => 'G R O V E';

  @override
  String get plantATree => 'Planter un arbre';

  @override
  String get plantTree => 'Planter l\'arbre';

  @override
  String get plantANewTree => 'Planter un nouvel arbre';

  @override
  String get habitName => 'Nom de l\'habitude';

  @override
  String get habitNameHint => 'Ex : Alcool, Tabac, Réseaux sociaux';

  @override
  String get trackingMode => 'MODE DE SUIVI';

  @override
  String get presetColors => 'COULEURS PRÉDÉFINIES';

  @override
  String get customHexCode => 'CODE HEX PERSONNALISÉ';

  @override
  String get hexCode => 'Code Hex';

  @override
  String get invalidHex => 'Code hex invalide';

  @override
  String get abstain => 'Abstinence';

  @override
  String get abstainSubtitle1 => 'Croît automatiquement chaque jour';

  @override
  String get abstainSubtitle2 => 'Appuyez pour enregistrer une rechute';

  @override
  String get checkIn => 'Pointage';

  @override
  String get checkInSubtitle1 => 'Pointez chaque jour pour progresser';

  @override
  String get checkInSubtitle2 => 'Croissance basée sur les pointages';

  @override
  String get history => 'Historique';

  @override
  String daysSuffix(Object days) {
    return '$days j';
  }

  @override
  String historyCount(Object count) {
    return 'Historique ($count)';
  }

  @override
  String get relapse => 'Rechute';

  @override
  String get checkedIn => 'Pointé';

  @override
  String get checkInAction => 'Pointer';

  @override
  String dayStreak(int days) {
    return 'Série de $days jours';
  }

  @override
  String dayCount(int days) {
    return 'Jour $days';
  }

  @override
  String get alreadyCheckedInToday => 'Déjà pointé aujourd\'hui ✓';

  @override
  String get tapBelowToCheckIn => 'Appuyez ci-dessous pour pointer';

  @override
  String get giveHabitName => 'Donnez un nom à votre habitude.';

  @override
  String get stageSeed => 'Graine';

  @override
  String get stageSprout => 'Germe';

  @override
  String get stageSapling => 'Jeune pousse';

  @override
  String get stageYoungTree => 'Jeune arbre';

  @override
  String get stageGroveTree => 'Arbre du bosquet';

  @override
  String get taglineSeed => 'Toute grande forêt commence ici.';

  @override
  String get taglineSprout => 'Les racines se forment sous la surface.';

  @override
  String get taglineSapling => 'De plus en plus fort à chaque lever du soleil.';

  @override
  String get taglineYoungTree => 'Votre canopée prend forme.';

  @override
  String get taglineGroveTree => 'Vous êtes devenu la forêt.';

  @override
  String get logARelapse => 'Enregistrer une rechute ?';

  @override
  String get relapseMotivation => 'Vous êtes plus fort que vous ne le pensez.';

  @override
  String get customTimestamp => 'HORODATAGE PERSONNALISÉ';

  @override
  String get loggedReason => 'MOTIF ENREGISTRÉ (Optionnel)';

  @override
  String get loggedReasonHint => 'Stress, anxiété, épuisement, pression sociale, déclencheur, etc.';

  @override
  String get confirmLog => 'Confirmer';

  @override
  String get cancel => 'Annuler';

  @override
  String get onboarding0Title => 'Bienvenue sur Grove 🌿';

  @override
  String get onboarding0Body => 'Un suivi privé de sobriété et d\'habitudes où les arbres représentent votre croissance. Plus vous restez sobre longtemps, plus vos arbres deviennent vibrants et luxuriants.';

  @override
  String get onboarding1Title => 'Plantez un arbre';

  @override
  String get onboarding1Body => 'Appuyez sur « Planter un arbre » pour créer une habitude. Donnez-lui un nom, choisissez une couleur, et Grove génère un arbre unique. Chacun grandit différemment.';

  @override
  String get onboarding2Title => 'Regardez-le pousser';

  @override
  String get onboarding2Body => 'Chaque jour sans rechute aide votre arbre à mûrir à travers cinq stades de croissance, d\'une toute petite graine jusqu\'à un arbre majestueux aux branches balancées par le vent.';

  @override
  String get onboarding3Title => 'Enregistrez une rechute';

  @override
  String get onboarding3Body => 'Si vous rechutez, enregistrez-le honnêtement. Grove suit vos plus longues séries et votre historique, afin que votre progrès ne soit jamais effacé.';

  @override
  String get onboarding4Title => 'Votre historique';

  @override
  String get onboarding4Body => 'Ouvrez n\'importe quel arbre pour explorer les calendriers, jalons, historique de séries, notes de rechutes et aperçus de votre constance à long terme.';

  @override
  String get onboarding5Title => 'Entièrement privé';

  @override
  String get onboarding5Body => 'Tout reste sur votre appareil. Rien n\'est jamais envoyé nulle part. Sauvegardez ou transférez votre bosquet à tout moment via Exporter / Importer dans les paramètres. Allez maintenant cultiver quelque chose qui en vaut la peine. 🌱';

  @override
  String get next => 'Suivant';

  @override
  String get back => 'Retour';

  @override
  String get startGrowing => 'Commencer à grandir 🌱';

  @override
  String get groveIsBare => 'Votre bosquet est vide.';

  @override
  String get plantFirstTree => 'Plantez votre premier arbre pour commencer.';

  @override
  String get settingsHub => 'Paramètres';

  @override
  String get layoutArchitecture => 'DISPOSITION';

  @override
  String get renderThemes => 'THÈMES';

  @override
  String get privacyNotifications => 'CONFIDENTIALITÉ ET NOTIFICATIONS';

  @override
  String get dataManagement => 'GESTION DES DONNÉES';

  @override
  String get reorderGrove => 'Réorganiser le bosquet';

  @override
  String get holdDragToReorder => 'Maintenez et faites glisser ≡ pour réorganiser';

  @override
  String get layoutWheel => 'Roue';

  @override
  String get layoutCarousel => 'Carrousel';

  @override
  String get layoutGrid => 'Grille';

  @override
  String get layoutList => 'Liste';

  @override
  String get themeForestDark => 'Forêt sombre';

  @override
  String get themeAmoledBlack => 'Noir AMOLED';

  @override
  String get themeMaterialYou => 'Material You';

  @override
  String get themeWhiteMinimal => 'Blanc minimaliste';

  @override
  String get milestoneNotifications => 'Notifications de jalons';

  @override
  String get milestoneNotificationsSubtitle => 'Soyez notifié quand un arbre atteint un nouveau stade de croissance';

  @override
  String get biometricUnlock => 'Déverrouillage biométrique';

  @override
  String get biometricUnlockSubtitle => 'Requérir empreinte / code PIN pour ouvrir Grove';

  @override
  String get exportGroveBackup => 'Exporter une sauvegarde';

  @override
  String get restoreGroveBackup => 'Restaurer le bosquet depuis une sauvegarde';

  @override
  String get exportImportNote => 'L\'export sauvegarde un fichier .json à l\'emplacement de votre choix.\nL\'import remplacera votre bosquet actuel • exportez d\'abord une sauvegarde.';

  @override
  String get backupSaved => '✓ Sauvegarde enregistrée';

  @override
  String saveFailed(String error) {
    return 'Échec de la sauvegarde : $error';
  }

  @override
  String get couldNotReadFile => 'Impossible de lire le fichier sélectionné.';

  @override
  String groveRestored(int count) {
    return '✓ Bosquet restauré — $count arbres chargés';
  }

  @override
  String get invalidBackup => '✗ Sauvegarde invalide — assurez-vous de sélectionner le bon fichier';

  @override
  String get language => 'LANGUE';

  @override
  String get languageLabel => 'Langue';

  @override
  String get links => 'LIENS';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => 'Code source et contributions';

  @override
  String get buyMeCoffee => 'Offrez-moi un café';

  @override
  String get buyMeCoffeeSubtitle => 'Soutenir le développement';

  @override
  String get madeWith => 'Fait avec 🌿 • toutes les données restent sur votre appareil.';

  @override
  String get openSource => 'Open source';

  @override
  String versionLabel(String version) {
    return 'v$version • Open source';
  }

  @override
  String get groveDescription => 'Grove est un suivi d\'habitudes minimaliste qui visualise votre croissance à travers des arbres. Chaque jour sobre, votre arbre grandit. Créé avec amour comme un outil gratuit et open source.';

  @override
  String get groveLocked => 'Grove est verrouillé';

  @override
  String get authenticateToContinue => 'Authentifiez-vous pour continuer';

  @override
  String get unlockGrove => 'Déverrouiller Grove';

  @override
  String get currentStreak => 'Série actuelle';

  @override
  String get peakRecord => 'Record maximum';

  @override
  String get relapses => 'Rechutes';

  @override
  String get checkIns => 'Pointages';

  @override
  String get interactiveMonthlyLogs => 'Journaux mensuels interactifs';

  @override
  String get swipeForEarlierMonths => 'Glissez ← pour les mois précédents';

  @override
  String get thisMonth => 'Ce mois-ci';

  @override
  String get logDateBeforeTracking => '← Enregistrer une date avant le début du suivi';

  @override
  String get cleanSinceStart => 'Sobre depuis le début';

  @override
  String get timeSinceLastRelapse => 'Temps depuis la dernière rechute';

  @override
  String get days => 'JOURS';

  @override
  String get hrs => 'H';

  @override
  String get min => 'MIN';

  @override
  String get sec => 'S';

  @override
  String get checkedInToday => 'Pointé aujourd\'hui';

  @override
  String get notCheckedInToday => 'Non pointé aujourd\'hui';

  @override
  String get streak => 'SÉRIE';

  @override
  String get total => 'TOTAL';

  @override
  String get alreadyCheckedIn => 'Déjà pointé';

  @override
  String get checkInToday => 'Pointer aujourd\'hui';

  @override
  String get relapseSweepTimeline => 'Chronologie des rechutes';

  @override
  String get checkInHistory => 'Historique des pointages';

  @override
  String totalCount(int count) {
    return '$count au total';
  }

  @override
  String get noRelapsesRecorded => 'Aucune rechute enregistrée. Continuez à grandir.';

  @override
  String get noCheckInsYet => 'Aucun pointage encore. Commencez aujourd\'hui !';

  @override
  String get renameHabit => 'Renommer l\'habitude';

  @override
  String get save => 'Enregistrer';

  @override
  String get dangerZone => 'Zone dangereuse';

  @override
  String get deleteHabitPermanently => 'Supprimer l\'habitude définitivement';

  @override
  String get deleteHabit => 'Supprimer l\'habitude ?';

  @override
  String deleteHabitConfirm(String name) {
    return 'Cela supprimera définitivement « $name » et tout son historique. Cette action est irréversible.';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get earlierThanLogs => 'Antérieur à vos journaux ?';

  @override
  String trackingStarted(String date) {
    return 'Le suivi a commencé le $date.\nSi quelque chose s\'est passé avant, vous pouvez l\'enregistrer ici.';
  }

  @override
  String get logEarlierDate => 'Enregistrer une date antérieure';

  @override
  String get extendsHistoryNote => 'Cela étend votre historique et recalcule les séries';

  @override
  String get logEarlierDateTitle => 'Enregistrer une date antérieure';

  @override
  String get beforeTrackingStarted => 'Avant le début du suivi';

  @override
  String get extendHistoryInfo => 'Cela étendra votre historique de suivi et recalculera vos meilleures séries.';

  @override
  String get date => 'DATE';

  @override
  String get time => 'HEURE';

  @override
  String get logAsRelapseOnDate => 'Enregistrer comme rechute à cette date';

  @override
  String get onlyExtendStartDate => 'Seulement étendre la date de début (sans rechute)';

  @override
  String get whatHappenedHint => 'Que s\'est-il passé ce jour-là…';

  @override
  String peakSweep(int days) {
    return 'Meilleure série : $days jours';
  }

  @override
  String get noReasonRecorded => 'Aucun motif enregistré.';

  @override
  String notifSproutTitle(String name) {
    return '$name germe ! 🌱';
  }

  @override
  String get notifSproutBody => 'Les racines de votre arbre sont formées. Continuez à grandir.';

  @override
  String notifSaplingTitle(String name) {
    return '$name est une jeune pousse ! 🌿';
  }

  @override
  String get notifSaplingBody => 'Votre arbre tient debout, regardez comme vous avez grandi';

  @override
  String notifYoungTreeTitle(String name) {
    return '$name grandit en hauteur ! 🌳';
  }

  @override
  String get notifYoungTreeBody => 'Votre canopée prend forme, incroyable.';

  @override
  String notifGroveTreeTitle(String name) {
    return '$name est un arbre du bosquet ! 🌲';
  }

  @override
  String get notifGroveTreeBody => 'Félicitations !!! Vous êtes devenu la forêt.';

  @override
  String get saveGroveBackupDialog => 'Enregistrer la sauvegarde';

  @override
  String get selectGroveBackupDialog => 'Sélectionner une sauvegarde';

  @override
  String get customAccentColor => 'Accent personnalisé';

  @override
  String get customAccentDefault => 'Vert par défaut';

  @override
  String get customAccentSubtitle => 'Appliqué sur les boutons, cartes et badges';

  @override
  String get applyAccent => 'Appliquer l\'accent';

  @override
  String get resetAccentDefault => 'Rétablir par défaut';

  @override
  String get dailyReminderSetting => 'Rappel quotidien de check-in';

  @override
  String get dailyReminderSettingSubtitle => 'Votre forêt vous attend !';

  @override
  String get tapToChange => 'Appuyez pour modifier';

  @override
  String get languageSection => 'LANGUE';

  @override
  String get dailyReminderTitle => 'C\'est l\'heure du pointage 🌿';

  @override
  String get dailyReminderBody => 'Votre bosquet vous attend. Gardez la série vivante.';
}
