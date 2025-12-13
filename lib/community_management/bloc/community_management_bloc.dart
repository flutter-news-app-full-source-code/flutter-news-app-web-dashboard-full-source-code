import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:data_repository/data_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_filter/community_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/constants/app_constants.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/shared/services/pending_updates_service.dart';
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
    required PendingUpdatesService pendingUpdatesService,
    Logger? logger,
  }) : _engagementsRepository = engagementsRepository,
       _reportsRepository = reportsRepository,
       _appReviewsRepository = appReviewsRepository,
       _communityFilterBloc = communityFilterBloc,
       _pendingUpdatesService = pendingUpdatesService,
       _logger = logger ?? Logger('CommunityManagementBloc'),
       super(const CommunityManagementState()) {
    on<CommunityManagementTabChanged>(_onTabChanged);
    on<LoadEngagementsRequested>(_onLoadEngagementsRequested);
    on<LoadReportsRequested>(_onLoadReportsRequested);
    on<LoadAppReviewsRequested>(_onLoadAppReviewsRequested);
    on<ApproveCommentRequested>(_onApproveCommentRequested);
    on<RejectCommentRequested>(_onRejectCommentRequested);
    on<ResolveReportRequested>(_onResolveReportRequested);
    on<UndoUpdateRequested>(_onUndoUpdateRequested);
    on<UpdateEventReceived>(_onUpdateEventReceived);

    _engagementsUpdateSubscription = _engagementsRepository.entityUpdated
        .listen((_) {
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
          filter: buildReportsFilterMap(
            _communityFilterBloc.state.reportsFilter,
          ),
          forceRefresh: true,
        ),
      );
    });

    _appReviewsUpdateSubscription = _appReviewsRepository.entityUpdated.listen((
      _,
    ) {
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

    _updateEventsSubscription = _pendingUpdatesService.updateEvents.listen(
      (event) => add(UpdateEventReceived(event)),
    );
  }

  final DataRepository<Engagement> _engagementsRepository;
  final DataRepository<Report> _reportsRepository;
  final DataRepository<AppReview> _appReviewsRepository;
  final CommunityFilterBloc _communityFilterBloc;
  final Logger _logger;
  final PendingUpdatesService _pendingUpdatesService;

  late final StreamSubscription<void> _engagementsUpdateSubscription;
  late final StreamSubscription<void> _reportsUpdateSubscription;
  late final StreamSubscription<void> _appReviewsUpdateSubscription;
  late final StreamSubscription<UpdateEvent<dynamic>> _updateEventsSubscription;

  @override
  Future<void> close() {
    _engagementsUpdateSubscription.cancel();
    _reportsUpdateSubscription.cancel();
    _appReviewsUpdateSubscription.cancel();
    _updateEventsSubscription.cancel();
    return super.close();
  }

  Map<String, dynamic> buildEngagementsFilterMap(EngagementsFilter filter) {
    final conditions = <Map<String, dynamic>>[];

    if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
      conditions.add({'userId': filter.searchQuery});
    }

    if (filter.selectedStatus != null) {
      conditions.add({'comment.status': filter.selectedStatus!.name});
    }

    if (conditions.isEmpty) {
      return {};
    } else if (conditions.length == 1) {
      return conditions.first;
    } else {
      return {r'$and': conditions};
    }
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

  Future<void> _onApproveCommentRequested(
    ApproveCommentRequested event,
    Emitter<CommunityManagementState> emit,
  ) async {
    try {
      final originalEngagement = state.engagements.firstWhere(
        (e) => e.id == event.engagementId,
      );

      if (originalEngagement.comment == null) return;

      final updatedEngagement = originalEngagement.copyWith(
        comment: ValueWrapper(
          originalEngagement.comment!.copyWith(
            status: ModerationStatus.resolved,
          ),
        ),
      );

      final updatedEngagements = List<Engagement>.from(state.engagements)
        ..[state.engagements.indexOf(originalEngagement)] = updatedEngagement;

      emit(
        state.copyWith(
          engagements: updatedEngagements,
          lastPendingUpdateId: event.engagementId,
          snackbarMessage: 'Comment approved.',
        ),
      );

      _pendingUpdatesService.requestUpdate(
        originalItem: originalEngagement,
        updatedItem: updatedEngagement,
        repository: _engagementsRepository,
        undoDuration: AppConstants.kSnackbarDuration,
      );
    } catch (e) {
      _logger.severe('Error approving comment: $e');
    }
  }

  Future<void> _onRejectCommentRequested(
    RejectCommentRequested event,
    Emitter<CommunityManagementState> emit,
  ) async {
    try {
      final originalEngagement = state.engagements.firstWhere(
        (e) => e.id == event.engagementId,
      );

      final updatedEngagement = originalEngagement.copyWith(
        // Use ValueWrapper to explicitly set the comment to null.
        comment: const ValueWrapper(null),
      );

      final updatedEngagements = List<Engagement>.from(state.engagements)
        ..[state.engagements.indexOf(originalEngagement)] = updatedEngagement;

      emit(
        state.copyWith(
          engagements: updatedEngagements,
          lastPendingUpdateId: event.engagementId,
          snackbarMessage: 'Comment rejected.',
        ),
      );

      _pendingUpdatesService.requestUpdate(
        originalItem: originalEngagement,
        updatedItem: updatedEngagement,
        repository: _engagementsRepository,
        undoDuration: AppConstants.kSnackbarDuration,
      );
    } catch (e) {
      _logger.severe('Error rejecting comment: $e');
    }
  }

  Future<void> _onResolveReportRequested(
    ResolveReportRequested event,
    Emitter<CommunityManagementState> emit,
  ) async {
    try {
      final originalReport = state.reports.firstWhere(
        (r) => r.id == event.reportId,
      );

      final updatedReport = originalReport.copyWith(
        status: ModerationStatus.resolved,
      );

      final updatedReports = List<Report>.from(state.reports)
        ..[state.reports.indexOf(originalReport)] = updatedReport;

      emit(
        state.copyWith(
          reports: updatedReports,
          lastPendingUpdateId: event.reportId,
          snackbarMessage: 'Report resolved.',
        ),
      );

      _pendingUpdatesService.requestUpdate(
        originalItem: originalReport,
        updatedItem: updatedReport,
        repository: _reportsRepository,
        undoDuration: AppConstants.kSnackbarDuration,
      );
    } catch (e) {
      _logger.severe('Error resolving report: $e');
    }
  }

  void _onUndoUpdateRequested(
    UndoUpdateRequested event,
    Emitter<CommunityManagementState> emit,
  ) {
    _pendingUpdatesService.undoUpdate(event.id);
  }

  Future<void> _onUpdateEventReceived(
    UpdateEventReceived event,
    Emitter<CommunityManagementState> emit,
  ) async {
    switch (event.event.status) {
      case UpdateStatus.confirmed:
        emit(
          state.copyWith(
            lastPendingUpdateId: null,
            snackbarMessage: null,
          ),
        );
      case UpdateStatus.undone:
        final item = event.event.originalItem;
        if (item is Engagement) {
          final index = state.engagements.indexWhere((e) => e.id == item.id);
          if (index != -1) {
            final updatedEngagements = List<Engagement>.from(state.engagements)
              ..[index] = item;
            emit(
              state.copyWith(
                engagements: updatedEngagements,
                lastPendingUpdateId: null,
                snackbarMessage: null,
              ),
            );
          } else {
            emit(
              state.copyWith(lastPendingUpdateId: null, snackbarMessage: null),
            );
          }
        } else if (item is Report) {
          final index = state.reports.indexWhere((r) => r.id == item.id);
          if (index != -1) {
            final updatedReports = List<Report>.from(state.reports)
              ..[index] = item;
            emit(
              state.copyWith(
                reports: updatedReports,
                lastPendingUpdateId: null,
                snackbarMessage: null,
              ),
            );
          } else {
            emit(
              state.copyWith(lastPendingUpdateId: null, snackbarMessage: null),
            );
          }
        } else {
          emit(
            state.copyWith(lastPendingUpdateId: null, snackbarMessage: null),
          );
        }
    }
  }
}
