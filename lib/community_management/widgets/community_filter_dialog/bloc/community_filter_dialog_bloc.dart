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
    on<CommunityFilterDialogModerationStatusChanged>(
      _onModerationStatusChanged,
    );
    on<CommunityFilterDialogReportableEntityChanged>(
      _onReportableEntityChanged,
    );
    on<CommunityFilterDialogAppReviewFeedbackChanged>(
      _onAppReviewFeedbackChanged,
    );
    on<CommunityFilterDialogReset>(_onFilterDialogReset);
  }

  void _onFilterDialogInitialized(
    CommunityFilterDialogInitialized event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.communityFilterState.searchQuery,
        selectedModerationStatus:
            event.communityFilterState.selectedModerationStatus,
        selectedReportableEntity:
            event.communityFilterState.selectedReportableEntity,
        selectedAppReviewFeedback:
            event.communityFilterState.selectedAppReviewFeedback,
      ),
    );
  }

  void _onSearchQueryChanged(
    CommunityFilterDialogSearchQueryChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onModerationStatusChanged(
    CommunityFilterDialogModerationStatusChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedModerationStatus: event.moderationStatus));
  }

  void _onReportableEntityChanged(
    CommunityFilterDialogReportableEntityChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedReportableEntity: event.reportableEntity));
  }

  void _onAppReviewFeedbackChanged(
    CommunityFilterDialogAppReviewFeedbackChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedAppReviewFeedback: event.appReviewFeedback));
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
