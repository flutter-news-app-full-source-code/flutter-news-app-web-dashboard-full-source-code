// ignore_for_file: unused_field

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/app/config/config.dart'
    as local_config;
import 'package:logging/logging.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthRepository authenticationRepository,
    required DataRepository<AppSettings> appSettingsRepository,
    required DataRepository<RemoteConfig> appConfigRepository,
    required local_config.AppEnvironment environment,
    Logger? logger,
  }) : _authenticationRepository = authenticationRepository,
       _appSettingsRepository = appSettingsRepository,
       _appConfigRepository = appConfigRepository,
       _logger = logger ?? Logger('AppBloc'),
       super(AppState(environment: environment)) {
    on<AppUserChanged>(_onAppUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppUserAppSettingsChanged>(
      _onAppUserAppSettingsChanged,
    );
    on<AppRemoteConfigChanged>(_onRemoteConfigChanged);

    _userSubscription = _authenticationRepository.authStateChanges.listen(
      (User? user) => add(AppUserChanged(user)),
    );

    _configSubscription = _appConfigRepository.entityUpdated
        .where((type) => type == RemoteConfig)
        .listen((_) => add(const AppRemoteConfigChanged()));

    // Initial load of remote config
    add(const AppRemoteConfigChanged());
  }

  final AuthRepository _authenticationRepository;
  final DataRepository<AppSettings> _appSettingsRepository;
  final DataRepository<RemoteConfig> _appConfigRepository;
  final Logger _logger;
  late final StreamSubscription<User?> _userSubscription;
  late final StreamSubscription<Type> _configSubscription;

  /// Handles user changes and loads initial settings once user is available.
  Future<void> _onAppUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) async {
    final user = event.user;
    final AppStatus status;

    if (user != null) {
      if (user.role == UserRole.admin || user.role == UserRole.publisher) {
        status = AppStatus.authenticated;
      } else {
        status = AppStatus.unauthenticated;
      }
    } else {
      status = AppStatus.unauthenticated;
    }

    // Emit user and status update
    emit(state.copyWith(status: status, user: user));

    // If user is authenticated, load their app settings
    if (status == AppStatus.authenticated && user != null) {
      try {
        final appSettings = await _appSettingsRepository.read(
          id: user.id,
        );
        emit(state.copyWith(appSettings: appSettings));
      } on NotFoundException {
        // If settings not found, create default ones
        _logger.info(
          'User app settings not found for user ${user.id}. Creating default.',
        );
        final defaultSettings = AppSettings(
          id: user.id,
          displaySettings: const DisplaySettings(
            baseTheme: AppBaseTheme.system,
            accentTheme: AppAccentTheme.defaultBlue,
            fontFamily: 'SystemDefault',
            textScaleFactor: AppTextScaleFactor.medium,
            fontWeight: AppFontWeight.regular,
          ),
          language: SupportedLanguage.en,
          feedSettings: const FeedSettings(
            feedItemDensity: FeedItemDensity.standard,
            feedItemImageStyle: FeedItemImageStyle.largeThumbnail,
            feedItemClickBehavior: FeedItemClickBehavior.defaultBehavior,
          ),
        );
        await _appSettingsRepository.create(item: defaultSettings);
        emit(state.copyWith(appSettings: defaultSettings));
      } on HttpException catch (e, s) {
        // Handle HTTP exceptions during settings load
        _logger.severe(
          'Error loading user app settings for user ${user.id}: ${e.message}',
          e,
          s,
        );
        emit(state.copyWith(clearAppSettings: true));
      } catch (e, s) {
        // Handle any other unexpected errors
        _logger.severe(
          'Unexpected error loading user app settings for user ${user.id}: $e',
          e,
          s,
        );
        emit(state.copyWith(clearAppSettings: true));
      }
    } else {
      // If user is unauthenticated or anonymous, clear app settings
      emit(state.copyWith(clearAppSettings: true));
    }
  }

  void _onAppUserAppSettingsChanged(
    AppUserAppSettingsChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(appSettings: event.appSettings));
  }

  Future<void> _onRemoteConfigChanged(
    AppRemoteConfigChanged event,
    Emitter<AppState> emit,
  ) async {
    try {
      final config = await _appConfigRepository.read(id: kRemoteConfigId);
      emit(state.copyWith(remoteConfig: config));
    } catch (e, s) {
      _logger.severe('Failed to load remote config', e, s);
      // We might want to emit a failure state or keep the old config
    }
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.signOut());
    emit(
      state.copyWith(clearAppSettings: true),
    );
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    _configSubscription.cancel();
    return super.close();
  }
}
