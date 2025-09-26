part of 'local_ads_filter_dialog_bloc.dart';

sealed class LocalAdsFilterDialogEvent extends Equatable {
  const LocalAdsFilterDialogEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize the filter dialog's state from the current filter BLoCs.
final class LocalAdsFilterDialogInitialized extends LocalAdsFilterDialogEvent {
  const LocalAdsFilterDialogInitialized({
    required this.filterLocalAdsState,
  });

  final FilterLocalAdsState filterLocalAdsState;

  @override
  List<Object?> get props => [
    filterLocalAdsState,
  ];
}

/// Event to update the temporary search query.
final class LocalAdsFilterDialogSearchQueryChanged
    extends LocalAdsFilterDialogEvent {
  const LocalAdsFilterDialogSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to update the temporary selected content status.
final class LocalAdsFilterDialogStatusChanged
    extends LocalAdsFilterDialogEvent {
  const LocalAdsFilterDialogStatusChanged(this.status);

  final ContentStatus status;

  @override
  List<Object?> get props => [status];
}

/// Event to update the temporary selected ad type.
final class LocalAdsFilterDialogAdTypeChanged
    extends LocalAdsFilterDialogEvent {
  const LocalAdsFilterDialogAdTypeChanged(this.adType);

  final AdType adType;

  @override
  List<Object?> get props => [adType];
}

/// Event to reset all temporary filter selections in the dialog to their
/// initial state.
final class LocalAdsFilterDialogReset extends LocalAdsFilterDialogEvent {
  const LocalAdsFilterDialogReset();
}
