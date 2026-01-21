part of 'overview_bloc.dart';

sealed class OverviewEvent extends Equatable {
  const OverviewEvent();

  @override
  List<Object> get props => [];
}

final class OverviewSubscriptionRequested extends OverviewEvent {
  const OverviewSubscriptionRequested();
}
