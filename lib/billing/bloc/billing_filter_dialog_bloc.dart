import 'package:bloc/bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/bloc/billing_filter_dialog_event.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/bloc/billing_filter_dialog_state.dart';

class BillingFilterDialogBloc
    extends Bloc<BillingFilterDialogEvent, BillingFilterDialogState> {
  BillingFilterDialogBloc() : super(const BillingFilterDialogState()) {
    on<BillingFilterDialogInitialized>(_onInitialized);
    on<BillingFilterDialogSearchQueryChanged>(_onSearchQueryChanged);
    on<BillingFilterDialogStatusChanged>(_onStatusChanged);
    on<BillingFilterDialogProviderChanged>(_onProviderChanged);
    on<BillingFilterDialogTierChanged>(_onTierChanged);
    on<BillingFilterDialogReset>(_onReset);
  }

  void _onInitialized(
    BillingFilterDialogInitialized event,
    Emitter<BillingFilterDialogState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.filterState.searchQuery,
        status: event.filterState.status,
        provider: event.filterState.provider,
        tier: event.filterState.tier,
      ),
    );
  }

  void _onSearchQueryChanged(
    BillingFilterDialogSearchQueryChanged event,
    Emitter<BillingFilterDialogState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onStatusChanged(
    BillingFilterDialogStatusChanged event,
    Emitter<BillingFilterDialogState> emit,
  ) {
    emit(state.copyWith(status: event.status));
  }

  void _onProviderChanged(
    BillingFilterDialogProviderChanged event,
    Emitter<BillingFilterDialogState> emit,
  ) {
    emit(state.copyWith(provider: event.provider));
  }

  void _onTierChanged(
    BillingFilterDialogTierChanged event,
    Emitter<BillingFilterDialogState> emit,
  ) {
    emit(state.copyWith(tier: event.tier));
  }

  void _onReset(
    BillingFilterDialogReset event,
    Emitter<BillingFilterDialogState> emit,
  ) {
    emit(const BillingFilterDialogState());
  }
}
