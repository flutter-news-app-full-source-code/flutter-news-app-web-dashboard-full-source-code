import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ht_auth_api/ht_auth_api.dart';
import 'package:ht_auth_client/ht_auth_client.dart';
import 'package:ht_auth_inmemory/ht_auth_inmemory.dart';
import 'package:ht_auth_repository/ht_auth_repository.dart';
import 'package:ht_dashboard/app/app.dart';
import 'package:ht_dashboard/app/config/config.dart' as app_config;
import 'package:ht_dashboard/bloc_observer.dart';
import 'package:ht_data_api/ht_data_api.dart';
import 'package:ht_data_client/ht_data_client.dart';
import 'package:ht_data_inmemory/ht_data_inmemory.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_http_client/ht_http_client.dart';
import 'package:ht_kv_storage_shared_preferences/ht_kv_storage_shared_preferences.dart';
import 'package:ht_shared/ht_shared.dart';
import 'package:ht_ui_kit/ht_ui_kit.dart';
import 'package:logging/logging.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<Widget> bootstrap(
  app_config.AppConfig appConfig,
  app_config.AppEnvironment environment,
) async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  timeago.setLocaleMessages('en', EnTimeagoMessages());
  timeago.setLocaleMessages('ar', ArTimeagoMessages());

  final kvStorage = await HtKvStorageSharedPreferences.getInstance();

  late final HtAuthClient authClient;
  late final HtAuthRepository authenticationRepository;
  HtHttpClient? httpClient;

  if (appConfig.environment == app_config.AppEnvironment.demo) {
    authClient = HtAuthInmemory(
      logger: Logger('HtAuthInmemory'),
    );
    authenticationRepository = HtAuthRepository(
      authClient: authClient,
      storageService: kvStorage,
    );
  } else {
    httpClient = HtHttpClient(
      baseUrl: appConfig.baseUrl,
      tokenProvider: () => authenticationRepository.getAuthToken(),
    );
    authClient = HtAuthApi(
      httpClient: httpClient,
      logger: Logger('HtAuthApi'),
    );
    authenticationRepository = HtAuthRepository(
      authClient: authClient,
      storageService: kvStorage,
    );
  }

  HtDataClient<Headline> headlinesClient;
  HtDataClient<Topic> topicsClient;
  HtDataClient<Country> countriesClient;
  HtDataClient<Source> sourcesClient;
  HtDataClient<UserContentPreferences> userContentPreferencesClient;
  HtDataClient<UserAppSettings> userAppSettingsClient;
  HtDataClient<RemoteConfig> remoteConfigClient;
  HtDataClient<DashboardSummary> dashboardSummaryClient;

  if (appConfig.environment == app_config.AppEnvironment.demo) {
    headlinesClient = HtDataInMemory<Headline>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: headlinesFixturesData,
      logger: Logger('HtDataInMemory<Headline>'),
    );
    topicsClient = HtDataInMemory<Topic>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: topicsFixturesData,
      logger: Logger('HtDataInMemory<Topic>'),
    );
    countriesClient = HtDataInMemory<Country>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: countriesFixturesData,
      logger: Logger('HtDataInMemory<Country>'),
    );
    sourcesClient = HtDataInMemory<Source>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: sourcesFixturesData,
      logger: Logger('HtDataInMemory<Source>'),
    );
    userContentPreferencesClient = HtDataInMemory<UserContentPreferences>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      logger: Logger('HtDataInMemory<UserContentPreferences>'),
    );
    userAppSettingsClient = HtDataInMemory<UserAppSettings>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      logger: Logger('HtDataInMemory<UserAppSettings>'),
    );
    remoteConfigClient = HtDataInMemory<RemoteConfig>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: remoteConfigsFixturesData,
      logger: Logger('HtDataInMemory<RemoteConfig>'),
    );
    dashboardSummaryClient = HtDataInMemory<DashboardSummary>(
      toJson: (i) => i.toJson(),
      getId: (i) => i.id,
      initialData: dashboardSummaryFixturesData,
      logger: Logger('HtDataInMemory<DashboardSummary>'),
    );
  } else if (appConfig.environment == app_config.AppEnvironment.development) {
    headlinesClient = HtDataApi<Headline>(
      httpClient: httpClient!,
      modelName: 'headline',
      fromJson: Headline.fromJson,
      toJson: (headline) => headline.toJson(),
      logger: Logger('HtDataApi<Headline>'),
    );
    topicsClient = HtDataApi<Topic>(
      httpClient: httpClient,
      modelName: 'topic',
      fromJson: Topic.fromJson,
      toJson: (topic) => topic.toJson(),
      logger: Logger('HtDataApi<Topic>'),
    );
    countriesClient = HtDataApi<Country>(
      httpClient: httpClient,
      modelName: 'country',
      fromJson: Country.fromJson,
      toJson: (country) => country.toJson(),
      logger: Logger('HtDataApi<Country>'),
    );
    sourcesClient = HtDataApi<Source>(
      httpClient: httpClient,
      modelName: 'source',
      fromJson: Source.fromJson,
      toJson: (source) => source.toJson(),
      logger: Logger('HtDataApi<Source>'),
    );
    userContentPreferencesClient = HtDataApi<UserContentPreferences>(
      httpClient: httpClient,
      modelName: 'user_content_preferences',
      fromJson: UserContentPreferences.fromJson,
      toJson: (prefs) => prefs.toJson(),
      logger: Logger('HtDataApi<UserContentPreferences>'),
    );
    userAppSettingsClient = HtDataApi<UserAppSettings>(
      httpClient: httpClient,
      modelName: 'user_app_settings',
      fromJson: UserAppSettings.fromJson,
      toJson: (settings) => settings.toJson(),
      logger: Logger('HtDataApi<UserAppSettings>'),
    );
    remoteConfigClient = HtDataApi<RemoteConfig>(
      httpClient: httpClient,
      modelName: 'remote_config',
      fromJson: RemoteConfig.fromJson,
      toJson: (config) => config.toJson(),
      logger: Logger('HtDataApi<RemoteConfig>'),
    );
    dashboardSummaryClient = HtDataApi<DashboardSummary>(
      httpClient: httpClient,
      modelName: 'dashboard_summary',
      fromJson: DashboardSummary.fromJson,
      toJson: (summary) => summary.toJson(),
      logger: Logger('HtDataApi<DashboardSummary>'),
    );
  } else {
    headlinesClient = HtDataApi<Headline>(
      httpClient: httpClient!,
      modelName: 'headline',
      fromJson: Headline.fromJson,
      toJson: (headline) => headline.toJson(),
      logger: Logger('HtDataApi<Headline>'),
    );
    topicsClient = HtDataApi<Topic>(
      httpClient: httpClient,
      modelName: 'topic',
      fromJson: Topic.fromJson,
      toJson: (topic) => topic.toJson(),
      logger: Logger('HtDataApi<Topic>'),
    );
    countriesClient = HtDataApi<Country>(
      httpClient: httpClient,
      modelName: 'country',
      fromJson: Country.fromJson,
      toJson: (country) => country.toJson(),
      logger: Logger('HtDataApi<Country>'),
    );
    sourcesClient = HtDataApi<Source>(
      httpClient: httpClient,
      modelName: 'source',
      fromJson: Source.fromJson,
      toJson: (source) => source.toJson(),
      logger: Logger('HtDataApi<Source>'),
    );
    userContentPreferencesClient = HtDataApi<UserContentPreferences>(
      httpClient: httpClient,
      modelName: 'user_content_preferences',
      fromJson: UserContentPreferences.fromJson,
      toJson: (prefs) => prefs.toJson(),
      logger: Logger('HtDataApi<UserContentPreferences>'),
    );
    userAppSettingsClient = HtDataApi<UserAppSettings>(
      httpClient: httpClient,
      modelName: 'user_app_settings',
      fromJson: UserAppSettings.fromJson,
      toJson: (settings) => settings.toJson(),
      logger: Logger('HtDataApi<UserAppSettings>'),
    );
    remoteConfigClient = HtDataApi<RemoteConfig>(
      httpClient: httpClient,
      modelName: 'remote_config',
      fromJson: RemoteConfig.fromJson,
      toJson: (config) => config.toJson(),
      logger: Logger('HtDataApi<RemoteConfig>'),
    );
    dashboardSummaryClient = HtDataApi<DashboardSummary>(
      httpClient: httpClient,
      modelName: 'dashboard_summary',
      fromJson: DashboardSummary.fromJson,
      toJson: (summary) => summary.toJson(),
      logger: Logger('HtDataApi<DashboardSummary>'),
    );
  }

  final headlinesRepository = HtDataRepository<Headline>(
    dataClient: headlinesClient,
  );
  final topicsRepository = HtDataRepository<Topic>(
    dataClient: topicsClient,
  );
  final countriesRepository = HtDataRepository<Country>(
    dataClient: countriesClient,
  );
  final sourcesRepository = HtDataRepository<Source>(dataClient: sourcesClient);
  final userContentPreferencesRepository =
      HtDataRepository<UserContentPreferences>(
        dataClient: userContentPreferencesClient,
      );
  final userAppSettingsRepository = HtDataRepository<UserAppSettings>(
    dataClient: userAppSettingsClient,
  );
  final remoteConfigRepository = HtDataRepository<RemoteConfig>(
    dataClient: remoteConfigClient,
  );
  final dashboardSummaryRepository = HtDataRepository<DashboardSummary>(
    dataClient: dashboardSummaryClient,
  );

  return App(
    htAuthenticationRepository: authenticationRepository,
    htHeadlinesRepository: headlinesRepository,
    htTopicsRepository: topicsRepository,
    htCountriesRepository: countriesRepository,
    htSourcesRepository: sourcesRepository,
    htUserAppSettingsRepository: userAppSettingsRepository,
    htUserContentPreferencesRepository: userContentPreferencesRepository,
    htRemoteConfigRepository: remoteConfigRepository,
    htDashboardSummaryRepository: dashboardSummaryRepository,
    kvStorageService: kvStorage,
    environment: environment,
  );
}
