// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Grove';

  @override
  String get appTagline => 'G R O V E';

  @override
  String get plantATree => '种一棵树';

  @override
  String get plantTree => '种下树木';

  @override
  String get plantANewTree => '种一棵新树';

  @override
  String get habitName => '习惯名称';

  @override
  String get habitNameHint => '例如：酒精、抽烟、社交媒体';

  @override
  String get trackingMode => '追踪模式';

  @override
  String get presetColors => '预设颜色';

  @override
  String get customHexCode => '自定义颜色代码';

  @override
  String get hexCode => '颜色代码';

  @override
  String get invalidHex => '无效的颜色代码';

  @override
  String get abstain => '戒除';

  @override
  String get abstainSubtitle1 => '每天自动生长';

  @override
  String get abstainSubtitle2 => '点击记录复发';

  @override
  String get checkIn => '打卡';

  @override
  String get checkInSubtitle1 => '每日打卡以促进生长';

  @override
  String get checkInSubtitle2 => '根据打卡次数生长';

  @override
  String get history => '历史';

  @override
  String daysSuffix(Object days) {
    return '$days天';
  }

  @override
  String historyCount(Object count) {
    return '历史记录 ($count)';
  }

  @override
  String get relapse => '复发';

  @override
  String get checkedIn => '已打卡';

  @override
  String get checkInAction => '打卡';

  @override
  String dayStreak(int days) {
    return '$days天连续';
  }

  @override
  String dayCount(int days) {
    return '第$days天';
  }

  @override
  String get alreadyCheckedInToday => '今日已打卡 ✓';

  @override
  String get tapBelowToCheckIn => '点击下方打卡';

  @override
  String get giveHabitName => '请为你的习惯命名。';

  @override
  String get stageSeed => '种子';

  @override
  String get stageSprout => '嫩芽';

  @override
  String get stageSapling => '幼苗';

  @override
  String get stageYoungTree => '小树';

  @override
  String get stageGroveTree => '大树';

  @override
  String get taglineSeed => '每片伟大的森林都从这里开始。';

  @override
  String get taglineSprout => '根系正在地下形成。';

  @override
  String get taglineSapling => '每一个清晨都让你更加茁壮。';

  @override
  String get taglineYoungTree => '你的树冠正在成形。';

  @override
  String get taglineGroveTree => '你已经成为了森林。';

  @override
  String get logARelapse => '记录复发？';

  @override
  String get relapseMotivation => '你比你想象的更坚强。';

  @override
  String get customTimestamp => '自定义时间戳';

  @override
  String get loggedReason => '记录原因（可选）';

  @override
  String get loggedReasonHint => '压力、焦虑、倦怠、同伴压力、触发因素等……';

  @override
  String get confirmLog => '确认记录';

  @override
  String get cancel => '取消';

  @override
  String get onboarding0Title => '欢迎使用 Grove 🌿';

  @override
  String get onboarding0Body =>
      '这是一款私密的戒瘾与习惯追踪应用，用树木代表你的成长。你保持戒断或打卡的时间越长，你的树就越茁壮繁茂。';

  @override
  String get onboarding1Title => '种一棵树';

  @override
  String get onboarding1Body =>
      '点击「种一棵树」创建习惯。给它起个名字，选择颜色，Grove 会为它生成一棵独特的树。每棵树的生长方式各不相同。';

  @override
  String get onboarding2Title => '看它成长';

  @override
  String get onboarding2Body => '每一天都帮助你的树经历五个生长阶段，从一粒小小的种子，成长为随风摇曳、枝繁叶茂的大树。';

  @override
  String get onboarding3Title => '记录复发';

  @override
  String get onboarding3Body =>
      '如果你失败了，诚实地记录下来。Grove 会追踪你最长的连续记录和历史，你的进步永远不会被抹去。';

  @override
  String get onboarding4Title => '你的历史';

  @override
  String get onboarding4Body => '打开任何一棵树，探索日历、里程碑、连续记录历史、复发笔记，以及你长期坚持的洞见。';

  @override
  String get onboarding5Title => '完全私密';

  @override
  String get onboarding5Body =>
      '所有内容都保存在你的设备上。任何内容都不会被发送到任何地方。随时通过设置中的导出/导入备份或迁移你的树林。现在去种植值得珍藏的东西吧。🌱';

  @override
  String get next => '下一步';

  @override
  String get back => '返回';

  @override
  String get startGrowing => '开始成长 🌱';

  @override
  String get groveIsBare => '你的树林还是空的。';

  @override
  String get plantFirstTree => '种下第一棵树，开始你的旅程。';

  @override
  String get settingsHub => '设置';

  @override
  String get layoutArchitecture => '布局方式';

  @override
  String get renderThemes => '主题';

  @override
  String get privacyNotifications => '隐私与通知';

  @override
  String get dataManagement => '数据管理';

  @override
  String get reorderGrove => '重新排序';

  @override
  String get holdDragToReorder => '长按并拖动 ≡ 进行排序';

  @override
  String get layoutWheel => '滚轮';

  @override
  String get layoutCarousel => '轮播';

  @override
  String get layoutGrid => '网格';

  @override
  String get layoutList => '列表';

  @override
  String get themeForestDark => '森林暗色';

  @override
  String get themeAmoledBlack => 'AMOLED 纯黑';

  @override
  String get themeMaterialYou => 'Material You';

  @override
  String get themeWhiteMinimal => '简约白色';

  @override
  String get milestoneNotifications => '里程碑通知';

  @override
  String get milestoneNotificationsSubtitle => '当树木达到新的生长阶段时获得通知';

  @override
  String get biometricUnlock => '生物识别解锁';

  @override
  String get biometricUnlockSubtitle => '需要指纹/PIN 才能打开 Grove';

  @override
  String get exportGroveBackup => '导出备份';

  @override
  String get restoreGroveBackup => '从备份恢复树林';

  @override
  String get exportImportNote =>
      '导出会将 .json 文件保存到你选择的位置。\n导入将替换当前的树林 • 请先导出备份。';

  @override
  String get backupSaved => '✓ 备份已保存';

  @override
  String saveFailed(String error) {
    return '保存失败：$error';
  }

  @override
  String get couldNotReadFile => '无法读取所选文件。';

  @override
  String groveRestored(int count) {
    return '✓ 树林已恢复 — 已加载 $count 棵树';
  }

  @override
  String get invalidBackup => '✗ 无效备份 — 请确保选择了正确的文件';

  @override
  String get language => '语言';

  @override
  String get languageLabel => '语言';

  @override
  String get links => '链接';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => '源代码与贡献';

  @override
  String get buyMeCoffee => '请我喝杯咖啡';

  @override
  String get buyMeCoffeeSubtitle => '支持开发';

  @override
  String get madeWith => '用 🌿 制作 • 所有数据保存在你的设备上。';

  @override
  String get openSource => '开源';

  @override
  String versionLabel(String version) {
    return 'v$version • 开源';
  }

  @override
  String get groveDescription =>
      'Grove 是一款简约的习惯与戒瘾追踪应用，通过树木将你的成长可视化。每一天你保持戒断或打卡，你的树就会成长。作为一款免费开源工具，用心制作。';

  @override
  String get groveLocked => 'Grove 已锁定';

  @override
  String get authenticateToContinue => '验证身份以继续';

  @override
  String get unlockGrove => '解锁 Grove';

  @override
  String get currentStreak => '当前连续';

  @override
  String get peakRecord => '最高记录';

  @override
  String get relapses => '复发次数';

  @override
  String get checkIns => '打卡次数';

  @override
  String get interactiveMonthlyLogs => '月度互动日志';

  @override
  String get swipeForEarlierMonths => '向左滑动查看更早的月份';

  @override
  String get thisMonth => '本月';

  @override
  String get logDateBeforeTracking => '← 记录追踪开始之前的日期';

  @override
  String get abstinentSinceStart => '尚无复发记录。';

  @override
  String get timeSinceLastRelapse => '距上次复发的时间';

  @override
  String get days => '天';

  @override
  String get hrs => '时';

  @override
  String get min => '分';

  @override
  String get sec => '秒';

  @override
  String get checkedInToday => '今日已打卡';

  @override
  String get notCheckedInToday => '今日未打卡';

  @override
  String get streak => '连续';

  @override
  String get total => '总计';

  @override
  String get alreadyCheckedIn => '已打卡';

  @override
  String get checkInToday => '今日打卡';

  @override
  String get relapseSweepTimeline => '复发时间线';

  @override
  String get checkInHistory => '打卡历史';

  @override
  String totalCount(int count) {
    return '共 $count 次';
  }

  @override
  String get noRelapsesRecorded => '没有记录复发。继续成长。';

  @override
  String get noCheckInsYet => '还没有打卡记录。今天开始！';

  @override
  String get renameHabit => '重命名习惯';

  @override
  String get habitOptions => '习惯选项';

  @override
  String get save => '保存';

  @override
  String get dangerZone => '危险区域';

  @override
  String get deleteHabitPermanently => '永久删除习惯';

  @override
  String get deleteHabit => '删除习惯？';

  @override
  String deleteHabitConfirm(String name) {
    return '这将永久删除「$name」及其所有历史记录。此操作无法撤销。';
  }

  @override
  String get delete => '删除';

  @override
  String get earlierThanLogs => '早于你的记录？';

  @override
  String trackingStarted(String date) {
    return '追踪于 $date 开始。\n如果在此之前发生了什么，你可以在此记录。';
  }

  @override
  String get logEarlierDate => '记录更早的日期';

  @override
  String get extendsHistoryNote => '这将扩展你的历史并重新计算连续记录';

  @override
  String get logEarlierDateTitle => '记录更早的日期';

  @override
  String get beforeTrackingStarted => '追踪开始之前';

  @override
  String get extendHistoryInfo => '这将扩展你的追踪历史，并重新计算你的最高连续记录。';

  @override
  String get date => '日期';

  @override
  String get time => '时间';

  @override
  String get logAsRelapseOnDate => '记录为该日期的复发';

  @override
  String get onlyExtendStartDate => '仅延伸开始日期（不记录复发）';

  @override
  String get whatHappenedHint => '那天发生了什么……';

  @override
  String peakSweep(int days) {
    return '最高连续：$days 天';
  }

  @override
  String get noReasonRecorded => '未记录原因。';

  @override
  String notifSproutTitle(String name) {
    return '$name 正在发芽！🌱';
  }

  @override
  String get notifSproutBody => '你的树的根已经形成。继续成长。';

  @override
  String notifSaplingTitle(String name) {
    return '$name 现在是幼苗了！🌿';
  }

  @override
  String get notifSaplingBody => '你的树已经可以独立生长，看看你成长了多少';

  @override
  String notifYoungTreeTitle(String name) {
    return '$name 正在茁壮成长！🌳';
  }

  @override
  String get notifYoungTreeBody => '你的树冠开始成形，太棒了。';

  @override
  String notifGroveTreeTitle(String name) {
    return '$name 成为了大树！🌲';
  }

  @override
  String get notifGroveTreeBody => '恭喜！！！你已经成为了森林。';

  @override
  String get saveGroveBackupDialog => '保存备份';

  @override
  String get selectGroveBackupDialog => '选择备份';

  @override
  String get customAccentColor => '自定义强调色';

  @override
  String get customAccentDefault => '默认绿色';

  @override
  String get customAccentSubtitle => '应用于按钮、卡片和徽章';

  @override
  String get applyAccent => '应用强调色';

  @override
  String get resetAccentDefault => '重置为默认';

  @override
  String get dailyReminderSetting => '每日签到提醒';

  @override
  String get dailyReminderSettingSubtitle => '提醒你在树林中打卡';

  @override
  String get tapToChange => '点击更改';

  @override
  String get languageSection => '语言';

  @override
  String get dailyReminderTitle => '该打卡了 🌿';

  @override
  String get dailyReminderBody => '你的树林在等你！保持连续记录。';

  @override
  String get legendMissed => '错过';

  @override
  String get legendAbstained => '已戒断';

  @override
  String get legendCheckIn => '签到';

  @override
  String get legendRelapse => '复发';

  @override
  String get legendExcused => '已豁免';

  @override
  String get relapseLoggedThisDay => '⚠️ 这一天记录了复发。';

  @override
  String get cleanRecord => '🌿 记录清白。';

  @override
  String get timeOverride => '覆盖时间';

  @override
  String anchorTime(String time) {
    return '锚定时间：$time';
  }

  @override
  String checkInTimeLabel(String time) {
    return '签到时间：$time';
  }

  @override
  String get editReason => '编辑原因';

  @override
  String get reasonOptional => '原因（可选）';

  @override
  String get reasonHint => '压力、焦虑、倦怠、同辈压力、触发因素？等等……';

  @override
  String get excusedStreakPreserved => '❄️ 已豁免，你的连续记录得以保留。';

  @override
  String get checkedInThisDay => '✅ 这一天已签到。';

  @override
  String get noCheckInRecorded => '🌿 未记录签到。';

  @override
  String get saveNewTime => '保存新时间';

  @override
  String get excuseThisDayInstead => '改为豁免这一天';

  @override
  String get checkInInstead => '改为签到';

  @override
  String get removeExcuse => '移除豁免';

  @override
  String get updateLog => '更新记录';

  @override
  String get removeRelapseBtn => '移除复发';

  @override
  String get addRelapseHere => '在此添加复发';

  @override
  String get removeCheckIn => '移除签到';

  @override
  String get checkInThisDay => '签到此日';

  @override
  String get editNote => '编辑备注';

  @override
  String get noteOptional => '备注（可选）';

  @override
  String get noteHint => '今天过得怎么样？有什么值得记住的小胜利或备注……';

  @override
  String get streakFrozen => '连续记录已冻结';

  @override
  String get freezeStreak => '冻结连续记录';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'Grove';

  @override
  String get appTagline => 'G R O V E';

  @override
  String get plantATree => '種一棵樹';

  @override
  String get plantTree => '種下樹木';

  @override
  String get plantANewTree => '種一棵新樹';

  @override
  String get habitName => '習慣名稱';

  @override
  String get habitNameHint => '例如：酒精、抽菸、社群媒體';

  @override
  String get trackingMode => '追蹤模式';

  @override
  String get presetColors => '預設顏色';

  @override
  String get customHexCode => '自訂顏色代碼';

  @override
  String get hexCode => '顏色代碼';

  @override
  String get invalidHex => '無效的顏色代碼';

  @override
  String get abstain => '戒除';

  @override
  String get abstainSubtitle1 => '每天自動生長';

  @override
  String get abstainSubtitle2 => '點擊記錄復發';

  @override
  String get checkIn => '打卡';

  @override
  String get checkInSubtitle1 => '每日打卡以促進生長';

  @override
  String get checkInSubtitle2 => '根據打卡次數生長';

  @override
  String get history => '歷史';

  @override
  String daysSuffix(Object days) {
    return '$days天';
  }

  @override
  String historyCount(Object count) {
    return '歷史記錄 ($count)';
  }

  @override
  String get relapse => '復發';

  @override
  String get checkedIn => '已打卡';

  @override
  String get checkInAction => '打卡';

  @override
  String dayStreak(int days) {
    return '$days天連續';
  }

  @override
  String dayCount(int days) {
    return '第$days天';
  }

  @override
  String get alreadyCheckedInToday => '今日已打卡 ✓';

  @override
  String get tapBelowToCheckIn => '點擊下方打卡';

  @override
  String get giveHabitName => '請為你的習慣命名。';

  @override
  String get stageSeed => '種子';

  @override
  String get stageSprout => '嫩芽';

  @override
  String get stageSapling => '幼苗';

  @override
  String get stageYoungTree => '小樹';

  @override
  String get stageGroveTree => '大樹';

  @override
  String get taglineSeed => '每片偉大的森林都從這裡開始。';

  @override
  String get taglineSprout => '根系正在地下形成。';

  @override
  String get taglineSapling => '每一個清晨都讓你更加茁壯。';

  @override
  String get taglineYoungTree => '你的樹冠正在成形。';

  @override
  String get taglineGroveTree => '你已經成為了森林。';

  @override
  String get logARelapse => '記錄復發？';

  @override
  String get relapseMotivation => '你比你想像的更堅強。';

  @override
  String get customTimestamp => '自訂時間戳記';

  @override
  String get loggedReason => '記錄原因（可選）';

  @override
  String get loggedReasonHint => '壓力、焦慮、倦怠、同儕壓力、觸發因素等……';

  @override
  String get confirmLog => '確認記錄';

  @override
  String get cancel => '取消';

  @override
  String get onboarding0Title => '歡迎使用 Grove 🌿';

  @override
  String get onboarding0Body =>
      '這是一款私密的戒癮與習慣追蹤應用程式，用樹木代表你的成長。你保持戒斷或打卡的時間越長，你的樹就越茁壯繁茂。';

  @override
  String get onboarding1Title => '種一棵樹';

  @override
  String get onboarding1Body =>
      '點擊「種一棵樹」建立習慣。給它取個名字，選擇顏色，Grove 會為它生成一棵獨特的樹。每棵樹的生長方式各不相同。';

  @override
  String get onboarding2Title => '看它成長';

  @override
  String get onboarding2Body => '每一天都幫助你的樹歷經五個生長階段，從一粒小小的種子，成長為隨風搖曳、枝繁葉茂的大樹。';

  @override
  String get onboarding3Title => '記錄復發';

  @override
  String get onboarding3Body =>
      '如果你失敗了，誠實地記錄下來。Grove 會追蹤你最長的連續記錄和歷史，你的進步永遠不會被抹去。';

  @override
  String get onboarding4Title => '你的歷史';

  @override
  String get onboarding4Body => '開啟任何一棵樹，探索日曆、里程碑、連續記錄歷史、復發筆記，以及你長期堅持的洞見。';

  @override
  String get onboarding5Title => '完全私密';

  @override
  String get onboarding5Body =>
      '所有內容都儲存在你的裝置上。任何內容都不會被傳送到任何地方。隨時透過設定中的匯出/匯入備份或遷移你的樹林。現在去種植值得珍藏的東西吧。🌱';

  @override
  String get next => '下一步';

  @override
  String get back => '返回';

  @override
  String get startGrowing => '開始成長 🌱';

  @override
  String get groveIsBare => '你的樹林還是空的。';

  @override
  String get plantFirstTree => '種下第一棵樹，開始你的旅程。';

  @override
  String get settingsHub => '設定';

  @override
  String get layoutArchitecture => '版面配置';

  @override
  String get renderThemes => '主題';

  @override
  String get privacyNotifications => '隱私與通知';

  @override
  String get dataManagement => '資料管理';

  @override
  String get reorderGrove => '重新排序';

  @override
  String get holdDragToReorder => '長按並拖曳 ≡ 進行排序';

  @override
  String get layoutWheel => '滾輪';

  @override
  String get layoutCarousel => '輪播';

  @override
  String get layoutGrid => '格狀';

  @override
  String get layoutList => '清單';

  @override
  String get themeForestDark => '森林暗色';

  @override
  String get themeAmoledBlack => 'AMOLED 純黑';

  @override
  String get themeMaterialYou => 'Material You';

  @override
  String get themeWhiteMinimal => '簡約白色';

  @override
  String get milestoneNotifications => '里程碑通知';

  @override
  String get milestoneNotificationsSubtitle => '當樹木達到新的生長階段時獲得通知';

  @override
  String get biometricUnlock => '生物識別解鎖';

  @override
  String get biometricUnlockSubtitle => '需要指紋/PIN 才能開啟 Grove';

  @override
  String get exportGroveBackup => '匯出備份';

  @override
  String get restoreGroveBackup => '從備份還原樹林';

  @override
  String get exportImportNote =>
      '匯出會將 .json 檔案儲存到你選擇的位置。\n匯入將取代目前的樹林 • 請先匯出備份。';

  @override
  String get backupSaved => '✓ 備份已儲存';

  @override
  String saveFailed(String error) {
    return '儲存失敗：$error';
  }

  @override
  String get couldNotReadFile => '無法讀取所選檔案。';

  @override
  String groveRestored(int count) {
    return '✓ 樹林已還原 — 已載入 $count 棵樹';
  }

  @override
  String get invalidBackup => '✗ 無效備份 — 請確認選擇了正確的檔案';

  @override
  String get language => '語言';

  @override
  String get languageLabel => '語言';

  @override
  String get links => '連結';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => '原始碼與貢獻';

  @override
  String get buyMeCoffee => '請我喝杯咖啡';

  @override
  String get buyMeCoffeeSubtitle => '支持開發';

  @override
  String get madeWith => '用 🌿 製作 • 所有資料保存在你的裝置上。';

  @override
  String get openSource => '開源';

  @override
  String versionLabel(String version) {
    return 'v$version • 開源';
  }

  @override
  String get groveDescription =>
      'Grove 是一款簡約的習慣與戒癮追蹤應用程式，透過樹木將你的成長視覺化。每一天你保持戒斷或打卡，你的樹就會成長。作為一款免費開源工具，用心製作。';

  @override
  String get groveLocked => 'Grove 已鎖定';

  @override
  String get authenticateToContinue => '驗證身份以繼續';

  @override
  String get unlockGrove => '解鎖 Grove';

  @override
  String get currentStreak => '當前連續';

  @override
  String get peakRecord => '最高記錄';

  @override
  String get relapses => '復發次數';

  @override
  String get checkIns => '打卡次數';

  @override
  String get interactiveMonthlyLogs => '月度互動日誌';

  @override
  String get swipeForEarlierMonths => '向左滑動查看更早的月份';

  @override
  String get thisMonth => '本月';

  @override
  String get logDateBeforeTracking => '← 記錄追蹤開始之前的日期';

  @override
  String get abstinentSinceStart => '尚無復發記錄。';

  @override
  String get timeSinceLastRelapse => '距上次復發的時間';

  @override
  String get days => '天';

  @override
  String get hrs => '時';

  @override
  String get min => '分';

  @override
  String get sec => '秒';

  @override
  String get checkedInToday => '今日已打卡';

  @override
  String get notCheckedInToday => '今日未打卡';

  @override
  String get streak => '連續';

  @override
  String get total => '總計';

  @override
  String get alreadyCheckedIn => '已打卡';

  @override
  String get checkInToday => '今日打卡';

  @override
  String get relapseSweepTimeline => '復發時間線';

  @override
  String get checkInHistory => '打卡歷史';

  @override
  String totalCount(int count) {
    return '共 $count 次';
  }

  @override
  String get noRelapsesRecorded => '沒有記錄復發。繼續成長。';

  @override
  String get noCheckInsYet => '還沒有打卡記錄。今天開始！';

  @override
  String get renameHabit => '重新命名習慣';

  @override
  String get habitOptions => '習慣選項';

  @override
  String get save => '儲存';

  @override
  String get dangerZone => '危險區域';

  @override
  String get deleteHabitPermanently => '永久刪除習慣';

  @override
  String get deleteHabit => '刪除習慣？';

  @override
  String deleteHabitConfirm(String name) {
    return '這將永久刪除「$name」及其所有歷史記錄。此操作無法撤銷。';
  }

  @override
  String get delete => '刪除';

  @override
  String get earlierThanLogs => '早於你的記錄？';

  @override
  String trackingStarted(String date) {
    return '追蹤於 $date 開始。\n如果在此之前發生了什麼，你可以在此記錄。';
  }

  @override
  String get logEarlierDate => '記錄更早的日期';

  @override
  String get extendsHistoryNote => '這將擴展你的歷史並重新計算連續記錄';

  @override
  String get logEarlierDateTitle => '記錄更早的日期';

  @override
  String get beforeTrackingStarted => '追蹤開始之前';

  @override
  String get extendHistoryInfo => '這將擴展你的追蹤歷史，並重新計算你的最高連續記錄。';

  @override
  String get date => '日期';

  @override
  String get time => '時間';

  @override
  String get logAsRelapseOnDate => '記錄為該日期的復發';

  @override
  String get onlyExtendStartDate => '僅延伸開始日期（不記錄復發）';

  @override
  String get whatHappenedHint => '那天發生了什麼……';

  @override
  String peakSweep(int days) {
    return '最高連續：$days 天';
  }

  @override
  String get noReasonRecorded => '未記錄原因。';

  @override
  String notifSproutTitle(String name) {
    return '$name 正在發芽！🌱';
  }

  @override
  String get notifSproutBody => '你的樹的根已經形成。繼續成長。';

  @override
  String notifSaplingTitle(String name) {
    return '$name 現在是幼苗了！🌿';
  }

  @override
  String get notifSaplingBody => '你的樹已經可以獨立生長，看看你成長了多少';

  @override
  String notifYoungTreeTitle(String name) {
    return '$name 正在茁壯成長！🌳';
  }

  @override
  String get notifYoungTreeBody => '你的樹冠開始成形，太棒了。';

  @override
  String notifGroveTreeTitle(String name) {
    return '$name 成為了大樹！🌲';
  }

  @override
  String get notifGroveTreeBody => '恭喜！！！你已經成為了森林。';

  @override
  String get saveGroveBackupDialog => '儲存備份';

  @override
  String get selectGroveBackupDialog => '選擇備份';

  @override
  String get customAccentColor => '自訂強調色';

  @override
  String get customAccentDefault => '預設綠色';

  @override
  String get customAccentSubtitle => '套用於按鈕、卡片和徽章';

  @override
  String get applyAccent => '套用強調色';

  @override
  String get resetAccentDefault => '重設為預設值';

  @override
  String get dailyReminderSetting => '每日簽到提醒';

  @override
  String get dailyReminderSettingSubtitle => '提醒你在樹林中打卡';

  @override
  String get tapToChange => '點擊更改';

  @override
  String get languageSection => '語言';

  @override
  String get dailyReminderTitle => '該打卡了 🌿';

  @override
  String get dailyReminderBody => '你的樹林在等你！保持連續記錄。';

  @override
  String get legendMissed => '錯過';

  @override
  String get legendAbstained => '已戒斷';

  @override
  String get legendCheckIn => '簽到';

  @override
  String get legendRelapse => '復發';

  @override
  String get legendExcused => '已豁免';

  @override
  String get relapseLoggedThisDay => '⚠️ 這一天記錄了復發。';

  @override
  String get cleanRecord => '🌿 記錄清白。';

  @override
  String get timeOverride => '覆蓋時間';

  @override
  String anchorTime(String time) {
    return '錨定時間：$time';
  }

  @override
  String checkInTimeLabel(String time) {
    return '簽到時間：$time';
  }

  @override
  String get editReason => '編輯原因';

  @override
  String get reasonOptional => '原因（可選）';

  @override
  String get reasonHint => '壓力、焦慮、倦怠、同儕壓力、觸發因素？等等……';

  @override
  String get excusedStreakPreserved => '❄️ 已豁免，你的連續記錄得以保留。';

  @override
  String get checkedInThisDay => '✅ 這一天已簽到。';

  @override
  String get noCheckInRecorded => '🌿 未記錄簽到。';

  @override
  String get saveNewTime => '儲存新時間';

  @override
  String get excuseThisDayInstead => '改為豁免這一天';

  @override
  String get checkInInstead => '改為簽到';

  @override
  String get removeExcuse => '移除豁免';

  @override
  String get updateLog => '更新記錄';

  @override
  String get removeRelapseBtn => '移除復發';

  @override
  String get addRelapseHere => '在此新增復發';

  @override
  String get removeCheckIn => '移除簽到';

  @override
  String get checkInThisDay => '簽到此日';

  @override
  String get editNote => '編輯備註';

  @override
  String get noteOptional => '備註（可選）';

  @override
  String get noteHint => '今天過得怎麼樣？有什麼值得記住的小勝利或備註……';

  @override
  String get streakFrozen => '連續記錄已凍結';

  @override
  String get freezeStreak => '凍結連續記錄';
}
