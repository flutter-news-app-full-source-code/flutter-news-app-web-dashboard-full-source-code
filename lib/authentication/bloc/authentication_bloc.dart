import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ht_auth_repository/ht_auth_repository.dart';
import 'package:ht_shared/ht_shared.dart'
    show
        AuthenticationException,
        ForbiddenException,
        HtHttpException,
        InvalidInputException,
        NetworkException,
        NotFoundException,
        OperationFailedException,
        ServerException,
        UnauthorizedException,
        UnknownException,
        User;

part 'authentication_event.dart';
part 'authentication_state.dart';

/// {@template authentication_bloc}
/// Bloc responsible for managing the authentication state of the application.
/// {@endtemplate}
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  /// {@macro authentication_bloc}
  AuthenticationBloc({required HtAuthRepository authenticationRepository})
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
  }

  final HtAuthRepository _authenticationRepository;
  late final StreamSubscription<User?> _userAuthSubscription;

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
    emit(state.copyWith(status: AuthenticationStatus.requestCodeLoading));
    try {
      await _authenticationRepository.requestSignInCode(
        event.email,
        isDashboardLogin: true,
      );
      emit(
        state.copyWith(
          status: AuthenticationStatus.codeSentSuccess,
          email: event.email,
        ),
      );
    } on InvalidInputException catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on UnauthorizedException catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on ForbiddenException catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on NetworkException catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on ServerException catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on OperationFailedException catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on HtHttpException catch (e) {
      // Catch any other HtHttpException subtypes
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
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
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on AuthenticationException catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on NotFoundException catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on NetworkException catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on ServerException catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on OperationFailedException catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on HtHttpException catch (e) {
      // Catch any other HtHttpException subtypes
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
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
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on ServerException catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on OperationFailedException catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } on HtHttpException catch (e) {
      // Catch any other HtHttpException subtypes
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: e,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          exception: UnknownException('An unexpected error occurred: $e'),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _userAuthSubscription.cancel();
    return super.close();
  }
}
