part of 'community_filter_bloc.dart';

class CommunityFilterState extends Equatable {
  const CommunityFilterState({
    this.searchQuery = '',
    this.selectedCommentStatus = const [],
    this.selectedReportStatus = const [],
    this.selectedReportableEntity = const [],
    this.selectedAppReviewFeedback = const [],
  });

  final String searchQuery;
  final List<CommentStatus> selectedCommentStatus;
  final List<ReportStatus> selectedReportStatus;
  final List<ReportableEntity> selectedReportableEntity;
  final List<AppReviewFeedback> selectedAppReviewFeedback;

  CommunityFilterState copyWith({
    String? searchQuery,
    List<CommentStatus>? selectedCommentStatus,
    List<ReportStatus>? selectedReportStatus,
    List<ReportableEntity>? selectedReportableEntity,
    List<AppReviewFeedback>? selectedAppReviewFeedback,
  }) {
    return CommunityFilterState(
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
    searchQuery,
    selectedCommentStatus,
    selectedReportStatus,
    selectedReportableEntity,
    selectedAppReviewFeedback,
  ];
}
