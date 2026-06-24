// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Grove';

  @override
  String get appTagline => 'G R O V E';

  @override
  String get plantATree => 'एक पेड़ लगाएं';

  @override
  String get plantTree => 'पेड़ लगाएं';

  @override
  String get plantANewTree => 'नया पेड़ लगाएं';

  @override
  String get habitName => 'आदत का नाम';

  @override
  String get habitNameHint => 'जैसे: शराब, धूम्रपान, सोशल मीडिया';

  @override
  String get trackingMode => 'ट्रैकिंग मोड';

  @override
  String get presetColors => 'प्रीसेट रंग';

  @override
  String get customHexCode => 'कस्टम हेक्स कोड';

  @override
  String get hexCode => 'हेक्स कोड';

  @override
  String get invalidHex => 'अमान्य हेक्स कोड';

  @override
  String get abstain => 'परहेज़';

  @override
  String get abstainSubtitle1 => 'प्रतिदिन स्वचालित रूप से बढ़ता है';

  @override
  String get abstainSubtitle2 => 'पुनरावृत्ति दर्ज करने के लिए टैप करें';

  @override
  String get checkIn => 'चेक-इन';

  @override
  String get checkInSubtitle1 => 'बढ़ने के लिए रोज़ चेक-इन करें';

  @override
  String get checkInSubtitle2 => 'चेक-इन के आधार पर विकास';

  @override
  String get history => 'इतिहास';

  @override
  String daysSuffix(Object days) {
    return '$daysदि';
  }

  @override
  String historyCount(Object count) {
    return 'इतिहास ($count)';
  }

  @override
  String get relapse => 'पुनरावृत्ति';

  @override
  String get checkedIn => 'चेक-इन हो गया';

  @override
  String get checkInAction => 'चेक-इन';

  @override
  String dayStreak(int days) {
    return '$days-दिन की श्रृंखला';
  }

  @override
  String dayCount(int days) {
    return 'दिन $days';
  }

  @override
  String get alreadyCheckedInToday => 'आज पहले ही चेक-इन हो गया ✓';

  @override
  String get tapBelowToCheckIn => 'चेक-इन के लिए नीचे टैप करें';

  @override
  String get giveHabitName => 'अपनी आदत को नाम दें।';

  @override
  String get stageSeed => 'बीज';

  @override
  String get stageSprout => 'अंकुर';

  @override
  String get stageSapling => 'पौधा';

  @override
  String get stageYoungTree => 'युवा पेड़';

  @override
  String get stageGroveTree => 'वन वृक्ष';

  @override
  String get taglineSeed => 'हर महान वन यहीं से शुरू होता है।';

  @override
  String get taglineSprout => 'सतह के नीचे जड़ें बन रही हैं।';

  @override
  String get taglineSapling => 'हर सूर्योदय के साथ और मजबूत होता जा रहा है।';

  @override
  String get taglineYoungTree => 'आपकी छतरी आकार ले रही है।';

  @override
  String get taglineGroveTree => 'आप जंगल बन गए हैं।';

  @override
  String get logARelapse => 'पुनरावृत्ति दर्ज करें?';

  @override
  String get relapseMotivation => 'आप उससे ज्यादा मजबूत हैं जितना आप सोचते हैं।';

  @override
  String get customTimestamp => 'कस्टम समय';

  @override
  String get loggedReason => 'दर्ज कारण (वैकल्पिक)';

  @override
  String get loggedReasonHint => 'तनाव, चिंता, थकान, साथियों का दबाव, ट्रिगर? आदि';

  @override
  String get confirmLog => 'लॉग पुष्टि करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get onboarding0Title => 'Grove में आपका स्वागत है 🌿';

  @override
  String get onboarding0Body => 'एक निजी आदत ट्रैकर जहां पेड़ आपके विकास का प्रतिनिधित्व करते हैं। जितने लंबे समय तक आप स्वच्छ रहेंगे, आपके पेड़ उतने ही जीवंत होते जाएंगे।';

  @override
  String get onboarding1Title => 'एक पेड़ लगाएं';

  @override
  String get onboarding1Body => 'एक आदत बनाने के लिए \"एक पेड़ लगाएं\" टैप करें। नाम दें, रंग चुनें, और Grove एक अनूठा पेड़ बनाता है।';

  @override
  String get onboarding2Title => 'इसे बढ़ते देखें';

  @override
  String get onboarding2Body => 'हर स्वच्छ दिन आपके पेड़ को पांच विकास चरणों से गुजरने में मदद करता है — एक छोटे बीज से लेकर पूर्ण वन वृक्ष तक।';

  @override
  String get onboarding3Title => 'पुनरावृत्ति दर्ज करें';

  @override
  String get onboarding3Body => 'यदि आप फिसल जाएं, तो ईमानदारी से दर्ज करें। Grove आपकी सबसे लंबी श्रृंखलाएं और इतिहास ट्रैक करता है।';

  @override
  String get onboarding4Title => 'आपका इतिहास';

  @override
  String get onboarding4Body => 'किसी भी पेड़ को खोलें और कैलेंडर, मील के पत्थर, श्रृंखला इतिहास, पुनरावृत्ति नोट्स और आपकी दीर्घकालिक निरंतरता की जानकारी देखें।';

  @override
  String get onboarding5Title => 'पूरी तरह निजी';

  @override
  String get onboarding5Body => 'सब कुछ आपके डिवाइस पर रहता है। कुछ भी कहीं नहीं भेजा जाता। सेटिंग में Export / Import के जरिए बैकअप लें। अब कुछ बढ़ाएं! 🌱';

  @override
  String get next => 'आगे';

  @override
  String get back => 'पीछे';

  @override
  String get startGrowing => 'बढ़ना शुरू करें 🌱';

  @override
  String get groveIsBare => 'आपका वन खाली है।';

  @override
  String get plantFirstTree => 'शुरू करने के लिए अपना पहला पेड़ लगाएं।';

  @override
  String get settingsHub => 'सेटिंग्स';

  @override
  String get layoutArchitecture => 'लेआउट';

  @override
  String get renderThemes => 'थीम';

  @override
  String get privacyNotifications => 'गोपनीयता और सूचनाएं';

  @override
  String get dataManagement => 'डेटा प्रबंधन';

  @override
  String get reorderGrove => 'वन को पुनर्व्यवस्थित करें';

  @override
  String get holdDragToReorder => '≡ को दबाकर खींचें';

  @override
  String get layoutWheel => 'पहिया';

  @override
  String get layoutCarousel => 'कैरोसेल';

  @override
  String get layoutGrid => 'ग्रिड';

  @override
  String get layoutList => 'सूची';

  @override
  String get themeForestDark => 'वन अंधेरा';

  @override
  String get themeAmoledBlack => 'AMOLED काला';

  @override
  String get themeMaterialYou => 'Material You';

  @override
  String get themeWhiteMinimal => 'सफेद मिनिमल';

  @override
  String get milestoneNotifications => 'मील का पत्थर सूचनाएं';

  @override
  String get milestoneNotificationsSubtitle => 'जब पेड़ नए विकास चरण पर पहुंचे तो सूचित हों';

  @override
  String get biometricUnlock => 'बायोमेट्रिक अनलॉक';

  @override
  String get biometricUnlockSubtitle => 'Grove खोलने के लिए फिंगरप्रिंट / पिन आवश्यक है';

  @override
  String get exportGroveBackup => 'Grove बैकअप निर्यात करें';

  @override
  String get restoreGroveBackup => 'बैकअप से Grove पुनर्स्थापित करें';

  @override
  String get exportImportNote => 'निर्यात एक .json फ़ाइल सहेजता है।\nआयात आपका वर्तमान grove बदल देगा • पहले बैकअप लें।';

  @override
  String get backupSaved => '✓ बैकअप सहेजा गया';

  @override
  String saveFailed(String error) {
    return 'सहेजना विफल: $error';
  }

  @override
  String get couldNotReadFile => 'चुनी गई फ़ाइल पढ़ी नहीं जा सकी।';

  @override
  String groveRestored(int count) {
    return '✓ Grove पुनर्स्थापित — $count पेड़ लोड हुए';
  }

  @override
  String get invalidBackup => '✗ अमान्य बैकअप — सुनिश्चित करें कि आपने सही फ़ाइल चुनी है';

  @override
  String get language => 'भाषा';

  @override
  String get languageLabel => 'भाषा';

  @override
  String get links => 'लिंक';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => 'स्रोत कोड और योगदान';

  @override
  String get buyMeCoffee => 'मुझे एक कॉफी खरीदें';

  @override
  String get buyMeCoffeeSubtitle => 'विकास का समर्थन करें';

  @override
  String get madeWith => '🌿 के साथ बनाया • सभी डेटा आपके डिवाइस पर रहता है।';

  @override
  String get openSource => 'ओपन सोर्स';

  @override
  String versionLabel(String version) {
    return 'v$version • ओपन सोर्स';
  }

  @override
  String get groveDescription => 'Grove एक न्यूनतम आदत ट्रैकर है जो पेड़ों के माध्यम से आपके विकास को दर्शाता है। हर स्वच्छ दिन आपका पेड़ बढ़ता है। मुफ्त, ओपन-सोर्स।';

  @override
  String get groveLocked => 'Grove लॉक है';

  @override
  String get authenticateToContinue => 'जारी रखने के लिए प्रमाणित करें';

  @override
  String get unlockGrove => 'Grove अनलॉक करें';

  @override
  String get currentStreak => 'वर्तमान श्रृंखला';

  @override
  String get peakRecord => 'शीर्ष रिकॉर्ड';

  @override
  String get relapses => 'पुनरावृत्तियां';

  @override
  String get checkIns => 'चेक-इन';

  @override
  String get interactiveMonthlyLogs => 'मासिक लॉग';

  @override
  String get swipeForEarlierMonths => 'पहले के महीनों के लिए ← स्वाइप करें';

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get logDateBeforeTracking => '← ट्रैकिंग शुरू होने से पहले की तारीख दर्ज करें';

  @override
  String get cleanSinceStart => 'शुरू से स्वच्छ';

  @override
  String get timeSinceLastRelapse => 'अंतिम पुनरावृत्ति के बाद का समय';

  @override
  String get days => 'दिन';

  @override
  String get hrs => 'घंटे';

  @override
  String get min => 'मिनट';

  @override
  String get sec => 'सेकंड';

  @override
  String get checkedInToday => 'आज चेक-इन हुआ';

  @override
  String get notCheckedInToday => 'आज चेक-इन नहीं हुआ';

  @override
  String get streak => 'श्रृंखला';

  @override
  String get total => 'कुल';

  @override
  String get alreadyCheckedIn => 'पहले ही चेक-इन हो गया';

  @override
  String get checkInToday => 'आज चेक-इन करें';

  @override
  String get relapseSweepTimeline => 'पुनरावृत्ति समयरेखा';

  @override
  String get checkInHistory => 'चेक-इन इतिहास';

  @override
  String totalCount(int count) {
    return '$count कुल';
  }

  @override
  String get noRelapsesRecorded => 'कोई पुनरावृत्ति दर्ज नहीं। बढ़ते रहें।';

  @override
  String get noCheckInsYet => 'अभी तक कोई चेक-इन नहीं। आज शुरू करें!';

  @override
  String get renameHabit => 'आदत का नाम बदलें';

  @override
  String get save => 'सहेजें';

  @override
  String get dangerZone => 'खतरनाक क्षेत्र';

  @override
  String get deleteHabitPermanently => 'आदत स्थायी रूप से हटाएं';

  @override
  String get deleteHabit => 'आदत हटाएं?';

  @override
  String deleteHabitConfirm(String name) {
    return 'यह \"$name\" और उसका पूरा इतिहास स्थायी रूप से हटा देगा। यह क्रिया पूर्ववत नहीं की जा सकती।';
  }

  @override
  String get delete => 'हटाएं';

  @override
  String get earlierThanLogs => 'आपके लॉग से पहले?';

  @override
  String trackingStarted(String date) {
    return 'ट्रैकिंग $date से शुरू हुई।\nयदि उससे पहले कुछ हुआ, तो आप इसे यहां दर्ज कर सकते हैं।';
  }

  @override
  String get logEarlierDate => 'पहले की तारीख दर्ज करें';

  @override
  String get extendsHistoryNote => 'यह आपके इतिहास को बढ़ाता है और श्रृंखलाओं की पुनर्गणना करता है';

  @override
  String get logEarlierDateTitle => 'पहले की तारीख दर्ज करें';

  @override
  String get beforeTrackingStarted => 'ट्रैकिंग शुरू होने से पहले';

  @override
  String get extendHistoryInfo => 'यह आपके ट्रैकिंग इतिहास को बढ़ाएगा और शीर्ष श्रृंखलाओं की पुनर्गणना करेगा।';

  @override
  String get date => 'तारीख';

  @override
  String get time => 'समय';

  @override
  String get logAsRelapseOnDate => 'इस तारीख को पुनरावृत्ति के रूप में दर्ज करें';

  @override
  String get onlyExtendStartDate => 'केवल प्रारंभ तारीख बढ़ाएं (पुनरावृत्ति नहीं)';

  @override
  String get whatHappenedHint => 'उस दिन क्या हुआ…';

  @override
  String peakSweep(int days) {
    return 'शीर्ष श्रृंखला: $days दिन';
  }

  @override
  String get noReasonRecorded => 'कोई कारण दर्ज नहीं।';

  @override
  String notifSproutTitle(String name) {
    return '$name अंकुरित हो रहा है! 🌱';
  }

  @override
  String get notifSproutBody => 'आपके पेड़ की जड़ें बन गई हैं। बढ़ते रहें।';

  @override
  String notifSaplingTitle(String name) {
    return '$name अब पौधा है! 🌿';
  }

  @override
  String get notifSaplingBody => 'आपका पेड़ अपने दम पर खड़ा है, देखें आप कितना बढ़े हैं';

  @override
  String notifYoungTreeTitle(String name) {
    return '$name बढ़ रहा है! 🌳';
  }

  @override
  String get notifYoungTreeBody => 'आपकी छतरी आकार ले रही है, अविश्वसनीय।';

  @override
  String notifGroveTreeTitle(String name) {
    return '$name वन वृक्ष बन गया! 🌲';
  }

  @override
  String get notifGroveTreeBody => 'बधाई हो!!! आप जंगल बन गए हैं।';

  @override
  String get saveGroveBackupDialog => 'Grove बैकअप सहेजें';

  @override
  String get selectGroveBackupDialog => 'Grove बैकअप चुनें';

  @override
  String get customAccentColor => 'कस्टम एक्सेंट रंग';

  @override
  String get customAccentDefault => 'डिफ़ॉल्ट हरा';

  @override
  String get customAccentSubtitle => 'बटन, कार्ड और बैज पर लागू';

  @override
  String get applyAccent => 'एक्सेंट लगाएं';

  @override
  String get resetAccentDefault => 'डिफ़ॉल्ट पर रीसेट करें';

  @override
  String get dailyReminderSetting => 'दैनिक चेक-इन रिमाइंडर';

  @override
  String get dailyReminderSettingSubtitle => 'अपने वन में चेक-इन करने का एक संकेत';

  @override
  String get tapToChange => 'बदलने के लिए टैप करें';

  @override
  String get languageSection => 'भाषा';

  @override
  String get dailyReminderTitle => 'चेक-इन का समय 🌿';

  @override
  String get dailyReminderBody => 'आपका वन प्रतीक्षा कर रहा है। श्रृंखला जीवित रखें।';
}
