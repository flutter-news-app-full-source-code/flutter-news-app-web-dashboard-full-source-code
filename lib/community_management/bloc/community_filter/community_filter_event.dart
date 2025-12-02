part of 'community_filter_bloc.dart';

abstract class CommunityFilterEvent extends Equatable {
  const CommunityFilterEvent();

  @override
  List<Object?> get props => [];
}

class CommunityFilterApplied extends CommunityFilterEvent {
  const CommunityFilterApplied({
    this.searchQuery = '',
    this.selectedCommentStatus = const [],
    this.selectedReportStatus = const [],
    this.selectedReportableEntity = const [],
    this.selectedAppReviewFeedback = const [],
    this.hasComment = HasCommentFilter.any,
  });

  final String searchQuery;
  final List<ModerationStatus> selectedCommentStatus;
  final List<ModerationStatus> selectedReportStatus;
  final List<ReportableEntity> selectedReportableEntity;
  final List<AppReviewFeedback> selectedAppReviewFeedback;
  final HasCommentFilter hasComment;

  @override
  List<Object?> get props => [
    searchQuery,
    selectedCommentStatus,
    selectedReportStatus,
    selectedReportableEntity,
    selectedAppReviewFeedback,
    hasComment,
  ];
}

class CommunityFilterReset extends CommunityFilterEvent {
  const CommunityFilterReset();
}
