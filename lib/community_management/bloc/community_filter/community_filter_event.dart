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
    this.selectedInitialFeedback = const [],
  });

  final String searchQuery;
  final List<CommentStatus> selectedCommentStatus;
  final List<ReportStatus> selectedReportStatus;
  final List<ReportableEntity> selectedReportableEntity;
  final List<InitialAppReviewFeedback> selectedInitialFeedback;

  @override
  List<Object?> get props => [
    searchQuery,
    selectedCommentStatus,
    selectedReportStatus,
    selectedReportableEntity,
    selectedInitialFeedback,
  ];
}

class CommunityFilterReset extends CommunityFilterEvent {
  const CommunityFilterReset();
}
