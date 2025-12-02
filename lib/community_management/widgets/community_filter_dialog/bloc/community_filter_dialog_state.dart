part of 'community_filter_dialog_bloc.dart';

class CommunityFilterDialogState extends Equatable {
  const CommunityFilterDialogState({
    required this.activeTab,
    this.searchQuery = '',
    this.selectedCommentStatus = const [],
    this.selectedReportStatus = const [],
    this.selectedReportableEntity = const [],
    this.selectedAppReviewFeedback = const [],
  });

  final CommunityManagementTab activeTab;
  final String searchQuery;
  final List<CommentStatus> selectedCommentStatus;
  final List<ReportStatus> selectedReportStatus;
  final List<ReportableEntity> selectedReportableEntity;
  final List<AppReviewFeedback> selectedAppReviewFeedback;

  CommunityFilterDialogState copyWith({
    String? searchQuery,
    List<CommentStatus>? selectedCommentStatus,
    List<ReportStatus>? selectedReportStatus,
    List<ReportableEntity>? selectedReportableEntity,
    List<AppReviewFeedback>? selectedAppReviewFeedback,
  }) {
    return CommunityFilterDialogState(
      activeTab: activeTab,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCommentStatus:
          selectedCommentStatus ?? this.selectedCommentStatus,
      selectedReportStatus: selectedReportStatus ?? this.selectedReportStatus,
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
    selectedCommentStatus,
    selectedReportStatus,
    selectedReportableEntity,
    selectedAppReviewFeedback,
  ];
}
