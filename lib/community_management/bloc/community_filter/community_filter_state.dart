part of 'community_filter_bloc.dart';

class CommunityFilterState extends Equatable {
  const CommunityFilterState({
    this.searchQuery = '',
    this.selectedModerationStatus = const [],
    this.selectedReportableEntity = const [],
    this.selectedAppReviewFeedback = const [],
    this.version = 0,
  });

  final String searchQuery;
  final List<ModerationStatus> selectedModerationStatus;
  final List<ReportableEntity> selectedReportableEntity;
  final List<AppReviewFeedback> selectedAppReviewFeedback;
  final int version;

  bool get isEngagementsFilterActive =>
      searchQuery.isNotEmpty || selectedModerationStatus.isNotEmpty;

  bool get isReportsFilterActive =>
      searchQuery.isNotEmpty ||
      selectedModerationStatus.isNotEmpty ||
      selectedReportableEntity.isNotEmpty;

  bool get isAppReviewsFilterActive =>
      searchQuery.isNotEmpty || selectedAppReviewFeedback.isNotEmpty;

  CommunityFilterState copyWith({
    String? searchQuery,
    List<ModerationStatus>? selectedModerationStatus,
    List<ReportableEntity>? selectedReportableEntity,
    List<AppReviewFeedback>? selectedAppReviewFeedback,
    int? version,
  }) {
    return CommunityFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedModerationStatus:
          selectedModerationStatus ?? this.selectedModerationStatus,
      selectedReportableEntity:
          selectedReportableEntity ?? this.selectedReportableEntity,
      selectedAppReviewFeedback:
          selectedAppReviewFeedback ?? this.selectedAppReviewFeedback,
      version: version ?? this.version,
    );
  }

  @override
  List<Object> get props => [
    searchQuery,
    selectedModerationStatus,
    selectedReportableEntity,
    selectedAppReviewFeedback,
    version,
  ];
}
