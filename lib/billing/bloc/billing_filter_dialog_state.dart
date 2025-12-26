import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

final class BillingFilterDialogState extends Equatable {
  const BillingFilterDialogState({
    this.searchQuery = '',
    this.status,
    this.provider,
  });

  final String searchQuery;
  final SubscriptionStatus? status;
  final StoreProvider? provider;

  BillingFilterDialogState copyWith({
    String? searchQuery,
    SubscriptionStatus? status,
    StoreProvider? provider,
  }) {
    return BillingFilterDialogState(
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      provider: provider ?? this.provider,
    );
  }

  @override
  List<Object?> get props => [searchQuery, status, provider];
}
