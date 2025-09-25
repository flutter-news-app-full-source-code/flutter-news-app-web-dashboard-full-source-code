part of 'sources_filter_bloc.dart';

sealed class SourcesFilterEvent extends Equatable {
  const SourcesFilterEvent();

  @override
  List<Object?> get props => [];
}

final class SourcesSearchQueryChanged extends SourcesFilterEvent {
  const SourcesSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class SourcesStatusFilterChanged extends SourcesFilterEvent {
  const SourcesStatusFilterChanged(this.status, this.isSelected);

  final ContentStatus status;
  final bool isSelected;

  @override
  List<Object?> get props => [status, isSelected];
}

final class SourcesFilterApplied extends SourcesFilterEvent {
  const SourcesFilterApplied();
}
