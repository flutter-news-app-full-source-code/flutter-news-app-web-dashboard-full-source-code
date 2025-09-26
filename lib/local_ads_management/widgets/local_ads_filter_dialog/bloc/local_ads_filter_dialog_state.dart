part of 'local_ads_filter_dialog_bloc.dart';

/// Represents the status of the filter dialog's operations.
enum LocalAdsFilterDialogStatus {
  /// The operation is in its initial state.
  initial,

  /// Data is currently being loaded or an operation is in progress.
  loading,

  /// Data has been successfully loaded or an operation completed.
  success,

  /// An error occurred during data loading or an operation.
  failure,
}

/// {@template local_ads_filter_dialog_state}
/// The state for the [LocalAdsFilterDialogBloc].
/// {@endtemplate}
final class LocalAdsFilterDialogState extends Equatable {
  /// {@macro local_ads_filter_dialog_state}
  const LocalAdsFilterDialogState({
    this.status = LocalAdsFilterDialogStatus.initial,
    this.exception,
    this.searchQuery = '',
    this.selectedStatus = ContentStatus.active,
    this.selectedAdType = AdType.native,
  });

  /// The current status of the filter dialog's main operations.
  final LocalAdsFilterDialogStatus status;

  /// The exception encountered during a failed operation, if any.
  final HttpException? exception;

  /// The current text in the search query field.
  final String searchQuery;

  /// The single content status to be included in the filter.
  final ContentStatus selectedStatus;

  /// The single ad type to be included in the filter.
  final AdType selectedAdType;

  /// Creates a copy of this [LocalAdsFilterDialogState] with updated values.
  LocalAdsFilterDialogState copyWith({
    LocalAdsFilterDialogStatus? status,
    HttpException? exception,
    String? searchQuery,
    ContentStatus? selectedStatus,
    AdType? selectedAdType,
  }) {
    return LocalAdsFilterDialogState(
      status: status ?? this.status,
      exception: exception,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedAdType: selectedAdType ?? this.selectedAdType,
    );
  }

  @override
  List<Object?> get props => [
    status,
    exception,
    searchQuery,
    selectedStatus,
    selectedAdType,
  ];
}
