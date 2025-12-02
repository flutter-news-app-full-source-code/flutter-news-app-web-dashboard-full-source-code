import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

part 'community_filter_event.dart';
part 'community_filter_state.dart';

class CommunityFilterBloc
    extends Bloc<CommunityFilterEvent, CommunityFilterState> {
  CommunityFilterBloc() : super(const CommunityFilterState()) {
    on<EngagementsFilterChanged>(
      (event, emit) => emit(
        state.copyWith(
          engagementsFilter: event.filter,
          version: state.version,
        ),
      ),
    );
    on<ReportsFilterChanged>(
      (event, emit) => emit(
        state.copyWith(
          reportsFilter: event.filter,
          version: state.version,
        ),
      ),
    );
    on<AppReviewsFilterChanged>(
      (event, emit) => emit(
        state.copyWith(
          appReviewsFilter: event.filter,
          version: state.version,
        ),
      ),
    );
    on<CommunityFilterReset>(_onFilterReset);
    on<CommunityFilterApplied>(_onFilterApplied);
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
