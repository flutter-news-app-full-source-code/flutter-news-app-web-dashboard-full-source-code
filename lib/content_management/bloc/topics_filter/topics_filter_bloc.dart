import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

part 'topics_filter_event.dart';
part 'topics_filter_state.dart';

/// {@template topics_filter_bloc}
/// A BLoC that manages the state of the topics filter UI.
///
/// It handles user input for search queries and status selections,
/// and builds a filter map to be used by the data-fetching BLoC.
/// {@endtemplate}
class TopicsFilterBloc extends Bloc<TopicsFilterEvent, TopicsFilterState> {
  /// {@macro topics_filter_bloc}
  TopicsFilterBloc() : super(const TopicsFilterState()) {
    on<TopicsSearchQueryChanged>(_onTopicsSearchQueryChanged);
    on<TopicsStatusFilterChanged>(_onTopicsStatusFilterChanged);
  }

  /// Handles changes to the search query text field.
  void _onTopicsSearchQueryChanged(
    TopicsSearchQueryChanged event,
    Emitter<TopicsFilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  /// Handles toggling of the status filter chips.
  void _onTopicsStatusFilterChanged(
    TopicsStatusFilterChanged event,
    Emitter<TopicsFilterState> emit,
  ) {
    final currentStatuses = Set<ContentStatus>.from(state.selectedStatuses);
    if (event.isSelected) {
      currentStatuses.add(event.status);
    } else {
      // Prevent removing the last status to ensure at least one is selected.
      if (currentStatuses.length > 1) {
        currentStatuses.remove(event.status);
      }
    }
    emit(state.copyWith(selectedStatuses: currentStatuses));
  }
}
