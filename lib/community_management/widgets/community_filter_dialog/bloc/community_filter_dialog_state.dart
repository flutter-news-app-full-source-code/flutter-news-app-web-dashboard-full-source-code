part of 'community_filter_dialog_bloc.dart';

class CommunityFilterDialogState extends Equatable {
  const CommunityFilterDialogState({
    required this.activeTab,
    this.searchQuery = '',
    this.selectedModerationStatus = const [],
    this.selectedReportableEntity = const [],
    this.selectedAppReviewFeedback = const [],
  });

  final CommunityManagementTab activeTab;
  final String searchQuery;
  final List<ModerationStatus> selectedModerationStatus;
  final List<ReportableEntity> selectedReportableEntity;
  final List<AppReviewFeedback> selectedAppReviewFeedback;

  CommunityFilterDialogState copyWith({
    String? searchQuery,
    List<ModerationStatus>? selectedModerationStatus,
    List<ReportableEntity>? selectedReportableEntity,
    List<AppReviewFeedback>? selectedAppReviewFeedback,
  }) {
    return CommunityFilterDialogState(
      activeTab: activeTab,
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
    activeTab,
    searchQuery,
    selectedModerationStatus,
    selectedReportableEntity,
    selectedAppReviewFeedback,
  ];
}
