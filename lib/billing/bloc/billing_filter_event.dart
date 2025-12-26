import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class BillingFilterEvent extends Equatable {
  const BillingFilterEvent();

  @override
  List<Object?> get props => [];
}

final class BillingFilterApplied extends BillingFilterEvent {
  const BillingFilterApplied({
    this.searchQuery = '',
    this.status,
    this.provider,
  });

  final String searchQuery;
  final SubscriptionStatus? status;
  final StoreProvider? provider;

  @override
  List<Object?> get props => [searchQuery, status, provider];
}

final class BillingFilterReset extends BillingFilterEvent {
  const BillingFilterReset();
}
