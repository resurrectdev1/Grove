// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Grove';

  @override
  String get appTagline => 'G R O V E';

  @override
  String get plantATree => '木を植える';

  @override
  String get plantTree => '木を植える';

  @override
  String get plantANewTree => '新しい木を植える';

  @override
  String get habitName => '習慣名';

  @override
  String get habitNameHint => '例：アルコール、喫煙、SNS';

  @override
  String get trackingMode => 'トラッキングモード';

  @override
  String get presetColors => 'プリセットカラー';

  @override
  String get customHexCode => 'カスタムHEXコード';

  @override
  String get hexCode => 'HEXコード';

  @override
  String get invalidHex => '無効なHEXコード';

  @override
  String get abstain => '節制';

  @override
  String get abstainSubtitle1 => '毎日自動的に成長';

  @override
  String get abstainSubtitle2 => '再発を記録するにはタップ';

  @override
  String get checkIn => 'チェックイン';

  @override
  String get checkInSubtitle1 => '毎日チェックインして成長';

  @override
  String get checkInSubtitle2 => 'チェックインに基づく成長';

  @override
  String get history => '履歴';

  @override
  String daysSuffix(Object days) {
    return '$days日';
  }

  @override
  String historyCount(Object count) {
    return '履歴（$count）';
  }

  @override
  String get relapse => '再発';

  @override
  String get checkedIn => 'チェックイン済み';

  @override
  String get checkInAction => 'チェックイン';

  @override
  String dayStreak(int days) {
    return '$days日連続';
  }

  @override
  String dayCount(int days) {
    return '$days日目';
  }

  @override
  String get alreadyCheckedInToday => '本日チェックイン済み ✓';

  @override
  String get tapBelowToCheckIn => 'チェックインするには下をタップ';

  @override
  String get giveHabitName => '習慣に名前をつけてください。';

  @override
  String get stageSeed => '種';

  @override
  String get stageSprout => '芽';

  @override
  String get stageSapling => '苗木';

  @override
  String get stageYoungTree => '若木';

  @override
  String get stageGroveTree => '森の木';

  @override
  String get taglineSeed => 'すべての大きな森はここから始まる。';

  @override
  String get taglineSprout => '根が地表の下で形成されています。';

  @override
  String get taglineSapling => '日の出ごとに強くなっています。';

  @override
  String get taglineYoungTree => 'あなたの樹冠が形を成しています。';

  @override
  String get taglineGroveTree => 'あなたは森になりました。';

  @override
  String get logARelapse => '再発を記録しますか？';

  @override
  String get relapseMotivation => 'あなたは思っているより強い。';

  @override
  String get customTimestamp => 'カスタムタイムスタンプ';

  @override
  String get loggedReason => '記録した理由（任意）';

  @override
  String get loggedReasonHint => 'ストレス、不安、燃え尽き症候群、仲間の圧力、きっかけ等';

  @override
  String get confirmLog => '記録を確認';

  @override
  String get cancel => 'キャンセル';

  @override
  String get onboarding0Title => 'Groveへようこそ 🌿';

  @override
  String get onboarding0Body => '木があなたの成長を表すプライベートな習慣トラッカーです。清潔でいる期間が長いほど、木は生き生きと茂っていきます。';

  @override
  String get onboarding1Title => '木を植える';

  @override
  String get onboarding1Body => '「木を植える」をタップして習慣を作りましょう。名前をつけ、色を選ぶと、Groveがその習慣だけのユニークな木を生成します。';

  @override
  String get onboarding2Title => '成長を見守る';

  @override
  String get onboarding2Body => '清潔な1日ごとに木は5つの成長段階を経て成熟します。小さな種から、揺れる枝と葉を持つ森の木へ。';

  @override
  String get onboarding3Title => '再発を記録する';

  @override
  String get onboarding3Body => 'もし失敗しても、正直に記録してください。Groveはあなたの最長連続記録と履歴を追跡し、進捗は消えません。';

  @override
  String get onboarding4Title => 'あなたの履歴';

  @override
  String get onboarding4Body => '任意の木を開いてカレンダー、マイルストーン、連続記録の履歴、長期的な一貫性の洞察を探りましょう。';

  @override
  String get onboarding5Title => '完全にプライベート';

  @override
  String get onboarding5Body => 'すべてあなたのデバイスに保存されます。どこにも送信されません。設定のExport / Importでいつでもバックアップできます。さあ、育てよう！ 🌱';

  @override
  String get next => '次へ';

  @override
  String get back => '戻る';

  @override
  String get startGrowing => '育て始める 🌱';

  @override
  String get groveIsBare => 'あなたの森は空っぽです。';

  @override
  String get plantFirstTree => '最初の木を植えて始めましょう。';

  @override
  String get settingsHub => '設定';

  @override
  String get layoutArchitecture => 'レイアウト';

  @override
  String get renderThemes => 'テーマ';

  @override
  String get privacyNotifications => 'プライバシーと通知';

  @override
  String get dataManagement => 'データ管理';

  @override
  String get reorderGrove => '順序変更';

  @override
  String get holdDragToReorder => '≡を長押しして並び替え';

  @override
  String get layoutWheel => 'ホイール';

  @override
  String get layoutCarousel => 'カルーセル';

  @override
  String get layoutGrid => 'グリッド';

  @override
  String get layoutList => 'リスト';

  @override
  String get themeForestDark => 'フォレストダーク';

  @override
  String get themeAmoledBlack => 'AMOLEDブラック';

  @override
  String get themeMaterialYou => 'Material You';

  @override
  String get themeWhiteMinimal => 'ホワイトミニマル';

  @override
  String get milestoneNotifications => 'マイルストーン通知';

  @override
  String get milestoneNotificationsSubtitle => '木が新しい成長段階に達したら通知を受け取る';

  @override
  String get biometricUnlock => '生体認証ロック解除';

  @override
  String get biometricUnlockSubtitle => 'Groveを開くには指紋/PINが必要';

  @override
  String get exportGroveBackup => 'Groveバックアップを書き出す';

  @override
  String get restoreGroveBackup => 'バックアップからGroveを復元';

  @override
  String get exportImportNote => '書き出しは.jsonファイルを選択した場所に保存します。\n読み込みは現在のgroveを置き換えます • 先にバックアップを。';

  @override
  String get backupSaved => '✓ バックアップを保存しました';

  @override
  String saveFailed(String error) {
    return '保存に失敗: $error';
  }

  @override
  String get couldNotReadFile => '選択したファイルを読み込めませんでした。';

  @override
  String groveRestored(int count) {
    return '✓ Grove復元完了 — $count本の木を読み込みました';
  }

  @override
  String get invalidBackup => '✗ 無効なバックアップ — 正しいファイルを選択しているか確認してください';

  @override
  String get language => '言語';

  @override
  String get languageLabel => '言語';

  @override
  String get links => 'リンク';

  @override
  String get github => 'GitHub';

  @override
  String get githubSubtitle => 'ソースコードと貢献';

  @override
  String get buyMeCoffee => 'コーヒーをおごって';

  @override
  String get buyMeCoffeeSubtitle => '開発をサポート';

  @override
  String get madeWith => '🌿 で作られました • すべてのデータはデバイスに保存されます。';

  @override
  String get openSource => 'オープンソース';

  @override
  String versionLabel(String version) {
    return 'v$version • オープンソース';
  }

  @override
  String get groveDescription => 'Groveは木を通してあなたの成長を視覚化するミニマリストの習慣トラッカーです。清潔な毎日、木が育ちます。無料・オープンソース。';

  @override
  String get groveLocked => 'Groveはロックされています';

  @override
  String get authenticateToContinue => '続けるには認証してください';

  @override
  String get unlockGrove => 'Groveのロックを解除';

  @override
  String get currentStreak => '現在の連続記録';

  @override
  String get peakRecord => '最高記録';

  @override
  String get relapses => '再発';

  @override
  String get checkIns => 'チェックイン';

  @override
  String get interactiveMonthlyLogs => '月次ログ';

  @override
  String get swipeForEarlierMonths => '← スワイプで前の月へ';

  @override
  String get thisMonth => '今月';

  @override
  String get logDateBeforeTracking => '← トラッキング開始前の日付を記録';

  @override
  String get cleanSinceStart => '開始からクリーン';

  @override
  String get timeSinceLastRelapse => '最後の再発からの時間';

  @override
  String get days => '日';

  @override
  String get hrs => '時間';

  @override
  String get min => '分';

  @override
  String get sec => '秒';

  @override
  String get checkedInToday => '本日チェックイン済み';

  @override
  String get notCheckedInToday => '本日未チェックイン';

  @override
  String get streak => '連続';

  @override
  String get total => '合計';

  @override
  String get alreadyCheckedIn => 'チェックイン済み';

  @override
  String get checkInToday => '今日チェックイン';

  @override
  String get relapseSweepTimeline => '再発タイムライン';

  @override
  String get checkInHistory => 'チェックイン履歴';

  @override
  String totalCount(int count) {
    return '合計$count件';
  }

  @override
  String get noRelapsesRecorded => '再発記録なし。成長し続けましょう。';

  @override
  String get noCheckInsYet => 'まだチェックインなし。今日から始めよう！';

  @override
  String get renameHabit => '習慣名を変更';

  @override
  String get save => '保存';

  @override
  String get dangerZone => '危険ゾーン';

  @override
  String get deleteHabitPermanently => '習慣を完全に削除';

  @override
  String get deleteHabit => '習慣を削除しますか？';

  @override
  String deleteHabitConfirm(String name) {
    return '「$name」とすべての履歴を完全に削除します。この操作は取り消せません。';
  }

  @override
  String get delete => '削除';

  @override
  String get earlierThanLogs => '記録より前の日付ですか？';

  @override
  String trackingStarted(String date) {
    return 'トラッキング開始日: $date。\nそれ以前に何かあった場合、ここに記録できます。';
  }

  @override
  String get logEarlierDate => '以前の日付を記録';

  @override
  String get extendsHistoryNote => 'これにより履歴が延長され、連続記録が再計算されます';

  @override
  String get logEarlierDateTitle => '以前の日付を記録';

  @override
  String get beforeTrackingStarted => 'トラッキング開始前';

  @override
  String get extendHistoryInfo => 'トラッキング履歴が延長され、最高連続記録が再計算されます。';

  @override
  String get date => '日付';

  @override
  String get time => '時刻';

  @override
  String get logAsRelapseOnDate => 'この日付を再発として記録';

  @override
  String get onlyExtendStartDate => '開始日のみ延長（再発なし）';

  @override
  String get whatHappenedHint => 'その日に何が起きたか…';

  @override
  String peakSweep(int days) {
    return '最高連続: $days日';
  }

  @override
  String get noReasonRecorded => '理由の記録なし。';

  @override
  String notifSproutTitle(String name) {
    return '$nameが芽吹いています！ 🌱';
  }

  @override
  String get notifSproutBody => '木の根が形成されました。成長し続けましょう。';

  @override
  String notifSaplingTitle(String name) {
    return '$nameが苗木になりました！ 🌿';
  }

  @override
  String get notifSaplingBody => '木が自立しています。どれだけ成長したか見てください';

  @override
  String notifYoungTreeTitle(String name) {
    return '$nameがすくすく育っています！ 🌳';
  }

  @override
  String get notifYoungTreeBody => '樹冠が形を成し始めています。素晴らしい。';

  @override
  String notifGroveTreeTitle(String name) {
    return '$nameが森の木になりました！ 🌲';
  }

  @override
  String get notifGroveTreeBody => 'おめでとうございます！！！あなたは森になりました。';

  @override
  String get saveGroveBackupDialog => 'Groveバックアップを保存';

  @override
  String get selectGroveBackupDialog => 'Groveバックアップを選択';

  @override
  String get customAccentColor => 'カスタムアクセントカラー';

  @override
  String get customAccentDefault => 'デフォルトグリーン';

  @override
  String get customAccentSubtitle => 'ボタン、カード、バッジに適用';

  @override
  String get applyAccent => 'アクセントを適用';

  @override
  String get resetAccentDefault => 'デフォルトにリセット';

  @override
  String get dailyReminderSetting => '毎日のチェックインリマインダー';

  @override
  String get dailyReminderSettingSubtitle => '連続記録を維持するための通知';

  @override
  String get tapToChange => 'タップして変更';

  @override
  String get languageSection => '言語';

  @override
  String get dailyReminderTitle => 'チェックインの時間です 🌿';

  @override
  String get dailyReminderBody => 'あなたの森が待っています。連続記録を守りましょう。';
}
