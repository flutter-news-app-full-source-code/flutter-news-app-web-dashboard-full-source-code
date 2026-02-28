// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get authenticationPageHeadline => '仪表盘访问';

  @override
  String get authenticationPageSubheadline => '管理员和发布者的安全登录。';

  @override
  String get authenticationEmailSignInButton => '使用邮箱登录';

  @override
  String get emailSignInPageTitle => '安全邮箱登录';

  @override
  String get requestCodePageHeadline => '安全邮箱登录';

  @override
  String get requestCodePageSubheadline => '输入您的授权邮箱以接收安全登录验证码。';

  @override
  String get requestCodeEmailLabel => '电子邮箱';

  @override
  String get requestCodeEmailHint => 'your.email@example.com';

  @override
  String get accountLinkingEmailValidationError => '请输入有效的电子邮箱地址。';

  @override
  String get requestCodeSendCodeButton => '发送验证码';

  @override
  String requestCodeResendButtonCooldown(int seconds) {
    return '$seconds秒后重发';
  }

  @override
  String get emailCodeSentPageTitle => '验证代码';

  @override
  String emailCodeSentConfirmation(String email) {
    return '我们已向 $email 发送了一个 6 位验证码';
  }

  @override
  String get emailCodeSentInstructions => '请检查您的收件箱并输入下方的验证码以继续。';

  @override
  String demoVerificationCodeMessage(String code) {
    return '在演示模式下，请使用代码：$code';
  }

  @override
  String get emailCodeVerificationHint => '6 位验证码';

  @override
  String get emailCodeValidationEmptyError => '验证码不能为空。';

  @override
  String get emailCodeValidationLengthError => '验证码必须为 6 位。';

  @override
  String get emailCodeVerificationButtonLabel => '验证代码';

  @override
  String get overview => '概览';

  @override
  String get contentManagement => '内容管理';

  @override
  String get contentManagementPageDescription => '管理移动应用程序的新闻头条、话题和来源。';

  @override
  String get headlines => '头条新闻';

  @override
  String get headline => '头条';

  @override
  String get topics => '话题';

  @override
  String get topic => '话题';

  @override
  String get sources => '来源';

  @override
  String get source => '来源';

  @override
  String get appConfiguration => '远程配置';

  @override
  String get appConfigurationPageDescription => '管理移动应用的全局设置，从内容限制到运营状态。';

  @override
  String get settings => '设置';

  @override
  String get appConfigurationPageTitle => '远程配置';

  @override
  String get feedTab => '信息流';

  @override
  String get advertisementsTab => '广告';

  @override
  String get systemTab => '系统';

  @override
  String get userContentLimitsTitle => '用户内容限制';

  @override
  String get userContentLimitsDescription => '为每个用户层级设置关注项目和保存头条的限制。';

  @override
  String get feedActionsTitle => '信息流操作';

  @override
  String get feedActionsDescription => '配置在信息流中插入操作组件（如“评价应用”）的频率。';

  @override
  String get feedDecoratorsTitle => '信息流装饰器';

  @override
  String get feedDecoratorsDescription => '为不同的用户角色配置内容在信息流中的装饰和呈现方式。';

  @override
  String get adSettingsTitle => '广告设置';

  @override
  String get adSettingsDescription => '管理不同用户角色的广告频率和投放位置。';

  @override
  String get maintenanceModeTitle => '维护模式';

  @override
  String get maintenanceModeDescription => '启用后向所有用户显示维护界面。';

  @override
  String get forceUpdateTitle => '强制应用更新';

  @override
  String get forceUpdateDescription => '为用户配置强制性的应用更新。';

  @override
  String get forceUpdateTab => '强制更新';

  @override
  String get appConfigSaveSuccessMessage => '远程配置保存成功。移动客户端将在下次启动时更新。';

  @override
  String appConfigSaveErrorMessage(String errorMessage) {
    return '错误：$errorMessage';
  }

  @override
  String get unknownError => '未知错误';

  @override
  String get loadingConfigurationHeadline => '正在加载配置';

  @override
  String get loadingConfigurationSubheadline => '正在加载设置，请稍候...';

  @override
  String get failedToLoadConfigurationMessage => '加载配置失败。';

  @override
  String get loadAppSettingsSubheadline => '从后端加载应用设置。';

  @override
  String get discardChangesButton => '放弃更改';

  @override
  String get saveChangesButton => '保存更改';

  @override
  String get confirmConfigUpdateDialogTitle => '确认配置更新';

  @override
  String get confirmConfigUpdateDialogContent =>
      '您确定要将这些更改应用于实时应用配置吗？这是一项关键操作。';

  @override
  String get cancelButton => '取消';

  @override
  String get confirmSaveButton => '确认保存';

  @override
  String get guestUserTab => '访客';

  @override
  String get authenticatedUserTab => '已认证';

  @override
  String get premiumUserTab => '高级用户';

  @override
  String get guestFollowedItemsLimitLabel => '访客关注项目限制';

  @override
  String get guestFollowedItemsLimitDescription =>
      '访客用户可以关注的国家、新闻来源或话题的最大数量（每种类型都有自己的限制）。';

  @override
  String get guestSavedHeadlinesLimitLabel => '访客保存头条限制';

  @override
  String get guestSavedHeadlinesLimitDescription => '访客用户可以保存的头条新闻的最大数量。';

  @override
  String get standardUserFollowedItemsLimitLabel => '标准用户关注项目限制';

  @override
  String get standardUserFollowedItemsLimitDescription =>
      '标准用户可以关注的国家、新闻来源或话题的最大数量。';

  @override
  String get standardUserSavedHeadlinesLimitLabel => '标准用户保存头条限制';

  @override
  String get standardUserSavedHeadlinesLimitDescription =>
      '标准用户可以保存的头条新闻的最大数量。';

  @override
  String get premiumFollowedItemsLimitLabel => '高级用户关注项目限制';

  @override
  String get premiumFollowedItemsLimitDescription =>
      '高级用户可以关注的国家、新闻来源或话题的最大数量。';

  @override
  String get premiumSavedHeadlinesLimitLabel => '高级用户保存头条限制';

  @override
  String get premiumSavedHeadlinesLimitDescription => '高级用户可以保存的头条新闻的最大数量。';

  @override
  String get standardUserAdTab => '标准用户';

  @override
  String get guestAdFrequencyLabel => '访客广告频率';

  @override
  String get guestAdFrequencyDescription =>
      '访客用户出现广告的频率（例如，值为 5 表示每 5 条新闻后可能放置一个广告）。';

  @override
  String get guestAdPlacementIntervalLabel => '访客广告投放间隔';

  @override
  String get guestAdPlacementIntervalDescription =>
      '在向访客用户显示第一个广告之前必须显示的最小新闻条数。';

  @override
  String get guestArticlesBeforeInterstitialAdsLabel => '访客插屏广告前文章数';

  @override
  String get guestArticlesBeforeInterstitialAdsDescription =>
      '访客用户在显示全屏插屏广告之前需要阅读的文章数量。';

  @override
  String get standardUserAdFrequencyLabel => '标准用户广告频率';

  @override
  String get standardUserAdFrequencyDescription =>
      '标准用户出现广告的频率（例如，值为 10 表示每 10 条新闻后可能放置一个广告）。';

  @override
  String get standardUserAdPlacementIntervalLabel => '标准用户广告投放间隔';

  @override
  String get standardUserAdPlacementIntervalDescription =>
      '在向标准用户显示第一个广告之前必须显示的最小新闻条数。';

  @override
  String get standardUserArticlesBeforeInterstitialAdsLabel => '标准用户插屏广告前文章数';

  @override
  String get standardUserArticlesBeforeInterstitialAdsDescription =>
      '标准用户在显示全屏插屏广告之前需要阅读的文章数量。';

  @override
  String get premiumAdFrequencyLabel => '高级用户广告频率';

  @override
  String get premiumAdFrequencyDescription => '高级用户出现广告的频率（0 表示无广告）。';

  @override
  String get premiumAdPlacementIntervalLabel => '高级用户广告投放间隔';

  @override
  String get premiumAdPlacementIntervalDescription =>
      '在向高级用户显示第一个广告之前必须显示的最小新闻条数。';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsLabel => '高级用户插屏广告前文章数';

  @override
  String get premiumUserArticlesBeforeInterstitialAdsDescription =>
      '高级用户在显示全屏插屏广告之前需要阅读的文章数量。';

  @override
  String get appOperationalStatusWarning => '警告：更改应用的运营状态会影响所有用户。请极其谨慎地使用。';

  @override
  String get appOperationalStatusLabel => '应用运营状态';

  @override
  String get appOperationalStatusDescription => '应用的当前运营状态（例如：激活、维护、禁用）。';

  @override
  String get maintenanceMessageLabel => '维护消息';

  @override
  String get maintenanceMessageDescription => '应用处于维护模式时显示的消息。';

  @override
  String get disabledMessageLabel => '禁用消息';

  @override
  String get disabledMessageDescription => '应用被永久禁用时显示的消息。';

  @override
  String get forceUpdateConfigurationTitle => '强制更新配置';

  @override
  String get minAllowedAppVersionLabel => '允许的最低应用版本';

  @override
  String get minAllowedAppVersionDescription => '允许运行的最低应用版本（例如：\"1.2.0\"）。';

  @override
  String get latestAppVersionLabel => '最新应用版本';

  @override
  String get latestAppVersionDescription => '最新的可用应用版本（例如：\"1.5.0\"）。';

  @override
  String get updateRequiredMessageLabel => '需要更新消息';

  @override
  String get updateRequiredMessageDescription => '需要强制更新时显示的消息。';

  @override
  String get updateOptionalMessageLabel => '可选更新消息';

  @override
  String get updateOptionalMessageDescription => '可选更新时显示的消息。';

  @override
  String get iosStoreUrlLabel => 'iOS 商店 URL';

  @override
  String get iosStoreUrlDescription => '应用在 Apple App Store 上的链接。';

  @override
  String get androidStoreUrlLabel => 'Android 商店 URL';

  @override
  String get androidUpdateUrlDescription => '应用在 Google Play 商店 上的链接。';

  @override
  String get guestDaysBetweenInAppPromptsLabel => '访客应用内提示间隔天数';

  @override
  String get guestDaysBetweenInAppPromptsDescription =>
      '访客用户看到另一个应用内提示之前必须经过的最少天数。';

  @override
  String get standardUserDaysBetweenInAppPromptsLabel => '标准用户应用内提示间隔天数';

  @override
  String get standardUserDaysBetweenInAppPromptsDescription =>
      '标准用户看到另一个应用内提示之前必须经过的最少天数。';

  @override
  String get signOut => '退出登录';

  @override
  String get settingsSavedSuccessfully => '设置保存成功！';

  @override
  String settingsSaveErrorMessage(String errorMessage) {
    return '保存设置时出错：$errorMessage';
  }

  @override
  String get loadingSettingsHeadline => '正在加载设置';

  @override
  String get loadingSettingsSubheadline => '正在加载您的设置，请稍候...';

  @override
  String failedToLoadSettingsMessage(String errorMessage) {
    return '加载设置失败：$errorMessage';
  }

  @override
  String get baseThemeLabel => '基础主题';

  @override
  String get baseThemeDescription => '选择应用的整体浅色或深色外观。';

  @override
  String get lightTheme => '浅色';

  @override
  String get darkTheme => '深色';

  @override
  String get systemTheme => '系统默认';

  @override
  String get accentThemeLabel => '强调色主题';

  @override
  String get accentThemeDescription => '为交互元素选择主要的强调色。';

  @override
  String get defaultBlueTheme => '默认蓝';

  @override
  String get newsRedTheme => '新闻红';

  @override
  String get graphiteGrayTheme => '石墨灰';

  @override
  String get fontFamilyLabel => '字体系列';

  @override
  String get fontFamilyDescription => '选择整个应用程序中使用的字体。';

  @override
  String get systemDefaultFont => '系统默认';

  @override
  String get textScaleFactorLabel => '文字大小';

  @override
  String get textScaleFactorDescription => '调整应用中文字的整体大小。';

  @override
  String get smallText => '小';

  @override
  String get mediumText => '中';

  @override
  String get largeText => '大';

  @override
  String get extraLargeText => '特大';

  @override
  String get fontWeightLabel => '字重';

  @override
  String get fontWeightDescription => '选择文字的粗细。';

  @override
  String get lightFontWeight => '细体';

  @override
  String get regularFontWeight => '常规';

  @override
  String get boldFontWeight => '粗体';

  @override
  String get languageLabel => '语言';

  @override
  String get languageDescription => '选择应用程序语言。';

  @override
  String get edit => '编辑';

  @override
  String get englishLanguage => '英语';

  @override
  String get arabicLanguage => '阿拉伯语';

  @override
  String get appearanceSettingsLabel => '外观';

  @override
  String get languageSettingsLabel => '语言';

  @override
  String get themeSettingsLabel => '主题设置';

  @override
  String get fontSettingsLabel => '字体设置';

  @override
  String get settingsPageDescription => '配置仪表盘界面的个人偏好，包括视觉呈现和语言选择。';

  @override
  String get appearanceSettingsDescription => '调整仪表盘的视觉特征，包括主题、强调色和排版样式。';

  @override
  String get loadingHeadlines => '正在加载头条';

  @override
  String get pleaseWait => '请稍候...';

  @override
  String get noHeadlinesFound => '未找到头条新闻。';

  @override
  String get headlineTitle => '标题';

  @override
  String get excerpt => '摘要';

  @override
  String get countryName => '国家';

  @override
  String get publishedAt => '发布于';

  @override
  String get actions => '操作';

  @override
  String get unknown => '未知';

  @override
  String get loadingTopics => '正在加载话题';

  @override
  String get noTopicsFound => '未找到话题。';

  @override
  String get topicName => '话题';

  @override
  String get description => '描述';

  @override
  String get notAvailable => '不适用';

  @override
  String get loadingSources => '正在加载来源';

  @override
  String get noSourcesFound => '未找到来源。';

  @override
  String get sourceName => '来源';

  @override
  String get sourceType => '类型';

  @override
  String get language => '语言';

  @override
  String get editTopic => '编辑话题';

  @override
  String get saveChanges => '保存更改';

  @override
  String get loadingTopic => '正在加载话题';

  @override
  String get icon => '图标';

  @override
  String get topicUpdatedSuccessfully => '话题更新成功。';

  @override
  String get cannotUpdateTopicError => '无法更新：原始话题数据未加载。';

  @override
  String get createTopic => '创建话题';

  @override
  String get topicCreatedSuccessfully => '话题创建成功。';

  @override
  String get editSource => '编辑来源';

  @override
  String get sourceUpdatedSuccessfully => '来源更新成功。';

  @override
  String get loadingSource => '正在加载来源...';

  @override
  String get sourceUrl => 'URL';

  @override
  String get headquarters => '总部';

  @override
  String get none => '无';

  @override
  String get cannotUpdateSourceError => '无法更新：原始来源数据未加载。';

  @override
  String get sourceTypeNewsAgency => '通讯社';

  @override
  String get sourceTypeLocalNewsOutlet => '地方新闻媒体';

  @override
  String get sourceTypeNationalNewsOutlet => '国家新闻媒体';

  @override
  String get sourceTypeInternationalNewsOutlet => '国际新闻媒体';

  @override
  String get sourceTypeSpecializedPublisher => '专业出版商';

  @override
  String get sourceTypeBlog => '博客';

  @override
  String get sourceTypeGovernmentSource => '政府来源';

  @override
  String get sourceTypeAggregator => '聚合器';

  @override
  String get sourceTypeOther => '其他';

  @override
  String get editHeadline => '编辑头条';

  @override
  String get headlineUpdatedSuccessfully => '头条更新成功。';

  @override
  String get loadingHeadline => '正在加载头条...';

  @override
  String get image => '图片';

  @override
  String get cannotUpdateHeadlineError => '无法更新：原始头条数据未加载。';

  @override
  String get createHeadline => '创建头条';

  @override
  String get headlineCreatedSuccessfully => '头条创建成功。';

  @override
  String get loadingData => '正在加载数据...';

  @override
  String get loadingFullList => '正在加载完整列表...';

  @override
  String get createSource => '创建来源';

  @override
  String get updateSourceTitle => '更新来源';

  @override
  String get updateSourceMessage => '您想发布这些更改还是将更新保存为草稿？';

  @override
  String get sourceCreatedSuccessfully => '来源创建成功。';

  @override
  String get updateTopicTitle => '更新话题';

  @override
  String get status => '状态';

  @override
  String get updateTopicMessage => '您想发布这些更改还是将更新保存为草稿？';

  @override
  String get lastUpdated => '最后更新';

  @override
  String get contentStatusActive => '激活';

  @override
  String get contentStatusArchived => '已归档';

  @override
  String get contentStatusDraft => '草稿';

  @override
  String get totalHeadlines => '头条总数';

  @override
  String get totalTopics => '话题总数';

  @override
  String get totalSources => '来源总数';

  @override
  String get loadingOverview => '正在加载仪表盘概览...';

  @override
  String get loadingOverviewSubheadline => '正在获取最新统计数据...';

  @override
  String get overviewLoadFailure => '加载仪表盘概览数据失败。';

  @override
  String get recentHeadlines => '最近头条';

  @override
  String get viewAll => '查看全部';

  @override
  String get noRecentHeadlines => '没有最近的头条新闻可显示。';

  @override
  String get systemStatus => '系统状态';

  @override
  String get quickActions => '快速操作';

  @override
  String get createHeadlineAction => '创建头条';

  @override
  String get manageContentAction => '管理内容';

  @override
  String get appConfigAction => '应用配置';

  @override
  String get appStatusActive => '激活';

  @override
  String get appStatusDisabled => '已禁用';

  @override
  String demoEmailHint(String email) {
    return '演示模式请使用邮箱：$email';
  }

  @override
  String demoCodeHint(String code) {
    return '演示模式请使用代码：$code';
  }

  @override
  String get appStatusMaintenance => '维护中';

  @override
  String get appStatusOperational => '运营中';

  @override
  String get isUnderMaintenanceLabel => '维护中';

  @override
  String get isUnderMaintenanceDescription => '切换以使移动应用进入维护模式，阻止用户访问。';

  @override
  String get isLatestVersionOnlyLabel => '强制仅限最新版本';

  @override
  String get isLatestVersionOnlyDescription => '如果启用，用户必须更新到最新的应用版本才能继续使用应用。';

  @override
  String get iosUpdateUrlLabel => 'iOS 更新 URL';

  @override
  String get iosUpdateUrlDescription => 'iOS 应用更新的 URL。';

  @override
  String get androidUpdateUrlLabel => 'Android 更新 URL';

  @override
  String get followedItemsLimitLabel => '关注项目限制';

  @override
  String get followedItemsLimitDescription => '此用户角色可以关注的国家、新闻来源或类别的最大数量。';

  @override
  String get savedFeedFiltersLimitLabel => '保存的过滤器限制';

  @override
  String get savedFeedFiltersLimitDescription => '此用户角色可以保存的信息流过滤器的最大数量。';

  @override
  String get adFrequencyLabel => '广告频率';

  @override
  String get adFrequencyDescription => '此用户角色的广告出现频率。';

  @override
  String get savedFeedFilterLimitsTitle => '保存的过滤器限制';

  @override
  String get savedFeedFilterLimitsDescription => '为每个用户层级设置保存的信息流过滤器数量限制。';

  @override
  String get adPlacementIntervalLabel => '广告投放间隔';

  @override
  String get adPlacementIntervalDescription => '在向此用户角色显示第一个广告之前必须显示的最小新闻条数。';

  @override
  String get articlesBeforeInterstitialAdsLabel => '插屏广告前文章数';

  @override
  String get articlesBeforeInterstitialAdsDescription =>
      '此用户角色在显示全屏插屏广告之前需要阅读的文章数量。';

  @override
  String get daysSuffix => '天';

  @override
  String daysBetweenPromptDescription(String actionType) {
    return '显示 $actionType 提示之前的最少天数。';
  }

  @override
  String get retryButtonText => '重试';

  @override
  String get feedActionTypeLinkAccount => '关联账号';

  @override
  String get feedActionTypeRateApp => '评价应用';

  @override
  String get feedActionTypeFollowTopics => '关注话题';

  @override
  String get feedActionTypeFollowSources => '关注来源';

  @override
  String get feedActionTypeUpgrade => '升级';

  @override
  String get feedActionTypeEnableNotifications => '开启通知';

  @override
  String get countryPickerSearchLabel => '搜索';

  @override
  String get countryPickerSearchHint => '开始输入以搜索...';

  @override
  String get countryPickerSelectCountryLabel => '选择国家';

  @override
  String get archivedHeadlines => '已归档头条';

  @override
  String get loadingArchivedHeadlines => '正在加载已归档头条';

  @override
  String get noArchivedHeadlinesFound => '未找到已归档头条。';

  @override
  String get restore => '恢复';

  @override
  String get deleteForever => '永久删除';

  @override
  String get archivedTopics => '已归档话题';

  @override
  String get loadingArchivedTopics => '正在加载已归档话题';

  @override
  String get noArchivedTopicsFound => '未找到已归档话题。';

  @override
  String get archivedSources => '已归档来源';

  @override
  String get loadingArchivedSources => '正在加载已归档来源';

  @override
  String get noArchivedSourcesFound => '未找到已归档来源。';

  @override
  String get archivedItems => '已归档项目';

  @override
  String get addNewItem => '添加新项目';

  @override
  String get archive => '归档';

  @override
  String headlineDeleted(String title) {
    return '已删除 “$title”。';
  }

  @override
  String get undo => '撤销';

  @override
  String get enabledLabel => '已启用';

  @override
  String get itemsToDisplayLabel => '显示项目数';

  @override
  String get itemsToDisplayDescription => '此装饰器中显示的项目数量。';

  @override
  String get roleSpecificSettingsTitle => '角色特定设置';

  @override
  String get daysBetweenViewsLabel => '视图间隔天数';

  @override
  String get daysBetweenViewsDescription =>
      '此设置决定了在相关任务尚未完成的情况下，装饰器再次向用户显示之前必须经过的最少天数。';

  @override
  String get feedDecoratorTypeLinkAccount => '关联账号';

  @override
  String get feedDecoratorTypeUpgrade => '升级到高级版';

  @override
  String get feedDecoratorTypeRateApp => '评价应用';

  @override
  String get feedDecoratorTypeEnableNotifications => '开启通知';

  @override
  String get feedDecoratorTypeSuggestedTopics => '推荐话题';

  @override
  String get feedDecoratorTypeSuggestedSources => '推荐来源';

  @override
  String get guestUserRole => '访客用户';

  @override
  String get standardUserRole => '标准用户';

  @override
  String get premiumUserRole => '高级用户';

  @override
  String get dashboardTitle => '仪表盘';

  @override
  String get clearSelection => '清除选择';

  @override
  String get search => '搜索';

  @override
  String get noResultsFound => '未找到结果。';

  @override
  String get close => '关闭';

  @override
  String get apply => '应用';

  @override
  String visibleToRoleLabel(String roleName) {
    return '对 $roleName 可见';
  }

  @override
  String get adPlatformConfigurationTitle => '广告平台配置';

  @override
  String get primaryAdPlatformTitle => '主要广告平台';

  @override
  String get primaryAdPlatformDescription => '选择要在整个应用程序中使用的主要广告平台。';

  @override
  String get adUnitIdentifiersTitle => '广告单元标识符';

  @override
  String get adUnitIdentifiersDescription => '为所选广告平台配置广告单元 ID。';

  @override
  String get feedAdSettingsTitle => '信息流广告设置';

  @override
  String get enableFeedAdsLabel => '启用信息流广告';

  @override
  String get feedAdTypeSelectionTitle => '信息流广告类型选择';

  @override
  String get feedAdTypeSelectionDescription => '选择在主信息流中显示的广告类型（原生或横幅）。';

  @override
  String get userRoleFrequencySettingsTitle => '用户角色频率设置';

  @override
  String get userRoleFrequencySettingsDescription => '根据用户角色配置广告频率和投放间隔。';

  @override
  String get articleAdSettingsTitle => '文章广告设置';

  @override
  String get enableArticleAdsLabel => '启用文章广告';

  @override
  String get defaultInArticleAdTypeSelectionTitle => '默认文章内广告类型选择';

  @override
  String get defaultInArticleAdTypeSelectionDescription =>
      '选择在文章内显示的默认广告类型（原生或横幅）。';

  @override
  String get inArticleAdSlotPlacementsTitle => '文章内广告位投放';

  @override
  String get inArticleAdSlotPlacementsDescription => '启用或禁用文章内容中的特定广告位。';

  @override
  String get feedNativeAdIdLabel => '信息流原生广告 ID';

  @override
  String get feedNativeAdIdDescription => '信息流中原生广告的单元 ID。';

  @override
  String get feedBannerAdIdLabel => '信息流横幅广告 ID';

  @override
  String get feedBannerAdIdDescription => '信息流中横幅广告的单元 ID。';

  @override
  String get articleInterstitialAdIdLabel => '文章插屏广告 ID';

  @override
  String get articleInterstitialAdIdDescription => '文章中插屏广告的单元 ID。';

  @override
  String get inArticleNativeAdIdLabel => '文章内原生广告 ID';

  @override
  String get inArticleNativeAdIdDescription => '文章内原生广告的单元 ID。';

  @override
  String get inArticleBannerAdIdLabel => '文章内横幅广告 ID';

  @override
  String get inArticleBannerAdIdDescription => '文章内横幅广告的单元 ID。';

  @override
  String get inArticleAdSlotTypeAboveArticleContinueReadingButton =>
      '在“继续阅读”按钮上方';

  @override
  String get inArticleAdSlotTypeBelowArticleContinueReadingButton =>
      '在“继续阅读”按钮下方';

  @override
  String idCopiedToClipboard(String id) {
    return 'ID “$id” 已复制到剪贴板。';
  }

  @override
  String get copyId => '复制 ID';

  @override
  String get enableGlobalAdsLabel => '启用广告';

  @override
  String get feedToArticleInterstitialAdIdLabel => '信息流至文章插屏广告 ID';

  @override
  String get feedToArticleInterstitialAdIdDescription =>
      '当用户从信息流导航到文章时显示的插屏广告单元 ID。';

  @override
  String get interstitialAdSettingsTitle => '插屏广告设置';

  @override
  String get enableInterstitialAdsLabel => '启用插屏广告';

  @override
  String get userRoleInterstitialFrequencyTitle => '按用户角色的插屏广告频率';

  @override
  String get userRoleInterstitialFrequencyDescription =>
      '根据用户的角色，配置用户在显示插屏广告之前必须进行的转换次数。';

  @override
  String get transitionsBeforeInterstitialAdsLabel => '插屏广告前的转换次数';

  @override
  String get transitionsBeforeInterstitialAdsDescription =>
      '在显示插屏广告之前，用户必须进行的转换（例如打开文章）次数。';

  @override
  String get adPlatformTypeAdmob => 'AdMob';

  @override
  String get nativeAdsTab => '原生广告';

  @override
  String get bannerAdsTab => '横幅广告';

  @override
  String get interstitialAdsTab => '插屏广告';

  @override
  String get videoAdsTab => '视频广告';

  @override
  String get bannerAdType => '横幅';

  @override
  String get nativeAdType => '原生';

  @override
  String get interstitialAdType => '插屏';

  @override
  String get videoAdType => '视频';

  @override
  String get rewardedAdType => '激励视频';

  @override
  String get bannerAdShapeSelectionTitle => '横幅广告形状';

  @override
  String get bannerAdShapeSelectionDescription => '选择文章中显示的横幅广告的首选视觉形状。';

  @override
  String get bannerAdShapeSquare => '正方形';

  @override
  String get bannerAdShapeRectangle => '长方形';

  @override
  String get loadingDraftHeadlines => '正在加载草稿头条';

  @override
  String get noDraftHeadlinesFound => '未找到草稿头条';

  @override
  String get publish => '发布';

  @override
  String get saveAsDraft => '保存为草稿';

  @override
  String get invalidFormTitle => '表单无效';

  @override
  String get invalidFormMessage => '请在发布前填写所有必填字段。您可以保存为草稿或放弃更改。';

  @override
  String get completeForm => '完成表单';

  @override
  String get discard => '放弃';

  @override
  String get drafts => '草稿';

  @override
  String get draftsIconTooltip => '草稿';

  @override
  String get draftHeadlines => '草稿头条';

  @override
  String get draftTopics => '草稿话题';

  @override
  String get draftSources => '草稿来源';

  @override
  String get saveHeadlineTitle => '保存头条';

  @override
  String get saveHeadlineMessage => '您想发布此头条还是将其保存为草稿？';

  @override
  String get saveTopicTitle => '保存话题';

  @override
  String get saveTopicMessage => '您想发布此话题还是将其保存为草稿？';

  @override
  String get saveSourceTitle => '保存来源';

  @override
  String get saveSourceMessage => '您想发布此来源还是将其保存为草稿？';

  @override
  String get loadingDraftTopics => '正在加载草稿话题...';

  @override
  String get noDraftTopicsFound => '未找到草稿话题。';

  @override
  String topicDeleted(String topicTitle) {
    return '话题 “$topicTitle” 已删除。';
  }

  @override
  String get loadingDraftSources => '正在加载草稿来源...';

  @override
  String get noDraftSourcesFound => '未找到草稿来源。';

  @override
  String sourceDeleted(String sourceName) {
    return '来源 “$sourceName” 已删除。';
  }

  @override
  String get publishTopic => '发布话题';

  @override
  String get publishSource => '发布来源';

  @override
  String enableInArticleAdsForRoleLabel(String role) {
    return '为 $role 启用文章内广告';
  }

  @override
  String get moreActions => '更多操作';

  @override
  String get filter => '筛选';

  @override
  String get applyFilters => '应用筛选';

  @override
  String get filterHeadlines => '筛选头条';

  @override
  String get filterTopics => '筛选话题';

  @override
  String get filterSources => '筛选来源';

  @override
  String get searchByHeadlineTitle => '按头条标题搜索...';

  @override
  String get searchByTopicName => '按名称或 ID 搜索...';

  @override
  String get searchBySourceName => '按名称或 ID 搜索...';

  @override
  String get selectSources => '选择来源';

  @override
  String get selectTopics => '选择话题';

  @override
  String get countries => '国家';

  @override
  String get selectCountries => '选择国家';

  @override
  String get selectSourceTypes => '选择来源类型';

  @override
  String get selectLanguages => '选择语言';

  @override
  String get selectHeadquarters => '选择总部';

  @override
  String get resetFiltersButtonText => '重置筛选';

  @override
  String get noResultsWithCurrentFilters => '当前筛选条件下未找到结果。请尝试重置。';

  @override
  String get aboutIconTooltip => '关于此页面';

  @override
  String get closeButtonText => '关闭';

  @override
  String get logo => 'Logo';

  @override
  String get userManagement => '用户管理';

  @override
  String get userManagementPageDescription => '管理系统用户，包括他们的角色和权限。';

  @override
  String get loadingUsers => '正在加载用户';

  @override
  String get noUsersFound => '未找到用户。';

  @override
  String get email => '电子邮箱';

  @override
  String get appRole => '应用角色';

  @override
  String get dashboardRole => '仪表盘角色';

  @override
  String get createdAt => '创建于';

  @override
  String get promoteToPublisher => '提升为发布者';

  @override
  String get demoteToUser => '降级为普通用户';

  @override
  String get adminRole => '管理员';

  @override
  String get publisherRole => '发布者';

  @override
  String get filterUsers => '筛选用户';

  @override
  String get searchByUserEmail => '按邮箱或 ID 搜索...';

  @override
  String get selectAppRoles => '选择应用角色';

  @override
  String get selectDashboardRoles => '选择仪表盘角色';

  @override
  String get authentication => '身份认证';

  @override
  String get subscription => '订阅';

  @override
  String get authenticationAnonymous => '匿名';

  @override
  String get authenticationAuthenticated => '已认证';

  @override
  String get subscriptionFree => '免费';

  @override
  String get subscriptionPremium => '高级版';

  @override
  String get savedHeadlineFilterLimitsTitle => '保存的头条过滤器限制';

  @override
  String get savedHeadlineFilterLimitsDescription =>
      '为每个用户层级设置保存的头条过滤器数量限制，包括总数、置顶和通知订阅。';

  @override
  String get totalLimitLabel => '总限制';

  @override
  String get totalLimitDescription => '用户可以创建的此类过滤器的总数。';

  @override
  String get pinnedLimitLabel => '置顶限制';

  @override
  String get pinnedLimitDescription => '可以置顶的此类过滤器的最大数量。';

  @override
  String get notificationSubscriptionLimitLabel => '通知订阅限制';

  @override
  String get notificationSubscriptionLimitDescription =>
      '用户可以订阅此通知类型的过滤器的最大数量。';

  @override
  String get pushNotificationSubscriptionDeliveryTypeBreakingOnly => '突发新闻';

  @override
  String get pushNotificationSubscriptionDeliveryTypeWeeklyRoundup => '每周回顾';

  @override
  String get isBreakingNewsLabel => '标记为突发新闻';

  @override
  String get isBreakingNewsDescription => '启用此项将在发布时立即向所有订阅用户发送推送通知。';

  @override
  String get isBreakingNewsDescriptionEdit =>
      '在编辑期间更改此状态不会触发新的推送通知，因为通知仅在初始创建时发送。';

  @override
  String get confirmBreakingNewsTitle => '确认突发新闻发布';

  @override
  String get confirmBreakingNewsMessage =>
      '您确定要将其作为突发新闻发布吗？此操作将立即向所有订阅用户发送推送通知。';

  @override
  String get confirmPublishButton => '确认并发布';

  @override
  String get cannotDraftBreakingNews => '突发新闻不能保存为草稿。请发布它或禁用“突发新闻”开关。';

  @override
  String get ok => '确定';

  @override
  String get breakingNewsFilterTitle => '突发新闻';

  @override
  String get breakingNewsFilterAll => '全部';

  @override
  String get breakingNewsFilterBreakingOnly => '仅限突发';

  @override
  String get breakingNewsFilterNonBreakingOnly => '非突发';

  @override
  String get notificationsTab => '通知';

  @override
  String get pushNotificationSettingsTitle => '推送通知设置';

  @override
  String get pushNotificationSettingsDescription =>
      '管理推送通知系统的全局设置，包括主要提供商和哪些通知类型处于激活状态。';

  @override
  String get pushNotificationSystemStatusTitle => '启用通知';

  @override
  String get pushNotificationSystemStatusDescription => '启用或禁用所有推送通知的全局开关。';

  @override
  String get pushNotificationPrimaryProviderTitle => '主要提供商';

  @override
  String get pushNotificationPrimaryProviderDescription =>
      '选择主要服务提供商。确保所选提供商已按照文档在后端的 .env 文件中正确配置。';

  @override
  String get pushNotificationDeliveryTypesTitle => '递送类型';

  @override
  String get pushNotificationDeliveryTypesDescription => '全局启用或禁用特定类型的推送通知。';

  @override
  String get pushNotificationProviderFirebase => 'Firebase';

  @override
  String get pushNotificationProviderOneSignal => 'OneSignal';

  @override
  String get appTab => '常规';

  @override
  String get featuresTab => '功能';

  @override
  String get limitsTab => '限制';

  @override
  String get maintenanceConfigTitle => '维护模式';

  @override
  String get maintenanceConfigDescription => '启用以使应用进入维护模式，阻止用户访问。';

  @override
  String get updateConfigTitle => '更新设置';

  @override
  String get updateConfigDescription => '为用户配置强制性的应用更新。';

  @override
  String get generalAppConfigTitle => '常规应用设置';

  @override
  String get generalAppConfigDescription => '管理常规应用程序设置，如服务条款和隐私政策 URL。';

  @override
  String get termsOfServiceUrlLabel => '服务条款 URL';

  @override
  String get termsOfServiceUrlDescription => '应用程序服务条款页面的 URL。';

  @override
  String get privacyPolicyUrlLabel => '隐私政策 URL';

  @override
  String get privacyPolicyUrlDescription => '应用程序隐私政策页面的 URL。';

  @override
  String get navigationAdConfigTitle => '导航广告设置';

  @override
  String get enableNavigationAdsLabel => '启用导航广告';

  @override
  String get navigationAdFrequencyTitle => '导航广告频率';

  @override
  String get navigationAdFrequencyDescription =>
      '根据用户的角色，配置用户在显示插屏广告之前必须进行的转换次数。';

  @override
  String get internalNavigationsBeforeAdLabel => '广告前内部导航次数';

  @override
  String get internalNavigationsBeforeAdDescription =>
      '在显示插屏广告之前，用户必须进行的内部页面间导航次数。';

  @override
  String get externalNavigationsBeforeAdLabel => '广告前外部导航次数';

  @override
  String get externalNavigationsBeforeAdDescription =>
      '在显示插屏广告之前，用户必须进行的外部导航次数。';

  @override
  String get nativeAdIdLabel => '原生广告 ID';

  @override
  String get nativeAdIdDescription => '原生广告的单元 ID。';

  @override
  String get bannerAdIdLabel => '横幅广告 ID';

  @override
  String get bannerAdIdDescription => '横幅广告的单元 ID。';

  @override
  String get interstitialAdIdLabel => '插屏广告 ID';

  @override
  String get interstitialAdIdDescription => '插屏广告的单元 ID。';

  @override
  String get savedHeadlinesLimitLabel => '保存头条限制';

  @override
  String get savedHeadlinesLimitDescription => '此用户角色可以保存的头条新闻的最大数量。';

  @override
  String get appUpdateManagementTitle => '应用程序更新管理';

  @override
  String get feedItemClickBehaviorTitle => '信息流项目点击行为';

  @override
  String get feedItemClickBehaviorDescription =>
      '设置打开头条的默认浏览器。用户可以在其应用的信息流设置中覆盖此设置。';

  @override
  String get feedItemClickBehaviorInternalNavigation => '应用内浏览器';

  @override
  String get feedItemClickBehaviorExternalNavigation => '系统浏览器';

  @override
  String get userLimitsTitle => '用户限制';

  @override
  String get userLimitsDescription => '定义用户特定功能和内容的限制。';

  @override
  String get appStatusAndUpdatesDescription => '控制应用程序的运营状态并管理更新要求。';

  @override
  String get advertisementsDescription => '管理所有广告设置，包括全局控制、平台和投放。';

  @override
  String get notificationsDescription => '配置推送通知系统，包括提供商和递送类型。';

  @override
  String get feedDescription => '控制用户内容信息流的行为和外观。';

  @override
  String get notificationSubscriptionBreakingOnlyDescription =>
      '针对匹配头条发送即时警报的订阅限制。';

  @override
  String get notificationSubscriptionWeeklyRoundupDescription =>
      '针对匹配头条发送每周摘要的订阅限制。';

  @override
  String get appStatusAndUpdatesTitle => '应用状态与更新';

  @override
  String get enableForcedUpdatesLabel => '启用强制更新';

  @override
  String get enableForcedUpdatesDescription => '启用后，您可以指定移动应用的最低要求版本。';

  @override
  String get appUrlsTitle => '应用程序 URL';

  @override
  String get appUrlsDescription => '管理应用程序中使用的外部和内部 URL。';

  @override
  String get communityAndEngagementTitle => '社区与互动';

  @override
  String get communityAndEngagementDescription =>
      '配置用户互动和举报工具。为确保问责制，无论此处的设置如何，移动应用中的访客用户都无法使用这些功能。';

  @override
  String get userEngagementTitle => '用户互动';

  @override
  String get userEngagementDescription => '配置回应和评论。';

  @override
  String get contentReportingTitle => '内容举报';

  @override
  String get contentReportingDescription => '设置用户可以举报内容的规则。';

  @override
  String get appReviewFunnelTitle => '应用评价';

  @override
  String get appReviewFunnelDescription => '管理获取用户满意度并可选地请求评价的过程。';

  @override
  String get enableEngagementFeaturesLabel => '启用互动功能';

  @override
  String get enableEngagementFeaturesDescription => '全局激活或停用所有回应和评论功能。';

  @override
  String get engagementModeLabel => '互动模式';

  @override
  String get engagementModeDescription => '决定用户是只能对内容做出回应，还是也可以添加评论。';

  @override
  String get engagementModeReactionsOnly => '仅限回应';

  @override
  String get engagementModeReactionsAndComments => '回应与评论';

  @override
  String get enableReportingSystemLabel => '启用举报系统';

  @override
  String get enableReportingSystemDescription => '全局激活或停用所有面向用户的举报选项。';

  @override
  String get enableHeadlineReportingLabel => '启用头条举报';

  @override
  String get enableSourceReportingLabel => '启用来源举报';

  @override
  String get enableCommentReportingLabel => '启用评论举报';

  @override
  String get enableAppFeedbackSystemLabel => '启用应用反馈系统';

  @override
  String get enableAppFeedbackSystemDescription => '激活内部系统，定期询问用户是否喜欢该应用。';

  @override
  String get interactionCycleThresholdLabel => '互动周期阈值';

  @override
  String get interactionCycleThresholdDescription =>
      '定义触发满意度提示所需的正面操作（如保存、点赞）数量。每当用户的正面操作总数是此数字的倍数时，就会显示提示。';

  @override
  String get initialPromptCooldownLabel => '初始提示冷却（天）';

  @override
  String get initialPromptCooldownDescription =>
      '第一次显示满意度提示之前等待的天数。此冷却时间可确保在用户充分使用应用之前不会询问他们。';

  @override
  String get requestStoreReviewLabel => '“是”之后请求商店评价';

  @override
  String get requestStoreReviewDescription =>
      '如果启用，对满意度提示回答“是”的用户将看到官方的 OS 商店评价对话框。';

  @override
  String get requestWrittenFeedbackLabel => '“否”之后请求书面反馈';

  @override
  String get requestWrittenFeedbackDescription =>
      '如果启用，回答“否”的用户将被提示直接向团队提供书面反馈。';

  @override
  String get internalPromptLogicTitle => '内部提示逻辑';

  @override
  String get eligiblePositiveInteractionsTitle => '符合条件的正面互动';

  @override
  String get positiveInteractionTypeSaveItem => '保存内容项目';

  @override
  String get positiveInteractionTypeFollowItem => '关注实体';

  @override
  String get positiveInteractionTypeShareContent => '分享内容项目';

  @override
  String get positiveInteractionTypeSaveFilter => '创建保存的过滤器';

  @override
  String get followUpActionsTitle => '后续操作';

  @override
  String get enableCommunityFeaturesLabel => '启用社区功能';

  @override
  String get enableCommunityFeaturesDescription => '全局激活或停用所有社区相关功能，包括互动和举报。';

  @override
  String get communityManagementPageDescription =>
      '管理用户生成的内容，包括互动（回应和评论）、内容举报和应用评价。';

  @override
  String get engagements => '互动';

  @override
  String get reports => '举报';

  @override
  String get appReviews => '应用评价';

  @override
  String get user => '用户';

  @override
  String get engagedContent => '互动内容';

  @override
  String get reaction => '回应';

  @override
  String get comment => '评论';

  @override
  String get commentStatus => '评论状态';

  @override
  String get hasCommentFilterLabel => '包含评论';

  @override
  String get hasCommentFilterDescription => '仅显示包含文字评论的互动。';

  @override
  String get date => '日期';

  @override
  String get approveComment => '批准评论';

  @override
  String get rejectComment => '拒绝评论';

  @override
  String get viewEngagedContent => '查看内容';

  @override
  String get copyUserId => '复制用户 ID';

  @override
  String get reporter => '举报人';

  @override
  String get reportedItem => '被举报项目';

  @override
  String get reason => '原因';

  @override
  String get reportStatus => '举报状态';

  @override
  String get viewReportedItem => '查看项目';

  @override
  String get markAsInReview => '标记为审核中';

  @override
  String get resolveReport => '解决举报';

  @override
  String get initialFeedback => '初始反馈';

  @override
  String get osPromptRequested => '已请求 OS 提示？';

  @override
  String get feedbackHistory => '反馈历史';

  @override
  String get lastInteraction => '最后一次互动';

  @override
  String get viewFeedbackHistory => '查看历史';

  @override
  String get reactionTypeLike => '点赞';

  @override
  String get reactionTypeInsightful => '有见地';

  @override
  String get reactionTypeAmusing => '有趣';

  @override
  String get reactionTypeSad => '悲伤';

  @override
  String get reactionTypeAngry => '愤怒';

  @override
  String get reactionTypeSkeptical => '怀疑';

  @override
  String get initialAppReviewFeedbackPositive => '正面';

  @override
  String get initialAppReviewFeedbackNegative => '负面';

  @override
  String get filterCommunity => '筛选社区内容';

  @override
  String get searchByEngagementUser => '按用户邮箱搜索...';

  @override
  String get searchByReportReporter => '按举报人邮箱搜索...';

  @override
  String get searchByAppReviewUser => '按用户邮箱搜索...';

  @override
  String get selectCommentStatus => '选择评论状态';

  @override
  String get selectReportStatus => '选择举报状态';

  @override
  String get selectInitialFeedback => '选择初始反馈';

  @override
  String get selectReportableEntity => '选择被举报项目类型';

  @override
  String get reportableEntityHeadline => '头条';

  @override
  String get reportableEntitySource => '来源';

  @override
  String get reportableEntityComment => '评论';

  @override
  String get noEngagementsFound => '未找到互动。';

  @override
  String get noReportsFound => '未找到举报。';

  @override
  String get noAppReviewsFound => '未找到应用评价。';

  @override
  String get loadingEngagements => '正在加载互动';

  @override
  String get loadingReports => '正在加载举报';

  @override
  String get loadingAppReviews => '正在加载应用评价';

  @override
  String get userIdCopied => '用户 ID 已复制到剪贴板。';

  @override
  String get reportStatusUpdated => '举报状态已更新。';

  @override
  String feedbackHistoryForUser(String email) {
    return '$email 的反馈历史';
  }

  @override
  String get noFeedbackHistory => '此用户没有可用的反馈历史。';

  @override
  String feedbackProvidedAt(String date) {
    return '反馈提供于：$date';
  }

  @override
  String feedbackReason(String reason) {
    return '原因：$reason';
  }

  @override
  String get noReasonProvided => '未提供原因。';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get reportReasonMisinformationOrFakeNews => '虚假信息 / 假新闻';

  @override
  String get reportReasonClickbaitTitle => '标题党';

  @override
  String get reportReasonOffensiveOrHateSpeech => '冒犯性 / 仇恨言论';

  @override
  String get reportReasonSpamOrScam => '垃圾信息 / 诈骗';

  @override
  String get reportReasonBrokenLink => '链接失效';

  @override
  String get reportReasonPaywalled => '付费墙';

  @override
  String get reportReasonLowQualityJournalism => '低质量新闻';

  @override
  String get reportReasonHighAdDensity => '广告密度过高';

  @override
  String get reportReasonBlog => '博客';

  @override
  String get reportReasonGovernmentSource => '政府来源';

  @override
  String get reportReasonAggregator => '聚合器';

  @override
  String get reportReasonOther => '其他';

  @override
  String get reportReasonFrequentPaywalls => '频繁出现付费墙';

  @override
  String get reportReasonImpersonation => '冒充他人';

  @override
  String get noNegativeFeedbackHistory => '未找到此用户的负面反馈历史。';

  @override
  String get reject => '拒绝';

  @override
  String get commentStatusFlaggedByAi => '被 AI 标记';

  @override
  String get cancel => '取消';

  @override
  String get rejectCommentConfirmation => '您确定要拒绝并永久删除此评论吗？此操作无法撤销。';

  @override
  String get searchByUserId => '按用户 ID 搜索...';

  @override
  String get viewReportedHeadline => '查看头条';

  @override
  String get viewReportedSource => '查看来源';

  @override
  String get viewReportedComment => '查看评论';

  @override
  String get entityType => '实体类型';

  @override
  String get feedback => '反馈';

  @override
  String get feedbackDetails => '反馈详情';

  @override
  String get moderationStatusPendingReview => '待审核';

  @override
  String get moderationStatusResolved => '已解决';

  @override
  String get hasComment => '有评论';

  @override
  String get any => '任何';

  @override
  String get withComment => '有评论';

  @override
  String get withoutComment => '无评论';

  @override
  String get reportResolved => '举报已解决。';

  @override
  String get commentApproved => '评论已批准。';

  @override
  String get commentRejected => '评论已拒绝。';

  @override
  String get copyHeadlineId => '复制头条 ID';

  @override
  String get copyReportedItemId => '复制被举报项目 ID';

  @override
  String get viewFeedbackDetails => '查看反馈详情';

  @override
  String get reportDetails => '举报详情';

  @override
  String get commentDetails => '评论详情';

  @override
  String get communityManagement => '社区管理';

  @override
  String get navContent => '内容';

  @override
  String get navUsers => '用户';

  @override
  String get navCommunity => '社区';

  @override
  String get confirmPromotionTitle => '确认提升';

  @override
  String confirmPromotionMessage(String email) {
    return '您确定要将 $email 提升为发布者吗？';
  }

  @override
  String get confirmDemotionTitle => '确认降级';

  @override
  String confirmDemotionMessage(String email) {
    return '您确定要将 $email 降级为普通用户吗？';
  }

  @override
  String get premiumUserTooltip => '高级用户';

  @override
  String get adminUserTooltip => '管理员';

  @override
  String get publisherUserTooltip => '发布者';

  @override
  String get breakingNewsHint => '这是一个突发新闻头条';

  @override
  String get breakingNewsFilterDescription => '仅显示突发新闻头条';

  @override
  String publishItemTitle(String itemType) {
    return '发布 $itemType？';
  }

  @override
  String publishItemContent(String itemType) {
    return '您确定要发布此 $itemType 吗？它将对公众可见。';
  }

  @override
  String archiveItemTitle(String itemType) {
    return '归档 $itemType？';
  }

  @override
  String archiveItemContent(String itemType) {
    return '您确定要归档此 $itemType 吗？它将从公众视野中隐藏。';
  }

  @override
  String restoreItemTitle(String itemType) {
    return '恢复 $itemType？';
  }

  @override
  String restoreItemContent(String itemType) {
    return '您确定要恢复此 $itemType 吗？它将重新激活并对公众可见。';
  }

  @override
  String deleteItemTitle(String itemType) {
    return '删除 $itemType？';
  }

  @override
  String deleteItemContent(String itemType) {
    return '您确定要删除此 $itemType 吗？';
  }

  @override
  String itemDeletedSnackbar(String itemType, String itemName) {
    return '$itemType “$itemName” 已删除。';
  }

  @override
  String get adPlatformConfigurationDescription => '选择主要广告提供商并配置其各自的广告单元 ID。';

  @override
  String get feedAdSettingsDescription => '控制用户内容信息流中的广告可见性、类型和频率。';

  @override
  String get navigationAdConfigDescription => '配置用户导航期间出现的插屏广告。';

  @override
  String get feedDecoratorLinkAccountDescription => '提示访客用户创建完整账号。';

  @override
  String get feedDecoratorUpgradeDescription => '提示标准用户升级到高级订阅。';

  @override
  String get feedDecoratorRateAppDescription => '提示用户在应用商店评价应用。';

  @override
  String get feedDecoratorEnableNotificationsDescription => '提示用户开启推送通知。';

  @override
  String get feedDecoratorSuggestedTopicsDescription => '显示用户可能感兴趣关注的话题集合。';

  @override
  String get feedDecoratorSuggestedSourcesDescription => '显示用户可能感兴趣关注的来源集合。';

  @override
  String get enableGlobalAdsDescription => '全局激活或停用应用程序内的所有广告。';

  @override
  String get enableFeedAdsDescription => '控制内容信息流中所有广告的可见性。';

  @override
  String visibleToRoleDescription(String roleName) {
    return '启用后，此功能将对具有 “$roleName” 角色的用户激活。';
  }

  @override
  String get enableDecoratorDescription => '为所有符合条件的用户全局激活或停用此装饰器。';

  @override
  String get enableNavigationAdsDescription => '控制用户导航期间出现的插屏广告的可见性。';

  @override
  String get enableHeadlineReportingDescription => '允许用户举报单个头条的虚假信息或标题党等问题。';

  @override
  String get enableSourceReportingDescription => '允许用户举报整个新闻来源的低质量或偏见等问题。';

  @override
  String get enableCommentReportingDescription => '允许用户举报单个评论以进行审核。';

  @override
  String get pushNotificationDeliveryTypeBreakingOnlyDescription =>
      '启用以允许用户订阅突发新闻的即时警报。';

  @override
  String get pushNotificationDeliveryTypeDailyDigestDescription =>
      '启用以允许用户订阅相关新闻的每日摘要。';

  @override
  String get pushNotificationDeliveryTypeWeeklyRoundupDescription =>
      '启用以允许用户订阅相关新闻的每周回顾。';

  @override
  String get positiveInteractionTypeSaveItemDescription => '当用户收藏头条时计数。';

  @override
  String get positiveInteractionTypeFollowItemDescription =>
      '当用户关注头条话题、来源或国家时计数。';

  @override
  String get positiveInteractionTypeShareContentDescription => '当用户分享头条时计数。';

  @override
  String get positiveInteractionTypeSaveFilterDescription => '当用户创建保存的过滤器时计数。';

  @override
  String get internalPromptLogicDescription => '定义触发满意度提示的条件，如用户操作数量和冷却期。';

  @override
  String get eligiblePositiveInteractionsDescription =>
      '选择哪些用户操作被计为“正面互动”以触发满意度提示。';

  @override
  String get followUpActionsDescription => '配置用户响应满意度提示后发生的情况，如请求商店评价。';

  @override
  String get analyticsTab => '分析';

  @override
  String get analyticsDescription => '配置分析提供商、事件记录和采样率。';

  @override
  String get analyticsSystemStatusTitle => '启用分析系统';

  @override
  String get analyticsSystemStatusDescription => '启用或禁用所有分析追踪的总开关。';

  @override
  String get analyticsProviderTitle => '当前提供商';

  @override
  String get analyticsProviderDescription => '选择主要的分析服务提供商。';

  @override
  String get analyticsEventsTitle => '事件配置';

  @override
  String get analyticsEventsDescription => '微调特定事件的记录。禁用干扰事件或调整采样率。';

  @override
  String samplingRateLabel(int rate) {
    return '采样率：$rate%';
  }

  @override
  String get analyticsProviderFirebase => 'Firebase';

  @override
  String get analyticsProviderMixpanel => 'Mixpanel';

  @override
  String get analyticsEventUserRegisteredLabel => '用户注册';

  @override
  String get analyticsEventUserRegisteredDescription => '追踪新用户成功创建账号的时间。';

  @override
  String get analyticsEventUserLoginLabel => '用户登录';

  @override
  String get analyticsEventUserLoginDescription => '追踪用户登录应用程序的时间。';

  @override
  String get analyticsEventAccountLinkedLabel => '账号关联';

  @override
  String get analyticsEventAccountLinkedDescription => '追踪访客用户将账号关联到永久凭据的时间。';

  @override
  String get analyticsEventUserRoleChangedLabel => '用户角色变更';

  @override
  String get analyticsEventUserRoleChangedDescription =>
      '追踪用户角色更新的时间（例如：升级到高级版）。';

  @override
  String get analyticsEventContentViewedLabel => '内容查看';

  @override
  String get analyticsEventContentViewedDescription => '追踪用户查看头条或文章的时间。';

  @override
  String get analyticsEventContentSharedLabel => '内容分享';

  @override
  String get analyticsEventContentSharedDescription => '追踪用户通过外部平台分享内容的时间。';

  @override
  String get analyticsEventContentSavedLabel => '内容保存';

  @override
  String get analyticsEventContentSavedDescription => '追踪用户收藏头条的时间。';

  @override
  String get analyticsEventContentUnsavedLabel => '取消内容保存';

  @override
  String get analyticsEventContentUnsavedDescription => '追踪用户移除收藏的时间。';

  @override
  String get analyticsEventContentReadingTimeLabel => '内容阅读时长';

  @override
  String get analyticsEventContentReadingTimeDescription => '追踪用户阅读文章所花费的时间。';

  @override
  String get analyticsEventReactionCreatedLabel => '添加回应';

  @override
  String get analyticsEventReactionCreatedDescription => '追踪用户对内容做出回应的时间。';

  @override
  String get analyticsEventReactionDeletedLabel => '移除回应';

  @override
  String get analyticsEventReactionDeletedDescription => '追踪用户移除其回应的时间。';

  @override
  String get analyticsEventCommentCreatedLabel => '发表评论';

  @override
  String get analyticsEventCommentCreatedDescription => '追踪用户提交新评论的时间。';

  @override
  String get analyticsEventCommentDeletedLabel => '删除评论';

  @override
  String get analyticsEventCommentDeletedDescription => '追踪用户删除其自身评论的时间。';

  @override
  String get analyticsEventReportSubmittedLabel => '提交举报';

  @override
  String get analyticsEventReportSubmittedDescription => '追踪用户举报内容或其他用户的时间。';

  @override
  String get analyticsEventHeadlineFilterCreatedLabel => '头条过滤器创建';

  @override
  String get analyticsEventHeadlineFilterCreatedDescription =>
      '追踪用户创建新的自定义头条过滤器的时间。';

  @override
  String get analyticsEventHeadlineFilterUpdatedLabel => '头条过滤器更新';

  @override
  String get analyticsEventHeadlineFilterUpdatedDescription =>
      '追踪用户修改现有头条过滤器的时间。';

  @override
  String get analyticsEventHeadlineFilterUsedLabel => '头条过滤器使用';

  @override
  String get analyticsEventHeadlineFilterUsedDescription =>
      '追踪用户应用已保存的头条过滤器的时间。';

  @override
  String get analyticsEventSearchPerformedLabel => '执行搜索';

  @override
  String get analyticsEventSearchPerformedDescription => '追踪用户执行搜索查询的时间。';

  @override
  String get analyticsEventAppReviewPromptRespondedLabel => '评价提示响应';

  @override
  String get analyticsEventAppReviewPromptRespondedDescription =>
      '追踪用户对内部“喜欢该应用吗？”提示的响应。';

  @override
  String get analyticsEventAppReviewStoreRequestedLabel => '商店评价请求';

  @override
  String get analyticsEventAppReviewStoreRequestedDescription =>
      '追踪请求原生 OS 商店评价对话框的时间。';

  @override
  String get analyticsEventLimitExceededLabel => '超出限制';

  @override
  String get analyticsEventLimitExceededDescription =>
      '追踪用户达到使用限制（如保存项目限制）的时间。';

  @override
  String get analyticsEventLimitExceededCtaClickedLabel => '限制 CTA 点击';

  @override
  String get analyticsEventLimitExceededCtaClickedDescription =>
      '追踪点击限制对话框中“升级”或“关联账号”按钮的次数。';

  @override
  String get analyticsEventPaywallPresentedLabel => '付费墙展示';

  @override
  String get analyticsEventPaywallPresentedDescription => '追踪向用户显示付费墙屏幕的时间。';

  @override
  String get analyticsEventSubscriptionStartedLabel => '订阅开始';

  @override
  String get analyticsEventSubscriptionStartedDescription => '追踪用户成功开始新订阅的时间。';

  @override
  String get analyticsEventSubscriptionRenewedLabel => '订阅续订';

  @override
  String get analyticsEventSubscriptionRenewedDescription => '追踪订阅自动或手动续订的时间。';

  @override
  String get analyticsEventSubscriptionCancelledLabel => '订阅取消';

  @override
  String get analyticsEventSubscriptionCancelledDescription => '追踪用户取消订阅的时间。';

  @override
  String get analyticsEventSubscriptionEndedLabel => '订阅结束';

  @override
  String get analyticsEventSubscriptionEndedDescription => '追踪订阅过期或终止的时间。';

  @override
  String get analyticsEventAdImpressionLabel => '广告展示';

  @override
  String get analyticsEventAdImpressionDescription => '追踪向用户展示广告的时间。';

  @override
  String get analyticsEventAdClickedLabel => '广告点击';

  @override
  String get analyticsEventAdClickedDescription => '追踪用户点击广告的时间。';

  @override
  String get analyticsEventAdLoadFailedLabel => '广告加载失败';

  @override
  String get analyticsEventAdLoadFailedDescription => '追踪尝试加载广告时的错误。';

  @override
  String get analyticsEventAdRewardEarnedLabel => '获得广告奖励';

  @override
  String get analyticsEventAdRewardEarnedDescription => '追踪用户完成激励广告操作的时间。';

  @override
  String get analyticsEventThemeChangedLabel => '主题变更';

  @override
  String get analyticsEventThemeChangedDescription => '追踪用户更改应用程序主题的时间。';

  @override
  String get analyticsEventLanguageChangedLabel => '语言变更';

  @override
  String get analyticsEventLanguageChangedDescription => '追踪用户更改应用程序语言的时间。';

  @override
  String get analyticsEventFeedDensityChangedLabel => '信息流密度变更';

  @override
  String get analyticsEventFeedDensityChangedDescription => '追踪用户调整信息流信息密度的时间。';

  @override
  String get analyticsEventBrowserChoiceChangedLabel => '浏览器偏好变更';

  @override
  String get analyticsEventBrowserChoiceChangedDescription =>
      '追踪用户更改打开链接的首选浏览器的时间。';

  @override
  String get analyticsEventAppTourStartedLabel => '应用导览开始';

  @override
  String get analyticsEventAppTourStartedDescription => '追踪显示身份验证前应用导览的时间。';

  @override
  String get analyticsEventAppTourStepViewedLabel => '应用导览步骤查看';

  @override
  String get analyticsEventAppTourStepViewedDescription => '追踪应用导览中的每个页面查看。';

  @override
  String get analyticsEventAppTourCompletedLabel => '应用导览完成';

  @override
  String get analyticsEventAppTourCompletedDescription => '追踪用户完成应用导览的时间。';

  @override
  String get analyticsEventAppTourSkippedLabel => '应用导览跳过';

  @override
  String get analyticsEventAppTourSkippedDescription => '追踪用户是否跳过了应用导览。';

  @override
  String get analyticsEventInitialPersonalizationStartedLabel => '初始个性化开始';

  @override
  String get analyticsEventInitialPersonalizationStartedDescription =>
      '追踪身份验证后个性化流程开始的时间。';

  @override
  String get analyticsEventInitialPersonalizationStepViewedLabel => '个性化步骤查看';

  @override
  String get analyticsEventInitialPersonalizationStepViewedDescription =>
      '追踪个性化流程中的每个步骤查看。';

  @override
  String get analyticsEventInitialPersonalizationCompletedLabel => '个性化完成';

  @override
  String get analyticsEventInitialPersonalizationCompletedDescription =>
      '追踪用户完成个性化流程的时间。';

  @override
  String get analyticsEventInitialPersonalizationSkippedLabel => '个性化跳过';

  @override
  String get analyticsEventInitialPersonalizationSkippedDescription =>
      '追踪用户是否跳过了个性化流程。';

  @override
  String get timeFrameDay => '24小时';

  @override
  String get timeFrameWeek => '7天';

  @override
  String get timeFrameMonth => '30天';

  @override
  String get timeFrameYear => '1年';

  @override
  String get noDataAvailable => '无可用数据';

  @override
  String get vsPreviousPeriod => '对比上一周期';

  @override
  String get vsPreviousDay => '对比过去 24 小时';

  @override
  String get vsPreviousWeek => '对比过去 7 天';

  @override
  String get vsPreviousMonth => '对比过去 30 天';

  @override
  String get vsPreviousYear => '对比去年';

  @override
  String get kpiUsersTotalRegistered => '注册用户总数';

  @override
  String get kpiUsersNewRegistrations => '新注册用户';

  @override
  String get kpiUsersActiveUsers => '活跃用户';

  @override
  String get kpiContentHeadlinesTotalPublished => '已发布头条总数';

  @override
  String get kpiContentHeadlinesTotalViews => '头条查看总数';

  @override
  String get kpiContentHeadlinesTotalLikes => '头条点赞总数';

  @override
  String get kpiContentSourcesTotalSources => '来源总数';

  @override
  String get kpiContentSourcesNewSources => '新来源';

  @override
  String get kpiContentSourcesTotalFollowers => '来源关注者总数';

  @override
  String get kpiContentTopicsTotalTopics => '话题总数';

  @override
  String get kpiContentTopicsNewTopics => '新话题';

  @override
  String get kpiContentTopicsTotalFollowers => '话题关注者总数';

  @override
  String get kpiEngagementsTotalReactions => '回应总数';

  @override
  String get kpiEngagementsTotalComments => '评论总数';

  @override
  String get kpiEngagementsAverageEngagementRate => '平均互动率';

  @override
  String get kpiEngagementsReportsPending => '待处理举报';

  @override
  String get kpiEngagementsReportsResolved => '已解决举报';

  @override
  String get kpiEngagementsReportsAverageResolutionTime => '平均解决时间';

  @override
  String get kpiEngagementsAppReviewsTotalFeedback => '反馈总数';

  @override
  String get kpiEngagementsAppReviewsPositiveFeedback => '正面反馈';

  @override
  String get kpiEngagementsAppReviewsStoreRequests => '商店评价请求';

  @override
  String get chartUsersRegistrationsOverTime => '注册量随时间变化';

  @override
  String get chartUsersActiveUsersOverTime => '活跃用户趋势';

  @override
  String get chartUsersRoleDistribution => '用户角色分布';

  @override
  String get chartContentHeadlinesViewsOverTime => '头条查看趋势';

  @override
  String get chartContentHeadlinesLikesOverTime => '头条点赞趋势';

  @override
  String get chartContentHeadlinesViewsByTopic => '按话题查看量';

  @override
  String get chartContentSourcesHeadlinesPublishedOverTime => '来源活动';

  @override
  String get chartContentSourcesFollowersOverTime => '来源关注者增长';

  @override
  String get chartContentSourcesEngagementByType => '按来源类型互动';

  @override
  String get chartContentTopicsFollowersOverTime => '话题关注者增长';

  @override
  String get chartContentTopicsHeadlinesPublishedOverTime => '话题活动';

  @override
  String get chartContentTopicsEngagementByTopic => '按话题互动';

  @override
  String get chartEngagementsReactionsOverTime => '回应趋势';

  @override
  String get chartEngagementsCommentsOverTime => '评论趋势';

  @override
  String get chartEngagementsReactionsByType => '回应分布';

  @override
  String get chartEngagementsReportsSubmittedOverTime => '已提交举报';

  @override
  String get chartEngagementsReportsResolutionTimeOverTime => '解决时间趋势';

  @override
  String get chartEngagementsReportsByReason => '按原因举报';

  @override
  String get chartEngagementsAppReviewsFeedbackOverTime => '反馈趋势';

  @override
  String get chartEngagementsAppReviewsPositiveVsNegative => '情感分析';

  @override
  String get chartEngagementsAppReviewsStoreRequestsOverTime => '商店请求趋势';

  @override
  String get chartContentSourcesStatusDistribution => '来源状态分布';

  @override
  String get chartContentHeadlinesBreakingNewsDistribution => '突发新闻分布';

  @override
  String get chartOverviewAppTourFunnel => '应用导览漏斗';

  @override
  String get chartOverviewInitialPersonalizationFunnel => '初始个性化漏斗';

  @override
  String get rankedListOverviewHeadlinesMostViewed => '查看次数最多的头条';

  @override
  String get rankedListOverviewHeadlinesMostLiked => '点赞次数最多的头条';

  @override
  String get rankedListOverviewSourcesMostFollowed => '关注人数最多的来源';

  @override
  String get rankedListOverviewTopicsMostFollowed => '关注人数最多的话题';

  @override
  String get subscriptionTab => '订阅';

  @override
  String get subscriptionDescription =>
      '配置向用户提供的订阅计划（例如：按月、按年）。启用后，达到功能限制的用户将被提示升级到高级层级。';

  @override
  String get enableSubscriptionLabel => '启用订阅功能';

  @override
  String get enableSubscriptionDescription =>
      '订阅系统的总开关。启用后，用户可以购买计划以升级其访问层级（例如：从标准版升级到高级版）。';

  @override
  String get monthlyPlanTitle => '月度计划';

  @override
  String get annualPlanTitle => '年度计划';

  @override
  String get planEnabledLabel => '启用计划';

  @override
  String get planRecommendedLabel => '推荐计划';

  @override
  String get planRecommendedDescription => '将此计划突出显示为最佳性价比选项。';

  @override
  String get appleProductIdLabel => 'Apple App Store 产品 ID';

  @override
  String get googleProductIdLabel => 'Google Play Store 产品 ID';

  @override
  String get subscriptionPlanEnablementError => '请至少输入一个产品 ID 以启用此计划。';

  @override
  String get subscriptionPlanDisabledNotification => '由于未提供产品 ID，计划已禁用。';

  @override
  String get subscriptionFeatureDisabledNotification => '由于没有激活的计划，订阅功能已禁用。';

  @override
  String get pushNotificationFeatureDisabledNotification =>
      '由于没有激活的递送类型，推送通知系统已禁用。';

  @override
  String get analyticsFeatureDisabledNotification => '由于所有事件均已禁用，分析系统已禁用。';

  @override
  String get reportingFeatureDisabledNotification => '由于没有激活的举报选项，举报系统已禁用。';

  @override
  String get appReviewFeatureDisabledNotification => '由于未选择正面互动，应用评价系统已禁用。';

  @override
  String get subscriptionsName => '订阅';

  @override
  String get subscriptionProvider => '商店提供商';

  @override
  String get accessTier => '访问层级';

  @override
  String get expiryDate => '过期日期';

  @override
  String get willAutoRenew => '自动续订';

  @override
  String get allAccessTiers => '所有层级';

  @override
  String get subscriptionActionCopyUserId => '复制用户 ID';

  @override
  String get subscriptionActionCopySubscriptionId => '复制订阅 ID';

  @override
  String get filterSubscriptions => '筛选订阅';

  @override
  String get selectStatus => '选择状态';

  @override
  String get selectProvider => '选择提供商';

  @override
  String get selectTier => '选择层级';

  @override
  String get noSubscriptionsFound => '未找到订阅。';

  @override
  String get loadingSubscriptions => '正在加载订阅';

  @override
  String get searchByUserIdOrSubscriptionId => '按用户 ID 或订阅 ID 搜索...';

  @override
  String get subscriptionsPageDescription =>
      '提供用于监控用户订阅状态的只读界面。所有生命周期事件（如购买、续订和取消）均由后端通过与 Apple App Store 和 Google Play 的 Webhook 同步自动处理。此仪表盘不发起或管理财务交易。';

  @override
  String get subscriptionStatusActive => '激活';

  @override
  String get subscriptionStatusGracePeriod => '宽限期';

  @override
  String get subscriptionStatusBillingIssue => '账单问题';

  @override
  String get subscriptionStatusCanceled => '已取消';

  @override
  String get subscriptionStatusExpired => '已过期';

  @override
  String get storeProviderApple => 'Apple';

  @override
  String get storeProviderGoogle => 'Google';

  @override
  String get chartSubscriptionsActiveOverTime => '活跃订阅随时间变化';

  @override
  String get chartSubscriptionsStatusDistribution => '订阅状态分布';

  @override
  String get chartSubscriptionsByStoreProvider => '按商店订阅';

  @override
  String get kpiRewardsAdsWatchedTotal => '观看广告总数';

  @override
  String get kpiRewardsActiveUsersCount => '活跃奖励用户';

  @override
  String get rewardsTab => '奖励';

  @override
  String get rewardsDescription => '为用户互动配置基于时间的奖励。';

  @override
  String get enableRewardsLabel => '启用奖励系统';

  @override
  String get enableRewardsDescription => '允许用户通过观看广告获得奖励。';

  @override
  String get rewardTypeAdFree => '免广告体验';

  @override
  String get rewardDurationDaysLabel => '持续时间（天）';

  @override
  String get rewardEnabledLabel => '已启用';

  @override
  String get chartRewardsAdsWatchedOverTime => '观看广告趋势';

  @override
  String get chartRewardsActiveByType => '按类型激活奖励';

  @override
  String get feedDecoratorUnlockRewardsDescription => '提示用户观看广告以暂时解锁高级功能。';

  @override
  String get rewardDurationDaysDescription => '奖励保持激活状态的天数。';

  @override
  String get rewardsManagement => '奖励管理';

  @override
  String get rewardsManagementPageDescription => '管理用户奖励和权利。';

  @override
  String get loadingRewards => '正在加载奖励';

  @override
  String get noRewardsFound => '未找到奖励。';

  @override
  String get userId => '用户 ID';

  @override
  String get activeRewards => '激活的奖励';

  @override
  String get expiry => '过期';

  @override
  String get filterRewards => '筛选奖励';

  @override
  String get rewardType => '奖励类型';

  @override
  String get selectRewardTypes => '选择奖励类型';

  @override
  String get loadingAnalytics => '正在加载分析';

  @override
  String get noAnalyticsDataHeadline => '无分析数据';

  @override
  String get noAnalyticsDataSubheadline => '尚无数据可显示。请稍后再试。';

  @override
  String get androidAdUnitsTitle => 'Android 广告单元';

  @override
  String get iosAdUnitsTitle => 'iOS 广告单元';

  @override
  String get rewardedAdIdLabel => '激励广告 ID';

  @override
  String get rewardedAdIdDescription => '激励广告的单元 ID。';

  @override
  String get kpiRewardsGrantedTotal => '授予奖励总数';

  @override
  String get analyticsEventRewardsHubViewedLabel => '奖励中心查看';

  @override
  String get analyticsEventRewardsHubViewedDescription => '追踪用户查看奖励中心的时间。';

  @override
  String get analyticsEventRewardOfferClickedLabel => '奖励优惠点击';

  @override
  String get analyticsEventRewardOfferClickedDescription => '追踪用户点击特定奖励优惠的时间。';

  @override
  String get analyticsEventRewardGrantedLabel => '奖励授予';

  @override
  String get analyticsEventRewardGrantedDescription => '追踪奖励成功发放给用户的时间。';

  @override
  String get chartRewardsGrantedOverTime => '授予奖励趋势';

  @override
  String get android => 'Android';

  @override
  String get ios => 'iOS';

  @override
  String get initialPersonalizationTitle => '初始个性化';

  @override
  String get initialPersonalizationDescription => '为新用户配置引导流程，包括国家、话题和来源选择。';

  @override
  String get enableInitialPersonalizationLabel => '启用初始个性化';

  @override
  String get enableInitialPersonalizationDescription =>
      '启用后，新用户在注册后将被引导完成个性化流程。';

  @override
  String get enableCountrySelectionLabel => '启用国家选择';

  @override
  String get enableCountrySelectionDescription => '允许用户在引导过程中选择其国家。';

  @override
  String get enableTopicSelectionLabel => '启用话题选择';

  @override
  String get enableTopicSelectionDescription => '允许用户在引导过程中选择感兴趣的话题。';

  @override
  String get enableSourceSelectionLabel => '启用来源选择';

  @override
  String get enableSourceSelectionDescription => '允许用户在引导过程中选择要关注的新闻来源。';

  @override
  String get minSelectionsRequiredLabel => '所需最少选择数';

  @override
  String get minSelectionsRequiredDescription => '用户必须在所有启用的类别中选择的项目总数才能继续。';

  @override
  String get onboardingTitle => '引导流程';

  @override
  String get onboardingDescription => '管理首次用户体验，包括应用导览和初始个性化。';

  @override
  String get enableOnboardingLabel => '启用引导流程';

  @override
  String get enableOnboardingDescription => '启用或禁用整个引导流程（应用导览和初始个性化）的总开关。';

  @override
  String get appTourTitle => '应用导览';

  @override
  String get appTourDescription => '配置向新用户显示的身份验证前导览。';

  @override
  String get enableAppTourLabel => '启用应用导览';

  @override
  String get enableAppTourDescription => '启用后，在用户登录前将向其显示应用功能的简短导览。';

  @override
  String get skippableAppTourLabel => '可跳过应用导览';

  @override
  String get skippableAppTourDescription => '启用后，用户将可以选择跳过应用导览。';

  @override
  String get skippableInitialPersonalizationLabel => '可跳过个性化';

  @override
  String get skippableInitialPersonalizationDescription =>
      '启用后，用户将可以选择跳过个性化流程。';

  @override
  String get filePickingErrorMessage => '选取文件时出错。';

  @override
  String get removeImage => '移除图片';

  @override
  String get clickToUploadImage => '点击上传图片';

  @override
  String get processingImage => '正在处理图片...';

  @override
  String get processingImageDescription => '您的图片正在优化中，很快就会显示。';

  @override
  String get chartMediaUploadsOverTime => '上传量随时间变化';

  @override
  String get chartMediaUploadsByPurpose => '按用途上传';

  @override
  String get chartMediaUploadsSuccessVsFailure => '上传成功与失败';

  @override
  String get kpiMediaTotalUploads => '上传总数';

  @override
  String get kpiMediaFailedUploads => '失败上传数';

  @override
  String get kpiMediaAverageUploadTime => '平均上传时间 (秒)';

  @override
  String get updateHeadlineTitle => '更新头条';

  @override
  String get updateHeadlineMessage => '您想发布这些更改还是将更新保存为草稿？';

  @override
  String get analyticsEventMediaUploadStartedLabel => '媒体上传开始';

  @override
  String get analyticsEventMediaUploadStartedDescription => '追踪用户发起文件上传的时间。';

  @override
  String get analyticsEventMediaUploadCompletedLabel => '媒体上传完成';

  @override
  String get analyticsEventMediaUploadCompletedDescription => '追踪文件上传成功完成的时间。';

  @override
  String get analyticsEventMediaUploadFailedLabel => '媒体上传失败';

  @override
  String get analyticsEventMediaUploadFailedDescription => '追踪文件上传失败的时间。';

  @override
  String get dashboard => '仪表盘';

  @override
  String get aboutOverviewPageTitle => '关于概览页面';

  @override
  String get aboutOverviewPageDescription =>
      '此页面提供关键应用程序指标的高级概览。显示的统计数据不是实时的；它们由后端定期更新。刷新间隔在服务器端配置。';

  @override
  String get audience => '受众';

  @override
  String get content => '内容';

  @override
  String get community => '社区';

  @override
  String get monetization => '变现';

  @override
  String get configuration => '配置';

  @override
  String get loadingConfiguration => '正在加载配置...';

  @override
  String get noConfigurationDataHeadline => '无配置数据';

  @override
  String get noConfigurationDataSubheadline => '无法加载应用程序的远程配置。';

  @override
  String get readOnlyConfigurationView => '只读配置视图';

  @override
  String get readOnlyConfigurationViewDescription =>
      '这是应用程序运营设置的实时只读快照。要进行更改，请转到主“远程配置”页面。';

  @override
  String get providers => '提供商';

  @override
  String get summary => '摘要';

  @override
  String get about => '关于';

  @override
  String get localizationConfigDescription => '配置支持的语言和默认回退。';

  @override
  String get enabledLanguagesLabel => '已启用语言';

  @override
  String get cannotDisableDefaultLanguage => '无法禁用默认语言。';

  @override
  String get atLeastOneLanguageRequired => '必须至少启用一种语言。';

  @override
  String get defaultLanguageLabel => '默认语言';

  @override
  String get defaultLanguageDescription => '如果用户偏好不受支持时的回退语言。';

  @override
  String get localizationTitle => '本地化';

  @override
  String get localizationDescription =>
      '控制移动应用和仪表盘的激活语言。启用一种语言允许用户查看翻译后的内容，并在仪表盘表单中添加相应的输入字段。没有翻译的内容将回退到默认语言。';

  @override
  String defaultLanguageRequired(String language) {
    return '默认语言 ($language) 是必填项。';
  }

  @override
  String get languageNameEn => '英语';

  @override
  String get languageNameEs => '西班牙语';

  @override
  String get languageNameFr => '法语';

  @override
  String get languageNameAr => '阿拉伯语';

  @override
  String get languageNamePt => '葡萄牙语';

  @override
  String get languageNameDe => '德语';

  @override
  String get languageNameIt => '意大利语';

  @override
  String get languageNameZh => '中文';

  @override
  String get languageNameHi => '印地语';

  @override
  String get languageNameJa => '日语';
}
