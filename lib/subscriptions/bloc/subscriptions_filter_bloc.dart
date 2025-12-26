import 'package:bloc/bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_filter_event.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_filter_state.dart';

class SubscriptionsFilterBloc
    extends Bloc<SubscriptionsFilterEvent, SubscriptionsFilterState> {
  SubscriptionsFilterBloc() : super(const SubscriptionsFilterState()) {
    on<SubscriptionsFilterApplied>(_onFilterApplied);
    on<SubscriptionsFilterReset>(_onFilterReset);
  }

  void _onFilterApplied(
    SubscriptionsFilterApplied event,
    Emitter<SubscriptionsFilterState> emit,
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
    SubscriptionsFilterReset event,
    Emitter<SubscriptionsFilterState> emit,
  ) {
    emit(const SubscriptionsFilterState());
  }
}
