import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_filter/community_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_management_bloc.dart';

part 'community_filter_dialog_event.dart';
part 'community_filter_dialog_state.dart';

class CommunityFilterDialogBloc
    extends Bloc<CommunityFilterDialogEvent, CommunityFilterDialogState> {
  CommunityFilterDialogBloc()
    : super(
        const CommunityFilterDialogState(
          activeTab: CommunityManagementTab.engagements,
        ),
      ) {
    on<CommunityFilterDialogInitialized>(_onFilterDialogInitialized);
    on<CommunityFilterDialogSearchQueryChanged>(_onSearchQueryChanged);
    on<CommunityFilterDialogEngagementsStatusChanged>(
      _onEngagementsStatusChanged,
    );
    on<CommunityFilterDialogReportsStatusChanged>(_onReportsStatusChanged);
    on<CommunityFilterDialogReportableEntityChanged>(
      _onReportableEntityChanged,
    );
    on<CommunityFilterDialogAppReviewsFeedbackChanged>(
      _onAppReviewsFeedbackChanged,
    );
    on<CommunityFilterDialogHasCommentChanged>(_onHasCommentChanged);
    on<CommunityFilterDialogReset>(_onFilterDialogReset);
  }

  void _onFilterDialogInitialized(
    CommunityFilterDialogInitialized event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    emit(
      CommunityFilterDialogState(
        activeTab: event.activeTab,
        engagementsFilter: event.communityFilterState.engagementsFilter,
        reportsFilter: event.communityFilterState.reportsFilter,
        appReviewsFilter: event.communityFilterState.appReviewsFilter,
      ),
    );
  }

  void _onSearchQueryChanged(
    CommunityFilterDialogSearchQueryChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    switch (state.activeTab) {
      case CommunityManagementTab.engagements:
        emit(
          state.copyWith(
            engagementsFilter: EngagementsFilterState(
              searchQuery: event.query,
              selectedStatus: state.engagementsFilter.selectedStatus,
              hasComment: state.engagementsFilter.hasComment,
            ),
          ),
        );
      case CommunityManagementTab.reports:
        emit(
          state.copyWith(
            reportsFilter: ReportsFilterState(
              searchQuery: event.query,
              selectedStatus: state.reportsFilter.selectedStatus,
              selectedReportableEntity:
                  state.reportsFilter.selectedReportableEntity,
            ),
          ),
        );
      case CommunityManagementTab.appReviews:
        emit(
          state.copyWith(
            appReviewsFilter: AppReviewsFilterState(
              searchQuery: event.query,
              selectedFeedback: state.appReviewsFilter.selectedFeedback,
            ),
          ),
        );
    }
  }

  void _onEngagementsStatusChanged(
    CommunityFilterDialogEngagementsStatusChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    final newFilter = state.engagementsFilter.copyWith(
      selectedStatus: event.status,
    );
    emit(state.copyWith(engagementsFilter: newFilter));
  }

  void _onReportsStatusChanged(
    CommunityFilterDialogReportsStatusChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    final newFilter = state.reportsFilter.copyWith(
      selectedStatus: event.status,
    );
    emit(state.copyWith(reportsFilter: newFilter));
  }

  void _onReportableEntityChanged(
    CommunityFilterDialogReportableEntityChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    final newFilter = state.reportsFilter.copyWith(
      selectedReportableEntity: event.reportableEntity,
    );
    emit(state.copyWith(reportsFilter: newFilter));
  }

  void _onAppReviewsFeedbackChanged(
    CommunityFilterDialogAppReviewsFeedbackChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    final newFilter = state.appReviewsFilter.copyWith(
      selectedFeedback: event.feedback,
    );
    emit(state.copyWith(appReviewsFilter: newFilter));
  }

  void _onHasCommentChanged(
    CommunityFilterDialogHasCommentChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    final newFilter = state.engagementsFilter.copyWith(
      hasComment: event.hasComment,
    );
    emit(state.copyWith(engagementsFilter: newFilter));
  }

  void _onFilterDialogReset(
    CommunityFilterDialogReset event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    emit(
      CommunityFilterDialogState(activeTab: state.activeTab),
    );
  }
}
