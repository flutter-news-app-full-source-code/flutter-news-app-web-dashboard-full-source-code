part of 'authentication_bloc.dart';

/// {@template authentication_status}
/// The status of the authentication process.
/// {@endtemplate}
enum AuthenticationStatus {
  /// The initial state of the authentication bloc.
  initial,

  /// An authentication operation is in progress.
  loading,

  /// The user is authenticated.
  authenticated,

  /// The user is unauthenticated.
  unauthenticated,

  /// The sign-in code is being requested.
  requestCodeLoading,

  /// The sign-in code was sent successfully.
  codeSentSuccess,

  /// An authentication operation failed.
  failure,
}

/// {@template authentication_state}
/// Represents the overall authentication state of the application.
/// {@endtemplate}
final class AuthenticationState extends Equatable {
  /// {@macro authentication_state}
  const AuthenticationState({
    this.status = AuthenticationStatus.initial,
    this.user,
    this.email,
    this.exception,
  });

  /// The current status of the authentication process.
  final AuthenticationStatus status;

  /// The authenticated [User] object, if available.
  final User? user;

  /// The email address involved in the current authentication flow.
  final String? email;

  /// The error describing an authentication failure, if any.
  final HtHttpException? exception;

  @override
  List<Object?> get props => [status, user, email, exception];

  /// Creates a copy of this [AuthenticationState] with the given fields
  /// replaced with the new values.
  AuthenticationState copyWith({
    AuthenticationStatus? status,
    User? user,
    String? email,
    HtHttpException? exception,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      user: user ?? this.user,
      email: email ?? this.email,
      exception: exception ?? this.exception,
    );
  }
}
