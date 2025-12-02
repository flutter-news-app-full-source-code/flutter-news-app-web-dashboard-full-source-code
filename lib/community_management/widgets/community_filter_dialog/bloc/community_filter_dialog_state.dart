part of 'community_filter_dialog_bloc.dart';

class CommunityFilterDialogState extends Equatable {
  const CommunityFilterDialogState({
    required this.activeTab,
    this.engagementsFilter = const EngagementsFilterState(),
    this.reportsFilter = const ReportsFilterState(),
    this.appReviewsFilter = const AppReviewsFilterState(),
  });

  final CommunityManagementTab activeTab;
  final EngagementsFilterState engagementsFilter;
  final ReportsFilterState reportsFilter;
  final AppReviewsFilterState appReviewsFilter;

  CommunityFilterDialogState copyWith({
    EngagementsFilterState? engagementsFilter,
    ReportsFilterState? reportsFilter,
    AppReviewsFilterState? appReviewsFilter,
  }) {
    return CommunityFilterDialogState(
      activeTab: activeTab,
      engagementsFilter: engagementsFilter ?? this.engagementsFilter,
      reportsFilter: reportsFilter ?? this.reportsFilter,
      appReviewsFilter: appReviewsFilter ?? this.appReviewsFilter,
    );
  }

  @override
  List<Object> get props => [
    activeTab,
    engagementsFilter,
    reportsFilter,
    appReviewsFilter,
  ];
}
