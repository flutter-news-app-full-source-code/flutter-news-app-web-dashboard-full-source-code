import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_filter/community_filter_bloc.dart';
import 'package:logging/logging.dart';

part 'community_management_event.dart';
part 'community_management_state.dart';

class CommunityManagementBloc
    extends Bloc<CommunityManagementEvent, CommunityManagementState> {
  CommunityManagementBloc({
    required DataRepository<Engagement> engagementsRepository,
    required DataRepository<Report> reportsRepository,
    required DataRepository<AppReview> appReviewsRepository,
    required CommunityFilterBloc communityFilterBloc,
    Logger? logger,
  })  : _engagementsRepository = engagementsRepository,
        _reportsRepository = reportsRepository,
        _appReviewsRepository = appReviewsRepository,
        _communityFilterBloc = communityFilterBloc,
        _logger = logger ?? Logger('CommunityManagementBloc'),
        super(const CommunityManagementState()) {
    on<CommunityManagementTabChanged>(_onTabChanged);
    on<LoadEngagementsRequested>(_onLoadEngagementsRequested);
    on<LoadReportsRequested>(_onLoadReportsRequested);
    on<LoadAppReviewsRequested>(_onLoadAppReviewsRequested);

    _engagementsUpdateSubscription =
        _engagementsRepository.entityUpdated.listen((_) {
      _logger.info('Engagement updated, reloading engagements list.');
      add(
        LoadEngagementsRequested(
          filter: buildEngagementsFilterMap(
            _communityFilterBloc.state.engagementsFilter,
          ),
          forceRefresh: true,
        ),
      );
    });

    _reportsUpdateSubscription = _reportsRepository.entityUpdated.listen((_) {
      _logger.info('Report updated, reloading reports list.');
      add(
        LoadReportsRequested(
          filter: buildReportsFilterMap(_communityFilterBloc.state.reportsFilter),
          forceRefresh: true,
        ),
      );
    });

    _appReviewsUpdateSubscription =
        _appReviewsRepository.entityUpdated.listen((_) {
      _logger.info('AppReview updated, reloading app reviews list.');
      add(
        LoadAppReviewsRequested(
          filter: buildAppReviewsFilterMap(
            _communityFilterBloc.state.appReviewsFilter,
          ),
          forceRefresh: true,
        ),
      );
    });
  }

  final DataRepository<Engagement> _engagementsRepository;
  final DataRepository<Report> _reportsRepository;
  final DataRepository<AppReview> _appReviewsRepository;
  final CommunityFilterBloc _communityFilterBloc;
  final Logger _logger;

  late final StreamSubscription<void> _engagementsUpdateSubscription;
  late final StreamSubscription<void> _reportsUpdateSubscription;
  late final StreamSubscription<void> _appReviewsUpdateSubscription;

  @override
  Future<void> close() {
    _engagementsUpdateSubscription.cancel();
    _reportsUpdateSubscription.cancel();
    _appReviewsUpdateSubscription.cancel();
    return super.close();
  }

  Map<String, dynamic> buildEngagementsFilterMap(EngagementsFilter filter) {
    final filterMap = <String, dynamic>{};
    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      filterMap['userId'] = filter.searchQuery;
    }
    if (filter.selectedStatus != null) {
      filterMap['comment.status'] = {
        r'$in': [filter.selectedStatus!.name],
      };
    }
    return filterMap;
  }

  Map<String, dynamic> buildReportsFilterMap(ReportsFilter filter) {
    final filterMap = <String, dynamic>{};
    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      filterMap['reporterUserId'] = filter.searchQuery;
    }
    if (filter.selectedStatus != null) {
      filterMap['status'] = {
        r'$in': [filter.selectedStatus!.name],
      };
    }
    if (filter.selectedReportableEntity != null) {
      filterMap['entityType'] = {
        r'$in': [filter.selectedReportableEntity!.name],
      };
    }
    return filterMap;
  }

  Map<String, dynamic> buildAppReviewsFilterMap(AppReviewsFilter filter) {
    final filterMap = <String, dynamic>{};
    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      filterMap['userId'] = filter.searchQuery;
    }
    if (filter.selectedFeedback != null) {
      filterMap['feedback'] = {
        r'$in': [filter.selectedFeedback!.name],
      };
    }
    return filterMap;
  }

  void _onTabChanged(
    CommunityManagementTabChanged event,
    Emitter<CommunityManagementState> emit,
  ) {
    emit(state.copyWith(activeTab: event.tab));
  }

  Future<void> _onLoadEngagementsRequested(
    LoadEngagementsRequested event,
    Emitter<CommunityManagementState> emit,
  ) async {
    _logger.info('Loading engagements with filter: ${event.filter}');
    emit(
      state.copyWith(
        engagementsStatus: CommunityManagementStatus.loading,
        engagements: event.forceRefresh ? [] : state.engagements,
      ),
    );
    try {
      final response = await _engagementsRepository.readAll(
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
        filter: event.filter,
        sort: [const SortOption('createdAt', SortOrder.desc)],
      );
      final newEngagements = event.forceRefresh
          ? response.items
          : [...state.engagements, ...response.items];

      emit(
        state.copyWith(
          engagementsStatus: CommunityManagementStatus.success,
          engagements: newEngagements,
          engagementsCursor: response.cursor,
          hasMoreEngagements: response.hasMore,
          forceEngagementsCursor: true,
        ),
      );
    } on HttpException catch (e) {
      _logger.severe('Failed to load engagements', e);
      emit(
        state.copyWith(
          engagementsStatus: CommunityManagementStatus.failure,
          exception: e,
        ),
      );
    }
  }

  Future<void> _onLoadReportsRequested(
    LoadReportsRequested event,
    Emitter<CommunityManagementState> emit,
  ) async {
    _logger.info('Loading reports with filter: ${event.filter}');
    emit(
      state.copyWith(
        reportsStatus: CommunityManagementStatus.loading,
        reports: event.forceRefresh ? [] : state.reports,
      ),
    );
    try {
      final response = await _reportsRepository.readAll(
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
        filter: event.filter,
        sort: [const SortOption('createdAt', SortOrder.desc)],
      );
      final newReports = event.forceRefresh
          ? response.items
          : [...state.reports, ...response.items];

      emit(
        state.copyWith(
          reportsStatus: CommunityManagementStatus.success,
          reports: newReports,
          reportsCursor: response.cursor,
          hasMoreReports: response.hasMore,
          forceReportsCursor: true,
        ),
      );
    } on HttpException catch (e) {
      _logger.severe('Failed to load reports', e);
      emit(
        state.copyWith(
          reportsStatus: CommunityManagementStatus.failure,
          exception: e,
        ),
      );
    }
  }

  Future<void> _onLoadAppReviewsRequested(
    LoadAppReviewsRequested event,
    Emitter<CommunityManagementState> emit,
  ) async {
    _logger.info('Loading app reviews with filter: ${event.filter}');
    emit(
      state.copyWith(
        appReviewsStatus: CommunityManagementStatus.loading,
        appReviews: event.forceRefresh ? [] : state.appReviews,
      ),
    );
    try {
      final response = await _appReviewsRepository.readAll(
        pagination: PaginationOptions(
          cursor: event.startAfterId,
          limit: event.limit,
        ),
        filter: event.filter,
        sort: [const SortOption('updatedAt', SortOrder.desc)],
      );
      final newAppReviews = event.forceRefresh
          ? response.items
          : [...state.appReviews, ...response.items];

      emit(
        state.copyWith(
          appReviewsStatus: CommunityManagementStatus.success,
          appReviews: newAppReviews,
          appReviewsCursor: response.cursor,
          hasMoreAppReviews: response.hasMore,
          forceAppReviewsCursor: true,
        ),
      );
    } on HttpException catch (e) {
      _logger.severe('Failed to load app reviews', e);
      emit(
        state.copyWith(
          appReviewsStatus: CommunityManagementStatus.failure,
          exception: e,
        ),
      );
    }
  }
}
