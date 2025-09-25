import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

part 'headlines_filter_event.dart';
part 'headlines_filter_state.dart';

/// {@template headlines_filter_bloc}
/// A BLoC that manages the state of the headlines filter UI.
///
/// It handles user input for search queries and status selections,
/// and builds a filter map to be used by the data-fetching BLoC.
/// {@endtemplate}
class HeadlinesFilterBloc
    extends Bloc<HeadlinesFilterEvent, HeadlinesFilterState> {
  /// {@macro headlines_filter_bloc}
  HeadlinesFilterBloc() : super(const HeadlinesFilterState()) {
    on<HeadlinesSearchQueryChanged>(_onHeadlinesSearchQueryChanged);
    on<HeadlinesStatusFilterChanged>(_onHeadlinesStatusFilterChanged);
  }

  /// Handles changes to the search query text field.
  void _onHeadlinesSearchQueryChanged(
    HeadlinesSearchQueryChanged event,
    Emitter<HeadlinesFilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  /// Handles toggling of the status filter chips.
  void _onHeadlinesStatusFilterChanged(
    HeadlinesStatusFilterChanged event,
    Emitter<HeadlinesFilterState> emit,
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
