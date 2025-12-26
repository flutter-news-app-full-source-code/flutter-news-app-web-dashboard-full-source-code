import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

final class SubscriptionsFilterDialogState extends Equatable {
  const SubscriptionsFilterDialogState({
    this.searchQuery = '',
    this.status,
    this.provider,
  });

  final String searchQuery;
  final SubscriptionStatus? status;
  final StoreProvider? provider;

  SubscriptionsFilterDialogState copyWith({
    String? searchQuery,
    SubscriptionStatus? status,
    StoreProvider? provider,
  }) {
    return SubscriptionsFilterDialogState(
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      provider: provider ?? this.provider,
    );
  }

  @override
  List<Object?> get props => [searchQuery, status, provider];
}
