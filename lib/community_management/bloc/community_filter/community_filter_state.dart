part of 'community_filter_bloc.dart';

class EngagementsFilter extends Equatable {
  const EngagementsFilter({
    this.searchQuery,
    this.selectedStatus,
  });

  final String? searchQuery;
  final ModerationStatus? selectedStatus;

  bool get isFilterActive =>
      (searchQuery != null && searchQuery!.isNotEmpty) ||
      selectedStatus != null;

  @override
  List<Object?> get props => [searchQuery, selectedStatus];
}

class ReportsFilter extends Equatable {
  const ReportsFilter({
    this.searchQuery,
    this.selectedStatus,
    this.selectedReportableEntity,
  });

  final String? searchQuery;
  final ModerationStatus? selectedStatus;
  final ReportableEntity? selectedReportableEntity;

  bool get isFilterActive =>
      (searchQuery != null && searchQuery!.isNotEmpty) ||
      selectedStatus != null ||
      selectedReportableEntity != null;

  @override
  List<Object?> get props => [
    searchQuery,
    selectedStatus,
    selectedReportableEntity,
  ];
}

class AppReviewsFilter extends Equatable {
  const AppReviewsFilter({
    this.searchQuery,
    this.selectedFeedback,
  });

  final String? searchQuery;
  final AppReviewFeedback? selectedFeedback;

  bool get isFilterActive =>
      (searchQuery != null && searchQuery!.isNotEmpty) ||
      selectedFeedback != null;

  @override
  List<Object?> get props => [searchQuery, selectedFeedback];
}

class CommunityFilterState extends Equatable {
  const CommunityFilterState({
    this.engagementsFilter = const EngagementsFilter(),
    this.reportsFilter = const ReportsFilter(),
    this.appReviewsFilter = const AppReviewsFilter(),
    this.version = 0,
  });

  final int version;
  final EngagementsFilter engagementsFilter;
  final ReportsFilter reportsFilter;
  final AppReviewsFilter appReviewsFilter;

  CommunityFilterState copyWith({
    EngagementsFilter? engagementsFilter,
    ReportsFilter? reportsFilter,
    AppReviewsFilter? appReviewsFilter,
    int? version,
  }) {
    return CommunityFilterState(
      engagementsFilter: engagementsFilter ?? this.engagementsFilter,
      reportsFilter: reportsFilter ?? this.reportsFilter,
      appReviewsFilter: appReviewsFilter ?? this.appReviewsFilter,
      version: version ?? this.version,
    );
  }

  @override
  List<Object> get props => [
    engagementsFilter,
    reportsFilter,
    appReviewsFilter,
    version,
  ];
}
