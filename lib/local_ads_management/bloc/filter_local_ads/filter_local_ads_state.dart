part of 'filter_local_ads_bloc.dart';

/// Represents the status of the filter dialog's operations.
enum FilterLocalAdsStatus {
  /// The operation is in its initial state.
  initial,

  /// Data is currently being loaded or an operation is in progress.
  loading,

  /// Data has been successfully loaded or an operation completed.
  success,

  /// An error occurred during data loading or an operation.
  failure,
}

/// {@template filter_local_ads_state}
/// The state for the [FilterLocalAdsBloc].
/// {@endtemplate}
final class FilterLocalAdsState extends Equatable {
  /// {@macro filter_local_ads_state}
  const FilterLocalAdsState({
    this.status = FilterLocalAdsStatus.initial,
    this.exception,
    this.searchQuery = '',
    this.selectedStatus = ContentStatus.active,
  });

  /// The current status of the filter dialog's main operations.
  final FilterLocalAdsStatus status;

  /// The exception encountered during a failed operation, if any.
  final HttpException? exception;

  /// The current text in the search query field.
  final String searchQuery;

  /// The single content status to be included in the filter.
  final ContentStatus selectedStatus;

  /// Creates a copy of this [FilterLocalAdsState] with updated values.
  FilterLocalAdsState copyWith({
    FilterLocalAdsStatus? status,
    HttpException? exception,
    String? searchQuery,
    ContentStatus? selectedStatus,
  }) {
    return FilterLocalAdsState(
      status: status ?? this.status,
      exception: exception,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  @override
  List<Object?> get props => [
    status,
    exception,
    searchQuery,
    selectedStatus,
  ];
}
