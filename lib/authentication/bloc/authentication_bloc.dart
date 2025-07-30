import 'dart:async';

import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:core/core.dart'
    show
        AuthenticationException,
        ForbiddenException,
        HttpException,
        InvalidInputException,
        NetworkException,
        NotFoundException,
        OperationFailedException,
        ServerException,
        UnauthorizedException,
        UnknownException,
        User;
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

const _requestCodeCooldownDuration = Duration(seconds: 60);

/// {@template authentication_bloc}
/// Bloc responsible for managing the authentication state of the application.
/// {@endtemplate}
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  /// {@macro authentication_bloc}
  AuthenticationBloc({required AuthRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository,
      super(const AuthenticationState()) {
    // Listen to authentication state changes from the repository
    _userAuthSubscription = _authenticationRepository.authStateChanges.listen(
      (user) => add(_AuthenticationStatusChanged(user: user)),
    );

    on<_AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthenticationRequestSignInCodeRequested>(
      _onAuthenticationRequestSignInCodeRequested,
    );
    on<AuthenticationVerifyCodeRequested>(_onAuthenticationVerifyCodeRequested);
    on<AuthenticationSignOutRequested>(_onAuthenticationSignOutRequested);
    on<AuthenticationCooldownCompleted>(_onAuthenticationCooldownCompleted);
  }

  final AuthRepository _authenticationRepository;
  late final StreamSubscription<User?> _userAuthSubscription;
  Timer? _cooldownTimer;

  /// Handles [_AuthenticationStatusChanged] events.
  Future<void> _onAuthenticationStatusChanged(
    _AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    if (event.user != null) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.authenticated,
          user: event.user,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AuthenticationStatus.unauthenticated,
          user: null,
        ),
      );
    }
  }

  /// Handles [AuthenticationRequestSignInCodeRequested] events.
  Future<void> _onAuthenticationRequestSignInCodeRequested(
    AuthenticationRequestSignInCodeRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    // Prevent request if already in cooldown
    if (state.cooldownEndTime != null &&
        state.cooldownEndTime!.isAfter(DateTime.now())) {
      return;
    }

    emit(state.copyWith(status: AuthenticationStatus.requestCodeLoading));
    try {
      await _authenticationRepository.requestSignInCode(
        event.email,
        isDashboardLogin: true,
      );
      final cooldownEndTime = DateTime.now().add(_requestCodeCooldownDuration);
      emit(
        state.copyWith(
          status: AuthenticationStatus.codeSentSuccess,
          email: event.email,
          cooldownEndTime: cooldownEndTime,
        ),
      );

      // Start a timer to transition out of cooldown
      _cooldownTimer?.cancel();
      _cooldownTimer = Timer(
        _requestCodeCooldownDuration,
        () => add(const AuthenticationCooldownCompleted()),
      );
    } on InvalidInputException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on UnauthorizedException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on ForbiddenException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on NetworkException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on ServerException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on OperationFailedException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on HttpException catch (e) {
      // Catch any other HttpException subtypes
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } catch (e) {
      // Catch any other unexpected errors
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
      // Optionally log the stackTrace here
    }
  }

  /// Handles [AuthenticationVerifyCodeRequested] events.
  Future<void> _onAuthenticationVerifyCodeRequested(
    AuthenticationVerifyCodeRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(status: AuthenticationStatus.loading));
    try {
      await _authenticationRepository.verifySignInCode(
        event.email,
        event.code,
        isDashboardLogin: true,
      );
      // On success, the _AuthenticationStatusChanged listener will handle
      // emitting AuthenticationAuthenticated.
    } on InvalidInputException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on AuthenticationException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on NotFoundException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on NetworkException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on ServerException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on OperationFailedException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on HttpException catch (e) {
      // Catch any other HttpException subtypes
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } catch (e) {
      // Catch any other unexpected errors
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
      // Optionally log the stackTrace here
    }
  }

  /// Handles [AuthenticationSignOutRequested] events.
  Future<void> _onAuthenticationSignOutRequested(
    AuthenticationSignOutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(status: AuthenticationStatus.loading));
    try {
      await _authenticationRepository.signOut();
      // On success, the _AuthenticationStatusChanged listener will handle
      // emitting AuthenticationUnauthenticated.
    } on NetworkException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on ServerException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on OperationFailedException catch (e) {
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } on HttpException catch (e) {
      // Catch any other HttpException subtypes
      emit(state.copyWith(status: AuthenticationStatus.failure, exception: e));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  void _onAuthenticationCooldownCompleted(
    AuthenticationCooldownCompleted event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(
      state.copyWith(
        status: AuthenticationStatus.initial,
        clearCooldownEndTime: true,
      ),
    );
  }

  @override
  Future<void> close() {
    _userAuthSubscription.cancel();
    _cooldownTimer?.cancel();
    return super.close();
  }
}
