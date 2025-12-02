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
  }) : _engagementsRepository = engagementsRepository,
       _reportsRepository = reportsRepository,
       _appReviewsRepository = appReviewsRepository,
       _communityFilterBloc = communityFilterBloc,
       _logger = logger ?? Logger('CommunityManagementBloc'),
       super(const CommunityManagementState()) {
    on<CommunityManagementTabChanged>(_onTabChanged);
    on<LoadEngagementsRequested>(_onLoadEngagementsRequested);
    on<LoadReportsRequested>(_onLoadReportsRequested);
    on<LoadAppReviewsRequested>(_onLoadAppReviewsRequested);

    _filterSubscription = _communityFilterBloc.stream.listen((filterState) {
      switch (state.activeTab) {
        case CommunityManagementTab.engagements:
          add(
            LoadEngagementsRequested(
              filter: buildEngagementsFilterMap(filterState),
              forceRefresh: true,
            ),
          );
        case CommunityManagementTab.reports:
          add(
            LoadReportsRequested(
              filter: buildReportsFilterMap(filterState),
              forceRefresh: true,
            ),
          );
        case CommunityManagementTab.appReviews:
          add(
            LoadAppReviewsRequested(
              filter: buildAppReviewsFilterMap(filterState),
              forceRefresh: true,
            ),
          );
      }
    });

    _entityUpdateSubscription =
        Stream<Type>.multi((controller) {
          controller
            ..addStream(_engagementsRepository.entityUpdated)
            ..addStream(_reportsRepository.entityUpdated)
            ..addStream(_appReviewsRepository.entityUpdated);
        }).listen((updatedType) {
          if (updatedType == Engagement) {
            _logger.info('Engagement updated, reloading engagements list.');
            add(
              LoadEngagementsRequested(
                filter: buildEngagementsFilterMap(_communityFilterBloc.state),
                forceRefresh: true,
              ),
            );
          } else if (updatedType == Report) {
            _logger.info('Report updated, reloading reports list.');
            add(
              LoadReportsRequested(
                filter: buildReportsFilterMap(_communityFilterBloc.state),
                forceRefresh: true,
              ),
            );
          } else if (updatedType == AppReview) {
            _logger.info('AppReview updated, reloading app reviews list.');
            add(
              LoadAppReviewsRequested(
                filter: buildAppReviewsFilterMap(_communityFilterBloc.state),
                forceRefresh: true,
              ),
            );
          }
        });
  }

  final DataRepository<Engagement> _engagementsRepository;
  final DataRepository<Report> _reportsRepository;
  final DataRepository<AppReview> _appReviewsRepository;
  final CommunityFilterBloc _communityFilterBloc;
  final Logger _logger;

  late final StreamSubscription<CommunityFilterState> _filterSubscription;
  late final StreamSubscription<Type> _entityUpdateSubscription;

  @override
  Future<void> close() {
    _filterSubscription.cancel();
    _entityUpdateSubscription.cancel();
    return super.close();
  }

  Map<String, dynamic> buildEngagementsFilterMap(CommunityFilterState state) {
    final filter = <String, dynamic>{};
    if (state.searchQuery.isNotEmpty) {
      filter['userId'] = state.searchQuery;
    }
    if (state.selectedCommentStatus.isNotEmpty) {
      filter['comment.status'] = {
        r'$in': state.selectedCommentStatus.map((s) => s.name).toList(),
      };
    }
    return filter;
  }

  Map<String, dynamic> buildReportsFilterMap(CommunityFilterState state) {
    final filter = <String, dynamic>{};
    if (state.searchQuery.isNotEmpty) {
      filter['reporterUserId'] = state.searchQuery;
    }
    if (state.selectedReportStatus.isNotEmpty) {
      filter['status'] = {
        r'$in': state.selectedReportStatus.map((s) => s.name).toList(),
      };
    }
    if (state.selectedReportableEntity.isNotEmpty) {
      filter['entityType'] = {
        r'$in': state.selectedReportableEntity.map((e) => e.name).toList(),
      };
    }
    return filter;
  }

  Map<String, dynamic> buildAppReviewsFilterMap(CommunityFilterState state) {
    final filter = <String, dynamic>{};
    if (state.searchQuery.isNotEmpty) {
      filter['userId'] = state.searchQuery;
    }
    if (state.selectedAppReviewFeedback.isNotEmpty) {
      filter['feedback'] = {
        r'$in': state.selectedAppReviewFeedback.map((f) => f.name).toList(),
      };
    }
    return filter;
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
