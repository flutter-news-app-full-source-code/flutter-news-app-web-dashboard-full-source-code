part of 'community_filter_bloc.dart';

enum HasCommentFilter { any, withComment, withoutComment }

class CommunityFilterState extends Equatable {
  const CommunityFilterState({
    this.engagementsFilter = const EngagementsFilterState(),
    this.reportsFilter = const ReportsFilterState(),
    this.appReviewsFilter = const AppReviewsFilterState(),
  });

  final EngagementsFilterState engagementsFilter;
  final ReportsFilterState reportsFilter;
  final AppReviewsFilterState appReviewsFilter;

  CommunityFilterState copyWith({
    EngagementsFilterState? engagementsFilter,
    ReportsFilterState? reportsFilter,
    AppReviewsFilterState? appReviewsFilter,
  }) {
    return CommunityFilterState(
      engagementsFilter: engagementsFilter ?? this.engagementsFilter,
      reportsFilter: reportsFilter ?? this.reportsFilter,
      appReviewsFilter: appReviewsFilter ?? this.appReviewsFilter,
    );
  }

  @override
  List<Object> get props => [
    engagementsFilter,
    reportsFilter,
    appReviewsFilter,
  ];
}

class EngagementsFilterState extends Equatable {
  const EngagementsFilterState({
    this.searchQuery = '',
    this.selectedStatus = const [],
    this.hasComment = HasCommentFilter.any,
  });

  final String searchQuery;
  final List<ModerationStatus> selectedStatus;
  final HasCommentFilter hasComment;

  bool get isFilterActive =>
      searchQuery.isNotEmpty ||
          selectedStatus.isNotEmpty ||
          hasComment != HasCommentFilter.any;

  @override
  List<Object> get props => [searchQuery, selectedStatus, hasComment];

  EngagementsFilterState copyWith({
    String? searchQuery,
    List<ModerationStatus>? selectedStatus,
    HasCommentFilter? hasComment,
  }) {
    return EngagementsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      hasComment: hasComment ?? this.hasComment,
    );
  }
}


class ReportsFilterState extends Equatable {
  const ReportsFilterState({
    this.searchQuery = '',
    this.selectedStatus = const [],
    this.selectedReportableEntity = const [],
  });

  final String searchQuery;
  final List<ModerationStatus> selectedStatus;
  final List<ReportableEntity> selectedReportableEntity;

  bool get isFilterActive =>
      searchQuery.isNotEmpty ||
          selectedStatus.isNotEmpty ||
          selectedReportableEntity.isNotEmpty;

  @override
  List<Object> get props => [
    searchQuery,
    selectedStatus,
    selectedReportableEntity,
  ];

  ReportsFilterState copyWith({
    String? searchQuery,
    List<ModerationStatus>? selectedStatus,
    List<ReportableEntity>? selectedReportableEntity,
  }) {
    return ReportsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedReportableEntity:
          selectedReportableEntity ?? this.selectedReportableEntity,
    );
  }
}

class AppReviewsFilterState extends Equatable {
  const AppReviewsFilterState({
    this.searchQuery = '',
    this.selectedFeedback = const [],
  });

  final String searchQuery;
  final List<AppReviewFeedback> selectedFeedback;

  bool get isFilterActive =>
      searchQuery.isNotEmpty || selectedFeedback.isNotEmpty;

  @override
  List<Object> get props => [searchQuery, selectedFeedback];

  AppReviewsFilterState copyWith({
    String? searchQuery,
    List<AppReviewFeedback>? selectedFeedback,
  }) {
    return AppReviewsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFeedback: selectedFeedback ?? this.selectedFeedback,
    );
  }
}
