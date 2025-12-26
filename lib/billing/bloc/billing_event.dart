import 'package:equatable/equatable.dart';

sealed class BillingEvent extends Equatable {
  const BillingEvent();

  @override
  List<Object?> get props => [];
}

final class LoadSubscriptionsRequested extends BillingEvent {
  const LoadSubscriptionsRequested({
    this.startAfterId,
    this.limit,
    this.forceRefresh = false,
    this.filter,
  });

  final String? startAfterId;
  final int? limit;
  final bool forceRefresh;
  final Map<String, dynamic>? filter;

  @override
  List<Object?> get props => [startAfterId, limit, forceRefresh, filter];
}
