part of 'community_filter_bloc.dart';

abstract class CommunityFilterEvent extends Equatable {
  const CommunityFilterEvent();

  @override
  List<Object?> get props => [];
}

class EngagementsFilterChanged extends CommunityFilterEvent {
  const EngagementsFilterChanged(this.filterState);
  final EngagementsFilterState filterState;
  @override
  List<Object?> get props => [filterState];
}

class ReportsFilterChanged extends CommunityFilterEvent {
  const ReportsFilterChanged(this.filterState);
  final ReportsFilterState filterState;
  @override
  List<Object?> get props => [filterState];
}

class AppReviewsFilterChanged extends CommunityFilterEvent {
  const AppReviewsFilterChanged(this.filterState);
  final AppReviewsFilterState filterState;
  @override
  List<Object?> get props => [filterState];
}

class CommunityFilterReset extends CommunityFilterEvent {
  const CommunityFilterReset();
}
