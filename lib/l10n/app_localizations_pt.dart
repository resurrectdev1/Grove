// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Grove';

  @override
  String get appTagline => 'G R O V E';

  @override
  String get plantATree => 'Plantar uma árvore';

  @override
  String get plantTree => 'Plantar árvore';

  @override
  String get plantANewTree => 'Plantar nova árvore';

  @override
  String get habitName => 'Nome do hábito';

  @override
  String get habitNameHint => 'Ex: Álcool, Tabagismo, Redes sociais';

  @override
  String get trackingMode => 'MODO DE RASTREAMENTO';

  @override
  String get presetColors => 'CORES PREDEFINIDAS';

  @override
  String get customHexCode => 'CÓDIGO HEX PERSONALIZADO';

  @override
  String get hexCode => 'Código Hex';

  @override
  String get invalidHex => 'Hex inválido';

  @override
  String get abstain => 'Abstinência';

  @override
  String get abstainSubtitle1 => 'Cresce automaticamente todo dia';

  @override
  String get abstainSubtitle2 => 'Toque para registrar recaída';

  @override
  String get checkIn => 'Check-in';

  @override
  String get checkInSubtitle1 => 'Faça check-in diário para crescer';

  @override
  String get checkInSubtitle2 => 'Crescimento baseado em check-ins';

  @override
  String get history => 'Histórico';

  @override
  String daysSuffix(Object days) {
    return '${days}d';
  }

  @override
  String historyCount(Object count) {
    return 'Histórico ($count)';
  }

  @override
  String get relapse => 'Recaída';

  @override
  String get checkedIn => 'Check-in feito';

  @override
  String get checkInAction => 'Check-in';

  @override
  String dayStreak(int days) {
    return 'Sequência de $days dias';
  }

  @override
  String dayCount(int days) {
    return 'Dia $days';
  }

  @override
  String get alreadyCheckedInToday => 'Já fez check-in hoje ✓';

  @override
  String get tapBelowToCheckIn => 'Toque abaixo para fazer check-in';

  @override
  String get giveHabitName => 'Dê um nome ao seu hábito.';

  @override
  String get stageSeed => 'Semente';

  @override
  String get stageSprout => 'Broto';

  @override
  String get stageSapling => 'Muda';

  @override
  String get stageYoungTree => 'Árvore jovem';

  @override
  String get stageGroveTree => 'Árvore do bosque';

  @override
  String get taglineSeed => 'Todo grande bosque começa aqui.';

  @override
  String get taglineSprout => 'Raízes estão se formando sob a superfície.';

  @override
  String get taglineSapling => 'Ficando mais forte a cada amanhecer.';

  @override
  String get taglineYoungTree => 'Sua copa está tomando forma.';

  @override
  String get taglineGroveTree => 'Você se tornou a floresta.';

  @override
  String get logARelapse => 'Registrar recaída?';

  @override
  String get relapseMotivation => 'Você é mais forte do que pensa.';

  @override
  String get customTimestamp => 'CARIMBO DE TEMPO PERSONALIZADO';

  @override
  String get loggedReason => 'MOTIVO REGISTRADO (Opcional)';

  @override
  String get loggedReasonHint => 'Estresse, Ansiedade, Esgotamento, Pressão dos colegas, Gatilho? etc...';

  @override
  String get confirmLog => 'Confirmar registro';

  @override
  String get cancel => 'Cancelar';

  @override
  String get onboarding0Title => 'Bem-vindo ao Grove 🌿';

  @override
  String get onboarding0Body => 'Um rastreador de hábitos privado onde árvores representam seu crescimento. Quanto mais tempo você se abstiver ou registrar, mais viçosas suas árvores ficam.';

  @override
  String get onboarding1Title => 'Plante uma árvore';

  @override
  String get onboarding1Body => 'Toque em \"Plantar uma árvore\" para criar um hábito. Dê um nome, escolha uma cor, e o Grove gera uma árvore única.';

  @override
  String get onboarding2Title => 'Veja crescer';

  @override
  String get onboarding2Body => 'Cada dia ajuda sua árvore a amadurecer por cinco estágios — de uma minúscula semente até uma árvore do bosque com galhos balançando.';

  @override
  String get onboarding3Title => 'Registre uma recaída';

  @override
  String get onboarding3Body => 'Se você escorregar, registre honestamente. O Grove acompanha suas sequências mais longas e histórico, o progresso nunca é apagado.';

  @override
  String get onboarding4Title => 'Seu histórico';

  @override
  String get onboarding4Body => 'Abra qualquer árvore para explorar calendários, marcos, histórico de sequências e insights sobre sua consistência de longo prazo.';

  @override
  String get onboarding5Title => 'Totalmente privado';

  @override
  String get onboarding5Body => 'Tudo fica no seu dispositivo. Nada é enviado. Faça backup via Exportar / Importar nas Configurações. Agora vá crescer algo que vale a pena! 🌱';

  @override
  String get next => 'Próximo';

  @override
  String get back => 'Voltar';

  @override
  String get startGrowing => 'Começar a crescer 🌱';

  @override
  String get groveIsBare => 'Seu bosque está vazio.';

  @override
  String get plantFirstTree => 'Plante sua primeira árvore para começar.';

  @override
  String get settingsHub => 'Central de configurações';

  @override
  String get layoutArchitecture => 'LAYOUT';

  @override
  String get renderThemes => 'TEMAS';

  @override
  String get privacyNotifications => 'PRIVACIDADE E NOTIFICAÇÕES';

  @override
  String get dataManagement => 'GERENCIAMENTO DE DADOS';

  @override
  String get reorderGrove => 'Reordenar bosque';

  @override
  String get holdDragToReorder => 'Segure e arraste ≡ para reordenar';

  @override
  String get layoutWheel => 'Roda';

  @override
  String get layoutCarousel => 'Carrossel';

  @override
  String get layoutGrid => 'Grade';

  @override
  String get layoutList => 'Lista';

  @override
  String get themeForestDark => 'Floresta Escura';

  @override
  String get themeAmoledBlack => 'AMOLED Preto';

  @override
  String get themeMaterialYou => 'Material You';

  @override
  String get themeWhiteMinimal => 'Branco Minimalista';

  @override
  String get milestoneNotifications => 'Notificações de marcos';

  @override
  String get milestoneNotificationsSubtitle => 'Seja notificado quando uma árvore atingir um novo estágio de crescimento';

  @override
  String get biometricUnlock => 'Desbloqueio biométrico';

  @override
  String get biometricUnlockSubtitle => 'Requer impressão digital / PIN para abrir o Grove';

  @override
  String get exportGroveBackup => 'Exportar backup do Grove';

  @override
  String get restoreGroveBackup => 'Restaurar Grove do backup';

  @override
  String get exportImportNote => 'Exportar salva um arquivo .json em um local que você escolher.\nImportar substituirá seu grove atual • exporte um backup primeiro.';

  @override
  String get backupSaved => '✓ Backup salvo';

  @override
  String saveFailed(String error) {
    return 'Falha ao salvar: $error';
  }

  @override
  String get couldNotReadFile => 'Não foi possível ler o arquivo selecionado.';

  @override
  String groveRestored(int count) {
    return '✓ Grove restaurado — $count árvores carregadas';
  }

  @override
  String get invalidBackup => '✗ Backup inválido — certifique-se de ter selecionado o arquivo correto';

  @override
  String get language => 'IDIOMA';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get links => 'LINKS';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => 'Código-fonte e contribuições';

  @override
  String get buyMeCoffee => 'Me pague um café';

  @override
  String get buyMeCoffeeSubtitle => 'Apoie o desenvolvimento';

  @override
  String get madeWith => 'Feito com 🌿 • todos os dados ficam no seu dispositivo.';

  @override
  String get openSource => 'Código aberto';

  @override
  String versionLabel(String version) {
    return 'v$version • Código aberto';
  }

  @override
  String get groveDescription => 'Grove é um rastreador de hábitos e sobriedade minimalista que visualiza seu crescimento através de árvores. Cada dia que você se abstém ou registra, sua árvore cresce. Gratuito e de código aberto.';

  @override
  String get groveLocked => 'Grove está bloqueado';

  @override
  String get authenticateToContinue => 'Autentique para continuar';

  @override
  String get unlockGrove => 'Desbloquear Grove';

  @override
  String get currentStreak => 'Sequência atual';

  @override
  String get peakRecord => 'Recorde máximo';

  @override
  String get relapses => 'Recaídas';

  @override
  String get checkIns => 'Check-ins';

  @override
  String get interactiveMonthlyLogs => 'Registros mensais interativos';

  @override
  String get swipeForEarlierMonths => 'Deslize ← para meses anteriores';

  @override
  String get thisMonth => 'Este mês';

  @override
  String get logDateBeforeTracking => '← Registrar data anterior ao rastreamento';

  @override
  String get abstinentSinceStart => 'Nenhuma recaída registrada.';

  @override
  String get timeSinceLastRelapse => 'Tempo desde a última recaída';

  @override
  String get days => 'DIAS';

  @override
  String get hrs => 'H';

  @override
  String get min => 'MIN';

  @override
  String get sec => 'SEG';

  @override
  String get checkedInToday => 'Check-in feito hoje';

  @override
  String get notCheckedInToday => 'Sem check-in hoje';

  @override
  String get streak => 'SEQUÊNCIA';

  @override
  String get total => 'TOTAL';

  @override
  String get alreadyCheckedIn => 'Check-in já realizado';

  @override
  String get checkInToday => 'Fazer check-in hoje';

  @override
  String get relapseSweepTimeline => 'Linha do tempo de recaídas';

  @override
  String get checkInHistory => 'Histórico de check-ins';

  @override
  String totalCount(int count) {
    return '$count no total';
  }

  @override
  String get noRelapsesRecorded => 'Nenhuma recaída registrada. Continue crescendo.';

  @override
  String get noCheckInsYet => 'Ainda sem check-ins. Comece hoje!';

  @override
  String get renameHabit => 'Renomear hábito';

  @override
  String get save => 'Salvar';

  @override
  String get dangerZone => 'Zona de perigo';

  @override
  String get deleteHabitPermanently => 'Excluir hábito permanentemente';

  @override
  String get deleteHabit => 'Excluir hábito?';

  @override
  String deleteHabitConfirm(String name) {
    return 'Isso excluirá permanentemente \"$name\" e todo o seu histórico. Esta ação não pode ser desfeita.';
  }

  @override
  String get delete => 'Excluir';

  @override
  String get earlierThanLogs => 'Anterior aos seus registros?';

  @override
  String trackingStarted(String date) {
    return 'Rastreamento iniciado em $date.\nSe algo aconteceu antes disso, você pode registrar aqui.';
  }

  @override
  String get logEarlierDate => 'Registrar data anterior';

  @override
  String get extendsHistoryNote => 'Isso estende seu histórico e recalcula sequências';

  @override
  String get logEarlierDateTitle => 'Registrar data anterior';

  @override
  String get beforeTrackingStarted => 'Antes do início do rastreamento';

  @override
  String get extendHistoryInfo => 'Isso estenderá seu histórico de rastreamento e recalculará seus recordes de sequência.';

  @override
  String get date => 'DATA';

  @override
  String get time => 'HORA';

  @override
  String get logAsRelapseOnDate => 'Registrar como recaída nesta data';

  @override
  String get onlyExtendStartDate => 'Apenas estender a data de início (sem recaída)';

  @override
  String get whatHappenedHint => 'O que aconteceu naquele dia…';

  @override
  String peakSweep(int days) {
    return 'Sequência máxima: $days dias';
  }

  @override
  String get noReasonRecorded => 'Nenhum motivo registrado.';

  @override
  String notifSproutTitle(String name) {
    return '$name está brotando! 🌱';
  }

  @override
  String get notifSproutBody => 'As raízes da sua árvore terminaram de se formar. Continue crescendo.';

  @override
  String notifSaplingTitle(String name) {
    return '$name é uma muda agora! 🌿';
  }

  @override
  String get notifSaplingBody => 'Sua árvore está de pé sozinha, veja quanto você cresceu';

  @override
  String notifYoungTreeTitle(String name) {
    return '$name está crescendo alto! 🌳';
  }

  @override
  String get notifYoungTreeBody => 'Sua copa está começando a tomar forma, incrível.';

  @override
  String notifGroveTreeTitle(String name) {
    return '$name é uma árvore do bosque! 🌲';
  }

  @override
  String get notifGroveTreeBody => 'Parabéns!!! Você se tornou a floresta.';

  @override
  String get saveGroveBackupDialog => 'Salvar backup do Grove';

  @override
  String get selectGroveBackupDialog => 'Selecionar backup do Grove';

  @override
  String get customAccentColor => 'Cor de destaque personalizada';

  @override
  String get customAccentDefault => 'Verde padrão';

  @override
  String get customAccentSubtitle => 'Aplicado em botões, cartões e emblemas';

  @override
  String get applyAccent => 'Aplicar destaque';

  @override
  String get resetAccentDefault => 'Redefinir para o padrão';

  @override
  String get dailyReminderSetting => 'Lembrete diário de check-in';

  @override
  String get dailyReminderSettingSubtitle => 'Um lembrete para fazer check-in na sua floresta';

  @override
  String get tapToChange => 'Toque para alterar';

  @override
  String get languageSection => 'IDIOMA';

  @override
  String get dailyReminderTitle => 'Hora do check-in 🌿';

  @override
  String get dailyReminderBody => 'Seu bosque está esperando. Mantenha a sequência viva.';

  @override
  String get legendMissed => 'Perdido';

  @override
  String get legendAbstained => 'Abstido';

  @override
  String get legendCheckIn => 'Check-in';

  @override
  String get legendRelapse => 'Recaída';

  @override
  String get legendExcused => 'Dispensado';

  @override
  String get relapseLoggedThisDay => '⚠️ Recaída registrada neste dia.';

  @override
  String get cleanRecord => '🌿 Registro limpo.';

  @override
  String get timeOverride => 'SUBSTITUIR HORÁRIO';

  @override
  String anchorTime(String time) {
    return 'Âncora: $time';
  }

  @override
  String checkInTimeLabel(String time) {
    return 'Horário de check-in: $time';
  }

  @override
  String get editReason => 'EDITAR MOTIVO';

  @override
  String get reasonOptional => 'MOTIVO (opcional)';

  @override
  String get reasonHint => 'Estresse, ansiedade, esgotamento, pressão social, gatilho? etc.';

  @override
  String get excusedStreakPreserved => '❄️ Dispensado, sua sequência foi preservada.';

  @override
  String get checkedInThisDay => '✅ Check-in feito neste dia.';

  @override
  String get noCheckInRecorded => '🌿 Nenhum check-in registrado.';

  @override
  String get saveNewTime => 'Salvar novo horário';

  @override
  String get excuseThisDayInstead => 'Dispensar este dia em vez disso';

  @override
  String get checkInInstead => 'Fazer check-in em vez disso';

  @override
  String get removeExcuse => 'Remover dispensa';

  @override
  String get updateLog => 'Atualizar registro';

  @override
  String get removeRelapseBtn => 'Remover recaída';

  @override
  String get addRelapseHere => 'Adicionar recaída aqui';

  @override
  String get removeCheckIn => 'Remover check-in';

  @override
  String get checkInThisDay => 'Fazer check-in neste dia';

  @override
  String get editNote => 'EDITAR NOTA';

  @override
  String get noteOptional => 'NOTA (opcional)';

  @override
  String get noteHint => 'Como foi o dia hoje? Alguma conquista ou nota para lembrar...';
}
