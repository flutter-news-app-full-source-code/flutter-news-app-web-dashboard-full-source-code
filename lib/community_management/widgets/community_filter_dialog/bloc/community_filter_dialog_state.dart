part of 'community_filter_dialog_bloc.dart';

class CommunityFilterDialogState extends Equatable {
  const CommunityFilterDialogState({
    required this.activeTab,
    this.searchQuery = '',
    this.selectedCommentStatus = const [],
    this.selectedReportStatus = const [],
    this.selectedReportableEntity = const [],
    this.selectedAppReviewFeedback = const [],
    this.hasComment = HasCommentFilter.any,
  });

  final CommunityManagementTab activeTab;
  final String searchQuery;
  final List<ModerationStatus> selectedCommentStatus;
  final List<ModerationStatus> selectedReportStatus;
  final List<ReportableEntity> selectedReportableEntity;
  final List<AppReviewFeedback> selectedAppReviewFeedback;
  final HasCommentFilter hasComment;

  CommunityFilterDialogState copyWith({
    String? searchQuery,
    List<ModerationStatus>? selectedCommentStatus,
    List<ModerationStatus>? selectedReportStatus,
    List<ReportableEntity>? selectedReportableEntity,
    List<AppReviewFeedback>? selectedAppReviewFeedback,
    HasCommentFilter? hasComment,
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
      hasComment: hasComment ?? this.hasComment,
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
    hasComment,
  ];
}
