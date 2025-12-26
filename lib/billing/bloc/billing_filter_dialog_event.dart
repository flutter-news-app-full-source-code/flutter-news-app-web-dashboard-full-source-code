import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/bloc/billing_filter_state.dart';

sealed class BillingFilterDialogEvent extends Equatable {
  const BillingFilterDialogEvent();

  @override
  List<Object?> get props => [];
}

final class BillingFilterDialogInitialized extends BillingFilterDialogEvent {
  const BillingFilterDialogInitialized(this.filterState);

  final BillingFilterState filterState;

  @override
  List<Object?> get props => [filterState];
}

final class BillingFilterDialogSearchQueryChanged
    extends BillingFilterDialogEvent {
  const BillingFilterDialogSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class BillingFilterDialogStatusChanged extends BillingFilterDialogEvent {
  const BillingFilterDialogStatusChanged(this.status);

  final SubscriptionStatus? status;

  @override
  List<Object?> get props => [status];
}

final class BillingFilterDialogProviderChanged
    extends BillingFilterDialogEvent {
  const BillingFilterDialogProviderChanged(this.provider);

  final StoreProvider? provider;

  @override
  List<Object?> get props => [provider];
}

final class BillingFilterDialogReset extends BillingFilterDialogEvent {
  const BillingFilterDialogReset();
}
