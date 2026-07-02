// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Grove';

  @override
  String get appTagline => 'G R O V E';

  @override
  String get plantATree => 'Trồng một cây';

  @override
  String get plantTree => 'Trồng cây';

  @override
  String get plantANewTree => 'Trồng cây mới';

  @override
  String get habitName => 'Tên thói quen';

  @override
  String get habitNameHint => 'Ví dụ: Rượu, Thuốc lá, Mạng xã hội';

  @override
  String get trackingMode => 'CHẾ ĐỘ THEO DÕI';

  @override
  String get presetColors => 'MÀU CÓ SẴN';

  @override
  String get customHexCode => 'MÃ HEX TÙY CHỈNH';

  @override
  String get hexCode => 'Mã Hex';

  @override
  String get invalidHex => 'Mã hex không hợp lệ';

  @override
  String get abstain => 'Kiêng cữ';

  @override
  String get abstainSubtitle1 => 'Tự động phát triển mỗi ngày';

  @override
  String get abstainSubtitle2 => 'Nhấn để ghi lại tái phát';

  @override
  String get checkIn => 'Điểm danh';

  @override
  String get checkInSubtitle1 => 'Điểm danh hàng ngày để phát triển';

  @override
  String get checkInSubtitle2 => 'Tăng trưởng dựa trên điểm danh';

  @override
  String get history => 'Lịch sử';

  @override
  String daysSuffix(Object days) {
    return '$days ngày';
  }

  @override
  String historyCount(Object count) {
    return 'Lịch sử ($count)';
  }

  @override
  String get relapse => 'Tái phát';

  @override
  String get checkedIn => 'Đã điểm danh';

  @override
  String get checkInAction => 'Điểm danh';

  @override
  String dayStreak(int days) {
    return 'Chuỗi $days ngày';
  }

  @override
  String dayCount(int days) {
    return 'Ngày $days';
  }

  @override
  String get alreadyCheckedInToday => 'Đã điểm danh hôm nay ✓';

  @override
  String get tapBelowToCheckIn => 'Nhấn bên dưới để điểm danh';

  @override
  String get giveHabitName => 'Đặt tên cho thói quen của bạn.';

  @override
  String get stageSeed => 'Hạt giống';

  @override
  String get stageSprout => 'Mầm';

  @override
  String get stageSapling => 'Cây non';

  @override
  String get stageYoungTree => 'Cây trẻ';

  @override
  String get stageGroveTree => 'Cây rừng';

  @override
  String get taglineSeed => 'Mọi khu rừng lớn đều bắt đầu từ đây.';

  @override
  String get taglineSprout => 'Rễ đang hình thành bên dưới.';

  @override
  String get taglineSapling => 'Ngày càng mạnh mẽ hơn với mỗi bình minh.';

  @override
  String get taglineYoungTree => 'Tán cây của bạn đang thành hình.';

  @override
  String get taglineGroveTree => 'Bạn đã trở thành khu rừng.';

  @override
  String get logARelapse => 'Ghi lại tái phát?';

  @override
  String get relapseMotivation => 'Bạn mạnh mẽ hơn bạn nghĩ.';

  @override
  String get customTimestamp => 'THỜI GIAN TÙY CHỈNH';

  @override
  String get loggedReason => 'LÝ DO GHI LẠI (Tùy chọn)';

  @override
  String get loggedReasonHint => 'Căng thẳng, Lo lắng, Kiệt sức, Áp lực đồng nghiệp…';

  @override
  String get confirmLog => 'Xác nhận ghi';

  @override
  String get cancel => 'Hủy';

  @override
  String get onboarding0Title => 'Chào mừng đến Grove 🌿';

  @override
  String get onboarding0Body => 'Công cụ theo dõi thói quen riêng tư, nơi những cái cây đại diện cho sự phát triển của bạn. Bạn kiêng cữ hoặc điểm danh càng lâu, cây càng xanh tươi.';

  @override
  String get onboarding1Title => 'Trồng một cây';

  @override
  String get onboarding1Body => 'Nhấn \"Trồng một cây\" để tạo thói quen. Đặt tên, chọn màu, và Grove tạo ra một cây riêng biệt. Mỗi cây phát triển khác nhau.';

  @override
  String get onboarding2Title => 'Xem cây phát triển';

  @override
  String get onboarding2Body => 'Mỗi ngày giúp cây của bạn trưởng thành qua năm giai đoạn — từ hạt giống nhỏ đến cây rừng đầy đủ với cành lá đung đưa.';

  @override
  String get onboarding3Title => 'Ghi lại tái phát';

  @override
  String get onboarding3Body => 'Nếu bạn sa ngã, hãy ghi lại trung thực. Grove theo dõi chuỗi dài nhất và lịch sử của bạn, tiến trình không bao giờ bị xóa.';

  @override
  String get onboarding4Title => 'Lịch sử của bạn';

  @override
  String get onboarding4Body => 'Mở bất kỳ cây nào để khám phá lịch, mốc quan trọng, lịch sử chuỗi và thông tin chi tiết về sự nhất quán lâu dài.';

  @override
  String get onboarding5Title => 'Hoàn toàn riêng tư';

  @override
  String get onboarding5Body => 'Mọi thứ đều ở trên thiết bị của bạn. Không có gì được gửi đi. Sao lưu hoặc di chuyển grove của bạn qua Xuất / Nhập trong Cài đặt. Hãy bắt đầu phát triển! 🌱';

  @override
  String get next => 'Tiếp theo';

  @override
  String get back => 'Quay lại';

  @override
  String get startGrowing => 'Bắt đầu phát triển 🌱';

  @override
  String get groveIsBare => 'Khu rừng của bạn trống rỗng.';

  @override
  String get plantFirstTree => 'Trồng cây đầu tiên để bắt đầu.';

  @override
  String get settingsHub => 'Trung tâm cài đặt';

  @override
  String get layoutArchitecture => 'BỐ CỤC';

  @override
  String get renderThemes => 'CHỦ ĐỀ';

  @override
  String get privacyNotifications => 'QUYỀN RIÊNG TƯ & THÔNG BÁO';

  @override
  String get dataManagement => 'QUẢN LÝ DỮ LIỆU';

  @override
  String get reorderGrove => 'Sắp xếp lại';

  @override
  String get holdDragToReorder => 'Giữ & kéo ≡ để sắp xếp';

  @override
  String get layoutWheel => 'Bánh xe';

  @override
  String get layoutCarousel => 'Băng chuyền';

  @override
  String get layoutGrid => 'Lưới';

  @override
  String get layoutList => 'Danh sách';

  @override
  String get themeForestDark => 'Rừng tối';

  @override
  String get themeAmoledBlack => 'AMOLED Đen';

  @override
  String get themeMaterialYou => 'Material You';

  @override
  String get themeWhiteMinimal => 'Trắng tối giản';

  @override
  String get milestoneNotifications => 'Thông báo mốc quan trọng';

  @override
  String get milestoneNotificationsSubtitle => 'Nhận thông báo khi cây đạt giai đoạn phát triển mới';

  @override
  String get biometricUnlock => 'Mở khóa sinh trắc học';

  @override
  String get biometricUnlockSubtitle => 'Yêu cầu vân tay / mã PIN để mở Grove';

  @override
  String get exportGroveBackup => 'Xuất bản sao lưu';

  @override
  String get restoreGroveBackup => 'Khôi phục từ bản sao lưu';

  @override
  String get exportImportNote => 'Xuất lưu file .json vào vị trí bạn chọn.\nNhập sẽ thay thế grove hiện tại của bạn • xuất bản sao lưu trước.';

  @override
  String get backupSaved => '✓ Đã lưu bản sao lưu';

  @override
  String saveFailed(String error) {
    return 'Lưu thất bại: $error';
  }

  @override
  String get couldNotReadFile => 'Không thể đọc file đã chọn.';

  @override
  String groveRestored(int count) {
    return '✓ Đã khôi phục grove — $count cây được tải';
  }

  @override
  String get invalidBackup => '✗ Bản sao lưu không hợp lệ — hãy chắc chắn bạn chọn đúng file';

  @override
  String get language => 'NGÔN NGỮ';

  @override
  String get languageLabel => 'Ngôn ngữ';

  @override
  String get links => 'LIÊN KẾT';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => 'Mã nguồn & đóng góp';

  @override
  String get buyMeCoffee => 'Mua cho tôi một ly cà phê';

  @override
  String get buyMeCoffeeSubtitle => 'Hỗ trợ phát triển';

  @override
  String get madeWith => 'Được tạo với 🌿 • tất cả dữ liệu ở trên thiết bị của bạn.';

  @override
  String get openSource => 'Mã nguồn mở';

  @override
  String versionLabel(String version) {
    return 'v$version • Mã nguồn mở';
  }

  @override
  String get groveDescription => 'Grove là ứng dụng theo dõi thói quen và sự tỉnh táo tối giản, trực quan hóa sự phát triển của bạn qua những cái cây. Mỗi ngày bạn kiêng cữ hoặc điểm danh, cây của bạn phát triển. Được xây dựng miễn phí, mã nguồn mở.';

  @override
  String get groveLocked => 'Grove đã bị khóa';

  @override
  String get authenticateToContinue => 'Xác thực để tiếp tục';

  @override
  String get unlockGrove => 'Mở khóa Grove';

  @override
  String get currentStreak => 'Chuỗi hiện tại';

  @override
  String get peakRecord => 'Kỷ lục đỉnh cao';

  @override
  String get relapses => 'Tái phát';

  @override
  String get checkIns => 'Điểm danh';

  @override
  String get interactiveMonthlyLogs => 'Nhật ký hàng tháng';

  @override
  String get swipeForEarlierMonths => 'Vuốt ← để xem tháng trước';

  @override
  String get thisMonth => 'Tháng này';

  @override
  String get logDateBeforeTracking => '← Ghi ngày trước khi bắt đầu theo dõi';

  @override
  String get abstinentSinceStart => 'Chưa có tái phát nào được ghi nhận.';

  @override
  String get timeSinceLastRelapse => 'Thời gian từ lần tái phát cuối';

  @override
  String get days => 'NGÀY';

  @override
  String get hrs => 'GIỜ';

  @override
  String get min => 'PHÚT';

  @override
  String get sec => 'GIÂY';

  @override
  String get checkedInToday => 'Đã điểm danh hôm nay';

  @override
  String get notCheckedInToday => 'Chưa điểm danh hôm nay';

  @override
  String get streak => 'CHUỖI';

  @override
  String get total => 'TỔNG';

  @override
  String get alreadyCheckedIn => 'Đã điểm danh';

  @override
  String get checkInToday => 'Điểm danh hôm nay';

  @override
  String get relapseSweepTimeline => 'Dòng thời gian tái phát';

  @override
  String get checkInHistory => 'Lịch sử điểm danh';

  @override
  String totalCount(int count) {
    return '$count tổng cộng';
  }

  @override
  String get noRelapsesRecorded => 'Chưa có tái phát nào. Tiếp tục phát triển.';

  @override
  String get noCheckInsYet => 'Chưa có điểm danh. Bắt đầu hôm nay!';

  @override
  String get renameHabit => 'Đổi tên thói quen';

  @override
  String get save => 'Lưu';

  @override
  String get dangerZone => 'Vùng nguy hiểm';

  @override
  String get deleteHabitPermanently => 'Xóa thói quen vĩnh viễn';

  @override
  String get deleteHabit => 'Xóa thói quen?';

  @override
  String deleteHabitConfirm(String name) {
    return 'Điều này sẽ xóa vĩnh viễn \"$name\" và toàn bộ lịch sử. Hành động này không thể hoàn tác.';
  }

  @override
  String get delete => 'Xóa';

  @override
  String get earlierThanLogs => 'Sớm hơn nhật ký?';

  @override
  String trackingStarted(String date) {
    return 'Bắt đầu theo dõi từ $date.\nNếu có gì xảy ra trước đó, bạn có thể ghi lại ở đây.';
  }

  @override
  String get logEarlierDate => 'Ghi ngày trước đó';

  @override
  String get extendsHistoryNote => 'Điều này mở rộng lịch sử và tính toán lại chuỗi';

  @override
  String get logEarlierDateTitle => 'Ghi ngày trước đó';

  @override
  String get beforeTrackingStarted => 'Trước khi bắt đầu theo dõi';

  @override
  String get extendHistoryInfo => 'Điều này sẽ mở rộng lịch sử theo dõi và tính toán lại chuỗi đỉnh cao.';

  @override
  String get date => 'NGÀY';

  @override
  String get time => 'GIỜ';

  @override
  String get logAsRelapseOnDate => 'Ghi là tái phát vào ngày này';

  @override
  String get onlyExtendStartDate => 'Chỉ mở rộng ngày bắt đầu (không tái phát)';

  @override
  String get whatHappenedHint => 'Điều gì đã xảy ra hôm đó…';

  @override
  String peakSweep(int days) {
    return 'Chuỗi đỉnh: $days ngày';
  }

  @override
  String get noReasonRecorded => 'Không có lý do nào được ghi.';

  @override
  String notifSproutTitle(String name) {
    return '$name đang nảy mầm! 🌱';
  }

  @override
  String get notifSproutBody => 'Rễ cây của bạn đã hình thành. Tiếp tục phát triển.';

  @override
  String notifSaplingTitle(String name) {
    return '$name đã thành cây non! 🌿';
  }

  @override
  String get notifSaplingBody => 'Cây của bạn đứng vững, hãy xem bạn đã phát triển thế nào';

  @override
  String notifYoungTreeTitle(String name) {
    return '$name đang lớn! 🌳';
  }

  @override
  String get notifYoungTreeBody => 'Tán cây của bạn đang thành hình, thật tuyệt vời.';

  @override
  String notifGroveTreeTitle(String name) {
    return '$name đã thành cây rừng! 🌲';
  }

  @override
  String get notifGroveTreeBody => 'Chúc mừng!!! Bạn đã trở thành khu rừng.';

  @override
  String get saveGroveBackupDialog => 'Lưu bản sao lưu Grove';

  @override
  String get selectGroveBackupDialog => 'Chọn bản sao lưu Grove';

  @override
  String get customAccentColor => 'Màu nhấn tùy chỉnh';

  @override
  String get customAccentDefault => 'Xanh mặc định';

  @override
  String get customAccentSubtitle => 'Áp dụng cho nút, thẻ và huy hiệu';

  @override
  String get applyAccent => 'Áp dụng màu';

  @override
  String get resetAccentDefault => 'Đặt lại mặc định';

  @override
  String get dailyReminderSetting => 'Nhắc nhở điểm danh hàng ngày';

  @override
  String get dailyReminderSettingSubtitle => 'Nhắc nhở bạn điểm danh trong khu rừng của mình';

  @override
  String get tapToChange => 'Nhấn để thay đổi';

  @override
  String get languageSection => 'NGÔN NGỮ';

  @override
  String get dailyReminderTitle => 'Đến giờ điểm danh 🌿';

  @override
  String get dailyReminderBody => 'Khu rừng của bạn đang chờ. Giữ chuỗi sống.';

  @override
  String get legendMissed => 'Đã bỏ lỡ';

  @override
  String get legendAbstained => 'Đã kiêng';

  @override
  String get legendCheckIn => 'Điểm danh';

  @override
  String get legendRelapse => 'Tái phạm';

  @override
  String get legendExcused => 'Được miễn';

  @override
  String get relapseLoggedThisDay => '⚠️ Đã ghi nhận tái phạm vào ngày này.';

  @override
  String get cleanRecord => '🌿 Ghi nhận sạch.';

  @override
  String get timeOverride => 'GHI ĐÈ THỜI GIAN';

  @override
  String anchorTime(String time) {
    return 'Mốc thời gian: $time';
  }

  @override
  String checkInTimeLabel(String time) {
    return 'Giờ điểm danh: $time';
  }

  @override
  String get editReason => 'CHỈNH SỬA LÝ DO';

  @override
  String get reasonOptional => 'LÝ DO (không bắt buộc)';

  @override
  String get reasonHint => 'Căng thẳng, lo âu, kiệt sức, áp lực bạn bè, tác nhân kích hoạt? v.v...';

  @override
  String get excusedStreakPreserved => '❄️ Được miễn, chuỗi ngày của bạn được giữ nguyên.';

  @override
  String get checkedInThisDay => '✅ Đã điểm danh vào ngày này.';

  @override
  String get noCheckInRecorded => '🌿 Không có điểm danh nào được ghi nhận.';

  @override
  String get saveNewTime => 'Lưu thời gian mới';

  @override
  String get excuseThisDayInstead => 'Miễn ngày này thay thế';

  @override
  String get checkInInstead => 'Điểm danh thay thế';

  @override
  String get removeExcuse => 'Xóa miễn trừ';

  @override
  String get updateLog => 'Cập nhật nhật ký';

  @override
  String get removeRelapseBtn => 'Xóa tái phạm';

  @override
  String get addRelapseHere => 'Thêm tái phạm tại đây';

  @override
  String get removeCheckIn => 'Xóa điểm danh';

  @override
  String get checkInThisDay => 'Điểm danh ngày này';
}
