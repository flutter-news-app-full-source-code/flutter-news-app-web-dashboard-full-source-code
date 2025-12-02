import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

part 'community_filter_event.dart';
part 'community_filter_state.dart';

class CommunityFilterBloc
    extends Bloc<CommunityFilterEvent, CommunityFilterState> {
  CommunityFilterBloc() : super(const CommunityFilterState()) {
    on<CommunityFilterSearchQueryChanged>(_onSearchQueryChanged);
    on<CommunityFilterModerationStatusChanged>(_onModerationStatusChanged);
    on<CommunityFilterReportableEntityChanged>(_onReportableEntityChanged);
    on<CommunityFilterAppReviewFeedbackChanged>(_onAppReviewFeedbackChanged);
    on<CommunityFilterReset>(_onFilterReset);
    on<CommunityFilterApplied>(_onFilterApplied);
  }

  void _onSearchQueryChanged(
    CommunityFilterSearchQueryChanged event,
    Emitter<CommunityFilterState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onModerationStatusChanged(
    CommunityFilterModerationStatusChanged event,
    Emitter<CommunityFilterState> emit,
  ) {
    emit(state.copyWith(selectedModerationStatus: event.moderationStatus));
  }

  void _onReportableEntityChanged(
    CommunityFilterReportableEntityChanged event,
    Emitter<CommunityFilterState> emit,
  ) {
    emit(state.copyWith(selectedReportableEntity: event.reportableEntity));
  }

  void _onAppReviewFeedbackChanged(
    CommunityFilterAppReviewFeedbackChanged event,
    Emitter<CommunityFilterState> emit,
  ) {
    emit(state.copyWith(selectedAppReviewFeedback: event.appReviewFeedback));
  }

  void _onFilterReset(
    CommunityFilterReset event,
    Emitter<CommunityFilterState> emit,
  ) {
    emit(const CommunityFilterState());
  }

  void _onFilterApplied(
    CommunityFilterApplied event,
    Emitter<CommunityFilterState> emit,
  ) {
    emit(state.copyWith(version: state.version + 1));
  }
}
