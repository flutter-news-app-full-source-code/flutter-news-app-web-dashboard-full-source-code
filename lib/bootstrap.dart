import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:veritai_dashboard/app/app.dart';
import 'package:veritai_dashboard/app/config/config.dart' as app_config;
import 'package:veritai_dashboard/bloc_observer.dart';
import 'package:veritai_dashboard/shared/constants/app_constants.dart';
import 'package:veritai_dashboard/shared/data/enrichment_repository.dart';
import 'package:veritai_dashboard/shared/services/analytics_service.dart';
import 'package:veritai_dashboard/shared/services/pending_deletions_service.dart';

Future<Widget> bootstrap(
  app_config.AppConfig appConfig,
  app_config.AppEnvironment environment,
) async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  // Validate application constants to ensure layout integrity.
  AppConstants.validate();

  timeago.setLocaleMessages('en', EnTimeagoMessages());
  timeago.setLocaleMessages('ar', ArTimeagoMessages());
  timeago.setLocaleMessages('es', timeago.EsMessages());
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('pt', timeago.PtBrMessages());
  timeago.setLocaleMessages('de', timeago.DeMessages());
  timeago.setLocaleMessages('it', timeago.ItMessages());
  timeago.setLocaleMessages('zh', timeago.ZhMessages());
  timeago.setLocaleMessages('hi', timeago.HiMessages());
  timeago.setLocaleMessages('ja', timeago.JaMessages());

  final kvStorage = await KVStorageSharedPreferences.getInstance();

  late final PendingDeletionsService pendingDeletionsService;
  late final AuthRepository authenticationRepository;

  final httpClient = HttpClient(
    baseUrl: appConfig.baseUrl,
    tokenProvider: () => authenticationRepository.getAuthToken(),
  );
  final authClient = AuthApi(httpClient: httpClient, logger: Logger('AuthApi'));
  authenticationRepository = AuthRepository(
    authClient: authClient,
    storageService: kvStorage,
  );

  DataClient<Headline> headlinesClient;
  DataClient<Topic> topicsClient;
  DataClient<Source> sourcesClient;
  DataClient<UserContentPreferences> userContentPreferencesClient;
  DataClient<AppSettings> appSettingsClient;
  DataClient<RemoteConfig> remoteConfigClient;
  DataClient<Country> countriesClient;
  DataClient<Language> languagesClient;
  DataClient<Person> personsClient;
  DataClient<User> usersClient;
  DataClient<Engagement> engagementsClient;
  DataClient<Report> reportsClient;
  MediaClient mediaClient;
  DataClient<AppReview> appReviewsClient;
  DataClient<KpiCardData> kpiCardsClient;
  DataClient<ChartCardData> chartCardsClient;
  DataClient<RankedListCardData> rankedListCardsClient;
  DataClient<UserRewards> userRewardsClient;
  DataClient<NewsAutomationTask> automationClient;
  EnrichmentClient enrichmentClient;

  headlinesClient = DataApi<Headline>(
    httpClient: httpClient,
    modelName: 'headline',
    fromJson: Headline.fromJson,
    toJson: (headline) => headline.toJson(),
    logger: Logger('DataApi<Headline>'),
  );
  topicsClient = DataApi<Topic>(
    httpClient: httpClient,
    modelName: 'topic',
    fromJson: Topic.fromJson,
    toJson: (topic) => topic.toJson(),
    logger: Logger('DataApi<Topic>'),
  );
  sourcesClient = DataApi<Source>(
    httpClient: httpClient,
    modelName: 'source',
    fromJson: Source.fromJson,
    toJson: (source) => source.toJson(),
    logger: Logger('DataApi<Source>'),
  );
  userContentPreferencesClient = DataApi<UserContentPreferences>(
    httpClient: httpClient,
    modelName: 'user_content_preferences',
    fromJson: UserContentPreferences.fromJson,
    toJson: (prefs) => prefs.toJson(),
    logger: Logger('DataApi<UserContentPreferences>'),
  );
  appSettingsClient = DataApi<AppSettings>(
    httpClient: httpClient,
    modelName: 'app_settings',
    fromJson: AppSettings.fromJson,
    toJson: (settings) => settings.toJson(),
    logger: Logger('DataApi<AppSettings>'),
  );
  remoteConfigClient = DataApi<RemoteConfig>(
    httpClient: httpClient,
    modelName: 'remote_config',
    fromJson: RemoteConfig.fromJson,
    toJson: (config) => config.toJson(),
    logger: Logger('DataApi<RemoteConfig>'),
  );
  countriesClient = DataApi<Country>(
    httpClient: httpClient,
    modelName: 'country',
    fromJson: Country.fromJson,
    toJson: (country) => country.toJson(),
    logger: Logger('DataApi<Country>'),
  );
  languagesClient = DataApi<Language>(
    httpClient: httpClient,
    modelName: 'language',
    fromJson: Language.fromJson,
    toJson: (language) => language.toJson(),
    logger: Logger('DataApi<Language>'),
  );
  personsClient = DataApi<Person>(
    httpClient: httpClient,
    modelName: 'person',
    fromJson: Person.fromJson,
    toJson: (person) => person.toJson(),
    logger: Logger('DataApi<Person>'),
  );

  usersClient = DataApi<User>(
    httpClient: httpClient,
    modelName: 'user',
    fromJson: User.fromJson,
    toJson: (user) => user.toJson(),
    logger: Logger('DataApi<User>'),
  );
  engagementsClient = DataApi<Engagement>(
    httpClient: httpClient,
    modelName: 'engagement',
    fromJson: Engagement.fromJson,
    toJson: (engagement) => engagement.toJson(),
    logger: Logger('DataApi<Engagement>'),
  );
  reportsClient = DataApi<Report>(
    httpClient: httpClient,
    modelName: 'report',
    fromJson: Report.fromJson,
    toJson: (report) => report.toJson(),
    logger: Logger('DataApi<Report>'),
  );
  appReviewsClient = DataApi<AppReview>(
    httpClient: httpClient,
    modelName: 'app_review',
    fromJson: AppReview.fromJson,
    toJson: (appReview) => appReview.toJson(),
    logger: Logger('DataApi<AppReview>'),
  );
  kpiCardsClient = DataApi<KpiCardData>(
    httpClient: httpClient,
    modelName: 'kpi_card_data',
    fromJson: KpiCardData.fromJson,
    toJson: (item) => item.toJson(),
    logger: Logger('DataApi<KpiCardData>'),
  );
  chartCardsClient = DataApi<ChartCardData>(
    httpClient: httpClient,
    modelName: 'chart_card_data',
    fromJson: ChartCardData.fromJson,
    toJson: (item) => item.toJson(),
    logger: Logger('DataApi<ChartCardData>'),
  );
  rankedListCardsClient = DataApi<RankedListCardData>(
    httpClient: httpClient,
    modelName: 'ranked_list_card_data',
    fromJson: RankedListCardData.fromJson,
    toJson: (item) => item.toJson(),
    logger: Logger('DataApi<RankedListCardData>'),
  );
  userRewardsClient = DataApi<UserRewards>(
    httpClient: httpClient,
    modelName: 'user_rewards',
    fromJson: UserRewards.fromJson,
    toJson: (item) => item.toJson(),
    logger: Logger('DataApi<UserRewards>'),
  );
  automationClient = DataApi<NewsAutomationTask>(
    httpClient: httpClient,
    modelName: 'news_automation_task',
    fromJson: NewsAutomationTask.fromJson,
    toJson: (item) => item.toJson(),
    logger: Logger('DataApi<NewsAutomationTask>'),
  );
  mediaClient = MediaApi(
    httpClient: httpClient,
    logger: Logger('MediaApi'),
  );
  enrichmentClient = EnrichmentApi(
    httpClient: httpClient,
    logger: Logger('EnrichmentApi'),
  );

  pendingDeletionsService = PendingDeletionsServiceImpl(
    logger: Logger('PendingDeletionsService'),
  );

  final headlinesRepository = DataRepository<Headline>(
    dataClient: headlinesClient,
  );
  final topicsRepository = DataRepository<Topic>(dataClient: topicsClient);
  final sourcesRepository = DataRepository<Source>(dataClient: sourcesClient);
  final userContentPreferencesRepository =
      DataRepository<UserContentPreferences>(
        dataClient: userContentPreferencesClient,
      );
  final appSettingsRepository = DataRepository<AppSettings>(
    dataClient: appSettingsClient,
  );
  final remoteConfigRepository = DataRepository<RemoteConfig>(
    dataClient: remoteConfigClient,
  );
  final countriesRepository = DataRepository<Country>(
    dataClient: countriesClient,
  );
  final languagesRepository = DataRepository<Language>(
    dataClient: languagesClient,
  );
  final personsRepository = DataRepository<Person>(
    dataClient: personsClient,
  );
  final usersRepository = DataRepository<User>(dataClient: usersClient);
  final engagementsRepository = DataRepository<Engagement>(
    dataClient: engagementsClient,
  );
  final reportsRepository = DataRepository<Report>(
    dataClient: reportsClient,
  );
  final appReviewsRepository = DataRepository<AppReview>(
    dataClient: appReviewsClient,
  );
  final kpiCardsRepository = DataRepository<KpiCardData>(
    dataClient: kpiCardsClient,
  );
  final chartCardsRepository = DataRepository<ChartCardData>(
    dataClient: chartCardsClient,
  );
  final rankedListCardsRepository = DataRepository<RankedListCardData>(
    dataClient: rankedListCardsClient,
  );
  final userRewardsRepository = DataRepository<UserRewards>(
    dataClient: userRewardsClient,
  );
  final automationRepository = DataRepository<NewsAutomationTask>(
    dataClient: automationClient,
  );
  final mediaRepository = MediaRepository(mediaClient: mediaClient);
  final enrichmentRepository = EnrichmentRepository(
    enrichmentClient: enrichmentClient,
  );

  final analyticsService = AnalyticsService(
    kpiRepository: kpiCardsRepository,
    chartRepository: chartCardsRepository,
    rankedListRepository: rankedListCardsRepository,
  );

  return App(
    authenticationRepository: authenticationRepository,
    headlinesRepository: headlinesRepository,
    topicsRepository: topicsRepository,
    sourcesRepository: sourcesRepository,
    appSettingsRepository: appSettingsRepository,
    userContentPreferencesRepository: userContentPreferencesRepository,
    remoteConfigRepository: remoteConfigRepository,
    countriesRepository: countriesRepository,
    languagesRepository: languagesRepository,
    personsRepository: personsRepository,
    usersRepository: usersRepository,
    engagementsRepository: engagementsRepository,
    reportsRepository: reportsRepository,
    appReviewsRepository: appReviewsRepository,
    analyticsService: analyticsService,
    mediaRepository: mediaRepository,
    enrichmentRepository: enrichmentRepository,
    automationRepository: automationRepository,
    userRewardsRepository: userRewardsRepository,
    storageService: kvStorage,
    environment: environment,
    pendingDeletionsService: pendingDeletionsService,
  );
}
