import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_filter_state.dart';

sealed class SubscriptionsFilterDialogEvent extends Equatable {
  const SubscriptionsFilterDialogEvent();

  @override
  List<Object?> get props => [];
}

final class SubscriptionsFilterDialogInitialized
    extends SubscriptionsFilterDialogEvent {
  const SubscriptionsFilterDialogInitialized(this.filterState);

  final SubscriptionsFilterState filterState;

  @override
  List<Object?> get props => [filterState];
}

final class SubscriptionsFilterDialogSearchQueryChanged
    extends SubscriptionsFilterDialogEvent {
  const SubscriptionsFilterDialogSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class SubscriptionsFilterDialogStatusChanged
    extends SubscriptionsFilterDialogEvent {
  const SubscriptionsFilterDialogStatusChanged(this.status);

  final SubscriptionStatus? status;

  @override
  List<Object?> get props => [status];
}

final class SubscriptionsFilterDialogProviderChanged
    extends SubscriptionsFilterDialogEvent {
  const SubscriptionsFilterDialogProviderChanged(this.provider);

  final StoreProvider? provider;

  @override
  List<Object?> get props => [provider];
}

final class SubscriptionsFilterDialogReset
    extends SubscriptionsFilterDialogEvent {
  const SubscriptionsFilterDialogReset();
}
