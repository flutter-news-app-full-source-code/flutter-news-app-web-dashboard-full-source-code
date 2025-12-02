part of 'community_filter_bloc.dart';

abstract class CommunityFilterEvent extends Equatable {
  const CommunityFilterEvent();

  @override
  List<Object?> get props => [];
}

class CommunityFilterApplied extends CommunityFilterEvent {
  const CommunityFilterApplied({
    this.searchQuery = '',
    this.selectedModerationStatus = const [],
    this.selectedReportableEntity = const [],
    this.selectedAppReviewFeedback = const [],
  });

  final String searchQuery;
  final List<ModerationStatus> selectedModerationStatus;
  final List<ReportableEntity> selectedReportableEntity;
  final List<AppReviewFeedback> selectedAppReviewFeedback;

  @override
  List<Object?> get props => [
    searchQuery,
    selectedModerationStatus,
    selectedReportableEntity,
    selectedAppReviewFeedback,
  ];
}

class CommunityFilterReset extends CommunityFilterEvent {
  const CommunityFilterReset();
}
