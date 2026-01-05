import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

final class SubscriptionsFilterState extends Equatable {
  const SubscriptionsFilterState({
    this.searchQuery = '',
    this.status,
    this.provider,
  });

  final String searchQuery;
  final SubscriptionStatus? status;
  final StoreProviders? provider;

  SubscriptionsFilterState copyWith({
    String? searchQuery,
    SubscriptionStatus? status,
    StoreProviders? provider,
  }) {
    return SubscriptionsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      provider: provider ?? this.provider,
    );
  }

  @override
  List<Object?> get props => [searchQuery, status, provider];
}
