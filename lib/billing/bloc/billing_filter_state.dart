import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

final class BillingFilterState extends Equatable {
  const BillingFilterState({
    this.searchQuery = '',
    this.status,
    this.provider,
  });

  final String searchQuery;
  final SubscriptionStatus? status;
  final StoreProvider? provider;

  BillingFilterState copyWith({
    String? searchQuery,
    SubscriptionStatus? status,
    StoreProvider? provider,
  }) {
    return BillingFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      provider: provider ?? this.provider,
    );
  }

  @override
  List<Object?> get props => [searchQuery, status, provider];
}
