import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

part 'community_filter_event.dart';
part 'community_filter_state.dart';

class CommunityFilterBloc
    extends Bloc<CommunityFilterEvent, CommunityFilterState> {
  CommunityFilterBloc() : super(const CommunityFilterState()) {
    on<EngagementsFilterChanged>(_onEngagementsFilterChanged);
    on<ReportsFilterChanged>(_onReportsFilterChanged);
    on<AppReviewsFilterChanged>(_onAppReviewsFilterChanged);
    on<CommunityFilterReset>(_onFilterReset);
  }

  void _onEngagementsFilterChanged(
    EngagementsFilterChanged event,
    Emitter<CommunityFilterState> emit,
  ) {
    emit(state.copyWith(engagementsFilter: event.filterState));
  }

  void _onReportsFilterChanged(
    ReportsFilterChanged event,
    Emitter<CommunityFilterState> emit,
  ) {
    emit(state.copyWith(reportsFilter: event.filterState));
  }

  void _onAppReviewsFilterChanged(
    AppReviewsFilterChanged event,
    Emitter<CommunityFilterState> emit,
  ) {
    emit(state.copyWith(appReviewsFilter: event.filterState));
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
