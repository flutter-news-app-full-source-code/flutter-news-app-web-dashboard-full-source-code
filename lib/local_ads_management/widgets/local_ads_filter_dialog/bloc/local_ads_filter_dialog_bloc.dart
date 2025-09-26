import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/bloc/filter_local_ads/filter_local_ads_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/local_ads_management/widgets/local_ads_filter_dialog/local_ads_filter_dialog.dart'
    show LocalAdsFilterDialog;
import 'package:rxdart/rxdart.dart';

part 'local_ads_filter_dialog_event.dart';
part 'local_ads_filter_dialog_state.dart';

/// A transformer to debounce events, typically used for search input.
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

/// {@template local_ads_filter_dialog_bloc}
/// A BLoC that manages the state and logic for the [LocalAdsFilterDialog].
///
/// This BLoC handles the temporary filter selections and provides
/// the necessary state for the UI to render the filter dialog.
/// {@endtemplate}
class LocalAdsFilterDialogBloc
    extends Bloc<LocalAdsFilterDialogEvent, LocalAdsFilterDialogState> {
  /// {@macro local_ads_filter_dialog_bloc}
  LocalAdsFilterDialogBloc() : super(const LocalAdsFilterDialogState()) {
    on<LocalAdsFilterDialogInitialized>(_onLocalAdsFilterDialogInitialized);
    on<LocalAdsFilterDialogSearchQueryChanged>(
      _onLocalAdsFilterDialogSearchQueryChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<LocalAdsFilterDialogStatusChanged>(_onLocalAdsFilterDialogStatusChanged);
    on<LocalAdsFilterDialogAdTypeChanged>(_onLocalAdsFilterDialogAdTypeChanged);
    on<LocalAdsFilterDialogReset>(_onLocalAdsFilterDialogReset);
  }

  /// Initializes the filter dialog's state from the current filter BLoC.
  void _onLocalAdsFilterDialogInitialized(
    LocalAdsFilterDialogInitialized event,
    Emitter<LocalAdsFilterDialogState> emit,
  ) {
    final filterState = event.filterLocalAdsState;
    emit(
      state.copyWith(
        searchQuery: filterState.searchQuery,
        selectedStatus: filterState.selectedStatus,
        selectedAdType: filterState.selectedAdType,
      ),
    );
  }

  /// Updates the temporary search query.
  void _onLocalAdsFilterDialogSearchQueryChanged(
    LocalAdsFilterDialogSearchQueryChanged event,
    Emitter<LocalAdsFilterDialogState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  /// Updates the temporary selected content status.
  void _onLocalAdsFilterDialogStatusChanged(
    LocalAdsFilterDialogStatusChanged event,
    Emitter<LocalAdsFilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedStatus: event.status));
  }

  /// Updates the temporary selected ad type.
  void _onLocalAdsFilterDialogAdTypeChanged(
    LocalAdsFilterDialogAdTypeChanged event,
    Emitter<LocalAdsFilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedAdType: event.adType));
  }

  /// Resets all temporary filter selections in the dialog to their initial state.
  void _onLocalAdsFilterDialogReset(
    LocalAdsFilterDialogReset event,
    Emitter<LocalAdsFilterDialogState> emit,
  ) {
    emit(const LocalAdsFilterDialogState());
  }
}
