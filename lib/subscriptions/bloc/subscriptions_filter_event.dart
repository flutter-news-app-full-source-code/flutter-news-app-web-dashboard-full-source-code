import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class SubscriptionsFilterEvent extends Equatable {
  const SubscriptionsFilterEvent();

  @override
  List<Object?> get props => [];
}

final class SubscriptionsFilterApplied extends SubscriptionsFilterEvent {
  const SubscriptionsFilterApplied({
    this.searchQuery = '',
    this.status,
    this.provider,
  });

  final String searchQuery;
  final SubscriptionStatus? status;
  final StoreProviders? provider;

  @override
  List<Object?> get props => [searchQuery, status, provider];
}

final class SubscriptionsFilterReset extends SubscriptionsFilterEvent {
  const SubscriptionsFilterReset();
}
