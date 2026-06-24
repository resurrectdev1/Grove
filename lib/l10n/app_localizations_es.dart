// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Grove';

  @override
  String get appTagline => 'G R O V E';

  @override
  String get plantATree => 'Plantar un árbol';

  @override
  String get plantTree => 'Plantar árbol';

  @override
  String get plantANewTree => 'Plantar un árbol nuevo';

  @override
  String get habitName => 'Nombre del hábito';

  @override
  String get habitNameHint => 'Ej: Alcohol, Tabaco, Redes sociales';

  @override
  String get trackingMode => 'MODO DE SEGUIMIENTO';

  @override
  String get presetColors => 'COLORES PREDEFINIDOS';

  @override
  String get customHexCode => 'CÓDIGO HEX PERSONALIZADO';

  @override
  String get hexCode => 'Código Hex';

  @override
  String get invalidHex => 'Hex inválido';

  @override
  String get abstain => 'Abstinencia';

  @override
  String get abstainSubtitle1 => 'Crece automáticamente cada día';

  @override
  String get abstainSubtitle2 => 'Toca para registrar una recaída';

  @override
  String get checkIn => 'Check-In';

  @override
  String get checkInSubtitle1 => 'Regístrate diariamente para crecer';

  @override
  String get checkInSubtitle2 => 'El crecimiento se basa en los registros';

  @override
  String get history => 'Historial';

  @override
  String daysSuffix(Object days) {
    return '${days}d';
  }

  @override
  String historyCount(Object count) {
    return 'Historial ($count)';
  }

  @override
  String get relapse => 'Recaída';

  @override
  String get checkedIn => 'Registrado';

  @override
  String get checkInAction => 'Registrarse';

  @override
  String dayStreak(int days) {
    return 'Racha de $days días';
  }

  @override
  String dayCount(int days) {
    return 'Día $days';
  }

  @override
  String get alreadyCheckedInToday => 'Ya registrado hoy ✓';

  @override
  String get tapBelowToCheckIn => 'Toca abajo para registrarte';

  @override
  String get giveHabitName => 'Ponle un nombre a tu hábito.';

  @override
  String get stageSeed => 'Semilla';

  @override
  String get stageSprout => 'Brote';

  @override
  String get stageSapling => 'Plántula';

  @override
  String get stageYoungTree => 'Árbol joven';

  @override
  String get stageGroveTree => 'Árbol del bosque';

  @override
  String get taglineSeed => 'Todo gran bosque comienza aquí.';

  @override
  String get taglineSprout => 'Las raíces se forman bajo la superficie.';

  @override
  String get taglineSapling => 'Cada amanecer te hace más fuerte.';

  @override
  String get taglineYoungTree => 'Tu copa está tomando forma.';

  @override
  String get taglineGroveTree => 'Te has convertido en el bosque.';

  @override
  String get logARelapse => '¿Registrar una recaída?';

  @override
  String get relapseMotivation => 'Eres más fuerte de lo que crees.';

  @override
  String get customTimestamp => 'MARCA DE TIEMPO PERSONALIZADA';

  @override
  String get loggedReason => 'MOTIVO REGISTRADO (Opcional)';

  @override
  String get loggedReasonHint => 'Estrés, ansiedad, agotamiento, presión social, desencadenante, etc.';

  @override
  String get confirmLog => 'Confirmar registro';

  @override
  String get cancel => 'Cancelar';

  @override
  String get onboarding0Title => 'Bienvenido a Grove 🌿';

  @override
  String get onboarding0Body => 'Un rastreador privado de sobriedad y hábitos donde los árboles representan tu crecimiento. Cuanto más tiempo te mantengas limpio, más vibrantes y frondosos se vuelven tus árboles.';

  @override
  String get onboarding1Title => 'Planta un árbol';

  @override
  String get onboarding1Body => 'Toca \"Plantar un árbol\" para crear un hábito. Dale un nombre, elige un color y Grove generará un árbol único. Cada uno crece de forma diferente.';

  @override
  String get onboarding2Title => 'Míralo crecer';

  @override
  String get onboarding2Body => 'Cada día limpio ayuda a tu árbol a madurar a través de cinco etapas de crecimiento, desde una pequeña semilla hasta un árbol frondoso con ramas y hojas mecidas por el viento.';

  @override
  String get onboarding3Title => 'Registra una recaída';

  @override
  String get onboarding3Body => 'Si fallas, regístralo honestamente. Grove guarda tus rachas más largas e historial, para que tu progreso nunca se borre.';

  @override
  String get onboarding4Title => 'Tu historial';

  @override
  String get onboarding4Body => 'Abre cualquier árbol para explorar calendarios, hitos, historial de rachas, notas de recaídas e información sobre tu constancia a largo plazo.';

  @override
  String get onboarding5Title => 'Completamente privado';

  @override
  String get onboarding5Body => 'Todo se queda en tu dispositivo. Nunca se envía nada a ningún lugar. Haz una copia de seguridad o mueve tu bosque en cualquier momento desde Ajustes. Ahora ve a hacer crecer algo que valga la pena. 🌱';

  @override
  String get next => 'Siguiente';

  @override
  String get back => 'Atrás';

  @override
  String get startGrowing => 'Empieza a crecer 🌱';

  @override
  String get groveIsBare => 'Tu bosque está vacío.';

  @override
  String get plantFirstTree => 'Planta tu primer árbol para empezar.';

  @override
  String get settingsHub => 'Ajustes';

  @override
  String get layoutArchitecture => 'DISEÑO DE PANTALLA';

  @override
  String get renderThemes => 'TEMAS';

  @override
  String get privacyNotifications => 'PRIVACIDAD Y NOTIFICACIONES';

  @override
  String get dataManagement => 'GESTIÓN DE DATOS';

  @override
  String get reorderGrove => 'Reordenar bosque';

  @override
  String get holdDragToReorder => 'Mantén y arrastra ≡ para reordenar';

  @override
  String get layoutWheel => 'Rueda';

  @override
  String get layoutCarousel => 'Carrusel';

  @override
  String get layoutGrid => 'Cuadrícula';

  @override
  String get layoutList => 'Lista';

  @override
  String get themeForestDark => 'Bosque oscuro';

  @override
  String get themeAmoledBlack => 'Negro AMOLED';

  @override
  String get themeMaterialYou => 'Material You';

  @override
  String get themeWhiteMinimal => 'Blanco minimalista';

  @override
  String get milestoneNotifications => 'Notificaciones de hitos';

  @override
  String get milestoneNotificationsSubtitle => 'Recibe avisos cuando un árbol alcance una nueva etapa de crecimiento';

  @override
  String get biometricUnlock => 'Desbloqueo biométrico';

  @override
  String get biometricUnlockSubtitle => 'Requerir huella dactilar / PIN para abrir Grove';

  @override
  String get exportGroveBackup => 'Exportar copia de seguridad';

  @override
  String get restoreGroveBackup => 'Restaurar bosque desde copia de seguridad';

  @override
  String get exportImportNote => 'La exportación guarda un archivo .json en una ubicación elegida.\nImportar reemplazará tu bosque actual • exporta primero una copia.';

  @override
  String get backupSaved => '✓ Copia guardada';

  @override
  String saveFailed(String error) {
    return 'Error al guardar: $error';
  }

  @override
  String get couldNotReadFile => 'No se pudo leer el archivo seleccionado.';

  @override
  String groveRestored(int count) {
    return '✓ Bosque restaurado — $count árboles cargados';
  }

  @override
  String get invalidBackup => '✗ Copia inválida — asegúrate de seleccionar el archivo correcto';

  @override
  String get language => 'IDIOMA';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get links => 'ENLACES';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => 'Código fuente y contribuciones';

  @override
  String get buyMeCoffee => 'Invítame a un café';

  @override
  String get buyMeCoffeeSubtitle => 'Apoya el desarrollo';

  @override
  String get madeWith => 'Hecho con 🌿 • todos los datos se quedan en tu dispositivo.';

  @override
  String get openSource => 'Código abierto';

  @override
  String versionLabel(String version) {
    return 'v$version • Código abierto';
  }

  @override
  String get groveDescription => 'Grove es un rastreador de hábitos minimalista que visualiza tu crecimiento mediante árboles. Cada día que te mantienes limpio, tu árbol crece. Construido con amor como una herramienta gratuita y de código abierto.';

  @override
  String get groveLocked => 'Grove está bloqueado';

  @override
  String get authenticateToContinue => 'Autentícate para continuar';

  @override
  String get unlockGrove => 'Desbloquear Grove';

  @override
  String get currentStreak => 'Racha actual';

  @override
  String get peakRecord => 'Récord máximo';

  @override
  String get relapses => 'Recaídas';

  @override
  String get checkIns => 'Registros';

  @override
  String get interactiveMonthlyLogs => 'Registros mensuales interactivos';

  @override
  String get swipeForEarlierMonths => 'Desliza ← para meses anteriores';

  @override
  String get thisMonth => 'Este mes';

  @override
  String get logDateBeforeTracking => '← Registra una fecha antes del inicio';

  @override
  String get cleanSinceStart => 'Limpio desde el inicio';

  @override
  String get timeSinceLastRelapse => 'Tiempo desde la última recaída';

  @override
  String get days => 'DÍAS';

  @override
  String get hrs => 'HORAS';

  @override
  String get min => 'MIN';

  @override
  String get sec => 'SEG';

  @override
  String get checkedInToday => 'Registrado hoy';

  @override
  String get notCheckedInToday => 'Sin registro hoy';

  @override
  String get streak => 'RACHA';

  @override
  String get total => 'TOTAL';

  @override
  String get alreadyCheckedIn => 'Ya registrado';

  @override
  String get checkInToday => 'Registrarse hoy';

  @override
  String get relapseSweepTimeline => 'Línea de tiempo de recaídas';

  @override
  String get checkInHistory => 'Historial de registros';

  @override
  String totalCount(int count) {
    return '$count en total';
  }

  @override
  String get noRelapsesRecorded => 'Sin recaídas registradas. Sigue creciendo.';

  @override
  String get noCheckInsYet => 'Sin registros aún. ¡Empieza hoy!';

  @override
  String get renameHabit => 'Renombrar hábito';

  @override
  String get save => 'Guardar';

  @override
  String get dangerZone => 'Zona de peligro';

  @override
  String get deleteHabitPermanently => 'Eliminar hábito permanentemente';

  @override
  String get deleteHabit => '¿Eliminar hábito?';

  @override
  String deleteHabitConfirm(String name) {
    return 'Esto eliminará permanentemente \"$name\" y todo su historial. Esta acción no se puede deshacer.';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String get earlierThanLogs => '¿Antes que tus registros?';

  @override
  String trackingStarted(String date) {
    return 'El seguimiento comenzó el $date.\nSi algo ocurrió antes, puedes registrarlo aquí.';
  }

  @override
  String get logEarlierDate => 'Registrar una fecha anterior';

  @override
  String get extendsHistoryNote => 'Esto extiende tu historial y recalcula las rachas';

  @override
  String get logEarlierDateTitle => 'Registrar fecha anterior';

  @override
  String get beforeTrackingStarted => 'Antes del inicio del seguimiento';

  @override
  String get extendHistoryInfo => 'Esto extenderá tu historial de seguimiento y recalculará tus rachas máximas.';

  @override
  String get date => 'FECHA';

  @override
  String get time => 'HORA';

  @override
  String get logAsRelapseOnDate => 'Registrar como recaída en esta fecha';

  @override
  String get onlyExtendStartDate => 'Solo extender fecha de inicio (sin recaída)';

  @override
  String get whatHappenedHint => '¿Qué pasó ese día…?';

  @override
  String peakSweep(int days) {
    return 'Récord de racha: $days días';
  }

  @override
  String get noReasonRecorded => 'Sin motivo registrado.';

  @override
  String notifSproutTitle(String name) {
    return '¡$name está brotando! 🌱';
  }

  @override
  String get notifSproutBody => 'Las raíces de tu árbol ya están formadas. Sigue creciendo.';

  @override
  String notifSaplingTitle(String name) {
    return '¡$name ya es una plántula! 🌿';
  }

  @override
  String get notifSaplingBody => 'Tu árbol se sostiene solo, mira cuánto has crecido';

  @override
  String notifYoungTreeTitle(String name) {
    return '¡$name está creciendo alto! 🌳';
  }

  @override
  String get notifYoungTreeBody => 'Tu copa está tomando forma, increíble.';

  @override
  String notifGroveTreeTitle(String name) {
    return '¡$name es un árbol del bosque! 🌲';
  }

  @override
  String get notifGroveTreeBody => '¡¡¡Felicitaciones!!! Te has convertido en el bosque.';

  @override
  String get saveGroveBackupDialog => 'Guardar copia de seguridad';

  @override
  String get selectGroveBackupDialog => 'Seleccionar copia de seguridad';

  @override
  String get customAccentColor => 'Acento personalizado';

  @override
  String get customAccentDefault => 'Verde predeterminado';

  @override
  String get customAccentSubtitle => 'Aplicado en botones, tarjetas e insignias';

  @override
  String get applyAccent => 'Aplicar acento';

  @override
  String get resetAccentDefault => 'Restablecer por defecto';

  @override
  String get dailyReminderSetting => 'Recordatorio diario de check-in';

  @override
  String get dailyReminderSettingSubtitle => '¡Tu bosque te está esperando!';

  @override
  String get tapToChange => 'Toca para cambiar';

  @override
  String get languageSection => 'IDIOMA';

  @override
  String get dailyReminderTitle => 'Hora de registrarse 🌿';

  @override
  String get dailyReminderBody => 'Tu bosque te está esperando. ¡Mantén la racha viva!';
}
