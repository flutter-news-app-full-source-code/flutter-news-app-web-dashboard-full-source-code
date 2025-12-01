part of 'community_filter_dialog_bloc.dart';

abstract class CommunityFilterDialogEvent extends Equatable {
  const CommunityFilterDialogEvent();

  @override
  List<Object> get props => [];
}

class CommunityFilterDialogInitialized extends CommunityFilterDialogEvent {
  const CommunityFilterDialogInitialized({
    required this.activeTab,
    required this.communityFilterState,
  });

  final CommunityManagementTab activeTab;
  final CommunityFilterState communityFilterState;

  @override
  List<Object> get props => [activeTab, communityFilterState];
}

class CommunityFilterDialogSearchQueryChanged
    extends CommunityFilterDialogEvent {
  const CommunityFilterDialogSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

class CommunityFilterDialogCommentStatusChanged
    extends CommunityFilterDialogEvent {
  const CommunityFilterDialogCommentStatusChanged(this.commentStatus);

  final List<CommentStatus> commentStatus;

  @override
  List<Object> get props => [commentStatus];
}

class CommunityFilterDialogReportStatusChanged
    extends CommunityFilterDialogEvent {
  const CommunityFilterDialogReportStatusChanged(this.reportStatus);

  final List<ReportStatus> reportStatus;

  @override
  List<Object> get props => [reportStatus];
}

class CommunityFilterDialogReportableEntityChanged
    extends CommunityFilterDialogEvent {
  const CommunityFilterDialogReportableEntityChanged(this.reportableEntity);

  final List<ReportableEntity> reportableEntity;

  @override
  List<Object> get props => [reportableEntity];
}

class CommunityFilterDialogInitialFeedbackChanged
    extends CommunityFilterDialogEvent {
  const CommunityFilterDialogInitialFeedbackChanged(this.initialFeedback);

  final List<InitialAppReviewFeedback> initialFeedback;

  @override
  List<Object> get props => [initialFeedback];
}

class CommunityFilterDialogReset extends CommunityFilterDialogEvent {
  const CommunityFilterDialogReset();
}
