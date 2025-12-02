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

class CommunityFilterDialogModerationStatusChanged
    extends CommunityFilterDialogEvent {
  const CommunityFilterDialogModerationStatusChanged(this.moderationStatus);

  final List<ModerationStatus> moderationStatus;

  @override
  List<Object> get props => [moderationStatus];
}

class CommunityFilterDialogReportableEntityChanged
    extends CommunityFilterDialogEvent {
  const CommunityFilterDialogReportableEntityChanged(this.reportableEntity);

  final List<ReportableEntity> reportableEntity;

  @override
  List<Object> get props => [reportableEntity];
}

class CommunityFilterDialogAppReviewFeedbackChanged
    extends CommunityFilterDialogEvent {
  const CommunityFilterDialogAppReviewFeedbackChanged(this.appReviewFeedback);

  final List<AppReviewFeedback> appReviewFeedback;

  @override
  List<Object> get props => [appReviewFeedback];
}

class CommunityFilterDialogReset extends CommunityFilterDialogEvent {
  const CommunityFilterDialogReset();
}
