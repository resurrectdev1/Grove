// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'Grove';

  @override
  String get appTagline => 'G R O V E';

  @override
  String get plantATree => 'ایک درخت لگائیں';

  @override
  String get plantTree => 'درخت لگائیں';

  @override
  String get plantANewTree => 'نیا درخت لگائیں';

  @override
  String get habitName => 'عادت کا نام';

  @override
  String get habitNameHint => 'مثال: شراب، سگریٹ، سوشل میڈیا';

  @override
  String get trackingMode => 'ٹریکنگ موڈ';

  @override
  String get presetColors => 'پہلے سے طے شدہ رنگ';

  @override
  String get customHexCode => 'کسٹم ہیکس کوڈ';

  @override
  String get hexCode => 'ہیکس کوڈ';

  @override
  String get invalidHex => 'غلط ہیکس کوڈ';

  @override
  String get abstain => 'پرہیز';

  @override
  String get abstainSubtitle1 => 'روزانہ خودبخود بڑھتا ہے';

  @override
  String get abstainSubtitle2 => 'دوبارہ لگنے کو ریکارڈ کرنے کے لیے ٹیپ کریں';

  @override
  String get checkIn => 'چیک-ان';

  @override
  String get checkInSubtitle1 => 'بڑھنے کے لیے روزانہ چیک-ان کریں';

  @override
  String get checkInSubtitle2 => 'چیک-انز کی بنیاد پر ترقی';

  @override
  String get history => 'تاریخ';

  @override
  String daysSuffix(Object days) {
    return '$daysد';
  }

  @override
  String historyCount(Object count) {
    return 'تاریخ ($count)';
  }

  @override
  String get relapse => 'دوبارہ لگنا';

  @override
  String get checkedIn => 'چیک-ان ہو گیا';

  @override
  String get checkInAction => 'چیک-ان';

  @override
  String dayStreak(int days) {
    return '$days دن کی سلسلہ';
  }

  @override
  String dayCount(int days) {
    return 'دن $days';
  }

  @override
  String get alreadyCheckedInToday => 'آج پہلے ہی چیک-ان ہو گیا ✓';

  @override
  String get tapBelowToCheckIn => 'چیک-ان کے لیے نیچے ٹیپ کریں';

  @override
  String get giveHabitName => 'اپنی عادت کو نام دیں۔';

  @override
  String get stageSeed => 'بیج';

  @override
  String get stageSprout => 'انکرہ';

  @override
  String get stageSapling => 'پودا';

  @override
  String get stageYoungTree => 'جوان درخت';

  @override
  String get stageGroveTree => 'باغ کا درخت';

  @override
  String get taglineSeed => 'ہر عظیم جنگل یہیں سے شروع ہوتا ہے۔';

  @override
  String get taglineSprout => 'جڑیں سطح کے نیچے بن رہی ہیں۔';

  @override
  String get taglineSapling => 'ہر طلوع آفتاب کے ساتھ مضبوط ہوتا جا رہا ہے۔';

  @override
  String get taglineYoungTree => 'آپ کی چھتری شکل لے رہی ہے۔';

  @override
  String get taglineGroveTree => 'آپ جنگل بن گئے ہیں۔';

  @override
  String get logARelapse => 'دوبارہ لگنا درج کریں؟';

  @override
  String get relapseMotivation => 'آپ اس سے زیادہ مضبوط ہیں جتنا آپ سوچتے ہیں۔';

  @override
  String get customTimestamp => 'کسٹم ٹائم اسٹیمپ';

  @override
  String get loggedReason => 'درج وجہ (اختیاری)';

  @override
  String get loggedReasonHint => 'تناؤ، پریشانی، تھکاوٹ، ہم عمروں کا دباؤ وغیرہ';

  @override
  String get confirmLog => 'لاگ تصدیق کریں';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get onboarding0Title => 'Grove میں خوش آمدید 🌿';

  @override
  String get onboarding0Body => 'ایک نجی عادت ٹریکر جہاں درخت آپ کی ترقی کی نمائندگی کرتے ہیں۔ جتنا لمبا آپ پرہیز کریں گے یا چیک ان کریں گے، آپ کے درخت اتنے ہی سرسبز ہوتے جائیں گے۔';

  @override
  String get onboarding1Title => 'ایک درخت لگائیں';

  @override
  String get onboarding1Body => 'عادت بنانے کے لیے \"ایک درخت لگائیں\" ٹیپ کریں۔ نام دیں، رنگ چنیں، اور Grove ایک منفرد درخت بناتا ہے۔';

  @override
  String get onboarding2Title => 'اسے بڑھتے دیکھیں';

  @override
  String get onboarding2Body => 'ہر دن آپ کے درخت کو پانچ مراحل سے گزرنے میں مدد کرتا ہے — ایک چھوٹے بیج سے لے کر مکمل باغ کے درخت تک۔';

  @override
  String get onboarding3Title => 'دوبارہ لگنا درج کریں';

  @override
  String get onboarding3Body => 'اگر آپ پھسل جائیں تو ایمانداری سے درج کریں۔ Grove آپ کی طویل ترین سلسلہ اور تاریخ ٹریک کرتا ہے۔';

  @override
  String get onboarding4Title => 'آپ کی تاریخ';

  @override
  String get onboarding4Body => 'کوئی بھی درخت کھولیں اور کیلنڈر، سنگ میل، سلسلہ کی تاریخ دیکھیں۔';

  @override
  String get onboarding5Title => 'مکمل طور پر نجی';

  @override
  String get onboarding5Body => 'سب کچھ آپ کے آلے پر رہتا ہے۔ کچھ بھی کہیں نہیں بھیجا جاتا۔ ترتیبات میں Export / Import کے ذریعے بیک اپ لیں یا grove منتقل کریں۔ اب کچھ ایسا اگائیں جو رکھنے کے قابل ہو۔ 🌱';

  @override
  String get next => 'آگے';

  @override
  String get back => 'پیچھے';

  @override
  String get startGrowing => 'بڑھنا شروع کریں 🌱';

  @override
  String get groveIsBare => 'آپ کا باغ خالی ہے۔';

  @override
  String get plantFirstTree => 'شروع کرنے کے لیے اپنا پہلا درخت لگائیں۔';

  @override
  String get settingsHub => 'ترتیبات';

  @override
  String get layoutArchitecture => 'لے آؤٹ';

  @override
  String get renderThemes => 'تھیمز';

  @override
  String get privacyNotifications => 'رازداری اور اطلاعات';

  @override
  String get dataManagement => 'ڈیٹا مینجمنٹ';

  @override
  String get reorderGrove => 'باغ کو دوبارہ ترتیب دیں';

  @override
  String get holdDragToReorder => '≡ کو پکڑ کر گھسیٹیں';

  @override
  String get layoutWheel => 'پہیہ';

  @override
  String get layoutCarousel => 'کیروسل';

  @override
  String get layoutGrid => 'گرڈ';

  @override
  String get layoutList => 'فہرست';

  @override
  String get themeForestDark => 'جنگل کا اندھیرا';

  @override
  String get themeAmoledBlack => 'AMOLED سیاہ';

  @override
  String get themeMaterialYou => 'Material You';

  @override
  String get themeWhiteMinimal => 'سفید مینیمل';

  @override
  String get milestoneNotifications => 'سنگ میل اطلاعات';

  @override
  String get milestoneNotificationsSubtitle => 'جب درخت نئے مرحلے پر پہنچے تو مطلع ہوں';

  @override
  String get biometricUnlock => 'بائیومیٹرک انلاک';

  @override
  String get biometricUnlockSubtitle => 'Grove کھولنے کے لیے فنگرپرنٹ / پن ضروری ہے';

  @override
  String get exportGroveBackup => 'Grove بیک اپ برآمد کریں';

  @override
  String get restoreGroveBackup => 'بیک اپ سے Grove بحال کریں';

  @override
  String get exportImportNote => 'برآمد .json فائل محفوظ کرتا ہے۔\nدرآمد آپ کا موجودہ grove بدل دے گا • پہلے بیک اپ لیں۔';

  @override
  String get backupSaved => '✓ بیک اپ محفوظ ہو گیا';

  @override
  String saveFailed(String error) {
    return 'محفوظ کرنے میں ناکامی: $error';
  }

  @override
  String get couldNotReadFile => 'منتخب فائل پڑھی نہیں جا سکی۔';

  @override
  String groveRestored(int count) {
    return '✓ Grove بحال — $count درخت لوڈ ہوئے';
  }

  @override
  String get invalidBackup => '✗ غلط بیک اپ — یقینی بنائیں کہ آپ نے صحیح فائل منتخب کی ہے';

  @override
  String get language => 'زبان';

  @override
  String get languageLabel => 'زبان';

  @override
  String get links => 'لنکس';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => 'سورس کوڈ اور شراکت';

  @override
  String get buyMeCoffee => 'مجھے ایک کافی خریدیں';

  @override
  String get buyMeCoffeeSubtitle => 'ترقی کی حمایت کریں';

  @override
  String get madeWith => '🌿 کے ساتھ بنایا • تمام ڈیٹا آپ کے آلے پر رہتا ہے۔';

  @override
  String get openSource => 'اوپن سورس';

  @override
  String versionLabel(String version) {
    return 'v$version • اوپن سورس';
  }

  @override
  String get groveDescription => 'Grove ایک کم سے کم عادت اور پرہیز ٹریکر ہے جو درختوں کے ذریعے آپ کی ترقی کو دکھاتا ہے۔ جس دن بھی آپ پرہیز کریں یا چیک ان کریں، آپ کا درخت بڑھتا ہے۔ مفت، اوپن سورس۔';

  @override
  String get groveLocked => 'Grove بند ہے';

  @override
  String get authenticateToContinue => 'جاری رکھنے کے لیے تصدیق کریں';

  @override
  String get unlockGrove => 'Grove کھولیں';

  @override
  String get currentStreak => 'موجودہ سلسلہ';

  @override
  String get peakRecord => 'اعلیٰ ریکارڈ';

  @override
  String get relapses => 'دوبارہ لگنے';

  @override
  String get checkIns => 'چیک-انز';

  @override
  String get interactiveMonthlyLogs => 'ماہانہ لاگز';

  @override
  String get swipeForEarlierMonths => 'پہلے کے مہینوں کے لیے ← سوائپ کریں';

  @override
  String get thisMonth => 'اس مہینے';

  @override
  String get logDateBeforeTracking => '← ٹریکنگ شروع ہونے سے پہلے کی تاریخ درج کریں';

  @override
  String get abstinentSinceStart => 'کوئی دوبارہ لگنا درج نہیں۔';

  @override
  String get timeSinceLastRelapse => 'آخری دوبارہ لگنے کے بعد کا وقت';

  @override
  String get days => 'دن';

  @override
  String get hrs => 'گھنٹے';

  @override
  String get min => 'منٹ';

  @override
  String get sec => 'سیکنڈ';

  @override
  String get checkedInToday => 'آج چیک-ان ہوا';

  @override
  String get notCheckedInToday => 'آج چیک-ان نہیں ہوا';

  @override
  String get streak => 'سلسلہ';

  @override
  String get total => 'کل';

  @override
  String get alreadyCheckedIn => 'پہلے ہی چیک-ان ہو گیا';

  @override
  String get checkInToday => 'آج چیک-ان کریں';

  @override
  String get relapseSweepTimeline => 'دوبارہ لگنے کی ٹائم لائن';

  @override
  String get checkInHistory => 'چیک-ان تاریخ';

  @override
  String totalCount(int count) {
    return '$count کل';
  }

  @override
  String get noRelapsesRecorded => 'کوئی دوبارہ لگنا درج نہیں۔ بڑھتے رہیں۔';

  @override
  String get noCheckInsYet => 'ابھی تک کوئی چیک-ان نہیں۔ آج شروع کریں!';

  @override
  String get renameHabit => 'عادت کا نام بدلیں';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get dangerZone => 'خطرناک علاقہ';

  @override
  String get deleteHabitPermanently => 'عادت مستقل طور پر حذف کریں';

  @override
  String get deleteHabit => 'عادت حذف کریں؟';

  @override
  String deleteHabitConfirm(String name) {
    return 'یہ \"$name\" اور اس کی تمام تاریخ مستقل طور پر حذف کر دے گا۔ یہ عمل واپس نہیں ہو سکتا۔';
  }

  @override
  String get delete => 'حذف کریں';

  @override
  String get earlierThanLogs => 'آپ کے لاگز سے پہلے؟';

  @override
  String trackingStarted(String date) {
    return 'ٹریکنگ $date سے شروع ہوئی۔\nاگر اس سے پہلے کچھ ہوا تو آپ یہاں درج کر سکتے ہیں۔';
  }

  @override
  String get logEarlierDate => 'پہلے کی تاریخ درج کریں';

  @override
  String get extendsHistoryNote => 'یہ آپ کی تاریخ بڑھاتا ہے اور سلسلہ کا دوبارہ حساب لگاتا ہے';

  @override
  String get logEarlierDateTitle => 'پہلے کی تاریخ درج کریں';

  @override
  String get beforeTrackingStarted => 'ٹریکنگ شروع ہونے سے پہلے';

  @override
  String get extendHistoryInfo => 'یہ آپ کی ٹریکنگ تاریخ بڑھائے گا اور اعلیٰ سلسلہ کا دوبارہ حساب لگائے گا۔';

  @override
  String get date => 'تاریخ';

  @override
  String get time => 'وقت';

  @override
  String get logAsRelapseOnDate => 'اس تاریخ کو دوبارہ لگنے کے طور پر درج کریں';

  @override
  String get onlyExtendStartDate => 'صرف شروعاتی تاریخ بڑھائیں (دوبارہ لگنے کے بغیر)';

  @override
  String get whatHappenedHint => 'اس دن کیا ہوا…';

  @override
  String peakSweep(int days) {
    return 'اعلیٰ سلسلہ: $days دن';
  }

  @override
  String get noReasonRecorded => 'کوئی وجہ درج نہیں۔';

  @override
  String notifSproutTitle(String name) {
    return '$name انکرہ ہو رہا ہے! 🌱';
  }

  @override
  String get notifSproutBody => 'آپ کے درخت کی جڑیں بن گئی ہیں۔ بڑھتے رہیں۔';

  @override
  String notifSaplingTitle(String name) {
    return '$name اب پودا ہے! 🌿';
  }

  @override
  String get notifSaplingBody => 'آپ کا درخت اپنے دم پر کھڑا ہے، دیکھیں آپ کتنے بڑھے ہیں';

  @override
  String notifYoungTreeTitle(String name) {
    return '$name بڑھ رہا ہے! 🌳';
  }

  @override
  String get notifYoungTreeBody => 'آپ کی چھتری شکل لے رہی ہے، ناقابل یقین۔';

  @override
  String notifGroveTreeTitle(String name) {
    return '$name باغ کا درخت بن گیا! 🌲';
  }

  @override
  String get notifGroveTreeBody => 'مبارک ہو!!! آپ جنگل بن گئے ہیں۔';

  @override
  String get saveGroveBackupDialog => 'Grove بیک اپ محفوظ کریں';

  @override
  String get selectGroveBackupDialog => 'Grove بیک اپ منتخب کریں';

  @override
  String get customAccentColor => 'کسٹم ایکسنٹ رنگ';

  @override
  String get customAccentDefault => 'ڈیفالٹ سبز';

  @override
  String get customAccentSubtitle => 'بٹن، کارڈ اور بیجز پر لاگو';

  @override
  String get applyAccent => 'ایکسنٹ لگائیں';

  @override
  String get resetAccentDefault => 'ڈیفالٹ پر ری سیٹ کریں';

  @override
  String get dailyReminderSetting => 'روزانہ چیک-ان یاددہانی';

  @override
  String get dailyReminderSettingSubtitle => 'اپنے باغ میں چیک-ان کرنے کا ایک اشارہ';

  @override
  String get tapToChange => 'تبدیل کرنے کے لیے ٹیپ کریں';

  @override
  String get languageSection => 'زبان';

  @override
  String get dailyReminderTitle => 'چیک-ان کا وقت ہے 🌿';

  @override
  String get dailyReminderBody => 'آپ کا باغ انتظار کر رہا ہے۔ سلسلہ زندہ رکھیں۔';

  @override
  String get legendMissed => 'چھوٹا ہوا';

  @override
  String get legendAbstained => 'پرہیز کیا';

  @override
  String get legendCheckIn => 'چیک ان';

  @override
  String get legendRelapse => 'دوبارہ لغزش';

  @override
  String get legendExcused => 'معاف شدہ';

  @override
  String get relapseLoggedThisDay => '⚠️ اس دن دوبارہ لغزش درج کی گئی۔';

  @override
  String get cleanRecord => '🌿 صاف ریکارڈ۔';

  @override
  String get timeOverride => 'وقت اوور رائیڈ';

  @override
  String anchorTime(String time) {
    return 'اینکر: $time';
  }

  @override
  String checkInTimeLabel(String time) {
    return 'چیک ان کا وقت: $time';
  }

  @override
  String get editReason => 'وجہ میں ترمیم کریں';

  @override
  String get reasonOptional => 'وجہ (اختیاری)';

  @override
  String get reasonHint => 'تناؤ، پریشانی، تھکن، ساتھیوں کا دباؤ، محرک؟ وغیرہ';

  @override
  String get excusedStreakPreserved => '❄️ معاف شدہ، آپ کا تسلسل برقرار ہے۔';

  @override
  String get checkedInThisDay => '✅ اس دن چیک ان کیا گیا۔';

  @override
  String get noCheckInRecorded => '🌿 کوئی چیک ان درج نہیں۔';

  @override
  String get saveNewTime => 'نیا وقت محفوظ کریں';

  @override
  String get excuseThisDayInstead => 'اس کے بجائے اس دن کو معاف کریں';

  @override
  String get checkInInstead => 'اس کے بجائے چیک ان کریں';

  @override
  String get removeExcuse => 'معافی ہٹائیں';

  @override
  String get updateLog => 'لاگ اپ ڈیٹ کریں';

  @override
  String get removeRelapseBtn => 'لغزش ہٹائیں';

  @override
  String get addRelapseHere => 'یہاں لغزش شامل کریں';

  @override
  String get removeCheckIn => 'چیک ان ہٹائیں';

  @override
  String get checkInThisDay => 'اس دن چیک ان کریں';

  @override
  String get editNote => 'نوٹ میں ترمیم کریں';

  @override
  String get noteOptional => 'نوٹ (اختیاری)';

  @override
  String get noteHint => 'آج کا دن کیسا رہا؟ کوئی کامیابی یا یاد رکھنے والا نوٹ...';
}
