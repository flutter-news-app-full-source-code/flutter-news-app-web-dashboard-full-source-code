part of 'community_filter_bloc.dart';

enum HasCommentFilter { any, withComment, withoutComment }

class CommunityFilterState extends Equatable {
  const CommunityFilterState({
    this.searchQuery = '',
    this.selectedCommentStatus = const [],
    this.selectedReportStatus = const [],
    this.selectedReportableEntity = const [],
    this.selectedAppReviewFeedback = const [],
    this.hasComment = HasCommentFilter.any,
  });

  final String searchQuery;
  final List<ModerationStatus> selectedCommentStatus;
  final List<ModerationStatus> selectedReportStatus;
  final List<ReportableEntity> selectedReportableEntity;
  final List<AppReviewFeedback> selectedAppReviewFeedback;
  final HasCommentFilter hasComment;

  CommunityFilterState copyWith({
    String? searchQuery,
    List<ModerationStatus>? selectedCommentStatus,
    List<ModerationStatus>? selectedReportStatus,
    List<ReportableEntity>? selectedReportableEntity,
    List<AppReviewFeedback>? selectedAppReviewFeedback,
    HasCommentFilter? hasComment,
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
      hasComment: hasComment ?? this.hasComment,
    );
  }

  @override
  List<Object> get props => [
    searchQuery,
    selectedCommentStatus,
    selectedReportStatus,
    selectedReportableEntity,
    selectedAppReviewFeedback,
    hasComment,
  ];
}
