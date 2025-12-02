part of 'community_management_bloc.dart';

enum CommunityManagementTab { engagements, reports, appReviews }

enum CommunityManagementStatus { initial, loading, success, failure }

class CommunityManagementState extends Equatable {
  const CommunityManagementState({
    this.activeTab = CommunityManagementTab.engagements,
    this.engagementsStatus = CommunityManagementStatus.initial,
    this.reportsStatus = CommunityManagementStatus.initial,
    this.appReviewsStatus = CommunityManagementStatus.initial,
    this.engagements = const [],
    this.reports = const [],
    this.appReviews = const [],
    this.engagementsCursor,
    this.reportsCursor,
    this.appReviewsCursor,
    this.hasMoreEngagements = true,
    this.hasMoreReports = true,
    this.hasMoreAppReviews = true,
    this.exception,
    this.lastPendingUpdateId,
    this.snackbarMessage,
  });

  final CommunityManagementTab activeTab;
  final CommunityManagementStatus engagementsStatus;
  final CommunityManagementStatus reportsStatus;
  final CommunityManagementStatus appReviewsStatus;
  final List<Engagement> engagements;
  final List<Report> reports;
  final List<AppReview> appReviews;
  final String? engagementsCursor;
  final String? reportsCursor;
  final String? appReviewsCursor;
  final bool hasMoreEngagements;
  final bool hasMoreReports;
  final bool hasMoreAppReviews;
  final HttpException? exception;
  final String? lastPendingUpdateId;
  final String? snackbarMessage;

  CommunityManagementState copyWith({
    CommunityManagementTab? activeTab,
    CommunityManagementStatus? engagementsStatus,
    CommunityManagementStatus? reportsStatus,
    CommunityManagementStatus? appReviewsStatus,
    List<Engagement>? engagements,
    List<Report>? reports,
    List<AppReview>? appReviews,
    String? engagementsCursor,
    String? reportsCursor,
    String? appReviewsCursor,
    bool? hasMoreEngagements,
    bool? hasMoreReports,
    bool? hasMoreAppReviews,
    HttpException? exception,
    String? lastPendingUpdateId,
    String? snackbarMessage,
    bool forceEngagementsCursor = false,
    bool forceReportsCursor = false,
    bool forceAppReviewsCursor = false,
  }) {
    return CommunityManagementState(
      activeTab: activeTab ?? this.activeTab,
      engagementsStatus: engagementsStatus ?? this.engagementsStatus,
      reportsStatus: reportsStatus ?? this.reportsStatus,
      appReviewsStatus: appReviewsStatus ?? this.appReviewsStatus,
      engagements: engagements ?? this.engagements,
      reports: reports ?? this.reports,
      appReviews: appReviews ?? this.appReviews,
      engagementsCursor: forceEngagementsCursor
          ? engagementsCursor
          : engagementsCursor ?? this.engagementsCursor,
      reportsCursor: forceReportsCursor
          ? reportsCursor
          : reportsCursor ?? this.reportsCursor,
      appReviewsCursor: forceAppReviewsCursor
          ? appReviewsCursor
          : appReviewsCursor ?? this.appReviewsCursor,
      hasMoreEngagements: hasMoreEngagements ?? this.hasMoreEngagements,
      hasMoreReports: hasMoreReports ?? this.hasMoreReports,
      hasMoreAppReviews: hasMoreAppReviews ?? this.hasMoreAppReviews,
      exception: exception,
      lastPendingUpdateId: lastPendingUpdateId,
      snackbarMessage: snackbarMessage,
    );
  }

  @override
  List<Object?> get props => [
    activeTab,
    engagementsStatus,
    reportsStatus,
    appReviewsStatus,
    engagements,
    reports,
    appReviews,
    engagementsCursor,
    reportsCursor,
    appReviewsCursor,
    hasMoreEngagements,
    hasMoreReports,
    hasMoreAppReviews,
    exception,
    lastPendingUpdateId,
    snackbarMessage,
  ];
}
