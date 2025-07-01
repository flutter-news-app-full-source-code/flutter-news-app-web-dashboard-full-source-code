// ignore_for_file: unused_field

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ht_auth_repository/ht_auth_repository.dart';
import 'package:ht_dashboard/app/config/config.dart' as local_config;
import 'package:ht_data_repository/ht_data_repository.dart';
import 'package:ht_shared/ht_shared.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required HtAuthRepository authenticationRepository,
    required HtDataRepository<UserAppSettings> userAppSettingsRepository,
    required HtDataRepository<AppConfig> appConfigRepository,
    required local_config.AppEnvironment environment,
  }) : _authenticationRepository = authenticationRepository,
       _userAppSettingsRepository = userAppSettingsRepository,
       _appConfigRepository = appConfigRepository,
       _environment = environment,
       super(
         const AppState(),
       ) {
    on<AppUserChanged>(_onAppUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppUserAppSettingsChanged>(_onAppUserAppSettingsChanged);

    _userSubscription = _authenticationRepository.authStateChanges.listen(
      (User? user) => add(AppUserChanged(user)),
    );
  }

  final HtAuthRepository _authenticationRepository;
  final HtDataRepository<UserAppSettings> _userAppSettingsRepository;
  final HtDataRepository<AppConfig> _appConfigRepository;
  final local_config.AppEnvironment _environment;
  late final StreamSubscription<User?> _userSubscription;

  /// Handles user changes and loads initial settings once user is available.
  Future<void> _onAppUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) async {
    // Determine the AppStatus based on the user object and its role
    final AppStatus status;

    switch (event.user?.role) {
      case null:
        status = AppStatus.unauthenticated;
      case UserRole.standardUser:
        status = AppStatus.authenticated;
      // ignore: no_default_cases
      default: // Fallback for any other roles not explicitly handled
        status = AppStatus
            .unauthenticated; // Treat other roles as unauthenticated for dashboard
    }

    // Emit user and status update
    emit(state.copyWith(status: status, user: event.user));

    // If user is authenticated, load their app settings
    if (event.user != null) {
      try {
        final userAppSettings = await _userAppSettingsRepository.read(
          id: event.user!.id,
        );
        emit(state.copyWith(userAppSettings: userAppSettings));
      } on NotFoundException {
        // If settings not found, create default ones
        final defaultSettings = UserAppSettings(id: event.user!.id);
        await _userAppSettingsRepository.create(item: defaultSettings);
        emit(state.copyWith(userAppSettings: defaultSettings));
      } on HtHttpException catch (e) {
        // Handle HTTP exceptions during settings load
        print('Error loading user app settings: ${e.message}');
        emit(state.copyWith()); // Clear settings on error
      } catch (e) {
        // Handle any other unexpected errors
        print('Unexpected error loading user app settings: $e');
        emit(state.copyWith()); // Clear settings on error
      }
    } else {
      // If user is unauthenticated, clear app settings
      emit(state.copyWith(clearUserAppSettings: true));
    }
  }

  void _onAppUserAppSettingsChanged(
    AppUserAppSettingsChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(userAppSettings: event.userAppSettings));
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.signOut());
    emit(
      state.copyWith(clearUserAppSettings: true),
    ); // Clear settings on logout
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
