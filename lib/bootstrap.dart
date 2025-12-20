import 'package:auth_api/auth_api.dart';
import 'package:auth_client/auth_client.dart';
import 'package:auth_inmemory/auth_inmemory.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:core/core.dart';
import 'package:data_api/data_api.dart';
import 'package:data_client/data_client.dart';
import 'package:data_inmemory/data_inmemory.dart';
import 'package:data_repository/data_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/app.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/config/config.dart'
    as app_config;
import 'package:flutter_news_app_web_dashboard_full_source_code/bloc_observer.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/pending_deletions_service.dart';
import 'package:http_client/http_client.dart';
import 'package:kv_storage_shared_preferences/kv_storage_shared_preferences.dart';
import 'package:logging/logging.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:ui_kit/ui_kit.dart';

Future<Widget> bootstrap(
  app_config.AppConfig appConfig,
  app_config.AppEnvironment environment,
) async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  timeago.setLocaleMessages('en', EnTimeagoMessages());
  timeago.setLocaleMessages('ar', ArTimeagoMessages());

  final kvStorage = await KVStorageSharedPreferences.getInstance();

  late final AuthClient authClient;
  late final AuthRepository authenticationRepository;
  HttpClient? httpClient;
  late final PendingDeletionsService pendingDeletionsService;

  if (appConfig.environment == app_config.AppEnvironment.demo) {
    authClient = AuthInmemory(logger: Logger('AuthInmemory'));
    authenticationRepository = AuthRepository(
      authClient: authClient,
      storageService: kvStorage,
    );
  } else {
    httpClient = HttpClient(
      baseUrl: appConfig.baseUrl,
      tokenProvider: () => authenticationRepository.getAuthToken(),
    );
    authClient = AuthApi(httpClient: httpClient, logger: Logger('AuthApi'));
    authenticationRepository = AuthRepository(
      authClient: authClient,
      storageService: kvStorage,
    );
  }

  DataClient<Headline> headlinesClient;
  DataClient<Topic> topicsClient;
  DataClient<Source> sourcesClient;
  DataClient<UserContentPreferences> userContentPreferencesClient;
  DataClient<AppSettings> appSettingsClient;
  DataClient<RemoteConfig> remoteConfigClient;
  DataClient<Country> countriesClient;
  DataClient<Language> languagesClient;
  DataClient<User> usersClient;
  DataClient<Engagement> engagementsClient;
  DataClient<Report> reportsClient;
  DataClient<AppReview> appReviewsClient;

  if (appConfig.environment == app_config.AppEnvironment.demo) {
    headlinesClient = DataInMemory<Headline>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: getHeadlinesFixturesData(languageCode: 'en'),
      logger: Logger('DataInMemory<Headline>'),
    );
    topicsClient = DataInMemory<Topic>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: getTopicsFixturesData(languageCode: 'en'),
      logger: Logger('DataInMemory<Topic>'),
    );
    sourcesClient = DataInMemory<Source>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: getSourcesFixturesData(languageCode: 'en'),
      logger: Logger('DataInMemory<Source>'),
    );
    userContentPreferencesClient = DataInMemory<UserContentPreferences>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      logger: Logger('DataInMemory<UserContentPreferences>'),
    );
    appSettingsClient = DataInMemory<AppSettings>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      logger: Logger(
        'DataInMemory<AppSettings>',
      ),
    );
    remoteConfigClient = DataInMemory<RemoteConfig>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: remoteConfigsFixturesData,
      logger: Logger('DataInMemory<RemoteConfig>'),
    );
    countriesClient = DataInMemory<Country>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: countriesFixturesData,
      logger: Logger('DataInMemory<Country>'),
    );
    languagesClient = DataInMemory<Language>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: languagesFixturesData,
      logger: Logger('DataInMemory<Language>'),
    );

    usersClient = DataInMemory<User>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: usersFixturesData,
      logger: Logger('DataInMemory<User>'),
    );
    engagementsClient = DataInMemory<Engagement>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: getEngagementsFixturesData(),
      logger: Logger('DataInMemory<Engagement>'),
    );
    reportsClient = DataInMemory<Report>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: getReportsFixturesData(),
      logger: Logger('DataInMemory<Report>'),
    );
    appReviewsClient = DataInMemory<AppReview>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: getAppReviewsFixturesData(),
      logger: Logger('DataInMemory<AppReview>'),
    );
  } else {
    headlinesClient = DataApi<Headline>(
      httpClient: httpClient!,
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
  }

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
    usersRepository: usersRepository,
    engagementsRepository: engagementsRepository,
    reportsRepository: reportsRepository,
    appReviewsRepository: appReviewsRepository,
    storageService: kvStorage,
    environment: environment,
    pendingDeletionsService: pendingDeletionsService,
  );
}
