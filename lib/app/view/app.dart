//
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ht_auth_repository/ht_auth_repository.dart';
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_kv_storage_service/ht_kv_storage_service.dart';
import 'package:ht_dashboard/app/bloc/app_bloc.dart';
import 'package:ht_dashboard/app/config/app_environment.dart';
import 'package:ht_dashboard/authentication/bloc/authentication_bloc.dart';
import 'package:ht_dashboard/l10n/app_localizations.dart';
import 'package:ht_dashboard/l10n/l10n.dart';
import 'package:ht_dashboard/router/router.dart';
import 'package:ht_shared/ht_shared.dart';

class App extends StatelessWidget {
  const App({
    required HtAuthRepository htAuthenticationRepository,
    required HtDataRepository<Headline> htHeadlinesRepository,
    required HtDataRepository<Category> htCategoriesRepository,
    required HtDataRepository<Country> htCountriesRepository,
    required HtDataRepository<Source> htSourcesRepository,
    required HtDataRepository<UserAppSettings> htUserAppSettingsRepository,
    required HtDataRepository<UserContentPreferences>
        htUserContentPreferencesRepository,
    required HtDataRepository<AppConfig> htAppConfigRepository,
    required HtKVStorageService kvStorageService,
    required AppEnvironment environment,
    super.key,
  }) : _htAuthenticationRepository = htAuthenticationRepository,
       _htHeadlinesRepository = htHeadlinesRepository,
       _htCategoriesRepository = htCategoriesRepository,
       _htCountriesRepository = htCountriesRepository,
       _htSourcesRepository = htSourcesRepository,
       _htUserAppSettingsRepository = htUserAppSettingsRepository,
       _htUserContentPreferencesRepository = htUserContentPreferencesRepository,
       _htAppConfigRepository = htAppConfigRepository,
       _kvStorageService = kvStorageService,
       _environment = environment;

  final HtAuthRepository _htAuthenticationRepository;
  final HtDataRepository<Headline> _htHeadlinesRepository;
  final HtDataRepository<Category> _htCategoriesRepository;
  final HtDataRepository<Country> _htCountriesRepository;
  final HtDataRepository<Source> _htSourcesRepository;
  final HtDataRepository<UserAppSettings> _htUserAppSettingsRepository;
  final HtDataRepository<UserContentPreferences>
      _htUserContentPreferencesRepository;
  final HtDataRepository<AppConfig> _htAppConfigRepository;
  final HtKVStorageService _kvStorageService;
  final AppEnvironment _environment;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _htAuthenticationRepository),
        RepositoryProvider.value(value: _htHeadlinesRepository),
        RepositoryProvider.value(value: _htCategoriesRepository),
        RepositoryProvider.value(value: _htCountriesRepository),
        RepositoryProvider.value(value: _htSourcesRepository),
        RepositoryProvider.value(value: _htUserAppSettingsRepository),
        RepositoryProvider.value(value: _htUserContentPreferencesRepository),
        RepositoryProvider.value(value: _htAppConfigRepository),
        RepositoryProvider.value(value: _kvStorageService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppBloc(
              authenticationRepository: context.read<HtAuthRepository>(),
              userAppSettingsRepository:
                  context.read<HtDataRepository<UserAppSettings>>(),
              appConfigRepository: context.read<HtDataRepository<AppConfig>>(),
              environment: _environment,
            ),
          ),
          BlocProvider(
            create: (context) => AuthenticationBloc(
              authenticationRepository: context.read<HtAuthRepository>(),
            ),
          ),
        ],
        child: _AppView(
          htAuthenticationRepository: _htAuthenticationRepository,
          environment: _environment,
        ),
      ),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView({
    required this.htAuthenticationRepository,
    required this.environment,
  });

  final HtAuthRepository htAuthenticationRepository;
  final AppEnvironment environment;

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  late final GoRouter _router;
  late final ValueNotifier<AppStatus> _statusNotifier;

  @override
  void initState() {
    super.initState();
    final appBloc = context.read<AppBloc>();
    _statusNotifier = ValueNotifier<AppStatus>(appBloc.state.status);
    _router = createRouter(
      authStatusNotifier: _statusNotifier,
      htAuthenticationRepository: widget.htAuthenticationRepository,
      environment: widget.environment,
    );
  }

  @override
  void dispose() {
    _statusNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        _statusNotifier.value = state.status;
      },
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
