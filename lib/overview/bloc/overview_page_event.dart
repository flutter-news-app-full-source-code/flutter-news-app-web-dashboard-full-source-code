part of 'overview_page_bloc.dart';

sealed class OverviewPageEvent extends Equatable {
  const OverviewPageEvent();

  @override
  List<Object> get props => [];
}

final class OverviewPageSubscriptionRequested extends OverviewPageEvent {
  const OverviewPageSubscriptionRequested();
}
