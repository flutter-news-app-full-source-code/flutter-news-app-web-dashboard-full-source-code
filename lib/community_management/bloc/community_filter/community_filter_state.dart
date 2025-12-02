part of 'community_filter_bloc.dart';

class CommunityFilterState extends Equatable {
  const CommunityFilterState({
    this.searchQuery = '',
    this.selectedModerationStatus = const [],
    this.selectedReportableEntity = const [],
    this.selectedAppReviewFeedback = const [],
  });

  final String searchQuery;
  final List<ModerationStatus> selectedModerationStatus;
  final List<ReportableEntity> selectedReportableEntity;
  final List<AppReviewFeedback> selectedAppReviewFeedback;

  CommunityFilterState copyWith({
    String? searchQuery,
    List<ModerationStatus>? selectedModerationStatus,
    List<ReportableEntity>? selectedReportableEntity,
    List<AppReviewFeedback>? selectedAppReviewFeedback,
  }) {
    return CommunityFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedModerationStatus:
          selectedModerationStatus ?? this.selectedModerationStatus,
      selectedReportableEntity:
          selectedReportableEntity ?? this.selectedReportableEntity,
      selectedAppReviewFeedback:
          selectedAppReviewFeedback ?? this.selectedAppReviewFeedback,
    );
  }

  @override
  List<Object> get props => [
    searchQuery,
    selectedModerationStatus,
    selectedReportableEntity,
    selectedAppReviewFeedback,
  ];
}
