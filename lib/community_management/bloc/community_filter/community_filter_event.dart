part of 'community_filter_bloc.dart';

abstract class CommunityFilterEvent extends Equatable {
  const CommunityFilterEvent();

  @override
  List<Object> get props => [];
}

class CommunityFilterSearchQueryChanged extends CommunityFilterEvent {
  const CommunityFilterSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

class CommunityFilterModerationStatusChanged extends CommunityFilterEvent {
  const CommunityFilterModerationStatusChanged(this.moderationStatus);

  final List<ModerationStatus> moderationStatus;

  @override
  List<Object> get props => [moderationStatus];
}

class CommunityFilterReportableEntityChanged extends CommunityFilterEvent {
  const CommunityFilterReportableEntityChanged(this.reportableEntity);

  final List<ReportableEntity> reportableEntity;

  @override
  List<Object> get props => [reportableEntity];
}

class CommunityFilterAppReviewFeedbackChanged extends CommunityFilterEvent {
  const CommunityFilterAppReviewFeedbackChanged(this.appReviewFeedback);

  final List<AppReviewFeedback> appReviewFeedback;

  @override
  List<Object> get props => [appReviewFeedback];
}

class CommunityFilterApplied extends CommunityFilterEvent {
  const CommunityFilterApplied();
}

class CommunityFilterReset extends CommunityFilterEvent {
  const CommunityFilterReset();
}
