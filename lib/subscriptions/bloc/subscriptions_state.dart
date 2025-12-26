import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

enum SubscriptionsStatus { initial, loading, success, failure }

final class SubscriptionsState extends Equatable {
  const SubscriptionsState({
    this.status = SubscriptionsStatus.initial,
    this.subscriptions = const [],
    this.cursor,
    this.hasMore = false,
    this.exception,
  });

  final SubscriptionsStatus status;
  final List<UserSubscription> subscriptions;
  final String? cursor;
  final bool hasMore;
  final HttpException? exception;

  SubscriptionsState copyWith({
    SubscriptionsStatus? status,
    List<UserSubscription>? subscriptions,
    String? cursor,
    bool? hasMore,
    HttpException? exception,
  }) {
    return SubscriptionsState(
      status: status ?? this.status,
      subscriptions: subscriptions ?? this.subscriptions,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      exception: exception,
    );
  }

  @override
  List<Object?> get props => [
    status,
    subscriptions,
    cursor,
    hasMore,
    exception,
  ];
}
