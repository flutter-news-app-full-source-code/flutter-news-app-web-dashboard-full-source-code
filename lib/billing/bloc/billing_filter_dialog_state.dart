import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

final class BillingFilterDialogState extends Equatable {
  const BillingFilterDialogState({
    this.searchQuery = '',
    this.status,
    this.provider,
    this.tier,
  });

  final String searchQuery;
  final SubscriptionStatus? status;
  final StoreProvider? provider;
  final AccessTier? tier;

  BillingFilterDialogState copyWith({
    String? searchQuery,
    SubscriptionStatus? status,
    StoreProvider? provider,
    AccessTier? tier,
  }) {
    return BillingFilterDialogState(
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      provider: provider ?? this.provider,
      tier: tier ?? this.tier,
    );
  }

  @override
  List<Object?> get props => [searchQuery, status, provider, tier];
}
