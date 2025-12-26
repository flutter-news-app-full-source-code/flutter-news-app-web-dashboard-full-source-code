import 'package:bloc/bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_filter_dialog_event.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/subscriptions/bloc/subscriptions_filter_dialog_state.dart';

class SubscriptionsFilterDialogBloc
    extends
        Bloc<SubscriptionsFilterDialogEvent, SubscriptionsFilterDialogState> {
  SubscriptionsFilterDialogBloc()
    : super(const SubscriptionsFilterDialogState()) {
    on<SubscriptionsFilterDialogInitialized>(_onInitialized);
    on<SubscriptionsFilterDialogSearchQueryChanged>(_onSearchQueryChanged);
    on<SubscriptionsFilterDialogStatusChanged>(_onStatusChanged);
    on<SubscriptionsFilterDialogProviderChanged>(_onProviderChanged);
    on<SubscriptionsFilterDialogReset>(_onReset);
  }

  void _onInitialized(
    SubscriptionsFilterDialogInitialized event,
    Emitter<SubscriptionsFilterDialogState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.filterState.searchQuery,
        status: event.filterState.status,
        provider: event.filterState.provider,
      ),
    );
  }

  void _onSearchQueryChanged(
    SubscriptionsFilterDialogSearchQueryChanged event,
    Emitter<SubscriptionsFilterDialogState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onStatusChanged(
    SubscriptionsFilterDialogStatusChanged event,
    Emitter<SubscriptionsFilterDialogState> emit,
  ) {
    emit(state.copyWith(status: event.status));
  }

  void _onProviderChanged(
    SubscriptionsFilterDialogProviderChanged event,
    Emitter<SubscriptionsFilterDialogState> emit,
  ) {
    emit(state.copyWith(provider: event.provider));
  }

  void _onReset(
    SubscriptionsFilterDialogReset event,
    Emitter<SubscriptionsFilterDialogState> emit,
  ) {
    emit(const SubscriptionsFilterDialogState());
  }
}
