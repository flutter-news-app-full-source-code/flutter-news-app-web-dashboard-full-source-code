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

class CommunityFilterDialogEngagementsStatusChanged
    extends CommunityFilterDialogEvent {
  const CommunityFilterDialogEngagementsStatusChanged(this.status);

  final List<ModerationStatus> status;

  @override
  List<Object> get props => [status];
}

class CommunityFilterDialogReportsStatusChanged
    extends CommunityFilterDialogEvent {
  const CommunityFilterDialogReportsStatusChanged(this.status);

  final List<ModerationStatus> status;

  @override
  List<Object> get props => [status];
}

class CommunityFilterDialogReportableEntityChanged
    extends CommunityFilterDialogEvent {
  const CommunityFilterDialogReportableEntityChanged(this.reportableEntity);

  final List<ReportableEntity> reportableEntity;

  @override
  List<Object> get props => [reportableEntity];
}

class CommunityFilterDialogAppReviewsFeedbackChanged
    extends CommunityFilterDialogEvent {
  const CommunityFilterDialogAppReviewsFeedbackChanged(this.feedback);

  final List<AppReviewFeedback> feedback;

  @override
  List<Object> get props => [feedback];
}

class CommunityFilterDialogHasCommentChanged
    extends CommunityFilterDialogEvent {
  const CommunityFilterDialogHasCommentChanged(this.hasComment);

  final HasCommentFilter hasComment;

  @override
  List<Object> get props => [hasComment];
}

class CommunityFilterDialogReset extends CommunityFilterDialogEvent {
  const CommunityFilterDialogReset();
}
