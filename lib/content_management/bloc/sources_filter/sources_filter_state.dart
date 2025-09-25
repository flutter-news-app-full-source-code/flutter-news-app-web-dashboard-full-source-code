part of 'sources_filter_bloc.dart';

/// {@template sources_filter_state}
/// The state for the sources filter UI.
///
/// Manages the search query and the set of selected content statuses
/// that the user wants to filter by.
/// {@endtemplate}
class SourcesFilterState extends Equatable {
  /// {@macro sources_filter_state}
  const SourcesFilterState({
    this.searchQuery = '',
    // Default to showing only active items.
    this.selectedStatus = ContentStatus.active,
    this.selectedSourceTypes = const [],
    this.selectedLanguageCodes = const [],
    this.selectedHeadquartersCountryIds = const [],
  });

  /// The current text in the search query field.
  final String searchQuery;

  /// The single content status to be included in the filter.
  final ContentStatus selectedStatus;

  /// The list of source types to be included in the filter.
  final List<SourceType> selectedSourceTypes;

  /// The list of language codes to be included in the filter.
  final List<String> selectedLanguageCodes;

  /// The list of headquarters country IDs to be included in the filter.
  final List<String> selectedHeadquartersCountryIds;

  /// Creates a copy of this state with the given fields replaced with the
  /// new values.
  SourcesFilterState copyWith({
    String? searchQuery,
    ContentStatus? selectedStatus,
    List<SourceType>? selectedSourceTypes,
    List<String>? selectedLanguageCodes,
    List<String>? selectedHeadquartersCountryIds,
  }) {
    return SourcesFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedSourceTypes: selectedSourceTypes ?? this.selectedSourceTypes,
      selectedLanguageCodes:
          selectedLanguageCodes ?? this.selectedLanguageCodes,
      selectedHeadquartersCountryIds:
          selectedHeadquartersCountryIds ?? this.selectedHeadquartersCountryIds,
    );
  }

  @override
  List<Object> get props => [
    searchQuery,
    selectedStatus,
    selectedSourceTypes,
    selectedLanguageCodes,
    selectedHeadquartersCountryIds,
  ];
}
