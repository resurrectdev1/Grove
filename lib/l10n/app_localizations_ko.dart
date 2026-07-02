// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Grove';

  @override
  String get appTagline => 'G R O V E';

  @override
  String get plantATree => '나무 심기';

  @override
  String get plantTree => '나무 심기';

  @override
  String get plantANewTree => '새 나무 심기';

  @override
  String get habitName => '습관 이름';

  @override
  String get habitNameHint => '예: 음주, 흡연, 소셜 미디어';

  @override
  String get trackingMode => '추적 모드';

  @override
  String get presetColors => '프리셋 색상';

  @override
  String get customHexCode => '사용자 정의 HEX 코드';

  @override
  String get hexCode => 'HEX 코드';

  @override
  String get invalidHex => '잘못된 HEX 코드';

  @override
  String get abstain => '절제';

  @override
  String get abstainSubtitle1 => '매일 자동으로 성장';

  @override
  String get abstainSubtitle2 => '재발 기록하려면 탭';

  @override
  String get checkIn => '체크인';

  @override
  String get checkInSubtitle1 => '매일 체크인하여 성장';

  @override
  String get checkInSubtitle2 => '체크인 기반 성장';

  @override
  String get history => '기록';

  @override
  String daysSuffix(Object days) {
    return '$days일';
  }

  @override
  String historyCount(Object count) {
    return '기록 ($count)';
  }

  @override
  String get relapse => '재발';

  @override
  String get checkedIn => '체크인 완료';

  @override
  String get checkInAction => '체크인';

  @override
  String dayStreak(int days) {
    return '$days일 연속';
  }

  @override
  String dayCount(int days) {
    return '$days일째';
  }

  @override
  String get alreadyCheckedInToday => '오늘 이미 체크인 완료 ✓';

  @override
  String get tapBelowToCheckIn => '아래 탭하여 체크인';

  @override
  String get giveHabitName => '습관에 이름을 붙여주세요.';

  @override
  String get stageSeed => '씨앗';

  @override
  String get stageSprout => '새싹';

  @override
  String get stageSapling => '묘목';

  @override
  String get stageYoungTree => '어린 나무';

  @override
  String get stageGroveTree => '숲 나무';

  @override
  String get taglineSeed => '모든 위대한 숲은 여기서 시작됩니다.';

  @override
  String get taglineSprout => '표면 아래에서 뿌리가 형성되고 있습니다.';

  @override
  String get taglineSapling => '매일 해가 뜰 때마다 더 강해지고 있습니다.';

  @override
  String get taglineYoungTree => '나무 지붕이 형성되고 있습니다.';

  @override
  String get taglineGroveTree => '당신은 숲이 되었습니다.';

  @override
  String get logARelapse => '재발을 기록할까요?';

  @override
  String get relapseMotivation => '당신은 생각보다 강합니다.';

  @override
  String get customTimestamp => '사용자 정의 타임스탬프';

  @override
  String get loggedReason => '기록된 이유 (선택 사항)';

  @override
  String get loggedReasonHint => '스트레스, 불안, 번아웃, 동료 압박, 트리거? 등';

  @override
  String get confirmLog => '기록 확인';

  @override
  String get cancel => '취소';

  @override
  String get onboarding0Title => 'Grove에 오신 것을 환영합니다 🌿';

  @override
  String get onboarding0Body => '나무가 당신의 성장을 나타내는 개인 습관 추적기입니다. 금욕하거나 체크인할수록 나무가 더 생생하고 무성해집니다.';

  @override
  String get onboarding1Title => '나무 심기';

  @override
  String get onboarding1Body => '습관을 만들려면 \"나무 심기\"를 탭하세요. 이름을 주고 색상을 선택하면 Grove가 고유한 나무를 생성합니다.';

  @override
  String get onboarding2Title => '성장 지켜보기';

  @override
  String get onboarding2Body => '매일매일이 나무를 5단계로 성숙시킵니다. 작은 씨앗부터 흔들리는 가지와 잎이 있는 완전한 숲 나무까지.';

  @override
  String get onboarding3Title => '재발 기록하기';

  @override
  String get onboarding3Body => '실수하면 솔직하게 기록하세요. Grove는 가장 긴 연속 기록과 역사를 추적하며 진행 상황은 절대 지워지지 않습니다.';

  @override
  String get onboarding4Title => '당신의 기록';

  @override
  String get onboarding4Body => '나무를 열어 달력, 마일스톤, 연속 기록 역사 및 장기적 일관성에 대한 통찰력을 탐색하세요.';

  @override
  String get onboarding5Title => '완전한 프라이버시';

  @override
  String get onboarding5Body => '모든 것이 기기에 저장됩니다. 어디에도 전송되지 않습니다. 설정의 내보내기 / 가져오기로 언제든 백업하세요. 이제 성장하세요! 🌱';

  @override
  String get next => '다음';

  @override
  String get back => '뒤로';

  @override
  String get startGrowing => '성장 시작 🌱';

  @override
  String get groveIsBare => '당신의 숲은 비어 있습니다.';

  @override
  String get plantFirstTree => '첫 번째 나무를 심어 시작하세요.';

  @override
  String get settingsHub => '설정';

  @override
  String get layoutArchitecture => '레이아웃';

  @override
  String get renderThemes => '테마';

  @override
  String get privacyNotifications => '개인 정보 보호 및 알림';

  @override
  String get dataManagement => '데이터 관리';

  @override
  String get reorderGrove => '숲 순서 변경';

  @override
  String get holdDragToReorder => '≡을 길게 눌러 순서 변경';

  @override
  String get layoutWheel => '휠';

  @override
  String get layoutCarousel => '캐러셀';

  @override
  String get layoutGrid => '그리드';

  @override
  String get layoutList => '목록';

  @override
  String get themeForestDark => '포레스트 다크';

  @override
  String get themeAmoledBlack => 'AMOLED 블랙';

  @override
  String get themeMaterialYou => 'Material You';

  @override
  String get themeWhiteMinimal => '화이트 미니멀';

  @override
  String get milestoneNotifications => '마일스톤 알림';

  @override
  String get milestoneNotificationsSubtitle => '나무가 새 성장 단계에 도달하면 알림 받기';

  @override
  String get biometricUnlock => '생체 인식 잠금 해제';

  @override
  String get biometricUnlockSubtitle => 'Grove를 열려면 지문 / PIN 필요';

  @override
  String get exportGroveBackup => 'Grove 백업 내보내기';

  @override
  String get restoreGroveBackup => '백업에서 Grove 복원';

  @override
  String get exportImportNote => '내보내기는 선택한 위치에 .json 파일을 저장합니다.\n가져오기는 현재 grove를 교체합니다 • 먼저 백업하세요.';

  @override
  String get backupSaved => '✓ 백업 저장됨';

  @override
  String saveFailed(String error) {
    return '저장 실패: $error';
  }

  @override
  String get couldNotReadFile => '선택한 파일을 읽을 수 없습니다.';

  @override
  String groveRestored(int count) {
    return '✓ Grove 복원됨 — 나무 $count그루 로드됨';
  }

  @override
  String get invalidBackup => '✗ 잘못된 백업 — 올바른 파일을 선택했는지 확인하세요';

  @override
  String get language => '언어';

  @override
  String get languageLabel => '언어';

  @override
  String get links => '링크';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => '소스 코드 및 기여';

  @override
  String get buyMeCoffee => '커피 한 잔 사주세요';

  @override
  String get buyMeCoffeeSubtitle => '개발 지원';

  @override
  String get madeWith => '🌿로 만들어졌습니다 • 모든 데이터는 기기에 저장됩니다.';

  @override
  String get openSource => '오픈 소스';

  @override
  String versionLabel(String version) {
    return 'v$version • 오픈 소스';
  }

  @override
  String get groveDescription => 'Grove는 나무를 통해 성장을 시각화하는 미니멀리스트 습관 및 금욕 추적기입니다. 매일 금욕하거나 체크인하면 나무가 자랍니다. 무료 오픈 소스.';

  @override
  String get groveLocked => 'Grove가 잠겨 있습니다';

  @override
  String get authenticateToContinue => '계속하려면 인증하세요';

  @override
  String get unlockGrove => 'Grove 잠금 해제';

  @override
  String get currentStreak => '현재 연속';

  @override
  String get peakRecord => '최고 기록';

  @override
  String get relapses => '재발';

  @override
  String get checkIns => '체크인';

  @override
  String get interactiveMonthlyLogs => '월별 기록';

  @override
  String get swipeForEarlierMonths => '이전 달은 ← 스와이프';

  @override
  String get thisMonth => '이번 달';

  @override
  String get logDateBeforeTracking => '← 추적 시작 전 날짜 기록';

  @override
  String get abstinentSinceStart => '재발 기록 없음.';

  @override
  String get timeSinceLastRelapse => '마지막 재발 이후 시간';

  @override
  String get days => '일';

  @override
  String get hrs => '시';

  @override
  String get min => '분';

  @override
  String get sec => '초';

  @override
  String get checkedInToday => '오늘 체크인 완료';

  @override
  String get notCheckedInToday => '오늘 체크인 안 함';

  @override
  String get streak => '연속';

  @override
  String get total => '합계';

  @override
  String get alreadyCheckedIn => '이미 체크인';

  @override
  String get checkInToday => '오늘 체크인';

  @override
  String get relapseSweepTimeline => '재발 타임라인';

  @override
  String get checkInHistory => '체크인 기록';

  @override
  String totalCount(int count) {
    return '총 $count건';
  }

  @override
  String get noRelapsesRecorded => '기록된 재발 없음. 계속 성장하세요.';

  @override
  String get noCheckInsYet => '아직 체크인 없음. 오늘 시작하세요!';

  @override
  String get renameHabit => '습관 이름 변경';

  @override
  String get save => '저장';

  @override
  String get dangerZone => '위험 구역';

  @override
  String get deleteHabitPermanently => '습관 영구 삭제';

  @override
  String get deleteHabit => '습관을 삭제할까요?';

  @override
  String deleteHabitConfirm(String name) {
    return '\"$name\"과 모든 기록을 영구적으로 삭제합니다. 이 작업은 취소할 수 없습니다.';
  }

  @override
  String get delete => '삭제';

  @override
  String get earlierThanLogs => '기록보다 이전 날짜인가요?';

  @override
  String trackingStarted(String date) {
    return '추적 시작일: $date.\n그 이전에 무언가 있었다면 여기에 기록할 수 있습니다.';
  }

  @override
  String get logEarlierDate => '이전 날짜 기록';

  @override
  String get extendsHistoryNote => '이렇게 하면 기록이 연장되고 연속이 재계산됩니다';

  @override
  String get logEarlierDateTitle => '이전 날짜 기록';

  @override
  String get beforeTrackingStarted => '추적 시작 전';

  @override
  String get extendHistoryInfo => '추적 기록이 연장되고 최고 연속 기록이 재계산됩니다.';

  @override
  String get date => '날짜';

  @override
  String get time => '시간';

  @override
  String get logAsRelapseOnDate => '이 날짜에 재발로 기록';

  @override
  String get onlyExtendStartDate => '시작 날짜만 연장 (재발 없음)';

  @override
  String get whatHappenedHint => '그날 무슨 일이 있었나요…';

  @override
  String peakSweep(int days) {
    return '최고 연속: $days일';
  }

  @override
  String get noReasonRecorded => '이유 기록 없음.';

  @override
  String notifSproutTitle(String name) {
    return '$name이(가) 싹트고 있어요! 🌱';
  }

  @override
  String get notifSproutBody => '나무의 뿌리가 형성되었습니다. 계속 성장하세요.';

  @override
  String notifSaplingTitle(String name) {
    return '$name이(가) 묘목이 되었어요! 🌿';
  }

  @override
  String get notifSaplingBody => '나무가 스스로 서 있습니다. 얼마나 성장했는지 보세요';

  @override
  String notifYoungTreeTitle(String name) {
    return '$name이(가) 쑥쑥 자라고 있어요! 🌳';
  }

  @override
  String get notifYoungTreeBody => '나무 지붕이 형성되기 시작했습니다. 대단해요.';

  @override
  String notifGroveTreeTitle(String name) {
    return '$name이(가) 숲 나무가 되었어요! 🌲';
  }

  @override
  String get notifGroveTreeBody => '축하합니다!!! 당신은 숲이 되었습니다.';

  @override
  String get saveGroveBackupDialog => 'Grove 백업 저장';

  @override
  String get selectGroveBackupDialog => 'Grove 백업 선택';

  @override
  String get customAccentColor => '사용자 정의 강조 색상';

  @override
  String get customAccentDefault => '기본 초록';

  @override
  String get customAccentSubtitle => '버튼, 카드, 배지에 적용';

  @override
  String get applyAccent => '강조색 적용';

  @override
  String get resetAccentDefault => '기본값으로 재설정';

  @override
  String get dailyReminderSetting => '매일 체크인 알림';

  @override
  String get dailyReminderSettingSubtitle => '당신의 숲에 체크인하라는 알림';

  @override
  String get tapToChange => '탭하여 변경';

  @override
  String get languageSection => '언어';

  @override
  String get dailyReminderTitle => '체크인 시간이에요 🌿';

  @override
  String get dailyReminderBody => '당신의 숲이 기다리고 있습니다. 연속 기록을 지키세요.';
}
