import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

enum BillingStatus { initial, loading, success, failure }

final class BillingState extends Equatable {
  const BillingState({
    this.status = BillingStatus.initial,
    this.subscriptions = const [],
    this.cursor,
    this.hasMore = false,
    this.exception,
  });

  final BillingStatus status;
  final List<UserSubscription> subscriptions;
  final String? cursor;
  final bool hasMore;
  final HttpException? exception;

  BillingState copyWith({
    BillingStatus? status,
    List<UserSubscription>? subscriptions,
    String? cursor,
    bool? hasMore,
    HttpException? exception,
  }) {
    return BillingState(
      status: status ?? this.status,
      subscriptions: subscriptions ?? this.subscriptions,
      cursor: cursor ?? this.cursor,
      hasMore: hasMore ?? this.hasMore,
      exception: exception,
    );
  }

  @override
  List<Object?> get props => [status, subscriptions, cursor, hasMore, exception];
}
