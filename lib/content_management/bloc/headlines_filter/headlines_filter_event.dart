part of 'headlines_filter_bloc.dart';

sealed class HeadlinesFilterEvent extends Equatable {
  const HeadlinesFilterEvent();

  @override
  List<Object?> get props => [];
}

final class HeadlinesSearchQueryChanged extends HeadlinesFilterEvent {
  const HeadlinesSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class HeadlinesStatusFilterChanged extends HeadlinesFilterEvent {
  const HeadlinesStatusFilterChanged(this.status, this.isSelected);

  final ContentStatus status;
  final bool isSelected;

  @override
  List<Object?> get props => [status, isSelected];
}

final class HeadlinesFilterApplied extends HeadlinesFilterEvent {
  const HeadlinesFilterApplied();
}
