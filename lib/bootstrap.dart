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
  DataClient<UserAppSettings> userAppSettingsClient;
  DataClient<RemoteConfig> remoteConfigClient;
  DataClient<DashboardSummary> dashboardSummaryClient;
  DataClient<Country> countriesClient;
  DataClient<Language> languagesClient;
  DataClient<LocalAd> localAdsClient;

  if (appConfig.environment == app_config.AppEnvironment.demo) {
    headlinesClient = DataInMemory<Headline>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: headlinesFixturesData,
      logger: Logger('DataInMemory<Headline>'),
    );
    topicsClient = DataInMemory<Topic>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: topicsFixturesData,
      logger: Logger('DataInMemory<Topic>'),
    );
    sourcesClient = DataInMemory<Source>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: sourcesFixturesData,
      logger: Logger('DataInMemory<Source>'),
    );
    userContentPreferencesClient = DataInMemory<UserContentPreferences>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      logger: Logger('DataInMemory<UserContentPreferences>'),
    );
    userAppSettingsClient = DataInMemory<UserAppSettings>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      logger: Logger('DataInMemory<UserAppSettings>'),
    );
    remoteConfigClient = DataInMemory<RemoteConfig>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: remoteConfigsFixturesData,
      logger: Logger('DataInMemory<RemoteConfig>'),
    );
    dashboardSummaryClient = DataInMemory<DashboardSummary>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: dashboardSummaryFixturesData,
      logger: Logger('DataInMemory<DashboardSummary>'),
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
    localAdsClient = DataInMemory<LocalAd>(
      toJson: FeedItem.toJson,
      getId: (i) => i.id,
      initialData: localAdsFixturesData/*  */,
      logger: Logger('DataInMemory<LocalAd>'),
    );
  } else if (appConfig.environment == app_config.AppEnvironment.development) {
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
    userAppSettingsClient = DataApi<UserAppSettings>(
      httpClient: httpClient,
      modelName: 'user_app_settings',
      fromJson: UserAppSettings.fromJson,
      toJson: (settings) => settings.toJson(),
      logger: Logger('DataApi<UserAppSettings>'),
    );
    remoteConfigClient = DataApi<RemoteConfig>(
      httpClient: httpClient,
      modelName: 'remote_config',
      fromJson: RemoteConfig.fromJson,
      toJson: (config) => config.toJson(),
      logger: Logger('DataApi<RemoteConfig>'),
    );
    dashboardSummaryClient = DataApi<DashboardSummary>(
      httpClient: httpClient,
      modelName: 'dashboard_summary',
      fromJson: DashboardSummary.fromJson,
      toJson: (summary) => summary.toJson(),
      logger: Logger('DataApi<DashboardSummary>'),
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
    localAdsClient = DataApi<LocalAd>(
      httpClient: httpClient,
      modelName: 'local_ad',
      fromJson: LocalAd.fromJson,
      toJson: LocalAd.toJson,
      logger: Logger('DataApi<LocalAd>'),
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
    userAppSettingsClient = DataApi<UserAppSettings>(
      httpClient: httpClient,
      modelName: 'user_app_settings',
      fromJson: UserAppSettings.fromJson,
      toJson: (settings) => settings.toJson(),
      logger: Logger('DataApi<UserAppSettings>'),
    );
    remoteConfigClient = DataApi<RemoteConfig>(
      httpClient: httpClient,
      modelName: 'remote_config',
      fromJson: RemoteConfig.fromJson,
      toJson: (config) => config.toJson(),
      logger: Logger('DataApi<RemoteConfig>'),
    );
    dashboardSummaryClient = DataApi<DashboardSummary>(
      httpClient: httpClient,
      modelName: 'dashboard_summary',
      fromJson: DashboardSummary.fromJson,
      toJson: (summary) => summary.toJson(),
      logger: Logger('DataApi<DashboardSummary>'),
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
    localAdsClient = DataApi<LocalAd>(
      httpClient: httpClient,
      modelName: 'local_ad',
      fromJson: LocalAd.fromJson,
      toJson: FeedItem.toJson,
      logger: Logger('DataApi<LocalAd>'),
    );
  }

  final headlinesRepository = DataRepository<Headline>(
    dataClient: headlinesClient,
  );
  final topicsRepository = DataRepository<Topic>(dataClient: topicsClient);
  final sourcesRepository = DataRepository<Source>(dataClient: sourcesClient);
  final userContentPreferencesRepository =
      DataRepository<UserContentPreferences>(
        dataClient: userContentPreferencesClient,
      );
  final userAppSettingsRepository = DataRepository<UserAppSettings>(
    dataClient: userAppSettingsClient,
  );
  final remoteConfigRepository = DataRepository<RemoteConfig>(
    dataClient: remoteConfigClient,
  );
  final dashboardSummaryRepository = DataRepository<DashboardSummary>(
    dataClient: dashboardSummaryClient,
  );
  final countriesRepository = DataRepository<Country>(
    dataClient: countriesClient,
  );
  final languagesRepository = DataRepository<Language>(
    dataClient: languagesClient,
  );
  final localAdsRepository = DataRepository<LocalAd>(
    dataClient: localAdsClient,
  );

  return App(
    authenticationRepository: authenticationRepository,
    headlinesRepository: headlinesRepository,
    topicsRepository: topicsRepository,
    sourcesRepository: sourcesRepository,
    userAppSettingsRepository: userAppSettingsRepository,
    userContentPreferencesRepository: userContentPreferencesRepository,
    remoteConfigRepository: remoteConfigRepository,
    dashboardSummaryRepository: dashboardSummaryRepository,
    countriesRepository: countriesRepository,
    languagesRepository: languagesRepository,
    localAdsRepository: localAdsRepository,
    storageService: kvStorage,
    environment: environment,
  );
}
