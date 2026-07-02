// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'غروف';

  @override
  String get appTagline => 'G R O V E';

  @override
  String get plantATree => 'ازرع شجرة';

  @override
  String get plantTree => 'ازرع الشجرة';

  @override
  String get plantANewTree => 'ازرع شجرة جديدة';

  @override
  String get habitName => 'اسم العادة';

  @override
  String get habitNameHint => 'مثال: الكحول، التدخين، وسائل التواصل الاجتماعي';

  @override
  String get trackingMode => 'وضع التتبع';

  @override
  String get presetColors => 'الألوان المحددة مسبقاً';

  @override
  String get customHexCode => 'كود لون مخصص';

  @override
  String get hexCode => 'كود اللون';

  @override
  String get invalidHex => 'كود لون غير صالح';

  @override
  String get abstain => 'الامتناع';

  @override
  String get abstainSubtitle1 => 'تنمو تلقائياً يومياً';

  @override
  String get abstainSubtitle2 => 'اضغط لتسجيل انتكاسة';

  @override
  String get checkIn => 'تسجيل الحضور';

  @override
  String get checkInSubtitle1 => 'سجّل حضورك يومياً للنمو';

  @override
  String get checkInSubtitle2 => 'النمو بناءً على تسجيلات الحضور';

  @override
  String get history => 'السجل';

  @override
  String daysSuffix(Object days) {
    return '$days يوم';
  }

  @override
  String historyCount(Object count) {
    return 'السجل ($count)';
  }

  @override
  String get relapse => 'انتكاسة';

  @override
  String get checkedIn => 'تم التسجيل';

  @override
  String get checkInAction => 'تسجيل الحضور';

  @override
  String dayStreak(int days) {
    return 'سلسلة $days يوم';
  }

  @override
  String dayCount(int days) {
    return 'اليوم $days';
  }

  @override
  String get alreadyCheckedInToday => 'تم التسجيل اليوم ✓';

  @override
  String get tapBelowToCheckIn => 'اضغط أدناه للتسجيل';

  @override
  String get giveHabitName => 'أعطِ عادتك اسماً.';

  @override
  String get stageSeed => 'بذرة';

  @override
  String get stageSprout => 'نبتة';

  @override
  String get stageSapling => 'شتلة';

  @override
  String get stageYoungTree => 'شجرة صغيرة';

  @override
  String get stageGroveTree => 'شجرة الغابة';

  @override
  String get taglineSeed => 'كل غابة عظيمة تبدأ من هنا.';

  @override
  String get taglineSprout => 'الجذور تتشكل تحت السطح.';

  @override
  String get taglineSapling => 'تنمو أقوى مع كل شروق شمس.';

  @override
  String get taglineYoungTree => 'مظلتك الخضراء تأخذ شكلها.';

  @override
  String get taglineGroveTree => 'لقد أصبحت الغابة.';

  @override
  String get logARelapse => 'تسجيل انتكاسة؟';

  @override
  String get relapseMotivation => 'أنت أقوى مما تعتقد.';

  @override
  String get customTimestamp => 'طابع زمني مخصص';

  @override
  String get loggedReason => 'السبب المُسجَّل (اختياري)';

  @override
  String get loggedReasonHint => 'ضغط، قلق، إرهاق، ضغط اجتماعي، مثير؟ إلخ...';

  @override
  String get confirmLog => 'تأكيد التسجيل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get onboarding0Title => 'مرحباً بك في غروف 🌿';

  @override
  String get onboarding0Body => 'متتبع خاص للرصانة والعادات حيث تمثل الأشجار نموك، كلما استمررت في الامتناع أو تسجيل الحضور لفترة أطول، أصبحت أشجارك أكثر إشراقاً وخضرة.';

  @override
  String get onboarding1Title => 'ازرع شجرة';

  @override
  String get onboarding1Body => 'اضغط على \"ازرع شجرة\" لإنشاء عادة. أعطها اسماً، واختر لوناً، وسيُنشئ غروف شجرة فريدة لها. كل شجرة تنمو بشكل مختلف.';

  @override
  String get onboarding2Title => 'شاهد النمو';

  @override
  String get onboarding2Body => 'كل يوم يساعد شجرتك على النضج عبر خمس مراحل نمو. من بذرة صغيرة وحتى شجرة غابة كاملة بأغصان وأوراق متمايلة.';

  @override
  String get onboarding3Title => 'تسجيل انتكاسة';

  @override
  String get onboarding3Body => 'إذا انزلقت، سجّل ذلك بصدق. يتتبع غروف أطول سلاسلك وتاريخك، لذا لا يُمحى تقدمك أبداً.';

  @override
  String get onboarding4Title => 'تاريخك';

  @override
  String get onboarding4Body => 'افتح أي شجرة لاستكشاف التقاويم والإنجازات وتاريخ السلاسل وملاحظات الانتكاسة ورؤى حول ثباتك على المدى الطويل.';

  @override
  String get onboarding5Title => 'خاص تماماً';

  @override
  String get onboarding5Body => 'كل شيء يبقى على جهازك. لا يُرسَل شيء لأي مكان. احتفظ بنسخة احتياطية أو انقل غابتك في أي وقت عبر التصدير/الاستيراد في الإعدادات. الآن اذهب وابنِ شيئاً يستحق الحفاظ عليه. 🌱';

  @override
  String get next => 'التالي';

  @override
  String get back => 'السابق';

  @override
  String get startGrowing => 'ابدأ النمو 🌱';

  @override
  String get groveIsBare => 'غابتك خالية.';

  @override
  String get plantFirstTree => 'ازرع أول شجرة للبدء.';

  @override
  String get settingsHub => 'مركز الإعدادات';

  @override
  String get layoutArchitecture => 'تخطيط العرض';

  @override
  String get renderThemes => 'السمات';

  @override
  String get privacyNotifications => 'الخصوصية والإشعارات';

  @override
  String get dataManagement => 'إدارة البيانات';

  @override
  String get reorderGrove => 'إعادة ترتيب الغابة';

  @override
  String get holdDragToReorder => 'اضغط مطولاً واسحب ≡ لإعادة الترتيب';

  @override
  String get layoutWheel => 'عجلة';

  @override
  String get layoutCarousel => 'دوار';

  @override
  String get layoutGrid => 'شبكة';

  @override
  String get layoutList => 'قائمة';

  @override
  String get themeForestDark => 'الغابة الداكنة';

  @override
  String get themeAmoledBlack => 'أسود AMOLED';

  @override
  String get themeMaterialYou => 'Material You';

  @override
  String get themeWhiteMinimal => 'أبيض بسيط';

  @override
  String get milestoneNotifications => 'إشعارات الإنجازات';

  @override
  String get milestoneNotificationsSubtitle => 'احصل على إشعار عندما تصل شجرة إلى مرحلة نمو جديدة';

  @override
  String get biometricUnlock => 'فتح بصمة';

  @override
  String get biometricUnlockSubtitle => 'طلب بصمة الإصبع / الرمز لفتح غروف';

  @override
  String get exportGroveBackup => 'تصدير نسخة احتياطية';

  @override
  String get restoreGroveBackup => 'استعادة الغابة من النسخة الاحتياطية';

  @override
  String get exportImportNote => 'التصدير يحفظ ملف .json في موقع تختاره.\nالاستيراد سيستبدل غابتك الحالية • صدّر نسخة احتياطية أولاً.';

  @override
  String get backupSaved => '✓ تم حفظ النسخة الاحتياطية';

  @override
  String saveFailed(String error) {
    return 'فشل الحفظ: $error';
  }

  @override
  String get couldNotReadFile => 'لا يمكن قراءة الملف المحدد.';

  @override
  String groveRestored(int count) {
    return '✓ تمت الاستعادة — تم تحميل $count أشجار';
  }

  @override
  String get invalidBackup => '✗ نسخة احتياطية غير صالحة — تأكد من اختيار الملف الصحيح';

  @override
  String get language => 'اللغة';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get links => 'الروابط';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => 'الكود المصدري والمساهمات';

  @override
  String get buyMeCoffee => 'اشترِ لي قهوة';

  @override
  String get buyMeCoffeeSubtitle => 'دعم التطوير';

  @override
  String get madeWith => 'صُنع بـ 🌿 • جميع البيانات تبقى على جهازك.';

  @override
  String get openSource => 'مفتوح المصدر';

  @override
  String versionLabel(String version) {
    return 'v$version • مفتوح المصدر';
  }

  @override
  String get groveDescription => 'غروف متتبع عادات ورصانة بسيط يُصوِّر نموك من خلال الأشجار. كل يوم تمتنع فيه أو تسجل حضورك، تنمو شجرتك. بُني بحب كأداة مجانية مفتوحة المصدر.';

  @override
  String get groveLocked => 'غروف مقفل';

  @override
  String get authenticateToContinue => 'المصادقة للمتابعة';

  @override
  String get unlockGrove => 'فتح غروف';

  @override
  String get currentStreak => 'السلسلة الحالية';

  @override
  String get peakRecord => 'الرقم القياسي';

  @override
  String get relapses => 'الانتكاسات';

  @override
  String get checkIns => 'تسجيلات الحضور';

  @override
  String get interactiveMonthlyLogs => 'السجلات الشهرية التفاعلية';

  @override
  String get swipeForEarlierMonths => 'اسحب ← للأشهر السابقة';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get logDateBeforeTracking => '← سجّل تاريخاً قبل بدء التتبع';

  @override
  String get abstinentSinceStart => 'لا توجد انتكاسات مسجلة.';

  @override
  String get timeSinceLastRelapse => 'الوقت منذ آخر انتكاسة';

  @override
  String get days => 'أيام';

  @override
  String get hrs => 'ساعات';

  @override
  String get min => 'دقائق';

  @override
  String get sec => 'ثوانٍ';

  @override
  String get checkedInToday => 'تم التسجيل اليوم';

  @override
  String get notCheckedInToday => 'لم يتم التسجيل اليوم';

  @override
  String get streak => 'سلسلة';

  @override
  String get total => 'الإجمالي';

  @override
  String get alreadyCheckedIn => 'تم التسجيل مسبقاً';

  @override
  String get checkInToday => 'سجّل حضورك اليوم';

  @override
  String get relapseSweepTimeline => 'الجدول الزمني للانتكاسات';

  @override
  String get checkInHistory => 'سجل تسجيلات الحضور';

  @override
  String totalCount(int count) {
    return '$count إجمالاً';
  }

  @override
  String get noRelapsesRecorded => 'لا انتكاسات مسجلة. واصل النمو.';

  @override
  String get noCheckInsYet => 'لا تسجيلات حضور بعد. ابدأ اليوم!';

  @override
  String get renameHabit => 'إعادة تسمية العادة';

  @override
  String get save => 'حفظ';

  @override
  String get dangerZone => 'منطقة الخطر';

  @override
  String get deleteHabitPermanently => 'حذف العادة نهائياً';

  @override
  String get deleteHabit => 'حذف العادة؟';

  @override
  String deleteHabitConfirm(String name) {
    return 'سيتم حذف \"$name\" وكل تاريخها نهائياً. لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get delete => 'حذف';

  @override
  String get earlierThanLogs => 'أقدم من سجلاتك؟';

  @override
  String trackingStarted(String date) {
    return 'بدأ التتبع في $date.\nإذا حدث شيء قبل ذلك، يمكنك تسجيله هنا.';
  }

  @override
  String get logEarlierDate => 'تسجيل تاريخ سابق';

  @override
  String get extendsHistoryNote => 'يمتد هذا إلى تاريخك ويُعيد حساب السلاسل';

  @override
  String get logEarlierDateTitle => 'تسجيل تاريخ سابق';

  @override
  String get beforeTrackingStarted => 'قبل بدء التتبع';

  @override
  String get extendHistoryInfo => 'سيمتد هذا إلى تاريخ التتبع السابق ويُعيد حساب أعلى سلاسلك.';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get logAsRelapseOnDate => 'تسجيل كانتكاسة في هذا التاريخ';

  @override
  String get onlyExtendStartDate => 'تمديد تاريخ البداية فقط (بدون انتكاسة)';

  @override
  String get whatHappenedHint => 'ماذا حدث في ذلك اليوم…';

  @override
  String peakSweep(int days) {
    return 'أعلى سلسلة: $days يوم';
  }

  @override
  String get noReasonRecorded => 'لم يُسجَّل أي سبب.';

  @override
  String notifSproutTitle(String name) {
    return '$name تنبت! 🌱';
  }

  @override
  String get notifSproutBody => 'جذور شجرتك اكتملت. واصل النمو.';

  @override
  String notifSaplingTitle(String name) {
    return '$name أصبحت شتلة! 🌿';
  }

  @override
  String get notifSaplingBody => 'شجرتك تقف بمفردها، انظر كم نمت';

  @override
  String notifYoungTreeTitle(String name) {
    return '$name تنمو طويلة! 🌳';
  }

  @override
  String get notifYoungTreeBody => 'مظلتك الخضراء تأخذ شكلها، رائع.';

  @override
  String notifGroveTreeTitle(String name) {
    return '$name أصبحت شجرة الغابة! 🌲';
  }

  @override
  String get notifGroveTreeBody => 'تهانينا!!! لقد أصبحت الغابة.';

  @override
  String get saveGroveBackupDialog => 'حفظ نسخة احتياطية';

  @override
  String get selectGroveBackupDialog => 'اختر نسخة احتياطية';

  @override
  String get customAccentColor => 'لون التمييز المخصص';

  @override
  String get customAccentDefault => 'الأخضر الافتراضي';

  @override
  String get customAccentSubtitle => 'يطبق على الأزرار والبطاقات والشارات';

  @override
  String get applyAccent => 'تطبيق التمييز';

  @override
  String get resetAccentDefault => 'إعادة إلى الافتراضي';

  @override
  String get dailyReminderSetting => 'تذكير يومي بالتسجيل';

  @override
  String get dailyReminderSettingSubtitle => 'تذكير للتسجيل في غابتك';

  @override
  String get tapToChange => 'انقر للتغيير';

  @override
  String get languageSection => 'اللغة';

  @override
  String get dailyReminderTitle => 'حان وقت تسجيل الحضور 🌿';

  @override
  String get dailyReminderBody => 'غابتك في انتظارك. واصل السلسلة.';
}
