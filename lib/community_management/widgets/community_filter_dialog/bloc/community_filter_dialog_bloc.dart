import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_filter/community_filter_bloc.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/community_management/bloc/community_management_bloc.dart';

part 'community_filter_dialog_event.dart';
part 'community_filter_dialog_state.dart';

class CommunityFilterDialogBloc
    extends Bloc<CommunityFilterDialogEvent, CommunityFilterDialogState> {
  CommunityFilterDialogBloc({required CommunityManagementTab activeTab})
    : super(CommunityFilterDialogState(activeTab: activeTab)) {
    on<CommunityFilterDialogInitialized>(_onFilterDialogInitialized);
    on<CommunityFilterDialogSearchQueryChanged>(_onSearchQueryChanged);
    on<CommunityFilterDialogCommentStatusChanged>(_onCommentStatusChanged);
    on<CommunityFilterDialogReportStatusChanged>(_onReportStatusChanged);
    on<CommunityFilterDialogReportableEntityChanged>(
      _onReportableEntityChanged,
    );
    on<CommunityFilterDialogInitialFeedbackChanged>(_onInitialFeedbackChanged);
    on<CommunityFilterDialogReset>(_onFilterDialogReset);
  }

  void _onFilterDialogInitialized(
    CommunityFilterDialogInitialized event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.communityFilterState.searchQuery,
        selectedCommentStatus: event.communityFilterState.selectedCommentStatus,
        selectedReportStatus: event.communityFilterState.selectedReportStatus,
        selectedReportableEntity:
            event.communityFilterState.selectedReportableEntity,
        selectedInitialFeedback:
            event.communityFilterState.selectedInitialFeedback,
      ),
    );
  }

  void _onSearchQueryChanged(
    CommunityFilterDialogSearchQueryChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onCommentStatusChanged(
    CommunityFilterDialogCommentStatusChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedCommentStatus: event.commentStatus));
  }

  void _onReportStatusChanged(
    CommunityFilterDialogReportStatusChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedReportStatus: event.reportStatus));
  }

  void _onReportableEntityChanged(
    CommunityFilterDialogReportableEntityChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedReportableEntity: event.reportableEntity));
  }

  void _onInitialFeedbackChanged(
    CommunityFilterDialogInitialFeedbackChanged event,
    Emitter<CommunityFilterDialogState> emit,
  ) {
    emit(state.copyWith(selectedInitialFeedback: event.initialFeedback));
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
