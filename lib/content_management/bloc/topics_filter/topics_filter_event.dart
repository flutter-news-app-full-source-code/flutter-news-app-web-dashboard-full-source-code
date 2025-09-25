part of 'topics_filter_bloc.dart';

sealed class TopicsFilterEvent extends Equatable {
  const TopicsFilterEvent();

  @override
  List<Object?> get props => [];
}

final class TopicsSearchQueryChanged extends TopicsFilterEvent {
  const TopicsSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class TopicsStatusFilterChanged extends TopicsFilterEvent {
  const TopicsStatusFilterChanged(this.status, this.isSelected);

  final ContentStatus status;
  final bool isSelected;

  @override
  List<Object?> get props => [status, isSelected];
}

final class TopicsFilterApplied extends TopicsFilterEvent {
  const TopicsFilterApplied();
}
