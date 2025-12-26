import 'package:bloc/bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/bloc/billing_filter_event.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/billing/bloc/billing_filter_state.dart';

class BillingFilterBloc extends Bloc<BillingFilterEvent, BillingFilterState> {
  BillingFilterBloc() : super(const BillingFilterState()) {
    on<BillingFilterApplied>(_onFilterApplied);
    on<BillingFilterReset>(_onFilterReset);
  }

  void _onFilterApplied(
    BillingFilterApplied event,
    Emitter<BillingFilterState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.searchQuery,
        status: event.status,
        provider: event.provider,
      ),
    );
  }

  void _onFilterReset(
    BillingFilterReset event,
    Emitter<BillingFilterState> emit,
  ) {
    emit(const BillingFilterState());
  }
}
