import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

/// {@template persons_filter_state}
/// The state for the persons filter UI.
///
/// Manages the search query and the selected content status.
/// {@endtemplate}
class PersonsFilterState extends Equatable {
  /// {@macro persons_filter_state}
  const PersonsFilterState({
    this.searchQuery = '',
    this.selectedStatus = ContentStatus.active,
  });

  /// The current text in the search query field.
  final String searchQuery;

  /// The single content status to be included in the filter.
  final ContentStatus selectedStatus;

  PersonsFilterState copyWith({
    String? searchQuery,
    ContentStatus? selectedStatus,
  }) {
    return PersonsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  @override
  List<Object?> get props => [searchQuery, selectedStatus];
}
