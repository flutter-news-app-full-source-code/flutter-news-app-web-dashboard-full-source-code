part of 'community_filter_bloc.dart';

abstract class CommunityFilterEvent extends Equatable {
  const CommunityFilterEvent();

  @override
  List<Object> get props => [];
}

class EngagementsFilterChanged extends CommunityFilterEvent {
  const EngagementsFilterChanged(this.filter);

  final EngagementsFilter filter;

  @override
  List<Object> get props => [filter];
}

class ReportsFilterChanged extends CommunityFilterEvent {
  const ReportsFilterChanged(this.filter);

  final ReportsFilter filter;

  @override
  List<Object> get props => [filter];
}

class AppReviewsFilterChanged extends CommunityFilterEvent {
  const AppReviewsFilterChanged(this.filter);

  final AppReviewsFilter filter;

  @override
  List<Object> get props => [filter];
}

class CommunityFilterApplied extends CommunityFilterEvent {
  const CommunityFilterApplied();
}

class CommunityFilterReset extends CommunityFilterEvent {
  const CommunityFilterReset();
}
