import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:verity_dashboard/content_management/bloc/persons_filter/persons_filter_bloc.dart'
    show PersonsFilterBloc;

/// Base class for all events related to the [PersonsFilterBloc].
sealed class PersonsFilterEvent extends Equatable {
  const PersonsFilterEvent();

  @override
  List<Object?> get props => [];
}

/// Event to notify the BLoC that the search query has changed.
final class PersonsSearchQueryChanged extends PersonsFilterEvent {
  const PersonsSearchQueryChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

/// Event to notify the BLoC that the selected content status has changed.
final class PersonsStatusFilterChanged extends PersonsFilterEvent {
  const PersonsStatusFilterChanged(this.status);
  final ContentStatus status;
  @override
  List<Object?> get props => [status];
}

/// Event to request applying all current filters.
final class PersonsFilterApplied extends PersonsFilterEvent {
  const PersonsFilterApplied({
    required this.searchQuery,
    required this.selectedStatus,
  });
  final String searchQuery;
  final ContentStatus selectedStatus;
  @override
  List<Object?> get props => [searchQuery, selectedStatus];
}

/// Event to request resetting all filters to their initial state.
final class PersonsFilterReset extends PersonsFilterEvent {
  const PersonsFilterReset();
}
