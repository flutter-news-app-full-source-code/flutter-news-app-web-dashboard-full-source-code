// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get authenticationPageHeadline => 'ダッシュボードへのアクセス';

  @override
  String get authenticationPageSubheadline => '管理者およびパブリッシャー向けの安全なサインイン。';

  @override
  String get authenticationEmailSignInButton => 'メールでサインイン';

  @override
  String get emailSignInPageTitle => '安全なメールサインイン';

  @override
  String get requestCodePageHeadline => '安全なメールサインイン';

  @override
  String get requestCodePageSubheadline =>
      '安全なサインインコードを受け取るために、承認されたメールアドレスを入力してください。';

  @override
  String get requestCodeEmailLabel => 'メールアドレス';

  @override
  String get requestCodeEmailHint => 'your.email@example.com';

  @override
  String get accountLinkingEmailValidationError => '有効なメールアドレスを入力してください。';

  @override
  String get requestCodeSendCodeButton => 'コードを送信';

  @override
  String requestCodeResendButtonCooldown(int seconds) {
    return '$seconds秒後に再送信';
  }

  @override
  String get emailCodeSentPageTitle => 'コードの確認';

  @override
  String emailCodeSentConfirmation(String email) {
    return '$emailに6桁のコードを送信しました';
  }

  @override
  String get emailCodeSentInstructions => '受信トレイを確認し、以下のコードを入力して続行してください。';

  @override
  String demoVerificationCodeMessage(String code) {
    return 'デモモードでは、コード「$code」を使用してください';
  }

  @override
  String get emailCodeVerificationHint => '6桁のコード';

  @override
  String get emailCodeValidationEmptyError => 'コードを入力してください。';

  @override
  String get emailCodeValidationLengthError => 'コードは6桁である必要があります。';

  @override
  String get emailCodeVerificationButtonLabel => 'コードを確認';

  @override
  String get overview => '概要';

  @override
  String get contentManagement => 'コンテンツ管理';

  @override
  String get contentManagementPageDescription =>
      'モバイルアプリケーションのニュース見出し、トピック、ソースを管理します。';

  @override
  String get headlines => '見出し';

  @override
  String get headline => '見出し';

  @override
  String get topics => 'トピック';

  @override
  String get topic => 'トピック';

  @override
  String get sources => 'ソース';

  @override
  String get source => 'ソース';

  @override
  String get appConfiguration => 'リモート設定';

  @override
  String get appConfigurationPageDescription =>
      'コンテンツ制限から運用ステータスまで、モバイルアプリのグローバル設定を管理します。';

  @override
  String get settings => '設定';

  @override
  String get appConfigurationPageTitle => 'リモート設定';

  @override
  String get feedTab => 'フィード';

  @override
  String get advertisementsTab => '広告';

  @override
  String get systemTab => 'システム';

  @override
  String get userContentLimitsTitle => 'ユーザーコンテンツ制限';

  @override
  String get userContentLimitsDescription =>
      'ユーザー層ごとに、フォローするアイテムと保存する見出しの制限を設定します。';

  @override
  String get feedActionsTitle => 'フィードアクション';

  @override
  String get feedActionsDescription =>
      'フィードにアクションウィジェット（例：「アプリを評価」）を挿入する頻度を設定します。';

  @override
  String get feedDecoratorsTitle => 'フィードデコレーター';

  @override
  String get feedDecoratorsDescription =>
      'ユーザーロールごとに、フィード内でのコンテンツの装飾と表示方法を設定します。';

  @override
  String get adSettingsTitle => '広告設定';

  @override
  String get adSettingsDescription => 'ユーザーロールごとに、広告の表示頻度と配置を管理します。';

  @override
  String get maintenanceModeTitle => 'メンテナンスモード';

  @override
  String get maintenanceModeDescription => '有効にすると、すべてのユーザーにメンテナンス画面が表示されます。';

  @override
  String get forceUpdateTitle => 'アプリの強制アップデート';

  @override
  String get forceUpdateDescription => 'ユーザーに対する必須のアプリアップデートを設定します。';

  @override
  String get forceUpdateTab => '強制アップデート';

  @override
  String get appConfigSaveSuccessMessage =>
      'リモート設定が正常に保存されました。モバイルクライアントは次回の起動時に更新されます。';

  @override
  String appConfigSaveErrorMessage(String errorMessage) {
    return 'エラー: $errorMessage';
  }

  @override
  String get unknownError => '不明なエラー';

  @override
  String get loadingConfigurationHeadline => '設定を読み込み中';

  @override
  String get loadingConfigurationSubheadline => '設定を読み込んでいます。しばらくお待ちください...';

  @override
  String get failedToLoadConfigurationMessage => '設定の読み込みに失敗しました。';

  @override
  String get loadAppSettingsSubheadline => 'バックエンドからアプリケーション設定を読み込みます。';

  @override
  String get discardChangesButton => '変更を破棄';

  @override
  String get saveChangesButton => '変更を保存';

  @override
  String get confirmConfigUpdateDialogTitle => '設定更新の確認';

  @override
  String get confirmConfigUpdateDialogContent =>
      'この変更をライブアプリケーション設定に適用してもよろしいですか？これは重要な操作です。';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get confirmSaveButton => '保存を確認';

  @override
  String get guestUserTab => 'ゲスト';

  @override
  String get authenticatedUserTab => '認証済み';

  @override
  String get premiumUserTab => 'プレミアム';

  @override
  String get guestFollowedItemsLimitLabel => 'ゲストのフォローアイテム制限';

  @override
  String get guestFollowedItemsLimitDescription =>
      'ゲストユーザーがフォローできる国、ニュースソース、またはトピックの最大数（タイプごとに独自の制限があります）。';

  @override
  String get guestSavedHeadlinesLimitLabel => 'ゲストの保存見出し制限';

  @override
  String get guestSavedHeadlinesLimitDescription => 'ゲストユーザーが保存できる見出しの最大数。';

  @override
  String get standardUserFollowedItemsLimitLabel => '標準ユーザーのフォローアイテム制限';

  @override
  String get standardUserFollowedItemsLimitDescription =>
      '標準ユーザーがフォローできる国、ニュースソース、またはトピックの最大数（タイプごとに独自の制限があります）。';

  @override
  String get standardUserSavedHeadlinesLimitLabel => '標準ユーザーの保存見出し制限';

  @override
  String get standardUserSavedHeadlinesLimitDescription =>
      '標準ユーザーが保存できる見出しの最大数。';

  @override
  String get premiumFollowedItemsLimitLabel => 'プレミアムユーザーのフォローアイテム制限';

  @override
  String get premiumFollowedItemsLimitDescription =>
      'プレミアムユーザーがフォローできる国、ニュースソース、またはトピックの最大数（タイプごとに独自の制限があります）。';

  @override
  String get premiumSavedHeadlinesLimitLabel => 'プレミアムユーザーの保存見出し制限';

  @override
  String get premiumSavedHeadlinesLimitDescription => 'プレミアムユーザーが保存できる見出しの最大数。';

  @override
  String get standardUserAdTab => '標準ユーザー';

  @override
  String get guestAdFrequencyLabel => 'ゲストの広告頻度';

  @override
  String get guestAdFrequencyDescription =>
      'ゲストユーザーに対して広告が表示される頻度（例：値が5の場合、5つのニュースアイテムごとに広告が配置される可能性があります）。';

  @override
  String get guestAdPlacementIntervalLabel => 'ゲストの広告配置間隔';

  @override
  String get guestAdPlacementIntervalDescription =>
      'ゲストユーザーに対して最初の広告が表示されるまでに表示する必要があるニュースアイテムの最小数。';

  @override
  String get guestArticlesBeforeInterstitialAdsLabel =>
      'ゲストのインタースティシャル広告表示までの記事数';

  @override
  String get guestArticlesBeforeInterstitialAdsDescription =>
      '全画面インタースティシャル広告が表示されるまでに、ゲストユーザーが読む必要がある記事の数。';

  @override
  String get standardUserAdFrequencyLabel => '標準ユーザーの広告頻度';

  @override
  String get standardUserAdFrequencyDescription =>
      '標準ユーザーに対して広告が表示される頻度（例：値が10の場合、10個のニュースアイテムごとに広告が配置される可能性があります）。';

  @override
  String get standardUserAdPlacementIntervalLabel => '標準ユーザーの広告配置間隔';

  @override
  String get standardUserAdPlacementIntervalDescription =>
      '標準ユーザーに対して最初の広告が表示されるまでに表示する必要があるニュースアイテムの最小数。';

  @override
  String get standardUserArticlesBeforeInterstitialAdsLabel =>
      '標準ユーザーのインタースティシャル広告表示までの記事数';

  @override
  String get standardUserArticlesBeforeInterstitialAdsDescription =>
      '全画面インタースティシャル広告が表示されるまでに、標準ユーザーが読む必要がある記事の数。';

  @override
  String get premiumAdFrequencyLabel => 'プレミアムユーザーの広告頻度';

  @override
  String get premiumAdFrequencyDescription =>
      'プレミアムユーザーに対して広告が表示される頻度（0は広告なし）。';

  @override
  String get premiumAdPlacementIntervalLabel => 'プレミアムユーザーの広告配置間隔';

  @override
  String get premiumAdPlacementIntervalDescription =>
      'プレミアムユーザーに対して最初の広告が表示されるまでに表示する必要があるニュースアイテムの最小数。';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsLabel =>
      'プレミアムユーザーのインタースティシャル広告表示までの記事数';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsDescription =>
      '全画面インタースティシャル広告が表示されるまでに、プレミアムユーザーが読む必要がある記事の数。';

  @override
  String get appOperationalStatusWarning =>
      '警告：アプリの運用ステータスを変更すると、すべてのユーザーに影響する可能性があります。細心の注意を払って使用してください。';

  @override
  String get appOperationalStatusLabel => 'アプリの運用ステータス';

  @override
  String get appOperationalStatusDescription =>
      'アプリの現在の運用ステータス（例：アクティブ、メンテナンス、無効）。';

  @override
  String get maintenanceMessageLabel => 'メンテナンスメッセージ';

  @override
  String get maintenanceMessageDescription => 'アプリがメンテナンスモードのときに表示されるメッセージ。';

  @override
  String get disabledMessageLabel => '無効メッセージ';

  @override
  String get disabledMessageDescription => 'アプリが恒久的に無効化されたときに表示されるメッセージ。';

  @override
  String get forceUpdateConfigurationTitle => '強制アップデート設定';

  @override
  String get minAllowedAppVersionLabel => '許可される最小アプリバージョン';

  @override
  String get minAllowedAppVersionDescription =>
      '実行が許可される最小のアプリバージョン（例：「1.2.0」）。';

  @override
  String get latestAppVersionLabel => '最新のアプリバージョン';

  @override
  String get latestAppVersionDescription => '利用可能な最新のアプリバージョン（例：「1.5.0」）。';

  @override
  String get updateRequiredMessageLabel => 'アップデート必須メッセージ';

  @override
  String get updateRequiredMessageDescription => '強制アップデートが必要なときに表示されるメッセージ。';

  @override
  String get updateOptionalMessageLabel => 'アップデート任意メッセージ';

  @override
  String get updateOptionalMessageDescription => '任意のアップデートに対して表示されるメッセージ。';

  @override
  String get iosStoreUrlLabel => 'iOSストアURL';

  @override
  String get iosStoreUrlDescription => 'Apple App Store上のアプリへのURL。';

  @override
  String get androidStoreUrlLabel => 'AndroidストアURL';

  @override
  String get androidUpdateUrlDescription => 'Google Playストア上のアプリへのURL。';

  @override
  String get guestDaysBetweenInAppPromptsLabel => 'ゲストのアプリ内プロンプト表示間隔（日数）';

  @override
  String get guestDaysBetweenInAppPromptsDescription =>
      'ゲストユーザーに次のアプリ内プロンプトが表示されるまでに経過する必要がある最小日数。';

  @override
  String get standardUserDaysBetweenInAppPromptsLabel =>
      '標準ユーザーのアプリ内プロンプト表示間隔（日数）';

  @override
  String get standardUserDaysBetweenInAppPromptsDescription =>
      '標準ユーザーに次のアプリ内プロンプトが表示されるまでに経過する必要がある最小日数。';

  @override
  String get signOut => 'サインアウト';

  @override
  String get settingsSavedSuccessfully => '設定が正常に保存されました！';

  @override
  String settingsSaveErrorMessage(String errorMessage) {
    return '設定の保存中にエラーが発生しました: $errorMessage';
  }

  @override
  String get loadingSettingsHeadline => '設定を読み込み中';

  @override
  String get loadingSettingsSubheadline => '設定を読み込んでいます。しばらくお待ちください...';

  @override
  String failedToLoadSettingsMessage(String errorMessage) {
    return '設定の読み込みに失敗しました: $errorMessage';
  }

  @override
  String get baseThemeLabel => 'ベーステーマ';

  @override
  String get baseThemeDescription => 'アプリ全体のライトまたはダークの外観を選択します。';

  @override
  String get lightTheme => 'ライト';

  @override
  String get darkTheme => 'ダーク';

  @override
  String get systemTheme => 'システムのデフォルト';

  @override
  String get accentThemeLabel => 'アクセントテーマ';

  @override
  String get accentThemeDescription => 'インタラクティブな要素の主要なアクセントカラーを選択します。';

  @override
  String get defaultBlueTheme => 'デフォルトブルー';

  @override
  String get newsRedTheme => 'ニュースレッド';

  @override
  String get graphiteGrayTheme => 'グラファイトグレー';

  @override
  String get fontFamilyLabel => 'フォントファミリー';

  @override
  String get fontFamilyDescription => 'アプリケーション全体で使用されるフォントを選択します。';

  @override
  String get systemDefaultFont => 'システムのデフォルト';

  @override
  String get textScaleFactorLabel => 'テキストサイズ';

  @override
  String get textScaleFactorDescription => 'アプリ内のテキスト全体のサイズを調整します。';

  @override
  String get smallText => '小';

  @override
  String get mediumText => '中';

  @override
  String get largeText => '大';

  @override
  String get extraLargeText => '特大';

  @override
  String get fontWeightLabel => 'フォントの太さ';

  @override
  String get fontWeightDescription => 'テキストの太さを選択します。';

  @override
  String get lightFontWeight => 'ライト';

  @override
  String get regularFontWeight => 'レギュラー';

  @override
  String get boldFontWeight => 'ボールド';

  @override
  String get languageLabel => '言語';

  @override
  String get languageDescription => 'アプリケーションの言語を選択します。';

  @override
  String get edit => '編集';

  @override
  String get englishLanguage => '英語';

  @override
  String get arabicLanguage => 'アラビア語';

  @override
  String get appearanceSettingsLabel => '外観';

  @override
  String get languageSettingsLabel => '言語';

  @override
  String get themeSettingsLabel => 'テーマ設定';

  @override
  String get fontSettingsLabel => 'フォント設定';

  @override
  String get settingsPageDescription =>
      '視覚的なプレゼンテーションと言語の選択を含む、ダッシュボードインターフェースの個人設定を構成します。';

  @override
  String get appearanceSettingsDescription =>
      'テーマ、アクセントカラー、タイポグラフィスタイルなど、ダッシュボードの視覚的特性を調整します。';

  @override
  String get loadingHeadlines => '見出しを読み込み中';

  @override
  String get pleaseWait => 'お待ちください...';

  @override
  String get noHeadlinesFound => '見出しが見つかりませんでした。';

  @override
  String get headlineTitle => 'タイトル';

  @override
  String get excerpt => '抜粋';

  @override
  String get countryName => '国';

  @override
  String get publishedAt => '公開日時';

  @override
  String get actions => 'アクション';

  @override
  String get unknown => '不明';

  @override
  String get loadingTopics => 'トピックを読み込み中';

  @override
  String get noTopicsFound => 'トピックが見つかりませんでした。';

  @override
  String get topicName => 'トピック';

  @override
  String get description => '説明';

  @override
  String get notAvailable => 'N/A';

  @override
  String get loadingSources => 'ソースを読み込み中';

  @override
  String get noSourcesFound => 'ソースが見つかりませんでした。';

  @override
  String get sourceName => 'ソース';

  @override
  String get sourceType => 'タイプ';

  @override
  String get language => '言語';

  @override
  String get editTopic => 'トピックを編集';

  @override
  String get saveChanges => '変更を保存';

  @override
  String get loadingTopic => 'トピックを読み込み中';

  @override
  String get icon => 'アイコン';

  @override
  String get topicUpdatedSuccessfully => 'トピックが正常に更新されました。';

  @override
  String get cannotUpdateTopicError => '更新できません：元のトピックデータが読み込まれていません。';

  @override
  String get createTopic => 'トピックを作成';

  @override
  String get topicCreatedSuccessfully => 'トピックが正常に作成されました。';

  @override
  String get editSource => 'ソースを編集';

  @override
  String get sourceUpdatedSuccessfully => 'ソースが正常に更新されました。';

  @override
  String get loadingSource => 'ソースを読み込み中...';

  @override
  String get sourceUrl => 'URL';

  @override
  String get headquarters => '本部';

  @override
  String get none => 'なし';

  @override
  String get cannotUpdateSourceError => '更新できません：元のソースデータが読み込まれていません。';

  @override
  String get sourceTypeNewsAgency => '通信社';

  @override
  String get sourceTypeLocalNewsOutlet => 'ローカルニュースメディア';

  @override
  String get sourceTypeNationalNewsOutlet => '全国ニュースメディア';

  @override
  String get sourceTypeInternationalNewsOutlet => '国際ニュースメディア';

  @override
  String get sourceTypeSpecializedPublisher => '専門出版社';

  @override
  String get sourceTypeBlog => 'ブログ';

  @override
  String get sourceTypeGovernmentSource => '政府機関';

  @override
  String get sourceTypeAggregator => 'アグリゲーター';

  @override
  String get sourceTypeOther => 'その他';

  @override
  String get editHeadline => '見出しを編集';

  @override
  String get headlineUpdatedSuccessfully => '見出しが正常に更新されました。';

  @override
  String get loadingHeadline => '見出しを読み込み中...';

  @override
  String get image => '画像';

  @override
  String get cannotUpdateHeadlineError => '更新できません：元の見出しデータが読み込まれていません。';

  @override
  String get createHeadline => '見出しを作成';

  @override
  String get headlineCreatedSuccessfully => '見出しが正常に作成されました。';

  @override
  String get loadingData => 'データを読み込み中...';

  @override
  String get loadingFullList => '全リストを読み込み中...';

  @override
  String get createSource => 'ソースを作成';

  @override
  String get updateSourceTitle => 'ソースを更新';

  @override
  String get updateSourceMessage => 'これらの変更を公開しますか、それとも下書きとして保存しますか？';

  @override
  String get sourceCreatedSuccessfully => 'ソースが正常に作成されました。';

  @override
  String get updateTopicTitle => 'トピックを更新';

  @override
  String get status => 'ステータス';

  @override
  String get updateTopicMessage => 'これらの変更を公開しますか、それとも下書きとして保存しますか？';

  @override
  String get lastUpdated => '最終更新日';

  @override
  String get contentStatusActive => 'アクティブ';

  @override
  String get contentStatusArchived => 'アーカイブ済み';

  @override
  String get contentStatusDraft => '下書き';

  @override
  String get totalHeadlines => '見出し総数';

  @override
  String get totalTopics => 'トピック総数';

  @override
  String get totalSources => 'ソース総数';

  @override
  String get loadingOverview => 'ダッシュボードの概要を読み込み中...';

  @override
  String get loadingOverviewSubheadline => '最新の統計を取得しています...';

  @override
  String get overviewLoadFailure => 'ダッシュボードの概要データの読み込みに失敗しました。';

  @override
  String get recentHeadlines => '最近の見出し';

  @override
  String get viewAll => 'すべて表示';

  @override
  String get noRecentHeadlines => '表示する最近の見出しはありません。';

  @override
  String get systemStatus => 'システムステータス';

  @override
  String get quickActions => 'クイックアクション';

  @override
  String get createHeadlineAction => '見出しを作成';

  @override
  String get manageContentAction => 'コンテンツを管理';

  @override
  String get appConfigAction => 'アプリ設定';

  @override
  String get appStatusActive => 'アクティブ';

  @override
  String get appStatusDisabled => '無効';

  @override
  String demoEmailHint(String email) {
    return 'デモ用メールアドレス: $email';
  }

  @override
  String demoCodeHint(String code) {
    return 'デモ用コード: $code';
  }

  @override
  String get appStatusMaintenance => 'メンテナンス';

  @override
  String get appStatusOperational => '運用中';

  @override
  String get isUnderMaintenanceLabel => 'メンテナンス中';

  @override
  String get isUnderMaintenanceDescription =>
      'モバイルアプリをメンテナンスモードに切り替え、ユーザーのアクセスを制限します。';

  @override
  String get isLatestVersionOnlyLabel => '最新バージョンのみ強制';

  @override
  String get isLatestVersionOnlyDescription =>
      '有効にすると、ユーザーはアプリを使い続けるために最新バージョンにアップデートする必要があります。';

  @override
  String get iosUpdateUrlLabel => 'iOSアップデートURL';

  @override
  String get iosUpdateUrlDescription => 'iOSアプリのアップデート用URL。';

  @override
  String get androidUpdateUrlLabel => 'AndroidアップデートURL';

  @override
  String get followedItemsLimitLabel => 'フォローアイテム制限';

  @override
  String get followedItemsLimitDescription =>
      'このユーザーロールがフォローできる国、ニュースソース、またはカテゴリの最大数（タイプごとに独自の制限があります）。';

  @override
  String get savedFeedFiltersLimitLabel => '保存済みフィルター制限';

  @override
  String get savedFeedFiltersLimitDescription =>
      'このユーザーロールが保存できるフィードフィルターの最大数。';

  @override
  String get adFrequencyLabel => '広告頻度';

  @override
  String get adFrequencyDescription =>
      'このユーザーロールに対して広告が表示される頻度（例：値が5の場合、5つのニュースアイテムごとに広告が配置される可能性があります）。';

  @override
  String get savedFeedFilterLimitsTitle => '保存済みフィルター制限';

  @override
  String get savedFeedFilterLimitsDescription =>
      'ユーザー層ごとに、保存できるフィードフィルターの数の制限を設定します。';

  @override
  String get adPlacementIntervalLabel => '広告配置間隔';

  @override
  String get adPlacementIntervalDescription =>
      'このユーザーロールに対して最初の広告が表示されるまでに表示する必要があるニュースアイテムの最小数。';

  @override
  String get articlesBeforeInterstitialAdsLabel => 'インタースティシャル広告表示までの記事数';

  @override
  String get articlesBeforeInterstitialAdsDescription =>
      '全画面インタースティシャル広告が表示されるまでに、このユーザーロールが読む必要がある記事の数。';

  @override
  String get daysSuffix => '日';

  @override
  String daysBetweenPromptDescription(String actionType) {
    return '$actionTypeプロンプトを表示するまでの最小日数。';
  }

  @override
  String get retryButtonText => '再試行';

  @override
  String get feedActionTypeLinkAccount => 'アカウントをリンク';

  @override
  String get feedActionTypeRateApp => 'アプリを評価';

  @override
  String get feedActionTypeFollowTopics => 'トピックをフォロー';

  @override
  String get feedActionTypeFollowSources => 'ソースをフォロー';

  @override
  String get feedActionTypeUpgrade => 'アップグレード';

  @override
  String get feedActionTypeEnableNotifications => '通知を有効化';

  @override
  String get countryPickerSearchLabel => '検索';

  @override
  String get countryPickerSearchHint => '入力して検索...';

  @override
  String get countryPickerSelectCountryLabel => '国を選択';

  @override
  String get archivedHeadlines => 'アーカイブ済みの見出し';

  @override
  String get loadingArchivedHeadlines => 'アーカイブ済みの見出しを読み込み中';

  @override
  String get noArchivedHeadlinesFound => 'アーカイブ済みの見出しは見つかりませんでした。';

  @override
  String get restore => '復元';

  @override
  String get deleteForever => '永久に削除';

  @override
  String get archivedTopics => 'アーカイブ済みのトピック';

  @override
  String get loadingArchivedTopics => 'アーカイブ済みのトピックを読み込み中';

  @override
  String get noArchivedTopicsFound => 'アーカイブ済みのトピックは見つかりませんでした。';

  @override
  String get archivedSources => 'アーカイブ済みのソース';

  @override
  String get loadingArchivedSources => 'アーカイブ済みのソースを読み込み中';

  @override
  String get noArchivedSourcesFound => 'アーカイブ済みのソースは見つかりませんでした。';

  @override
  String get archivedItems => 'アーカイブ済みのアイテム';

  @override
  String get addNewItem => '新しいアイテムを追加';

  @override
  String get archive => 'アーカイブ';

  @override
  String headlineDeleted(String title) {
    return '「$title」を削除しました。';
  }

  @override
  String get undo => '元に戻す';

  @override
  String get enabledLabel => '有効';

  @override
  String get itemsToDisplayLabel => '表示するアイテム数';

  @override
  String get itemsToDisplayDescription => 'このデコレーターで表示するアイテムの数。';

  @override
  String get roleSpecificSettingsTitle => 'ロール固有の設定';

  @override
  String get daysBetweenViewsLabel => '表示間隔（日数）';

  @override
  String get daysBetweenViewsDescription =>
      'この設定は、関連するタスクがまだ完了していない場合に、デコレーターをユーザーに再度表示するまでに経過する必要がある最小日数を決定します。';

  @override
  String get feedDecoratorTypeLinkAccount => 'アカウントをリンク';

  @override
  String get feedDecoratorTypeUpgrade => 'プレミアムにアップグレード';

  @override
  String get feedDecoratorTypeRateApp => 'アプリを評価';

  @override
  String get feedDecoratorTypeEnableNotifications => '通知を有効化';

  @override
  String get feedDecoratorTypeSuggestedTopics => 'おすすめのトピック';

  @override
  String get feedDecoratorTypeSuggestedSources => 'おすすめのソース';

  @override
  String get guestUserRole => 'ゲストユーザー';

  @override
  String get standardUserRole => '標準ユーザー';

  @override
  String get premiumUserRole => 'プレミアムユーザー';

  @override
  String get dashboardTitle => 'ダッシュボード';

  @override
  String get clearSelection => '選択を解除';

  @override
  String get search => '検索';

  @override
  String get noResultsFound => '結果が見つかりませんでした。';

  @override
  String get close => '閉じる';

  @override
  String get apply => '適用';

  @override
  String visibleToRoleLabel(String roleName) {
    return '$roleNameに表示';
  }

  @override
  String get adPlatformConfigurationTitle => '広告プラットフォーム設定';

  @override
  String get primaryAdPlatformTitle => '主要な広告プラットフォーム';

  @override
  String get primaryAdPlatformDescription =>
      'アプリケーション全体で使用される主要な広告プラットフォームを選択します。';

  @override
  String get adUnitIdentifiersTitle => '広告ユニット識別子';

  @override
  String get adUnitIdentifiersDescription => '選択した広告プラットフォームの広告ユニットIDを設定します。';

  @override
  String get feedAdSettingsTitle => 'フィード広告設定';

  @override
  String get enableFeedAdsLabel => 'フィード広告を有効化';

  @override
  String get feedAdTypeSelectionTitle => 'フィード広告タイプの選択';

  @override
  String get feedAdTypeSelectionDescription =>
      'メインフィードに表示する広告のタイプ（ネイティブまたはバナー）を選択します。';

  @override
  String get userRoleFrequencySettingsTitle => 'ユーザーロールごとの頻度設定';

  @override
  String get userRoleFrequencySettingsDescription =>
      'ユーザーロールに基づいて広告の頻度と配置間隔を設定します。';

  @override
  String get articleAdSettingsTitle => '記事内広告設定';

  @override
  String get enableArticleAdsLabel => '記事内広告を有効化';

  @override
  String get defaultInArticleAdTypeSelectionTitle => 'デフォルトの記事内広告タイプの選択';

  @override
  String get defaultInArticleAdTypeSelectionDescription =>
      '記事内に表示する広告のデフォルトタイプ（ネイティブまたはバナー）を選択します。';

  @override
  String get inArticleAdSlotPlacementsTitle => '記事内広告スロットの配置';

  @override
  String get inArticleAdSlotPlacementsDescription =>
      '記事コンテンツ内の特定の広告スロットを有効または無効にします。';

  @override
  String get feedNativeAdIdLabel => 'フィードネイティブ広告ID';

  @override
  String get feedNativeAdIdDescription => 'フィード内のネイティブ広告のユニットID。';

  @override
  String get feedBannerAdIdLabel => 'フィードバナー広告ID';

  @override
  String get feedBannerAdIdDescription => 'フィード内のバナー広告のユニットID。';

  @override
  String get articleInterstitialAdIdLabel => '記事インタースティシャル広告ID';

  @override
  String get articleInterstitialAdIdDescription => '記事内のインタースティシャル広告のユニットID。';

  @override
  String get inArticleNativeAdIdLabel => '記事内ネイティブ広告ID';

  @override
  String get inArticleNativeAdIdDescription => '記事内のネイティブ広告のユニットID。';

  @override
  String get inArticleBannerAdIdLabel => '記事内バナー広告ID';

  @override
  String get inArticleBannerAdIdDescription => '記事内のバナー広告のユニットID。';

  @override
  String get inArticleAdSlotTypeAboveArticleContinueReadingButton =>
      '「続きを読む」ボタンの上';

  @override
  String get inArticleAdSlotTypeBelowArticleContinueReadingButton =>
      '「続きを読む」ボタンの下';

  @override
  String idCopiedToClipboard(String id) {
    return 'ID「$id」をクリップボードにコピーしました。';
  }

  @override
  String get copyId => 'IDをコピー';

  @override
  String get enableGlobalAdsLabel => '広告を有効化';

  @override
  String get feedToArticleInterstitialAdIdLabel => 'フィードから記事へのインタースティシャル広告ID';

  @override
  String get feedToArticleInterstitialAdIdDescription =>
      'ユーザーがフィードから記事に移動したときに表示されるインタースティシャル広告の広告ユニットID。';

  @override
  String get interstitialAdSettingsTitle => 'インタースティシャル広告設定';

  @override
  String get enableInterstitialAdsLabel => 'インタースティシャル広告を有効化';

  @override
  String get userRoleInterstitialFrequencyTitle => 'ユーザーロールごとのインタースティシャル広告頻度';

  @override
  String get userRoleInterstitialFrequencyDescription =>
      'ロールに基づいて、インタースティシャル広告が表示されるまでにユーザーが行う必要がある遷移の数を設定します。';

  @override
  String get transitionsBeforeInterstitialAdsLabel => 'インタースティシャル広告表示までの遷移数';

  @override
  String get transitionsBeforeInterstitialAdsDescription =>
      'インタースティシャル広告が表示されるまでにユーザーが行う必要がある遷移（例：記事を開く）の数。';

  @override
  String get adPlatformTypeAdmob => 'AdMob';

  @override
  String get nativeAdsTab => 'ネイティブ広告';

  @override
  String get bannerAdsTab => 'バナー広告';

  @override
  String get interstitialAdsTab => 'インタースティシャル広告';

  @override
  String get videoAdsTab => '動画広告';

  @override
  String get bannerAdType => 'バナー';

  @override
  String get nativeAdType => 'ネイティブ';

  @override
  String get interstitialAdType => 'インタースティシャル';

  @override
  String get videoAdType => '動画';

  @override
  String get rewardedAdType => 'リワード';

  @override
  String get bannerAdShapeSelectionTitle => 'バナー広告の形状';

  @override
  String get bannerAdShapeSelectionDescription =>
      '記事に表示されるバナー広告の優先的な視覚的形状を選択します。';

  @override
  String get bannerAdShapeSquare => '正方形';

  @override
  String get bannerAdShapeRectangle => '長方形';

  @override
  String get loadingDraftHeadlines => '下書きの見出しを読み込み中';

  @override
  String get noDraftHeadlinesFound => '下書きの見出しは見つかりませんでした';

  @override
  String get publish => '公開';

  @override
  String get saveAsDraft => '下書きとして保存';

  @override
  String get invalidFormTitle => '無効なフォーム';

  @override
  String get invalidFormMessage =>
      '公開する前に、すべての必須フィールドを入力してください。下書きとして保存するか、変更を破棄することもできます。';

  @override
  String get completeForm => 'フォームを完成させる';

  @override
  String get discard => '破棄';

  @override
  String get drafts => '下書き';

  @override
  String get draftsIconTooltip => '下書き';

  @override
  String get draftHeadlines => '下書きの見出し';

  @override
  String get draftTopics => '下書きのトピック';

  @override
  String get draftSources => '下書きのソース';

  @override
  String get saveHeadlineTitle => '見出しを保存';

  @override
  String get saveHeadlineMessage => 'この見出しを公開しますか、それとも下書きとして保存しますか？';

  @override
  String get saveTopicTitle => 'トピックを保存';

  @override
  String get saveTopicMessage => 'このトピックを公開しますか、それとも下書きとして保存しますか？';

  @override
  String get saveSourceTitle => 'ソースを保存';

  @override
  String get saveSourceMessage => 'このソースを公開しますか、それとも下書きとして保存しますか？';

  @override
  String get loadingDraftTopics => '下書きのトピックを読み込み中...';

  @override
  String get noDraftTopicsFound => '下書きのトピックは見つかりませんでした。';

  @override
  String topicDeleted(String topicTitle) {
    return 'トピック「$topicTitle」を削除しました。';
  }

  @override
  String get loadingDraftSources => '下書きのソースを読み込み中...';

  @override
  String get noDraftSourcesFound => '下書きのソースは見つかりませんでした。';

  @override
  String sourceDeleted(String sourceName) {
    return 'ソース「$sourceName」を削除しました。';
  }

  @override
  String get publishTopic => 'トピックを公開';

  @override
  String get publishSource => 'ソースを公開';

  @override
  String enableInArticleAdsForRoleLabel(String role) {
    return '$roleの記事内広告を有効にする';
  }

  @override
  String get moreActions => 'その他のアクション';

  @override
  String get filter => 'フィルター';

  @override
  String get applyFilters => 'フィルターを適用';

  @override
  String get filterHeadlines => '見出しをフィルター';

  @override
  String get filterTopics => 'トピックをフィルター';

  @override
  String get filterSources => 'ソースをフィルター';

  @override
  String get searchByHeadlineTitle => '見出しタイトルで検索...';

  @override
  String get searchByTopicName => '名前またはIDで検索...';

  @override
  String get searchBySourceName => '名前またはIDで検索...';

  @override
  String get selectSources => 'ソースを選択';

  @override
  String get selectTopics => 'トピックを選択';

  @override
  String get countries => '国';

  @override
  String get selectCountries => '国を選択';

  @override
  String get selectSourceTypes => 'ソースタイプを選択';

  @override
  String get selectLanguages => '言語を選択';

  @override
  String get selectHeadquarters => '本部を選択';

  @override
  String get resetFiltersButtonText => 'フィルターをリセット';

  @override
  String get noResultsWithCurrentFilters =>
      '現在のフィルターでは結果が見つかりませんでした。リセットしてみてください。';

  @override
  String get aboutIconTooltip => 'このページについて';

  @override
  String get closeButtonText => '閉じる';

  @override
  String get logo => 'ロゴ';

  @override
  String get userManagement => 'ユーザー管理';

  @override
  String get userManagementPageDescription => 'ロールや権限を含むシステムユーザーを管理します。';

  @override
  String get loadingUsers => 'ユーザーを読み込み中';

  @override
  String get noUsersFound => 'ユーザーが見つかりませんでした。';

  @override
  String get email => 'メールアドレス';

  @override
  String get appRole => 'アプリロール';

  @override
  String get dashboardRole => 'ダッシュボードロール';

  @override
  String get createdAt => '作成日時';

  @override
  String get promoteToPublisher => 'パブリッシャーに昇格';

  @override
  String get demoteToUser => 'ユーザーに降格';

  @override
  String get adminRole => '管理者';

  @override
  String get publisherRole => 'パブリッシャー';

  @override
  String get filterUsers => 'ユーザーをフィルター';

  @override
  String get searchByUserEmail => 'メールアドレスまたはIDで検索...';

  @override
  String get selectAppRoles => 'アプリロールを選択';

  @override
  String get selectDashboardRoles => 'ダッシュボードロールを選択';

  @override
  String get authentication => '認証';

  @override
  String get subscription => 'サブスクリプション';

  @override
  String get authenticationAnonymous => '匿名';

  @override
  String get authenticationAuthenticated => '認証済み';

  @override
  String get subscriptionFree => '無料';

  @override
  String get subscriptionPremium => 'プレミアム';

  @override
  String get savedHeadlineFilterLimitsTitle => '保存済み見出しフィルター制限';

  @override
  String get savedHeadlineFilterLimitsDescription =>
      '合計、ピン留め、通知サブスクリプションを含む、ユーザー層ごとの保存済み見出しフィルターの数の制限を設定します。';

  @override
  String get totalLimitLabel => '合計制限';

  @override
  String get totalLimitDescription => 'ユーザーが作成できるこのタイプのフィルターの総数。';

  @override
  String get pinnedLimitLabel => 'ピン留め制限';

  @override
  String get pinnedLimitDescription => 'ピン留めできるこのタイプのフィルターの最大数。';

  @override
  String get notificationSubscriptionLimitLabel => '通知サブスクリプション制限';

  @override
  String get notificationSubscriptionLimitDescription =>
      'この通知タイプでユーザーが購読できるフィルターの最大数。';

  @override
  String get pushNotificationSubscriptionDeliveryTypeBreakingOnly => '速報';

  @override
  String get pushNotificationSubscriptionDeliveryTypeWeeklyRoundup => '週間まとめ';

  @override
  String get isBreakingNewsLabel => '速報としてマーク';

  @override
  String get isBreakingNewsDescription =>
      'これを有効にすると、公開時にすべての購読ユーザーに即座にプッシュ通知が送信されます。';

  @override
  String get isBreakingNewsDescriptionEdit =>
      '編集中にこのステータスを変更しても、通知は最初の作成時にのみ送信されるため、新しいプッシュ通知はトリガーされません。';

  @override
  String get confirmBreakingNewsTitle => '速報公開の確認';

  @override
  String get confirmBreakingNewsMessage =>
      'これを速報として公開してもよろしいですか？このアクションにより、すべての購読ユーザーに即座にプッシュ通知が送信されます。';

  @override
  String get confirmPublishButton => '確認して公開';

  @override
  String get cannotDraftBreakingNews =>
      '速報は下書きとして保存できません。公開するか、「速報」トグルを無効にしてください。';

  @override
  String get ok => 'OK';

  @override
  String get breakingNewsFilterTitle => '速報';

  @override
  String get breakingNewsFilterAll => 'すべて';

  @override
  String get breakingNewsFilterBreakingOnly => '速報のみ';

  @override
  String get breakingNewsFilterNonBreakingOnly => '速報以外';

  @override
  String get notificationsTab => '通知';

  @override
  String get pushNotificationSettingsTitle => 'プッシュ通知設定';

  @override
  String get pushNotificationSettingsDescription =>
      '主要プロバイダーやアクティブな通知タイプなど、プッシュ通知システムのグローバル設定を管理します。';

  @override
  String get pushNotificationSystemStatusTitle => '通知を有効化';

  @override
  String get pushNotificationSystemStatusDescription =>
      'すべてのプッシュ通知を有効または無効にするグローバルスイッチ。';

  @override
  String get pushNotificationPrimaryProviderTitle => '主要プロバイダー';

  @override
  String get pushNotificationPrimaryProviderDescription =>
      '主要なサービスプロバイダーを選択します。選択したプロバイダーが、ドキュメントに従ってバックエンドの.envファイルで正しく構成されていることを確認してください。';

  @override
  String get pushNotificationDeliveryTypesTitle => '配信タイプ';

  @override
  String get pushNotificationDeliveryTypesDescription =>
      '特定のタイプのプッシュ通知をグローバルに有効または無効にします。';

  @override
  String get pushNotificationProviderFirebase => 'Firebase';

  @override
  String get pushNotificationProviderOneSignal => 'OneSignal';

  @override
  String get appTab => '全般';

  @override
  String get featuresTab => '機能';

  @override
  String get limitsTab => '制限';

  @override
  String get maintenanceConfigTitle => 'メンテナンスモード';

  @override
  String get maintenanceConfigDescription =>
      '有効にするとアプリがメンテナンスモードになり、ユーザーのアクセスが制限されます。';

  @override
  String get updateConfigTitle => 'アップデート設定';

  @override
  String get updateConfigDescription => 'ユーザーに対する必須のアプリアップデートを設定します。';

  @override
  String get generalAppConfigTitle => 'アプリの全般設定';

  @override
  String get generalAppConfigDescription =>
      '利用規約やプライバシーポリシーのURLなどの全般的なアプリケーション設定を管理します。';

  @override
  String get termsOfServiceUrlLabel => '利用規約URL';

  @override
  String get termsOfServiceUrlDescription => 'アプリケーションの利用規約ページへのURL。';

  @override
  String get privacyPolicyUrlLabel => 'プライバシーポリシーURL';

  @override
  String get privacyPolicyUrlDescription => 'アプリケーションのプライバシーポリシーページへのURL。';

  @override
  String get navigationAdConfigTitle => 'ナビゲーション広告設定';

  @override
  String get enableNavigationAdsLabel => 'ナビゲーション広告を有効化';

  @override
  String get navigationAdFrequencyTitle => 'ナビゲーション広告の頻度';

  @override
  String get navigationAdFrequencyDescription =>
      'ロールに基づいて、インタースティシャル広告が表示されるまでにユーザーが行う必要がある遷移の数を設定します。';

  @override
  String get internalNavigationsBeforeAdLabel => '広告表示までの内部ナビゲーション数';

  @override
  String get internalNavigationsBeforeAdDescription =>
      'インタースティシャル広告が表示されるまでにユーザーが行う必要がある内部ページ間ナビゲーションの数。';

  @override
  String get externalNavigationsBeforeAdLabel => '広告表示までの外部ナビゲーション数';

  @override
  String get externalNavigationsBeforeAdDescription =>
      'インタースティシャル広告が表示されるまでにユーザーが行う必要がある外部ナビゲーションの数。';

  @override
  String get nativeAdIdLabel => 'ネイティブ広告ID';

  @override
  String get nativeAdIdDescription => 'ネイティブ広告のユニットID。';

  @override
  String get bannerAdIdLabel => 'バナー広告ID';

  @override
  String get bannerAdIdDescription => 'バナー広告のユニットID。';

  @override
  String get interstitialAdIdLabel => 'インタースティシャル広告ID';

  @override
  String get interstitialAdIdDescription => 'インタースティシャル広告のユニットID。';

  @override
  String get savedHeadlinesLimitLabel => '保存済み見出し制限';

  @override
  String get savedHeadlinesLimitDescription => 'このユーザーロールが保存できる見出しの最大数。';

  @override
  String get appUpdateManagementTitle => 'アプリケーションアップデート管理';

  @override
  String get feedItemClickBehaviorTitle => 'フィードアイテムのクリック動作';

  @override
  String get feedItemClickBehaviorDescription =>
      '見出しを開くためのデフォルトのブラウザを設定します。これは、ユーザーがアプリのフィード設定で上書きできます。';

  @override
  String get feedItemClickBehaviorInternalNavigation => 'アプリ内ブラウザ';

  @override
  String get feedItemClickBehaviorExternalNavigation => 'システムブラウザ';

  @override
  String get userLimitsTitle => 'ユーザー制限';

  @override
  String get userLimitsDescription => 'ユーザー固有の機能とコンテンツの制限を定義します。';

  @override
  String get appStatusAndUpdatesDescription =>
      'アプリケーションの運用ステータスを制御し、アップデート要件を管理します。';

  @override
  String get advertisementsDescription =>
      'グローバルコントロール、プラットフォーム、配置を含むすべての広告設定を管理します。';

  @override
  String get notificationsDescription => 'プロバイダーや配信タイプを含むプッシュ通知システムを構成します。';

  @override
  String get feedDescription => 'ユーザーのコンテンツフィードの動作と外観を制御します。';

  @override
  String get notificationSubscriptionBreakingOnlyDescription =>
      '一致する見出しに対して即座にアラートを送信するサブスクリプションの制限。';

  @override
  String get notificationSubscriptionWeeklyRoundupDescription =>
      '一致する見出しの週間まとめを送信するサブスクリプションの制限。';

  @override
  String get appStatusAndUpdatesTitle => 'アプリのステータスとアップデート';

  @override
  String get enableForcedUpdatesLabel => '強制アップデートを有効化';

  @override
  String get enableForcedUpdatesDescription =>
      '有効にすると、モバイルアプリの必須最小バージョンを指定できます。';

  @override
  String get appUrlsTitle => 'アプリケーションURL';

  @override
  String get appUrlsDescription => 'アプリケーション内で使用される外部および内部URLを管理します。';

  @override
  String get communityAndEngagementTitle => 'コミュニティとエンゲージメント';

  @override
  String get communityAndEngagementDescription =>
      'ユーザーエンゲージメントとレポートツールを構成します。説明責任を果たすため、ここでの設定に関わらず、モバイルアプリ内のゲストユーザーはこれらの機能を利用できません。';

  @override
  String get userEngagementTitle => 'ユーザーエンゲージメント';

  @override
  String get userEngagementDescription => 'リアクションとコメントを構成します。';

  @override
  String get contentReportingTitle => 'コンテンツレポート';

  @override
  String get contentReportingDescription => 'ユーザーがレポートできる内容のルールを設定します。';

  @override
  String get appReviewFunnelTitle => 'アプリレビュー';

  @override
  String get appReviewFunnelDescription =>
      'ユーザーの満足度を把握し、オプションでレビューをリクエストするプロセスを管理します。';

  @override
  String get enableEngagementFeaturesLabel => 'エンゲージメント機能を有効化';

  @override
  String get enableEngagementFeaturesDescription =>
      'すべてのリアクションおよびコメント機能をグローバルに有効または無効にします。';

  @override
  String get engagementModeLabel => 'エンゲージメントモード';

  @override
  String get engagementModeDescription =>
      'ユーザーがコンテンツに対してリアクションのみを行えるか、コメントも追加できるかを決定します。';

  @override
  String get engagementModeReactionsOnly => 'リアクションのみ';

  @override
  String get engagementModeReactionsAndComments => 'リアクションとコメント';

  @override
  String get enableReportingSystemLabel => 'レポートシステムを有効化';

  @override
  String get enableReportingSystemDescription =>
      'ユーザー向けのすべてのレポートオプションをグローバルに有効または無効にします。';

  @override
  String get enableHeadlineReportingLabel => '見出しレポートを有効化';

  @override
  String get enableSourceReportingLabel => 'ソースレポートを有効化';

  @override
  String get enableCommentReportingLabel => 'コメントレポートを有効化';

  @override
  String get enableAppFeedbackSystemLabel => 'アプリフィードバックシステムを有効化';

  @override
  String get enableAppFeedbackSystemDescription =>
      'ユーザーがアプリを楽しんでいるかどうかを定期的に尋ねる内部システムを有効にします。';

  @override
  String get interactionCycleThresholdLabel => 'インタラクションサイクルのしきい値';

  @override
  String get interactionCycleThresholdDescription =>
      '満足度プロンプトをトリガーするために必要なポジティブなアクション（例：保存、いいね）の数を定義します。プロンプトは、ユーザーのポジティブなアクションの合計がこの数値の倍数になるたびに表示されます。';

  @override
  String get initialPromptCooldownLabel => '初回プロンプトのクールダウン（日数）';

  @override
  String get initialPromptCooldownDescription =>
      '満足度プロンプトを初めて表示するまでに待機する日数。このクールダウンにより、ユーザーがアプリを十分に利用するまで質問されないようにします。';

  @override
  String get requestStoreReviewLabel => '「はい」の後にストアレビューをリクエスト';

  @override
  String get requestStoreReviewDescription =>
      '有効にすると、満足度プロンプトに「はい」と回答したユーザーに、公式のOSストアレビューダイアログが表示されます。';

  @override
  String get requestWrittenFeedbackLabel => '「いいえ」の後に記述式フィードバックをリクエスト';

  @override
  String get requestWrittenFeedbackDescription =>
      '有効にすると、「いいえ」と回答したユーザーに、チームに直接記述式フィードバックを提供するよう促します。';

  @override
  String get internalPromptLogicTitle => '内部プロンプトのロジック';

  @override
  String get eligiblePositiveInteractionsTitle => '対象となるポジティブなインタラクション';

  @override
  String get positiveInteractionTypeSaveItem => 'コンテンツアイテムを保存';

  @override
  String get positiveInteractionTypeFollowItem => 'エンティティをフォロー';

  @override
  String get positiveInteractionTypeShareContent => 'コンテンツアイテムを共有';

  @override
  String get positiveInteractionTypeSaveFilter => '保存済みフィルターを作成';

  @override
  String get followUpActionsTitle => 'フォローアップアクション';

  @override
  String get enableCommunityFeaturesLabel => 'コミュニティ機能を有効化';

  @override
  String get enableCommunityFeaturesDescription =>
      'エンゲージメントやレポートを含む、すべてのコミュニティ関連機能をグローバルに有効または無効にします。';

  @override
  String get communityManagementPageDescription =>
      'エンゲージメント（リアクションとコメント）、コンテンツレポート、アプリレビューなどのユーザー生成コンテンツを管理します。';

  @override
  String get engagements => 'エンゲージメント';

  @override
  String get reports => 'レポート';

  @override
  String get appReviews => 'アプリレビュー';

  @override
  String get user => 'ユーザー';

  @override
  String get engagedContent => 'エンゲージメント対象のコンテンツ';

  @override
  String get reaction => 'リアクション';

  @override
  String get comment => 'コメント';

  @override
  String get commentStatus => 'コメントステータス';

  @override
  String get hasCommentFilterLabel => 'コメントあり';

  @override
  String get hasCommentFilterDescription => 'テキストコメントを含むエンゲージメントのみを表示します。';

  @override
  String get date => '日付';

  @override
  String get approveComment => 'コメントを承認';

  @override
  String get rejectComment => 'コメントを拒否';

  @override
  String get viewEngagedContent => 'コンテンツを表示';

  @override
  String get copyUserId => 'ユーザーIDをコピー';

  @override
  String get reporter => 'レポート作成者';

  @override
  String get reportedItem => 'レポート対象のアイテム';

  @override
  String get reason => '理由';

  @override
  String get reportStatus => 'レポートステータス';

  @override
  String get viewReportedItem => 'アイテムを表示';

  @override
  String get markAsInReview => '審査中に設定';

  @override
  String get resolveReport => 'レポートを解決';

  @override
  String get initialFeedback => '初回フィードバック';

  @override
  String get osPromptRequested => 'OSプロンプトをリクエスト済み？';

  @override
  String get feedbackHistory => 'フィードバック履歴';

  @override
  String get lastInteraction => '最終インタラクション';

  @override
  String get viewFeedbackHistory => '履歴を表示';

  @override
  String get reactionTypeLike => 'いいね';

  @override
  String get reactionTypeInsightful => '洞察に満ちている';

  @override
  String get reactionTypeAmusing => '面白い';

  @override
  String get reactionTypeSad => '悲しい';

  @override
  String get reactionTypeAngry => '怒り';

  @override
  String get reactionTypeSkeptical => '懐疑的';

  @override
  String get initialAppReviewFeedbackPositive => 'ポジティブ';

  @override
  String get initialAppReviewFeedbackNegative => 'ネガティブ';

  @override
  String get filterCommunity => 'コミュニティコンテンツをフィルター';

  @override
  String get searchByEngagementUser => 'ユーザーのメールアドレスで検索...';

  @override
  String get searchByReportReporter => 'レポート作成者のメールアドレスで検索...';

  @override
  String get searchByAppReviewUser => 'ユーザーのメールアドレスで検索...';

  @override
  String get selectCommentStatus => 'コメントステータスを選択';

  @override
  String get selectReportStatus => 'レポートステータスを選択';

  @override
  String get selectInitialFeedback => '初回フィードバックを選択';

  @override
  String get selectReportableEntity => 'レポート対象のアイテムタイプを選択';

  @override
  String get reportableEntityHeadline => '見出し';

  @override
  String get reportableEntitySource => 'ソース';

  @override
  String get reportableEntityComment => 'コメント';

  @override
  String get noEngagementsFound => 'エンゲージメントが見つかりませんでした。';

  @override
  String get noReportsFound => 'レポートが見つかりませんでした。';

  @override
  String get noAppReviewsFound => 'アプリレビューが見つかりませんでした。';

  @override
  String get loadingEngagements => 'エンゲージメントを読み込み中';

  @override
  String get loadingReports => 'レポートを読み込み中';

  @override
  String get loadingAppReviews => 'アプリレビューを読み込み中';

  @override
  String get userIdCopied => 'ユーザーIDをクリップボードにコピーしました。';

  @override
  String get reportStatusUpdated => 'レポートステータスを更新しました。';

  @override
  String feedbackHistoryForUser(String email) {
    return '$emailのフィードバック履歴';
  }

  @override
  String get noFeedbackHistory => 'このユーザーのフィードバック履歴はありません。';

  @override
  String feedbackProvidedAt(String date) {
    return 'フィードバック提供日時: $date';
  }

  @override
  String feedbackReason(String reason) {
    return '理由: $reason';
  }

  @override
  String get noReasonProvided => '理由は提供されていません。';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get reportReasonMisinformationOrFakeNews => '誤報 / フェイクニュース';

  @override
  String get reportReasonClickbaitTitle => '釣りタイトル';

  @override
  String get reportReasonOffensiveOrHateSpeech => '攻撃的 / ヘイトスピーチ';

  @override
  String get reportReasonSpamOrScam => 'スパム / 詐欺';

  @override
  String get reportReasonBrokenLink => 'リンク切れ';

  @override
  String get reportReasonPaywalled => 'ペイウォール（有料記事）';

  @override
  String get reportReasonLowQualityJournalism => '低品質なジャーナリズム';

  @override
  String get reportReasonHighAdDensity => '広告が多すぎる';

  @override
  String get reportReasonBlog => 'ブログ';

  @override
  String get reportReasonGovernmentSource => '政府機関';

  @override
  String get reportReasonAggregator => 'アグリゲーター';

  @override
  String get reportReasonOther => 'その他';

  @override
  String get reportReasonFrequentPaywalls => '頻繁なペイウォール';

  @override
  String get reportReasonImpersonation => 'なりすまし';

  @override
  String get noNegativeFeedbackHistory => 'このユーザーのネガティブなフィードバック履歴は見つかりませんでした。';

  @override
  String get reject => '拒否';

  @override
  String get commentStatusFlaggedByAi => 'AIによってフラグ設定済み';

  @override
  String get cancel => 'キャンセル';

  @override
  String get rejectCommentConfirmation =>
      'このコメントを拒否して永久に削除してもよろしいですか？このアクションは取り消せません。';

  @override
  String get searchByUserId => 'ユーザーIDで検索...';

  @override
  String get viewReportedHeadline => '見出しを表示';

  @override
  String get viewReportedSource => 'ソースを表示';

  @override
  String get viewReportedComment => 'コメントを表示';

  @override
  String get entityType => 'エンティティタイプ';

  @override
  String get feedback => 'フィードバック';

  @override
  String get feedbackDetails => 'フィードバックの詳細';

  @override
  String get moderationStatusPendingReview => '審査待ち';

  @override
  String get moderationStatusResolved => '解決済み';

  @override
  String get hasComment => 'コメントあり';

  @override
  String get any => 'すべて';

  @override
  String get withComment => 'コメントあり';

  @override
  String get withoutComment => 'コメントなし';

  @override
  String get reportResolved => 'レポートを解決しました。';

  @override
  String get commentApproved => 'コメントを承認しました。';

  @override
  String get commentRejected => 'コメントを拒否しました。';

  @override
  String get copyHeadlineId => '見出しIDをコピー';

  @override
  String get copyReportedItemId => 'レポート対象のアイテムIDをコピー';

  @override
  String get viewFeedbackDetails => 'フィードバックの詳細を表示';

  @override
  String get reportDetails => 'レポートの詳細';

  @override
  String get commentDetails => 'コメントの詳細';

  @override
  String get communityManagement => 'コミュニティ管理';

  @override
  String get navContent => 'コンテンツ';

  @override
  String get navUsers => 'ユーザー';

  @override
  String get navCommunity => 'コミュニティ';

  @override
  String get confirmPromotionTitle => '昇格の確認';

  @override
  String confirmPromotionMessage(String email) {
    return '$emailをパブリッシャーに昇格させてもよろしいですか？';
  }

  @override
  String get confirmDemotionTitle => '降格の確認';

  @override
  String confirmDemotionMessage(String email) {
    return '$emailを標準ユーザーに降格させてもよろしいですか？';
  }

  @override
  String get premiumUserTooltip => 'プレミアム';

  @override
  String get adminUserTooltip => '管理者';

  @override
  String get publisherUserTooltip => 'パブリッシャー';

  @override
  String get breakingNewsHint => 'これは速報の見出しです';

  @override
  String get breakingNewsFilterDescription => '速報の見出しのみを表示';

  @override
  String publishItemTitle(String itemType) {
    return '$itemTypeを公開しますか？';
  }

  @override
  String publishItemContent(String itemType) {
    return 'この$itemTypeを公開してもよろしいですか？一般に公開されます。';
  }

  @override
  String archiveItemTitle(String itemType) {
    return '$itemTypeをアーカイブしますか？';
  }

  @override
  String archiveItemContent(String itemType) {
    return 'この$itemTypeをアーカイブしてもよろしいですか？一般には表示されなくなります。';
  }

  @override
  String restoreItemTitle(String itemType) {
    return '$itemTypeを復元しますか？';
  }

  @override
  String restoreItemContent(String itemType) {
    return 'この$itemTypeを復元してもよろしいですか？再びアクティブになり、一般に公開されます。';
  }

  @override
  String deleteItemTitle(String itemType) {
    return '$itemTypeを削除しますか？';
  }

  @override
  String deleteItemContent(String itemType) {
    return 'この$itemTypeを削除してもよろしいですか？ ';
  }

  @override
  String itemDeletedSnackbar(String itemType, String itemName) {
    return '$itemType「$itemName」を削除しました。';
  }

  @override
  String get adPlatformConfigurationDescription =>
      '主要な広告プロバイダーを選択し、それぞれの広告ユニットIDを構成します。';

  @override
  String get feedAdSettingsDescription =>
      'ユーザーのコンテンツフィード内での広告の表示、タイプ、頻度を制御します。';

  @override
  String get navigationAdConfigDescription =>
      'ユーザーのナビゲーション中に表示されるインタースティシャル広告を構成します。';

  @override
  String get feedDecoratorLinkAccountDescription => 'ゲストユーザーにフルアカウントの作成を促します。';

  @override
  String get feedDecoratorUpgradeDescription =>
      '標準ユーザーにプレミアムサブスクリプションへのアップグレードを促します。';

  @override
  String get feedDecoratorRateAppDescription =>
      'ユーザーにアプリストアでのアプリケーションの評価を促します。';

  @override
  String get feedDecoratorEnableNotificationsDescription =>
      'ユーザーにプッシュ通知の有効化を促します。';

  @override
  String get feedDecoratorSuggestedTopicsDescription =>
      'ユーザーがフォローに興味を持ちそうなトピックのコレクションを表示します。';

  @override
  String get feedDecoratorSuggestedSourcesDescription =>
      'ユーザーがフォローに興味を持ちそうなソースのコレクションを表示します。';

  @override
  String get enableGlobalAdsDescription =>
      'アプリケーション内のすべての広告をグローバルに有効または無効にします。';

  @override
  String get enableFeedAdsDescription => 'コンテンツフィード内のすべての広告の表示を制御します。';

  @override
  String visibleToRoleDescription(String roleName) {
    return '有効にすると、この機能は「$roleName」ロールを持つユーザーに対してアクティブになります。';
  }

  @override
  String get enableDecoratorDescription =>
      'すべての対象ユーザーに対して、このデコレーターをグローバルに有効または無効にします。';

  @override
  String get enableNavigationAdsDescription =>
      'ユーザーのナビゲーション中に表示されるインタースティシャル広告の表示を制御します。';

  @override
  String get enableHeadlineReportingDescription =>
      'ユーザーが誤報や釣りタイトルなどの問題で見出しをレポートできるようにします。';

  @override
  String get enableSourceReportingDescription =>
      'ユーザーが低品質や偏向などの問題でニュースソース全体をレポートできるようにします。';

  @override
  String get enableCommentReportingDescription =>
      'ユーザーがモデレーションのために個別のコメントをレポートできるようにします。';

  @override
  String get pushNotificationDeliveryTypeBreakingOnlyDescription =>
      '有効にすると、ユーザーが速報の即時アラートを購読できるようになります。';

  @override
  String get pushNotificationDeliveryTypeDailyDigestDescription =>
      '有効にすると、ユーザーが関連ニュースの日次まとめを購読できるようになります。';

  @override
  String get pushNotificationDeliveryTypeWeeklyRoundupDescription =>
      '有効にすると、ユーザーが関連ニュースの週間まとめを購読できるようになります。';

  @override
  String get positiveInteractionTypeSaveItemDescription =>
      'ユーザーが見出しをブックマークしたときにカウントされます。';

  @override
  String get positiveInteractionTypeFollowItemDescription =>
      'ユーザーが見出しのトピック、ソース、または国をフォローしたときにカウントされます。';

  @override
  String get positiveInteractionTypeShareContentDescription =>
      'ユーザーが見出しを共有したときにカウントされます。';

  @override
  String get positiveInteractionTypeSaveFilterDescription =>
      'ユーザーが保存済みフィルターを作成したときにカウントされます。';

  @override
  String get internalPromptLogicDescription =>
      'ユーザーのアクション数やクールダウン期間など、満足度プロンプトをトリガーする条件を定義します。';

  @override
  String get eligiblePositiveInteractionsDescription =>
      '満足度プロンプトをトリガーするための「ポジティブなインタラクション」としてカウントされるユーザーアクションを選択します。';

  @override
  String get followUpActionsDescription =>
      'ストアレビューのリクエストなど、ユーザーが満足度プロンプトに回答した後に何が起こるかを構成します。';

  @override
  String get analyticsTab => '分析';

  @override
  String get analyticsDescription => '分析プロバイダー、イベントログ、サンプリングレートを構成します。';

  @override
  String get analyticsSystemStatusTitle => '分析システムを有効化';

  @override
  String get analyticsSystemStatusDescription =>
      'すべての分析トラッキングを有効または無効にするマスタースイッチ。';

  @override
  String get analyticsProviderTitle => 'アクティブなプロバイダー';

  @override
  String get analyticsProviderDescription => '主要な分析サービスプロバイダーを選択します。';

  @override
  String get analyticsEventsTitle => 'イベント構成';

  @override
  String get analyticsEventsDescription =>
      '特定のイベントのログを微調整します。ノイズの多いイベントを無効にしたり、サンプリングレートを調整したりします。';

  @override
  String samplingRateLabel(int rate) {
    return 'サンプリングレート: $rate%';
  }

  @override
  String get analyticsProviderFirebase => 'Firebase';

  @override
  String get analyticsProviderMixpanel => 'Mixpanel';

  @override
  String get analyticsEventUserRegisteredLabel => 'ユーザー登録';

  @override
  String get analyticsEventUserRegisteredDescription =>
      '新しいユーザーがアカウントを正常に作成したときを追跡します。';

  @override
  String get analyticsEventUserLoginLabel => 'ユーザーログイン';

  @override
  String get analyticsEventUserLoginDescription =>
      'ユーザーがアプリケーションにログインしたときを追跡します。';

  @override
  String get analyticsEventAccountLinkedLabel => 'アカウントのリンク';

  @override
  String get analyticsEventAccountLinkedDescription =>
      'ゲストユーザーがアカウントを恒久的な認証情報にリンクしたときを追跡します。';

  @override
  String get analyticsEventUserRoleChangedLabel => 'ユーザーロールの変更';

  @override
  String get analyticsEventUserRoleChangedDescription =>
      'ユーザーのロールが更新されたとき（例：プレミアムにアップグレード）を追跡します。';

  @override
  String get analyticsEventContentViewedLabel => 'コンテンツの閲覧';

  @override
  String get analyticsEventContentViewedDescription =>
      'ユーザーが見出しや記事を閲覧したときを追跡します。';

  @override
  String get analyticsEventContentSharedLabel => 'コンテンツの共有';

  @override
  String get analyticsEventContentSharedDescription =>
      'ユーザーが外部プラットフォーム経由でコンテンツを共有したときを追跡します。';

  @override
  String get analyticsEventContentSavedLabel => 'コンテンツの保存';

  @override
  String get analyticsEventContentSavedDescription =>
      'ユーザーが見出しをブックマークしたときを追跡します。';

  @override
  String get analyticsEventContentUnsavedLabel => 'コンテンツの保存解除';

  @override
  String get analyticsEventContentUnsavedDescription =>
      'ユーザーがブックマークを削除したときを追跡します。';

  @override
  String get analyticsEventContentReadingTimeLabel => 'コンテンツの読了時間';

  @override
  String get analyticsEventContentReadingTimeDescription =>
      'ユーザーが記事を読むのに費やした時間を追跡します。';

  @override
  String get analyticsEventReactionCreatedLabel => 'リアクションの追加';

  @override
  String get analyticsEventReactionCreatedDescription =>
      'ユーザーがコンテンツにリアクションしたときを追跡します。';

  @override
  String get analyticsEventReactionDeletedLabel => 'リアクションの削除';

  @override
  String get analyticsEventReactionDeletedDescription =>
      'ユーザーがリアクションを削除したときを追跡します。';

  @override
  String get analyticsEventCommentCreatedLabel => 'コメントの投稿';

  @override
  String get analyticsEventCommentCreatedDescription =>
      'ユーザーが新しいコメントを送信したときを追跡します。';

  @override
  String get analyticsEventCommentDeletedLabel => 'コメントの削除';

  @override
  String get analyticsEventCommentDeletedDescription =>
      'ユーザーが自分のコメントを削除したときを追跡します。';

  @override
  String get analyticsEventReportSubmittedLabel => 'レポートの送信';

  @override
  String get analyticsEventReportSubmittedDescription =>
      'ユーザーがコンテンツや他のユーザーをレポートしたときを追跡します。';

  @override
  String get analyticsEventHeadlineFilterCreatedLabel => '見出しフィルターの作成';

  @override
  String get analyticsEventHeadlineFilterCreatedDescription =>
      'ユーザーが新しいカスタム見出しフィルターを作成したときを追跡します。';

  @override
  String get analyticsEventHeadlineFilterUpdatedLabel => '見出しフィルターの更新';

  @override
  String get analyticsEventHeadlineFilterUpdatedDescription =>
      'ユーザーが既存の見出しフィルターを変更したときを追跡します。';

  @override
  String get analyticsEventHeadlineFilterUsedLabel => '見出しフィルターの使用';

  @override
  String get analyticsEventHeadlineFilterUsedDescription =>
      'ユーザーが保存済みの見出しフィルターを適用したときを追跡します。';

  @override
  String get analyticsEventSearchPerformedLabel => '検索の実行';

  @override
  String get analyticsEventSearchPerformedDescription =>
      'ユーザーが検索クエリを実行したときを追跡します。';

  @override
  String get analyticsEventAppReviewPromptRespondedLabel => 'レビュープロンプトへの回答';

  @override
  String get analyticsEventAppReviewPromptRespondedDescription =>
      '内部の「アプリを楽しんでいますか？」プロンプトに対するユーザーの回答を追跡します。';

  @override
  String get analyticsEventAppReviewStoreRequestedLabel => 'ストアレビューのリクエスト';

  @override
  String get analyticsEventAppReviewStoreRequestedDescription =>
      'ネイティブOSのストアレビューダイアログがリクエストされたときを追跡します。';

  @override
  String get analyticsEventLimitExceededLabel => '制限超過';

  @override
  String get analyticsEventLimitExceededDescription =>
      'ユーザーが使用制限（例：保存アイテムの制限）に達したときを追跡します。';

  @override
  String get analyticsEventLimitExceededCtaClickedLabel => '制限CTAのクリック';

  @override
  String get analyticsEventLimitExceededCtaClickedDescription =>
      '制限ダイアログの「アップグレード」または「アカウントをリンク」ボタンのクリックを追跡します。';

  @override
  String get analyticsEventPaywallPresentedLabel => 'ペイウォールの表示';

  @override
  String get analyticsEventPaywallPresentedDescription =>
      'ペイウォール画面がユーザーに表示されたときを追跡します。';

  @override
  String get analyticsEventSubscriptionStartedLabel => 'サブスクリプションの開始';

  @override
  String get analyticsEventSubscriptionStartedDescription =>
      'ユーザーが新しいサブスクリプションを正常に開始したときを追跡します。';

  @override
  String get analyticsEventSubscriptionRenewedLabel => 'サブスクリプションの更新';

  @override
  String get analyticsEventSubscriptionRenewedDescription =>
      'サブスクリプションが自動または手動で更新されたときを追跡します。';

  @override
  String get analyticsEventSubscriptionCancelledLabel => 'サブスクリプションのキャンセル';

  @override
  String get analyticsEventSubscriptionCancelledDescription =>
      'ユーザーがサブスクリプションをキャンセルしたときを追跡します。';

  @override
  String get analyticsEventSubscriptionEndedLabel => 'サブスクリプションの終了';

  @override
  String get analyticsEventSubscriptionEndedDescription =>
      'サブスクリプションが期限切れになるか終了したときを追跡します。';

  @override
  String get analyticsEventAdImpressionLabel => '広告の表示';

  @override
  String get analyticsEventAdImpressionDescription => '広告がユーザーに表示されたときを追跡します。';

  @override
  String get analyticsEventAdClickedLabel => '広告のクリック';

  @override
  String get analyticsEventAdClickedDescription => 'ユーザーが広告をクリックしたときを追跡します。';

  @override
  String get analyticsEventAdLoadFailedLabel => '広告の読み込み失敗';

  @override
  String get analyticsEventAdLoadFailedDescription => '広告の読み込みを試みた際のエラーを追跡します。';

  @override
  String get analyticsEventAdRewardEarnedLabel => '広告リワードの獲得';

  @override
  String get analyticsEventAdRewardEarnedDescription =>
      'ユーザーがリワード広告のアクションを完了したときを追跡します。';

  @override
  String get analyticsEventThemeChangedLabel => 'テーマの変更';

  @override
  String get analyticsEventThemeChangedDescription =>
      'ユーザーがアプリケーションのテーマを変更したときを追跡します。';

  @override
  String get analyticsEventLanguageChangedLabel => '言語の変更';

  @override
  String get analyticsEventLanguageChangedDescription =>
      'ユーザーがアプリケーションの言語を変更したときを追跡します。';

  @override
  String get analyticsEventFeedDensityChangedLabel => 'フィード密度の変更';

  @override
  String get analyticsEventFeedDensityChangedDescription =>
      'ユーザーがフィードの情報密度を調整したときを追跡します。';

  @override
  String get analyticsEventBrowserChoiceChangedLabel => 'ブラウザ設定の変更';

  @override
  String get analyticsEventBrowserChoiceChangedDescription =>
      'ユーザーがリンクを開くための優先ブラウザを変更したときを追跡します。';

  @override
  String get analyticsEventAppTourStartedLabel => 'アプリツアーの開始';

  @override
  String get analyticsEventAppTourStartedDescription =>
      '認証前のアプリツアーが表示されたときを追跡します。';

  @override
  String get analyticsEventAppTourStepViewedLabel => 'アプリツアーのステップ閲覧';

  @override
  String get analyticsEventAppTourStepViewedDescription =>
      'アプリツアー内の各ページビューを追跡します。';

  @override
  String get analyticsEventAppTourCompletedLabel => 'アプリツアーの完了';

  @override
  String get analyticsEventAppTourCompletedDescription =>
      'ユーザーがアプリツアーを完了したときを追跡します。';

  @override
  String get analyticsEventAppTourSkippedLabel => 'アプリツアーのスキップ';

  @override
  String get analyticsEventAppTourSkippedDescription =>
      'ユーザーがアプリツアーをスキップしたかどうかを追跡します。';

  @override
  String get analyticsEventInitialPersonalizationStartedLabel => '初回パーソナライズの開始';

  @override
  String get analyticsEventInitialPersonalizationStartedDescription =>
      '認証後のパーソナライズフローが開始されたときを追跡します。';

  @override
  String get analyticsEventInitialPersonalizationStepViewedLabel =>
      'パーソナライズステップの閲覧';

  @override
  String get analyticsEventInitialPersonalizationStepViewedDescription =>
      'パーソナライズフロー内の各ステップビューを追跡します。';

  @override
  String get analyticsEventInitialPersonalizationCompletedLabel => 'パーソナライズの完了';

  @override
  String get analyticsEventInitialPersonalizationCompletedDescription =>
      'ユーザーがパーソナライズフローを完了したときを追跡します。';

  @override
  String get analyticsEventInitialPersonalizationSkippedLabel => 'パーソナライズのスキップ';

  @override
  String get analyticsEventInitialPersonalizationSkippedDescription =>
      'ユーザーがパーソナライズフローをスキップしたかどうかを追跡します。';

  @override
  String get timeFrameDay => '24時間';

  @override
  String get timeFrameWeek => '7日間';

  @override
  String get timeFrameMonth => '30日間';

  @override
  String get timeFrameYear => '1年間';

  @override
  String get noDataAvailable => 'データなし';

  @override
  String get vsPreviousPeriod => '前期間比';

  @override
  String get vsPreviousDay => '過去24時間比';

  @override
  String get vsPreviousWeek => '過去7日間比';

  @override
  String get vsPreviousMonth => '過去30日間比';

  @override
  String get vsPreviousYear => '前年比';

  @override
  String get kpiUsersTotalRegistered => '登録ユーザー総数';

  @override
  String get kpiUsersNewRegistrations => '新規登録数';

  @override
  String get kpiUsersActiveUsers => 'アクティブユーザー数';

  @override
  String get kpiContentHeadlinesTotalPublished => '公開済み見出し総数';

  @override
  String get kpiContentHeadlinesTotalViews => '見出し閲覧総数';

  @override
  String get kpiContentHeadlinesTotalLikes => '見出しいいね総数';

  @override
  String get kpiContentSourcesTotalSources => 'ソース総数';

  @override
  String get kpiContentSourcesNewSources => '新規ソース数';

  @override
  String get kpiContentSourcesTotalFollowers => 'ソースフォロワー総数';

  @override
  String get kpiContentTopicsTotalTopics => 'トピック総数';

  @override
  String get kpiContentTopicsNewTopics => '新規トピック数';

  @override
  String get kpiContentTopicsTotalFollowers => 'トピックフォロワー総数';

  @override
  String get kpiEngagementsTotalReactions => 'リアクション総数';

  @override
  String get kpiEngagementsTotalComments => 'コメント総数';

  @override
  String get kpiEngagementsAverageEngagementRate => '平均エンゲージメント率';

  @override
  String get kpiEngagementsReportsPending => '保留中のレポート';

  @override
  String get kpiEngagementsReportsResolved => '解決済みのレポート';

  @override
  String get kpiEngagementsReportsAverageResolutionTime => '平均解決時間';

  @override
  String get kpiEngagementsAppReviewsTotalFeedback => 'フィードバック総数';

  @override
  String get kpiEngagementsAppReviewsPositiveFeedback => 'ポジティブなフィードバック';

  @override
  String get kpiEngagementsAppReviewsStoreRequests => 'ストアレビューリクエスト数';

  @override
  String get chartUsersRegistrationsOverTime => '登録数の推移';

  @override
  String get chartUsersActiveUsersOverTime => 'アクティブユーザーの傾向';

  @override
  String get chartUsersRoleDistribution => 'ユーザーロールの分布';

  @override
  String get chartContentHeadlinesViewsOverTime => '見出し閲覧数の傾向';

  @override
  String get chartContentHeadlinesLikesOverTime => '見出しいいね数の傾向';

  @override
  String get chartContentHeadlinesViewsByTopic => 'トピック別の閲覧数';

  @override
  String get chartContentSourcesHeadlinesPublishedOverTime => 'ソースのアクティビティ';

  @override
  String get chartContentSourcesFollowersOverTime => 'ソースフォロワーの成長';

  @override
  String get chartContentSourcesEngagementByType => 'ソースタイプ別のエンゲージメント';

  @override
  String get chartContentTopicsFollowersOverTime => 'トピックフォロワーの成長';

  @override
  String get chartContentTopicsHeadlinesPublishedOverTime => 'トピックのアクティビティ';

  @override
  String get chartContentTopicsEngagementByTopic => 'トピック別のエンゲージメント';

  @override
  String get chartEngagementsReactionsOverTime => 'リアクションの傾向';

  @override
  String get chartEngagementsCommentsOverTime => 'コメントの傾向';

  @override
  String get chartEngagementsReactionsByType => 'リアクションの分布';

  @override
  String get chartEngagementsReportsSubmittedOverTime => '送信されたレポート';

  @override
  String get chartEngagementsReportsResolutionTimeOverTime => '解決時間の傾向';

  @override
  String get chartEngagementsReportsByReason => '理由別のレポート';

  @override
  String get chartEngagementsAppReviewsFeedbackOverTime => 'フィードバックの傾向';

  @override
  String get chartEngagementsAppReviewsPositiveVsNegative => 'センチメント分析';

  @override
  String get chartEngagementsAppReviewsStoreRequestsOverTime => 'ストアリクエストの傾向';

  @override
  String get chartContentSourcesStatusDistribution => 'ソースステータスの分布';

  @override
  String get chartContentHeadlinesBreakingNewsDistribution => '速報の分布';

  @override
  String get chartOverviewAppTourFunnel => 'アプリツアーのファンネル';

  @override
  String get chartOverviewInitialPersonalizationFunnel => '初回パーソナライズのファンネル';

  @override
  String get rankedListOverviewHeadlinesMostViewed => '閲覧数の多い見出し';

  @override
  String get rankedListOverviewHeadlinesMostLiked => 'いいねの多い見出し';

  @override
  String get rankedListOverviewSourcesMostFollowed => 'フォロワーの多いソース';

  @override
  String get rankedListOverviewTopicsMostFollowed => 'フォロワーの多いトピック';

  @override
  String get subscriptionTab => 'サブスクリプション';

  @override
  String get subscriptionDescription =>
      'ユーザーに提供されるサブスクリプションプラン（例：月額、年額）を構成します。有効にすると、機能制限に達したユーザーにプレミアム層へのアップグレードが促されます。';

  @override
  String get enableSubscriptionLabel => 'サブスクリプション機能を有効化';

  @override
  String get enableSubscriptionDescription =>
      'サブスクリプションシステムのマスタースイッチ。有効にすると、ユーザーはプランを購入してアクセス層をアップグレード（例：標準からプレミアムへ）できます。';

  @override
  String get monthlyPlanTitle => '月額プラン';

  @override
  String get annualPlanTitle => '年額プラン';

  @override
  String get planEnabledLabel => 'プランを有効化';

  @override
  String get planRecommendedLabel => 'おすすめプラン';

  @override
  String get planRecommendedDescription => 'このプランを最もお得なオプションとして強調します。';

  @override
  String get appleProductIdLabel => 'Apple App Store製品ID';

  @override
  String get googleProductIdLabel => 'Google Playストア製品ID';

  @override
  String get subscriptionPlanEnablementError =>
      'このプランを有効にするには、少なくとも1つの製品IDを入力してください。';

  @override
  String get subscriptionPlanDisabledNotification =>
      '製品IDが提供されていないため、プランは無効になっています。';

  @override
  String get subscriptionFeatureDisabledNotification =>
      'アクティブなプランがないため、サブスクリプション機能は無効になっています。';

  @override
  String get pushNotificationFeatureDisabledNotification =>
      'アクティブな配信タイプがないため、プッシュ通知システムは無効になっています。';

  @override
  String get analyticsFeatureDisabledNotification =>
      'すべてのイベントが無効になっているため、分析システムは無効になっています。';

  @override
  String get reportingFeatureDisabledNotification =>
      'レポートオプションがアクティブでないため、レポートシステムは無効になっています。';

  @override
  String get appReviewFeatureDisabledNotification =>
      'ポジティブなインタラクションが選択されていないため、アプリレビューシステムは無効になっています。';

  @override
  String get subscriptionsName => 'サブスクリプション';

  @override
  String get subscriptionProvider => 'ストアプロバイダー';

  @override
  String get accessTier => 'アクセス層';

  @override
  String get expiryDate => '有効期限';

  @override
  String get willAutoRenew => '自動更新';

  @override
  String get allAccessTiers => 'すべての層';

  @override
  String get subscriptionActionCopyUserId => 'ユーザーIDをコピー';

  @override
  String get subscriptionActionCopySubscriptionId => 'サブスクリプションIDをコピー';

  @override
  String get filterSubscriptions => 'サブスクリプションをフィルター';

  @override
  String get selectStatus => 'ステータスを選択';

  @override
  String get selectProvider => 'プロバイダーを選択';

  @override
  String get selectTier => '層を選択';

  @override
  String get noSubscriptionsFound => 'サブスクリプションが見つかりませんでした。';

  @override
  String get loadingSubscriptions => 'サブスクリプションを読み込み中';

  @override
  String get searchByUserIdOrSubscriptionId => 'ユーザーIDまたはサブスクリプションIDで検索...';

  @override
  String get subscriptionsPageDescription =>
      'ユーザーのサブスクリプションステータスを監視するための読み取り専用インターフェースを提供します。購入、更新、キャンセルなどのすべてのライフサイクルイベントは、Apple App StoreおよびGoogle PlayとのWebhook同期を通じてバックエンドによって自動的に処理されます。このダッシュボードは、金融取引を開始または管理しません。';

  @override
  String get subscriptionStatusActive => 'アクティブ';

  @override
  String get subscriptionStatusGracePeriod => '猶予期間';

  @override
  String get subscriptionStatusBillingIssue => '請求の問題';

  @override
  String get subscriptionStatusCanceled => 'キャンセル済み';

  @override
  String get subscriptionStatusExpired => '期限切れ';

  @override
  String get storeProviderApple => 'Apple';

  @override
  String get storeProviderGoogle => 'Google';

  @override
  String get chartSubscriptionsActiveOverTime => 'アクティブなサブスクリプションの推移';

  @override
  String get chartSubscriptionsStatusDistribution => 'サブスクリプションステータスの分布';

  @override
  String get chartSubscriptionsByStoreProvider => 'ストア別のサブスクリプション';

  @override
  String get kpiRewardsAdsWatchedTotal => '広告視聴総数';

  @override
  String get kpiRewardsActiveUsersCount => 'アクティブなリワードユーザー';

  @override
  String get rewardsTab => 'リワード';

  @override
  String get rewardsDescription => 'ユーザーエンゲージメントに対する時間ベースのリワードを構成します。';

  @override
  String get enableRewardsLabel => 'リワードシステムを有効化';

  @override
  String get enableRewardsDescription => 'ユーザーが広告を視聴することでリワードを獲得できるようにします。';

  @override
  String get rewardTypeAdFree => '広告なし体験';

  @override
  String get rewardDurationDaysLabel => '期間（日数）';

  @override
  String get rewardEnabledLabel => '有効';

  @override
  String get chartRewardsAdsWatchedOverTime => '広告視聴数の傾向';

  @override
  String get chartRewardsActiveByType => 'タイプ別のアクティブなリワード';

  @override
  String get feedDecoratorUnlockRewardsDescription =>
      'プレミアム機能を一時的にロック解除するために広告を視聴するようユーザーに促します。';

  @override
  String get rewardDurationDaysDescription => 'リワードがアクティブなままである日数。';

  @override
  String get rewardsManagement => 'リワード管理';

  @override
  String get rewardsManagementPageDescription => 'ユーザーのリワードと権利を管理します。';

  @override
  String get loadingRewards => 'リワードを読み込み中';

  @override
  String get noRewardsFound => 'リワードが見つかりませんでした。';

  @override
  String get userId => 'ユーザーID';

  @override
  String get activeRewards => 'アクティブなリワード';

  @override
  String get expiry => '期限';

  @override
  String get filterRewards => 'リワードをフィルター';

  @override
  String get rewardType => 'リワードタイプ';

  @override
  String get selectRewardTypes => 'リワードタイプを選択';

  @override
  String get loadingAnalytics => '分析を読み込み中';

  @override
  String get noAnalyticsDataHeadline => '分析データなし';

  @override
  String get noAnalyticsDataSubheadline => '表示するデータはまだありません。後で確認してください。';

  @override
  String get androidAdUnitsTitle => 'Android広告ユニット';

  @override
  String get iosAdUnitsTitle => 'iOS広告ユニット';

  @override
  String get rewardedAdIdLabel => 'リワード広告ID';

  @override
  String get rewardedAdIdDescription => 'リワード広告のユニットID。';

  @override
  String get kpiRewardsGrantedTotal => '付与されたリワード総数';

  @override
  String get analyticsEventRewardsHubViewedLabel => 'リワードハブの閲覧';

  @override
  String get analyticsEventRewardsHubViewedDescription =>
      'ユーザーがリワードハブを閲覧したときを追跡します。';

  @override
  String get analyticsEventRewardOfferClickedLabel => 'リワードオファーのクリック';

  @override
  String get analyticsEventRewardOfferClickedDescription =>
      'ユーザーが特定のリワードオファーをクリックしたときを追跡します。';

  @override
  String get analyticsEventRewardGrantedLabel => 'リワードの付与';

  @override
  String get analyticsEventRewardGrantedDescription =>
      'ユーザーにリワードが正常に発行されたときを追跡します。';

  @override
  String get chartRewardsGrantedOverTime => '付与されたリワードの傾向';

  @override
  String get android => 'Android';

  @override
  String get ios => 'iOS';

  @override
  String get initialPersonalizationTitle => '初回パーソナライズ';

  @override
  String get initialPersonalizationDescription =>
      '国、トピック、ソースの選択を含む、新規ユーザー向けのオンボーディングフローを構成します。';

  @override
  String get enableInitialPersonalizationLabel => '初回パーソナライズを有効化';

  @override
  String get enableInitialPersonalizationDescription =>
      '有効にすると、新規ユーザーは登録後にパーソナライズフローに案内されます。';

  @override
  String get enableCountrySelectionLabel => '国の選択を有効化';

  @override
  String get enableCountrySelectionDescription =>
      'オンボーディング中にユーザーが国を選択できるようにします。';

  @override
  String get enableTopicSelectionLabel => 'トピックの選択を有効化';

  @override
  String get enableTopicSelectionDescription =>
      'オンボーディング中にユーザーが興味のあるトピックを選択できるようにします。';

  @override
  String get enableSourceSelectionLabel => 'ソースの選択を有効化';

  @override
  String get enableSourceSelectionDescription =>
      'オンボーディング中にユーザーがフォローするニュースソースを選択できるようにします。';

  @override
  String get minSelectionsRequiredLabel => '必須の最小選択数';

  @override
  String get minSelectionsRequiredDescription =>
      '続行するために、有効なすべてのカテゴリにわたってユーザーが選択する必要があるアイテムの総数。';

  @override
  String get onboardingTitle => 'オンボーディング';

  @override
  String get onboardingDescription => 'アプリツアーや初回パーソナライズを含む、初回ユーザー体験を管理します。';

  @override
  String get enableOnboardingLabel => 'オンボーディングを有効化';

  @override
  String get enableOnboardingDescription =>
      'オンボーディングフロー全体（アプリツアーと初回パーソナライズ）を有効または無効にするマスタースイッチ。';

  @override
  String get appTourTitle => 'アプリツアー';

  @override
  String get appTourDescription => '新規ユーザーに表示される認証前のツアーを構成します。';

  @override
  String get enableAppTourLabel => 'アプリツアーを有効化';

  @override
  String get enableAppTourDescription =>
      '有効にすると、ユーザーがログインする前にアプリの機能の簡単なツアーが表示されます。';

  @override
  String get skippableAppTourLabel => 'スキップ可能なアプリツアー';

  @override
  String get skippableAppTourDescription =>
      '有効にすると、ユーザーはアプリツアーをスキップするオプションを利用できます。';

  @override
  String get skippableInitialPersonalizationLabel => 'スキップ可能なパーソナライズ';

  @override
  String get skippableInitialPersonalizationDescription =>
      '有効にすると、ユーザーはパーソナライズフローをスキップするオプションを利用できます。';

  @override
  String get filePickingErrorMessage => 'ファイルの選択中にエラーが発生しました。';

  @override
  String get removeImage => '画像を削除';

  @override
  String get clickToUploadImage => 'クリックして画像をアップロード';

  @override
  String get processingImage => '画像を処理中...';

  @override
  String get processingImageDescription => '画像を最適化しています。まもなく表示されます。';

  @override
  String get chartMediaUploadsOverTime => 'アップロード数の推移';

  @override
  String get chartMediaUploadsByPurpose => '目的別のアップロード';

  @override
  String get chartMediaUploadsSuccessVsFailure => 'アップロードの成功と失敗';

  @override
  String get kpiMediaTotalUploads => 'アップロード総数';

  @override
  String get kpiMediaFailedUploads => '失敗したアップロード数';

  @override
  String get kpiMediaAverageUploadTime => '平均アップロード時間（秒）';

  @override
  String get updateHeadlineTitle => '見出しを更新';

  @override
  String get updateHeadlineMessage => 'これらの変更を公開しますか、それともアップデートを下書きとして保存しますか？';

  @override
  String get analyticsEventMediaUploadStartedLabel => 'メディアアップロードの開始';

  @override
  String get analyticsEventMediaUploadStartedDescription =>
      'ユーザーがファイルのアップロードを開始したときを追跡します。';

  @override
  String get analyticsEventMediaUploadCompletedLabel => 'メディアアップロードの完了';

  @override
  String get analyticsEventMediaUploadCompletedDescription =>
      'ファイルのアップロードが正常に完了したときを追跡します。';

  @override
  String get analyticsEventMediaUploadFailedLabel => 'メディアアップロードの失敗';

  @override
  String get analyticsEventMediaUploadFailedDescription =>
      'ファイルのアップロードが失敗したときを追跡します。';

  @override
  String get dashboard => 'ダッシュボード';

  @override
  String get aboutOverviewPageTitle => '概要ページについて';

  @override
  String get aboutOverviewPageDescription =>
      'このページでは、主要なアプリケーション指標のハイレベルな概要を提供します。表示されている統計はライブではありません。バックエンドによって定期的に更新されます。更新間隔はサーバー側で構成されます。';

  @override
  String get audience => 'オーディエンス';

  @override
  String get content => 'コンテンツ';

  @override
  String get community => 'コミュニティ';

  @override
  String get monetization => '収益化';

  @override
  String get configuration => '設定';

  @override
  String get loadingConfiguration => '設定を読み込み中...';

  @override
  String get noConfigurationDataHeadline => '設定データなし';

  @override
  String get noConfigurationDataSubheadline => 'アプリケーションのリモート設定を読み込めませんでした。';

  @override
  String get readOnlyConfigurationView => '読み取り専用設定ビュー';

  @override
  String get readOnlyConfigurationViewDescription =>
      'これは、アプリケーションの運用設定のリアルタイムで読み取り専用のスナップショットです。変更を加えるには、メインの「リモート設定」ページに移動してください。';

  @override
  String get providers => 'プロバイダー';

  @override
  String get summary => 'サマリー';

  @override
  String get about => '詳細';

  @override
  String get localizationConfigDescription =>
      'サポートされている言語とデフォルトのフォールバックを構成します。';

  @override
  String get enabledLanguagesLabel => '有効な言語';

  @override
  String get cannotDisableDefaultLanguage => 'デフォルト言語を無効にすることはできません。';

  @override
  String get atLeastOneLanguageRequired => '少なくとも1つの言語を有効にする必要があります。';

  @override
  String get defaultLanguageLabel => 'デフォルト言語';

  @override
  String get defaultLanguageDescription => 'ユーザーの好みがサポートされていない場合のフォールバック言語。';

  @override
  String get localizationTitle => 'ローカライズ';

  @override
  String get localizationDescription =>
      'モバイルアプリとダッシュボードのアクティブな言語を制御します。言語を有効にすると、ユーザーは翻訳されたコンテンツを表示できるようになり、ダッシュボードのフォームに対応する入力フィールドが追加されます。コンテンツのない翻訳はデフォルト言語にフォールバックします。';

  @override
  String defaultLanguageRequired(String language) {
    return 'デフォルト言語（$language）は必須です。';
  }

  @override
  String get languageNameEn => '英語';

  @override
  String get languageNameEs => 'スペイン語';

  @override
  String get languageNameFr => 'フランス語';

  @override
  String get languageNameAr => 'アラビア語';

  @override
  String get languageNamePt => 'ポルトガル語';

  @override
  String get languageNameDe => 'ドイツ語';

  @override
  String get languageNameIt => 'イタリア語';

  @override
  String get languageNameZh => '中国語';

  @override
  String get languageNameHi => 'ヒンディー語';

  @override
  String get languageNameJa => '日本語';
}
