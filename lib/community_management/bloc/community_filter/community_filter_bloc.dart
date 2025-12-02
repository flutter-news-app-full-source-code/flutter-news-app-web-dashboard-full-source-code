import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

part 'community_filter_event.dart';
part 'community_filter_state.dart';

class CommunityFilterBloc
    extends Bloc<CommunityFilterEvent, CommunityFilterState> {
  CommunityFilterBloc() : super(const CommunityFilterState()) {
    on<CommunityFilterApplied>(_onFilterApplied);
    on<CommunityFilterReset>(_onFilterReset);
  }

  void _onFilterApplied(
    CommunityFilterApplied event,
    Emitter<CommunityFilterState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.searchQuery,
        selectedCommentStatus: event.selectedCommentStatus,
        selectedReportStatus: event.selectedReportStatus,
        selectedReportableEntity: event.selectedReportableEntity,
        selectedAppReviewFeedback: event.selectedAppReviewFeedback,
        hasComment: event.hasComment,
      ),
    );
  }

  void _onFilterReset(
    CommunityFilterReset event,
    Emitter<CommunityFilterState> emit,
  ) {
    emit(
      const CommunityFilterState(),
    );
  }
}
